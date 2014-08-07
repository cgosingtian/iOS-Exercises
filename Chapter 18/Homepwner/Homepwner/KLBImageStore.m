//
//  KLBImageStore.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/6/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBImageStore.h"

@interface KLBImageStore ()
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end

@implementation KLBImageStore

#pragma mark - Initializers and Singleton Getter
+ (instancetype)sharedStore
{
    static KLBImageStore *imageStore;
    
//    if (!imageStore)
//    {
//        imageStore = [[self alloc]initPrivate];
//    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageStore = [[self alloc] initPrivate];
    });
    
    return imageStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

- (void)clearCache:(id)sender
{
    NSLog(@"Clearing cache");
//    for (NSString *key in [self.dictionary allKeys])
//    {
//        [self deleteImageForKey:key];
//    }
    [self.dictionary removeAllObjects];
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[KLBImageStore sharedStore]"];
    return nil;
}

#pragma mark - Image Getters and Setters
- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    //[self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image; //shorthand
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:key];
    // Turn image into JPEG data
    //NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSData *data = UIImagePNGRepresentation(image);
    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
    //return [self.dictionary objectForKey:key];
    //return self.dictionary[key];
    
    // If possible, get it from the dictionary
    UIImage *result = self.dictionary[key];
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        // If we found an image on the file system, place it into the cache
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", imagePath);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key)
        return;
    
    [self.dictionary removeObjectForKey:key];
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                               error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}
@end
