//
//  CTContacts.m
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "CTContacts.h"

@implementation CTContacts

- (void)getWithAfterToken:(NSString *)afterToken completionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle {}

- (BOOL)isNext {
    return NO;
}

@end
