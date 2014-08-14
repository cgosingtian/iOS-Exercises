//
//  KLBItemCell.h
//  Homepwner
//
//  Created by Chase Gosingtian on 8/8/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLBItemCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *valueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (copy, nonatomic) void (^actionBlock)(void);
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *orderLabel;

@end
