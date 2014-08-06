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
    
    if (!imageStore)
    {
        imageStore = [[self alloc]initPrivate];
    }
    
    return imageStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
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
}

-(UIImage *)imageForKey:(NSString *)key
{
    //return [self.dictionary objectForKey:key];
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key)
        return;
    
    [self.dictionary removeObjectForKey:key];
}

@end
