//
//  KLBImageTransformer.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/11/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBImageTransformer.h"

@implementation KLBImageTransformer

+(Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    if (!value)
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]])
    {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
