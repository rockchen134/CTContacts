//
//  CTFBContact.h
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "CTContacts.h"

@interface CTFBContact : CTContacts

- (instancetype)initWithSignIn:(FBSDKAccessToken *)signIn;

@end
