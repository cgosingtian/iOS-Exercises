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
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *assetLabel;

@property (strong,nonatomic) NSManagedObjectContext *context;

@property (weak,nonatomic) UITableViewController *source;

@end
