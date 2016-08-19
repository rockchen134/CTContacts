//
//  CTContactsProtocol.h
//  CTContacts
//
//  Created by Rock Chen on 2016/8/12.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTPersonal.h"

@protocol CTContactsProtocol <NSObject>

- (BOOL)isNext;
- (void)getWithAfterToken:(NSString *)afterToken completionHandler:(void (^) (id result, NSString *afterToken, NSError *error))completeHandle;

@end
