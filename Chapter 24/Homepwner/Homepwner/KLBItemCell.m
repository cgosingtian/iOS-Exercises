//
//  KLBItemCell.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/8/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBItemCell.h"

@interface KLBItemCell ()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@end

@implementation KLBItemCell

@synthesize nameLabel,imageView,valueLabel,serialNumberLabel,orderLabel;

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.orderLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    if (!imageSizeDictionary)
    {
        imageSizeDictionary = @{ UIContentSizeCategoryExtraSmall : @40,
                                 UIContentSizeCategorySmall : @40,
                                 UIContentSizeCategoryMedium : @40,
                                 UIContentSizeCategoryLarge : @40,
                                 UIContentSizeCategoryExtraLarge : @45,
                                 UIContentSizeCategoryExtraExtraLarge : @55,
                                 UIContentSizeCategoryExtraExtraExtraLarge : @65 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
    //self.imageViewWidthConstraint.constant = imageSize.floatValue;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //[self updateInterfaceForDynamicTypeSize];
    
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc addObserver:self
//           selector:@selector(updateInterfaceForDynamicTypeSize)
//               name:UIContentSizeCategoryDidChangeNotification
//             object:nil];
    
    NSLayoutConstraint *constraint =
    [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.thumbnailView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1
                                  constant:0];
    [self.thumbnailView addConstraint:constraint];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
