//
//  CTGoogleSignIn.m
//  CTContacts
//
//  Created by Rock Chen on 2016/8/14.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "CTGoogleSignIn.h"

@interface CTGoogleSignIn () <GIDSignInUIDelegate, GIDSignInDelegate>

@property (nonatomic, strong) GIDSignIn *signIn;
@property (nonatomic, copy) CTGoogleSingInSuccessHandler singInSuccessHandler;
@property (nonatomic, copy) CTGoogleSingInFailureHandler singInFailureHandler;

@end

@implementation CTGoogleSignIn

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _signIn = [GIDSignIn sharedInstance];
        _signIn.uiDelegate = self;
        _signIn.delegate = self;
        [_signIn setScopes:@[@"https://www.googleapis.com/auth/contacts.readonly",
                                                @"https://www.google.com/m8/feeds/"]];
        [_signIn signOut];
    }
    
    return self;
}

- (void)singInWithSuccessHandler:(CTGoogleSingInSuccessHandler)successHandler failureHandler:(CTGoogleSingInFailureHandler)failureHandler {
    self.singInSuccessHandler = [successHandler copy];
    self.singInFailureHandler = [failureHandler copy];
    
    [self.signIn signIn];
}

#pragma mark GIDSignInUIDelegate
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    if (error == nil) {
        
    }
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self.fromViewController presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
        self.singInSuccessHandler(user);
    }
    else {
        self.singInFailureHandler(error);
    }
}

@end
