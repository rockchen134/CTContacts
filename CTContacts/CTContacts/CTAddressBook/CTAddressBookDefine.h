//
//  CTAddressBookDefine.h
//  17Life
//
//  Created by Alan.Yen on 2016/08/04
//  Copyright © 2016年 17Life All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CTPersonInfoEntity.h"

#define IOS7_OR_EARLY_SX   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] == NSOrderedAscending )
#define IOS9_OR_LATER_SX   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define IOS8_SX  ((!IOS7_OR_EARLY_SX) && (!IOS9_OR_LATER_SX))

// 因為iOS89不一樣，所以做一個統一
typedef NS_ENUM(NSUInteger, CTAddressBookAuthStatus) {
    kCTAddressBookAuthStatusNotDetermined = 0,
    kCTAddressBookAuthStatusRestricted,
    kCTAddressBookAuthStatusDenied,
    kCTAddressBookAuthStatusAuthorized
};

typedef void(^CTAddressBookChooseAction)(CTPersonInfoEntity *person);

@interface CTAddressBookDefine : NSObject
@end