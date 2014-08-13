//
//  KLBItem.h
//  Homepwner
//
//  Created by Chase Gosingtian on 8/12/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KLBItem : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * itemKey;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, assign) double orderingValue;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) UIImage * thumbnail;
@property (nonatomic, assign) int valueInDollars;
@property (nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
