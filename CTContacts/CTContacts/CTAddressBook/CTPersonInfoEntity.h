//
//  CTPersonInfoEntity.h
//  17Life
//
//  Created by Alan.Yen on 2016/08/04
//  Copyright © 2016年 17Life All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTPersonInfoEntity : NSObject

@property (copy, nonatomic) NSString *firstname;
@property (copy, nonatomic) NSString *lastname;
@property (copy, nonatomic) NSString *fullname;
@property (copy, nonatomic) NSString *company;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSData *imageData;

@end