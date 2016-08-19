//
//  ContactsViewController.m
//  testgoole
//
//  Created by Rock Chen on 2016/8/5.
//  Copyright © 2016年 Rock Chen. All rights reserved.
//

#import "ContactsViewController.h"
#import "CTTableViewCell.h"
#import "CTPersonal.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - [UITableViewDataSource]

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTTableViewCell"
                                                            forIndexPath:indexPath];
    
    CTPersonal *info = [self.dataSource objectAtIndex:indexPath.row];
    cell.nameLabel.text = (info.name) ? info.name : @"";
    cell.detailLabel.text = info.email;
    
    if ([info.photo isKindOfClass:[NSString class]]) {
        [cell.profileImageView sd_setImageWithURL:info.photo placeholderImage:[UIImage imageNamed:@"classprofile"]];
    }
    else {
        if (info.photo) {
            cell.profileImageView.image = [UIImage imageWithData:info.photo];
        }
        else {
            cell.profileImageView.image = [UIImage imageNamed:@"classprofile"];
        }
    }
    
    
    cell.profileImageView.layer.cornerRadius = (CGRectGetHeight(cell.profileImageView.frame) * 0.5);
    
    return cell;
}

#pragma mark -
#pragma mark - [UITableViewDelegate]

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 66.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
