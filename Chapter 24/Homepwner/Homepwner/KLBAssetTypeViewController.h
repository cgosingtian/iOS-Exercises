//
//  KLBAssetTypeViewController.h
//  Homepwner
//
//  Created by Chase Gosingtian on 8/12/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KLBItem;

@interface KLBAssetTypeViewController : UITableViewController

@property (nonatomic, strong) KLBItem *item;
@property (nonatomic, retain) NSManagedObject *selectedType;

@end
