//
//  CTAddressBookIOS8Maneger.m
//  17Life
//
//  Created by Alan.Yen on 2016/08/04
//  Copyright © 2016年 17Life All rights reserved.
//

#import "CTAddressBookIOS8Maneger.h"
#import <AddressBookUI/AddressBookUI.h>

@interface CTAddressBookIOS8Maneger () <ABPeoplePickerNavigationControllerDelegate>

@end

@implementation CTAddressBookIOS8Maneger

+ (CTAddressBookIOS8Maneger *)manager {
    
    static CTAddressBookIOS8Maneger *sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure {
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            if (success) {
                success();
            }
        }
        else {
            if (failure) {
                failure();
            }
        }
    });
}

- (CTAddressBookAuthStatus)getAuthStatus {
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        return kCTAddressBookAuthStatusNotDetermined;
    }
    else if (status == kABAuthorizationStatusAuthorized) {
        return kCTAddressBookAuthStatusAuthorized;
    }
    else if (status == kABAuthorizationStatusRestricted) {
        return kCTAddressBookAuthStatusRestricted;
    }
    else {
        return kCTAddressBookAuthStatusDenied;
    }
}

- (NSArray *)getPersonInfoArray {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    
    NSMutableArray *personArray = [NSMutableArray array];
    for (NSInteger i = 0; i < peopleCount; i++) {
        
        CTPersonInfoEntity *personEntity = [CTPersonInfoEntity new];
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        personEntity.lastname = lastName;
        personEntity.firstname = firstName;
        
        NSMutableString *fullname = [[NSString stringWithFormat:@"%@%@", lastName, firstName] mutableCopy];
        [fullname replaceOccurrencesOfString:@"(null)"
                                  withString:@""
                                     options:NSCaseInsensitiveSearch
                                       range:NSMakeRange(0, fullname.length)];
        personEntity.fullname = fullname;
        
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        NSString *fullPhoneStr = [NSString string];
        for (NSInteger i = 0; i < phoneCount; i++) {
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            if (phoneValue.length > 0) {
                fullPhoneStr = [fullPhoneStr stringByAppendingString:phoneValue];
                fullPhoneStr = [fullPhoneStr stringByAppendingString:@","];
            }
        }

        if (fullPhoneStr.length > 1) {
            personEntity.phoneNumber = [fullPhoneStr substringToIndex:fullPhoneStr.length - 1];
        }

        CFDataRef photo = ABPersonCopyImageData(person);
        if (photo) {
            personEntity.imageData = (__bridge NSData*)photo;
            CFRelease(photo);
        }

        [personArray addObject:personEntity];
        CFRelease(phones);
    }
    
    CFRelease(addressBook);
    CFRelease(peopleArray);
    
    return personArray;
}

@end