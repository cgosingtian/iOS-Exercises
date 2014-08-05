//
//  KLBItemStore.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBItemStore.h"
#import "KLBItem.h"

@interface KLBItemStore ()
@property (nonatomic) NSMutableArray *privateItems;
@end

@implementation KLBItemStore

- (KLBItem *)createItem
{
    KLBItem *item = [KLBItem randomItem];
    [self.privateItems addObject:item];
    NSLog(@"Adding %@",item);
    return item;
}

+ (instancetype)sharedStore
{
    static KLBItemStore *sharedStore;
    
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

// If a programmer calls [[BNRItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[BNRItemStore sharedStore]"];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems
{
    NSMutableArray *arrCopy = [self.privateItems mutableCopy];
    [arrCopy addObject:@"No more items!"];
    return [arrCopy copy];
}

- (NSArray *)filteredItemsWithValueInDollarGreaterThan:(NSInteger)num
{
    NSMutableArray *arrCopy = [self.privateItems mutableCopy];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"valueInDollars > %d",num];
    [arrCopy filterUsingPredicate:filter];
    [arrCopy addObject:@"No more items!"];
    return [arrCopy copy];
}
- (NSArray *)filteredItemsWithValueInDollarLessThanEqualTo:(NSInteger)num
{
    NSMutableArray *arrCopy = [self.privateItems mutableCopy];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"valueInDollars <= %d",num];
    [arrCopy filterUsingPredicate:filter];
    [arrCopy addObject:@"No more items!"];
    return [arrCopy copy];
}
@end
