//
//  KLBItemStore.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/4/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBItemStore.h"
#import "KLBItem.h"
#import "KLBImageStore.h"

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

-(void)removeItem:(KLBItem *)item
{
    [[KLBImageStore sharedStore] deleteImageForKey:item.itemKey];
    [self.privateItems removeObjectIdenticalTo:item];
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
    return arrCopy;
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex
{
    [self.privateItems exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
}
@end
