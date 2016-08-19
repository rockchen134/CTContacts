//
//  CTGoogleContact.m
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "CTGoogleContact.h"
#import <Google/SignIn.h>

@interface CTGoogleContact ()

@property (nonatomic, strong) GIDSignIn *singIn;

@end

@implementation CTGoogleContact

- (void)dealloc {
    
}

- (instancetype)initWithSignIn:(GIDSignIn *)signIn {
    self = [super init];
    
    if (self) {
        _singIn = signIn;
    }
    
    return self;
}

- (void)getWithAfterToken:(NSString *)afterToken completionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle {
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.google.com/m8/feeds/contacts/default/thin?alt=json&v=3.0&access_token=%@", self.singIn.currentUser.authentication.accessToken];
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
            completeHandle(contacts, @"", error);
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
            photoUrl = [NSString stringWithFormat:@"%@?access_token=%@", link[@"href"], self.singIn.currentUser.authentication.accessToken];
        }
    }
    
    fullName = name[@"gd$fullName"][@"$t"];
    
    result.name = fullName;
    result.email = email;
    result.photo = photoUrl;
    
    return result;
}

@end
