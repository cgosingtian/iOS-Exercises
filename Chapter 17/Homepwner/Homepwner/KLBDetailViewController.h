//
//  KLBDetailViewController.h
//  Homepwner
//
//  Created by Chase Gosingtian on 8/5/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLBItem;

@interface KLBDetailViewController : UIViewController

@property (nonatomic,strong) KLBItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end
