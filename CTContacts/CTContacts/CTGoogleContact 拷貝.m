//
//  CTGoogleContact.m
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

//#import "CTGoogleContact.h"
//
//typedef void(^CTGoogleContactCompletionHandler)(id result, NSString *afterToken, NSError *error);
//
//@interface CTGoogleContact () <GIDSignInUIDelegate, GIDSignInDelegate>
//
//@property (nonatomic, strong) UIViewController *fromViewController;
//@property (nonatomic, copy) CTGoogleContactCompletionHandler googleContactCompletionHandler;
//
//@end
//
//@implementation CTGoogleContact
//
//- (instancetype)initWithFromViewController:(UIViewController *)fromViewController {
//    self = [super init];
//    
//    if (self) {
//        _fromViewController = fromViewController;
//        
//        [GIDSignIn sharedInstance].uiDelegate = self;
//        [GIDSignIn sharedInstance].delegate = self;
//        [[GIDSignIn sharedInstance] setScopes:@[@"https://www.googleapis.com/auth/contacts.readonly",
//                                                @"https://www.google.com/m8/feeds/"]];
//    }
//    
//    return self;
//}
//
//- (void)getWithAfterToken:(NSString *)afterToken completionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle {
//    [[GIDSignIn sharedInstance] signIn];
//    if (completeHandle) {
//        self.googleContactCompletionHandler = completeHandle;
//    }
//}
//
//#pragma mark GIDSignInUIDelegate
//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//    if (error == nil) {
//        
//    }
//}
//
//// Present a view that prompts the user to sign in with Google
//- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
//    [self.fromViewController presentViewController:viewController animated:YES completion:nil];
//}
//
//// Dismiss the "Sign in with Google" view
//- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
//    [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
//}
//
//#pragma mark GIDSignInDelegate
//- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
//    if (error == nil) {
//        [self p_getContactsWithCompletionHandler:self.googleContactCompletionHandler];
//    }
//}
//
//- (void)p_getContactsWithCompletionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle {
//    NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/m8/feeds/contacts/default/thin?alt=json&v=3.0&access_token=%@", [GIDSignIn sharedInstance].currentUser.authentication.accessToken];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"3.0" forHTTPHeaderField:@"GData-Version"];
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSMutableArray *contacts = nil;
//        
//        if (error == nil) {
//            contacts = [[NSMutableArray alloc] init];
//            
//            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            
//            if ([json isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dictionary = json;
//                NSArray *entry = dictionary[@"feed"][@"entry"];
//                
//                for (NSDictionary *item in entry) {
//                    CTPersonal *personal = [self p_parseWithDictionary:item];
//                    [contacts addObject:personal];
//                }
//            }
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.googleContactCompletionHandler(contacts, @"", error);
//        });
//    }];
//    [dataTask resume];
//}
//
//// Finished disconnecting |user| from the app successfully if |error| is |nil|.
//- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
//    
//}
//
//- (CTPersonal<NSString *> *)p_parseWithDictionary:(NSDictionary *)dictionary {
//    CTPersonal<NSString *> *result = [[CTPersonal alloc] init];
//    
//    NSDictionary *name = dictionary[@"gd$name"];
//    
//    NSString *fullName = nil;
//    NSString *photoUrl = nil;
//    NSString *email = nil;
//    
//    for (NSDictionary *gdEmail in dictionary[@"gd$email"]) {
//        if ([gdEmail[@"primary"] boolValue]) {
//            email = gdEmail[@"address"];
//        }
//    }
//    
//    for (NSDictionary *link in dictionary[@"link"]) {
//        if ([link[@"type"] isEqualToString:@"image/*"]) {
//            photoUrl = [NSString stringWithFormat:@"%@?access_token=%@", link[@"href"], [GIDSignIn sharedInstance].currentUser.authentication.accessToken];
//        }
//    }
//    
//    fullName = name[@"gd$fullName"][@"$t"];
//    
//    result.name = fullName;
//    result.email = email;
//    result.photo = photoUrl;
//    
//    return result;
//}
//
//@end

#import "CTGoogleContact.h"
#import "CTGDataRequest.h"

typedef void(^CTGoogleContactCompletionHandler)(id result, NSString *afterToken, NSError *error);

@interface CTGoogleContact ()

//@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, copy) CTGoogleContactCompletionHandler googleContactCompletionHandler;
@property (nonatomic, strong) CTGoogleSignIn *singIn;
@property (nonatomic, strong) NSString *accessToken;

@end

@implementation CTGoogleContact

- (void)dealloc {
    
}

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController {
    self = [super init];
    
    if (self) {
//        _fromViewController = fromViewController;
        _singIn = [[CTGoogleSignIn alloc] init];
        [_singIn setFromViewController:fromViewController];
    }
    
    return self;
}

- (void)getWithAfterToken:(NSString *)afterToken completionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle {
    self.googleContactCompletionHandler = [completeHandle copy];
    __weak typeof(self) weakSelf = self;
    
    [self.singIn singInWithSuccessHandler:^(GIDGoogleUser *user) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.accessToken = user.authentication.accessToken;
        [strongSelf p_getContacts];
    } failureHandler:^(NSError *error) {
        NSLog(@"ddd");
    }];
}

//- (void)p_getContactsCompletionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle {
- (void)p_getContacts {
    NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/m8/feeds/contacts/default/thin?alt=json&v=3.0&access_token=%@", self.accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"3.0" forHTTPHeaderField:@"GData-Version"];
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableArray *contacts = nil;
        
        if (error == nil) {
            contacts = [[NSMutableArray alloc] init];
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dictionary = json;
                NSArray *entry = dictionary[@"feed"][@"entry"];
                
                for (NSDictionary *item in entry) {
                    CTPersonal *personal = [self p_parseWithDictionary:item];
                    [contacts addObject:personal];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.googleContactCompletionHandler(contacts, @"", error);
        });
    }];
    [dataTask resume];
}

- (CTPersonal<NSString *> *)p_parseWithDictionary:(NSDictionary *)dictionary {
    CTPersonal<NSString *> *result = [[CTPersonal alloc] init];
    
    NSDictionary *name = dictionary[@"gd$name"];
    
    NSString *fullName = nil;
    NSString *photoUrl = nil;
    NSString *email = nil;
    
    for (NSDictionary *gdEmail in dictionary[@"gd$email"]) {
        if ([gdEmail[@"primary"] boolValue]) {
            email = gdEmail[@"address"];
        }
    }
    
    for (NSDictionary *link in dictionary[@"link"]) {
        if ([link[@"type"] isEqualToString:@"image/*"]) {
            photoUrl = [NSString stringWithFormat:@"%@?access_token=%@", link[@"href"], self.accessToken];
        }
    }
    
    fullName = name[@"gd$fullName"][@"$t"];
    
    result.name = fullName;
    result.email = email;
    result.photo = photoUrl;
    
    return result;
}

@end