//
//  CTFBContact.m
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "CTFBContact.h"

@interface CTFBContact ()

@property (nonatomic, strong) FBSDKAccessToken *signIn;

@end

@implementation CTFBContact

- (void)dealloc {
    
}

- (instancetype)initWithSignIn:(FBSDKAccessToken *)signIn {
    self = [super init];
    
    if (self) {
        _signIn = signIn;
    }
    
    return self;
}

- (void)getWithAfterToken:(NSString *)afterToken completionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle {
    
    if ([self.signIn hasGranted:@"user_friends"]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"me/invitable_friends"
                                      parameters:@{@"pretty" : @"0", @"fields" : @"id,first_name,last_name,name,picture", @"limit" : @"1000",
                                                   @"after" : afterToken}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            NSMutableArray *friends = nil;
            NSString *after = nil;
            
            if (error == nil) {
                friends = [[NSMutableArray alloc] init];
                NSArray *data = result[@"data"];
                
                for (NSDictionary *item in data) {
                    CTPersonal *personal = [self p_parseWithDictionary:item];
                    [friends addObject:personal];
                }
                
                NSDictionary *paging = result[@"paging"];
                NSDictionary *cursors = paging[@"cursors"];
                after = cursors[@"after"];
            }
            
            
            completeHandle(friends, after, error);
        }];
    }
    else {
        // error
    }
}

- (CTPersonal<NSString *> *)p_parseWithDictionary:(NSDictionary *)dictionary {
    CTPersonal<NSString *> *result = [[CTPersonal alloc] init];
    
    result.firstName = dictionary[@"first_name"];
    result.lastName = dictionary[@"last_name"];
    result.name = dictionary[@"name"];
    result.photo = dictionary[@"picture"][@"data"][@"url"];
    
    return result;
}

@end
