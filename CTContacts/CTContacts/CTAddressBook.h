//
//  CTAddressBook.h
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "CTContacts.h"
#import "CTAddressBookManager.h"

@interface CTAddressBook : CTContacts

- (instancetype)initWithSignIn:(CTAddressBookManager *)signIn;

@end
