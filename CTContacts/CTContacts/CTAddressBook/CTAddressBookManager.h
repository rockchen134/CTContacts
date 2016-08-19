//
//  CTAddressBookManager.h
//  17Life
//
//  Created by Alan.Yen on 2016/08/04
//  Copyright © 2016年 17Life All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTAddressBookDefine.h"

@interface CTAddressBookManager : NSObject

+ (CTAddressBookManager *)manager;
- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure;
- (CTAddressBookAuthStatus)getAuthStatus;
- (NSArray *)getPersonInfoArray;

@end
