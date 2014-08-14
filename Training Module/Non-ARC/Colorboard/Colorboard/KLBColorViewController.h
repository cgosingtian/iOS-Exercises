//
//  KLBColorViewController.h
//  Colorboard
//
//  Created by Chase Gosingtian on 8/13/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBColorDescription.h"

@interface KLBColorViewController : UIViewController

@property (nonatomic) BOOL existingColor;
@property (nonatomic, retain) KLBColorDescription *colorDescription;

@end
