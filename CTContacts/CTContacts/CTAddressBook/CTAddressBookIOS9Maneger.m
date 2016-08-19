//
//  CTAddressBookIOS9Maneger.m
//  17Life
//
//  Created by Alan.Yen on 2016/08/04
//  Copyright © 2016年 17Life All rights reserved.
//

#import "CTAddressBookIOS9Maneger.h"
#import <ContactsUI/ContactsUI.h>

@interface CTAddressBookIOS9Maneger () <CNContactPickerDelegate>

@end

@implementation CTAddressBookIOS9Maneger

+ (CTAddressBookIOS9Maneger *)manager {
    
    static CTAddressBookIOS9Maneger *sharedInstance = nil;
    if (!sharedInstance) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

- (void)askUserWithSuccess:(void (^)())success failure:(void (^)())failure {
    
    [[[CNContactStore alloc]init] requestAccessForEntityType:CNEntityTypeContacts
                                           completionHandler:^(BOOL granted, NSError * _Nullable error) {
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
    }];
}

- (CTAddressBookAuthStatus)getAuthStatus {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        return kCTAddressBookAuthStatusNotDetermined;
    }
    else if (status == CNAuthorizationStatusAuthorized) {
        return kCTAddressBookAuthStatusAuthorized;
    }
    else if (status == CNAuthorizationStatusDenied) {
        return kCTAddressBookAuthStatusDenied;
    }
    else {
        return kCTAddressBookAuthStatusRestricted;
    }
}

- (NSArray *)getPersonInfoArray {
    
    NSMutableArray *personArray = [NSMutableArray array];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];

    [contactStore enumerateContactsWithFetchRequest:request
                                              error:nil
                                         usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
    {
        CTPersonInfoEntity *personEntity = [CTPersonInfoEntity new];
        NSString *lastname = contact.familyName;
        NSString *firstname = contact.givenName;
        personEntity.lastname = lastname;
        personEntity.firstname = firstname;
        
        NSMutableString *fullname = [[NSString stringWithFormat:@"%@%@", lastname, firstname] mutableCopy];
        [fullname replaceOccurrencesOfString:@"(null)"
                                  withString:@""
                                     options:NSCaseInsensitiveSearch
                                       range:NSMakeRange(0, fullname.length)];
        personEntity.fullname = fullname;
        
        NSArray *phoneNums = contact.phoneNumbers;
        NSString *fullPhoneStr = [NSString string];
        for (CNLabeledValue *labeledValue in phoneNums) {
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            if (phoneValue.length > 0) {
                fullPhoneStr = [fullPhoneStr stringByAppendingString:phoneValue];
                fullPhoneStr = [fullPhoneStr stringByAppendingString:@","];
            }
        }
        
        if (fullPhoneStr.length > 1) {
            personEntity.phoneNumber = [fullPhoneStr substringToIndex:fullPhoneStr.length - 1];
        }
        
        if (contact.imageData) {
            personEntity.imageData = contact.imageData;
        }
        
        [personArray addObject:personEntity];
    }];
    
    return personArray;
}

@end
