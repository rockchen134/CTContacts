//
//  CTTestObj.m
//  CTContacts
//
//  Created by Rock Chen on 2016/8/19.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "CTTestObj.h"

@implementation CTTestObj

- (void)testcompletionHandler:(void (^) ())completeHandle {
    completeHandle();
}

- (void)p_acompletionHandler:(void (^) ())completeHandle {
    
}

@end
