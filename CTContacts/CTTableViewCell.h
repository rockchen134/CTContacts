//
//  CTTableViewCell.h
//  testgoole
//
//  Created by Rock Chen on 2016/8/5.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
