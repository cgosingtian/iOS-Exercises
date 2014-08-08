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
    //KLBItem *item = [KLBItem randomItem];
    KLBItem *item = [[KLBItem alloc] init];
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
    
//    if (!sharedStore)
//    {
//        sharedStore = [[self alloc] initPrivate];
//    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// If a programmer calls [[BNRItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[KLBItemStore sharedStore]"];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        //_privateItems = [[NSMutableArray alloc] init];
        
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        // If the array hadn't been saved previously, create a new empty one
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
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


- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems
                                       toFile:path];
}
@end
