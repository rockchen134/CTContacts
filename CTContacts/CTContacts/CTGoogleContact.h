//
//  CTGoogleContact.h
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "CTContacts.h"

@class GIDSignIn;

@interface CTGoogleContact : CTContacts

- (instancetype)initWithSignIn:(GIDSignIn *)signIn;

@end