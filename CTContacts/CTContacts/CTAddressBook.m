//
//  CTAddressBook.m
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "CTAddressBook.h"

@interface CTAddressBook ()

@property (nonatomic, strong) CTAddressBookManager *signIn;

@end

@implementation CTAddressBook

- (void)dealloc {
    
}

- (instancetype)initWithSignIn:(CTAddressBookManager *)signIn {
    self = [super init];
    
    if (self) {
        _signIn = signIn;
    }
    
    return self;
}

- (void)getWithAfterToken:(NSString *)afterToken completionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle {
    __block NSMutableArray *contacts = nil;
    
    CTAddressBookAuthStatus status = [self.signIn getAuthStatus];
    if (status == kCTAddressBookAuthStatusNotDetermined) {
        [self.signIn askUserWithSuccess:^{
            NSArray *personEntityArray = [self.signIn getPersonInfoArray];
            
            contacts = [[NSMutableArray alloc] init];
            
            for (CTPersonInfoEntity *item in personEntityArray) {
                CTPersonal *personal = [self p_parseWithPersonInfoEntity:item];
                [contacts addObject:personal];
            }
            completeHandle(contacts, nil, nil);
        } failure:^{
            NSLog(@"失敗");
        }];
    }
    else if (status == kCTAddressBookAuthStatusAuthorized) {
        NSArray *personEntityArray = [self.signIn getPersonInfoArray];
        
        contacts = [[NSMutableArray alloc] init];
        
        for (CTPersonInfoEntity *item in personEntityArray) {
            CTPersonal *personal = [self p_parseWithPersonInfoEntity:item];
            [contacts addObject:personal];
        }
        
        completeHandle(contacts, nil, nil);
    }
    else {
        NSLog(@"沒有權限");
    }
    
}

- (CTPersonal<NSData *> *)p_parseWithPersonInfoEntity:(CTPersonInfoEntity *)personInfoEntity {
    CTPersonal<NSData *> *result = [[CTPersonal alloc] init];
    
    result.firstName = personInfoEntity.firstname;
    result.lastName = personInfoEntity.lastname;
    result.name = personInfoEntity.fullname;
    result.phone = personInfoEntity.phoneNumber;
    result.photo = personInfoEntity.imageData;
    
    return result;
}

@end
