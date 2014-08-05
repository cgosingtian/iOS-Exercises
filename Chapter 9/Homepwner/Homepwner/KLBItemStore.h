//
//  KLBItemStore.h
//  Homepwner
//
//  Created by Chase Gosingtian on 8/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "KLBItem.h"
@class KLBItem; //speeds up compile times; ok not to use import since we don't send messages to KLBItem in here

@interface KLBItemStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

+(instancetype)sharedStore;
-(KLBItem *)createItem;
-(void)removeItem:(KLBItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex;

@end
