//
//  CTAddressBookManager.m
//  17Life
//
//  Created by Alan.Yen on 2016/08/04
//  Copyright © 2016年 17Life All rights reserved.
//

#import "CTAddressBookManager.h"
#import "CTAddressBookIOS8Maneger.h"
#import "CTAddressBookIOS9Maneger.h"

@implementation CTAddressBookManager

+ (CTAddressBookManager *)manager {
    
    //
    // Reference:
    // https://github.com/dsxNiubility/SXEasyAddressBook
    //
    
    static CTAddressBookManager *sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

- (void)checkStatusAndDoSomethingSuccess:(void (^)())success failure:(void (^)())failure {

    CTAddressBookAuthStatus status = [[CTAddressBookManager manager] getAuthStatus];
    if (status == kCTAddressBookAuthStatusNotDetermined) {
        [[CTAddressBookManager manager] askUserWithSuccess:^{
            if (success) {
                success();
            }
        } failure:^{
            if (failure) {
                failure();
            }
        }];
    }
    else if (status == kCTAddressBookAuthStatusAuthorized) {
        if (success) {
            success();
        }
    }
    else {
        if (failure) {
            failure();
        }
    }
}

- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure {

    if (IOS9_OR_LATER_SX) {
        [[CTAddressBookIOS9Maneger manager] askUserWithSuccess:success failure:failure];
    }
    else {
        [[CTAddressBookIOS8Maneger manager] askUserWithSuccess:success failure:failure];
    }
}

- (CTAddressBookAuthStatus)getAuthStatus {
    
    CTAddressBookAuthStatus status;
    if (IOS9_OR_LATER_SX) {
        status = [[CTAddressBookIOS9Maneger manager] getAuthStatus];
    }
    else {
        status = [[CTAddressBookIOS8Maneger manager] getAuthStatus];
    }
    return status;
}

- (NSArray *)getPersonInfoArray {
    
    if (IOS9_OR_LATER_SX) {
        return [[CTAddressBookIOS9Maneger manager] getPersonInfoArray];
    }
    else {
        return [[CTAddressBookIOS8Maneger manager] getPersonInfoArray];
    }
}

@end