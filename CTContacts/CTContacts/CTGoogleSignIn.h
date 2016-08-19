//
//  CTGoogleSignIn.h
//  CTContacts
//
//  Created by Rock Chen on 2016/8/14.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/SignIn.h>

typedef void(^CTGoogleSingInSuccessHandler)(GIDGoogleUser *user);
typedef void(^CTGoogleSingInFailureHandler)(NSError *error);

@interface CTGoogleSignIn : NSObject

@property (nonatomic, strong) UIViewController *fromViewController;
- (void)singInWithSuccessHandler:(CTGoogleSingInSuccessHandler)successHandler failureHandler:(CTGoogleSingInFailureHandler)failureHandler;

@end
