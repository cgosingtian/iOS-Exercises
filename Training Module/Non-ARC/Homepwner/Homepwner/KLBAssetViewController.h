//
//  KLBAssetViewController.h
//  Homepwner
//
//  Created by Chase Gosingtian on 8/12/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLBItem.h"

@interface KLBAssetViewController : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *addButton;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *assetLabel;

@property (strong,nonatomic) NSManagedObjectContext *context;

@property (unsafe_unretained,nonatomic) UITableViewController *source;

@end
