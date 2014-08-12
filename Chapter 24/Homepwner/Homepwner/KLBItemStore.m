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
    //KLBItem *item = [[KLBItem alloc] init];
    
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);
    
    KLBItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"KLBItem" inManagedObjectContext:self.context];
    
    item.orderingValue = order;
    
    [self.privateItems addObject:item];
    NSLog(@"Adding %@",item);
    return item;
}

-(void)removeItem:(KLBItem *)item
{
    [[KLBImageStore sharedStore] deleteImageForKey:item.itemKey];
    [self.context deleteObject:item];
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
//        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        //read in Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSURL *storeURL = [NSURL fileURLWithPath:path];

        NSError *error;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            [NSException raise:@"Open store failure" format:[error localizedDescription]];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:psc];
        
        [self loadAllItems];
        
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
    //[arrCopy addObject:@"No more items!"];
    return arrCopy;
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex)
        return;
    
    //(lower bound + upper bound) / 2 = item's new ordering value
    //if destination is last entry
    
    double lowerBound = 0.0, upperBound = 0.0;
    int limit = [self.privateItems count]-1;
    
    KLBItem *item1 = nil;
    KLBItem *item2 = nil;
    
    if (toIndex == 0) //if moving to start
    {
        item1 = self.privateItems[1]; //get first entry
        
        lowerBound = 0.0;
        upperBound = item1.orderingValue;
    }
    else if (toIndex == limit) // if moving to end
    {
        item1 = self.privateItems[toIndex-1]; //get next to last entry
        
        lowerBound = item1.orderingValue;
        upperBound = item1.orderingValue * 2.0;
    }
    else //normal case, get before and after entry
    {
        item1 = self.privateItems[toIndex-1];
        item2 = self.privateItems[toIndex+1];
        
        lowerBound = item1.orderingValue;
        upperBound = item2.orderingValue;
    }
    
    KLBItem *movingItem = self.privateItems[fromIndex];
    KLBItem *destinationItem = self.privateItems[toIndex];
    
    destinationItem.orderingValue = movingItem.orderingValue;
    movingItem.orderingValue = (lowerBound + upperBound) / 2.0;
    
    
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
//    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
//    NSString *path = [self itemArchivePath];
//    // Returns YES on success
//    return [NSKeyedArchiver archiveRootObject:self.privateItems
//                                       toFile:path];
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"KLBItem" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue"
                                ascending:YES];
        request.sortDescriptors = @[sd];
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"KLBAssetType" inManagedObjectContext:self.context];
        request.entity = e;
        NSError *error;
        NSArray *result = [[self.context executeFetchRequest:request error:&error] mutableCopy];
        if (!result)
        {
            [NSException raise:@"Fetch failed" format:[error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    if (_allAssetTypes.count == 0) //if nothing saved, add default values
    {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"KLBAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"KLBAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"KLBAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    
    return _allAssetTypes;
}

- (NSArray *)allItemsOfAssetType:(NSManagedObject *)type
{
    NSArray *items;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"KLBItem" inManagedObjectContext:self.context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assetType = %@",type];
    NSError *error;
    
    request.entity = e;
    request.predicate = predicate;
    
    items = [self.context executeFetchRequest:request error:&error];
    
    return items;
}

- (void)addAssetType:(NSString *)value forKey:(NSString *)key
{
    NSManagedObject *type;
    type = [NSEntityDescription insertNewObjectForEntityForName:@"KLBAssetType" inManagedObjectContext:self.context];
    [type setValue:value forKey:key];
    [_allAssetTypes addObject:type];
}

+ (NSManagedObjectContext *)context
{
    return self.context;
}
@end
