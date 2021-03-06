//
//  KLBDetailViewController.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/5/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBDetailViewController.h"
#import "KLBDateViewController.h"
#import "KLBAssetTypeViewController.h"
#import "KLBItem.h"
#import "KLBItemStore.h"
#import "KLBImageStore.h"

@class PopoverBackground;
@interface PopoverBackground: UIPopoverBackgroundView
@end
@implementation PopoverBackground

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
//    UIEdgeInsets popoverInsets = UIEdgeInsetsMake(68.0f, 16.0f, 16.0f, 34.0f);
//    UIImage *popover = [[UIImage imageNamed:@"logo.png"] resizableImageWithCapInsets:popoverInsets];
//    [popover drawInRect:rect];
}

+ (CGFloat)arrowBase
{
    return 25.0f;
}
+ (CGFloat)arrowHeight
{
    return 16.0f;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(0.0f, 5.0f, 5.0f, 5.0f);
}

- (void)setArrowDirection:(UIPopoverArrowDirection)direction
{
    // no-op
}
- (UIPopoverArrowDirection)arrowDirection
{
    return UIPopoverArrowDirectionUp;
}
- (void)setArrowOffset:(CGFloat)offset
{
    // no-op
}
- (CGFloat)arrowOffset
{
    return 0.0f;
}
@end

@interface KLBDetailViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) UIPopoverController *assetTypePopover;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *serialField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *valueField;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIToolbar *toolBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *valueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;


@end

@implementation KLBDetailViewController

- (void) dealloc
{
    [_item release];
    [_imagePickerPopover release];
    [_assetTypePopover release];
    _item = nil;
    _imagePickerPopover = nil;
    _assetTypePopover = nil;
    [super dealloc];
}

- (void)updateFonts
{
    @try{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    self.nameField.font = font;
    self.serialField.font = font;
    self.valueField.font = font;
    }@catch(NSException *e) { NSLog(@"%@",e); }
}

- (void)viewDidLoad //overridden to create our own image view with constraints - chapter 16!
{
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    // The contentMode of the image view in the XIB was Aspect Fit:
    iv.contentMode = UIViewContentModeScaleAspectFit;
    // Do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    // The image view was a subview of the view
    [self.view addSubview:iv];
    // The image view was pointed to by the imageView property
    self.imageView = iv;
    [iv release];
    
    // Map the objects to names
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar" : self.toolBar};
    
    // imageView is 0 pts from superview at left and right edges
    NSArray *horizontalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    // imageView is 8 pts from dateLabel at its top edge...
    // ... and 8 pts from toolbar at its bottom edge
    NSArray *verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:
     @"V:[dateLabel]-[imageView]-[toolbar]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
    [self.imageView setContentHuggingPriority:200
                                      forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700
                                                    forAxis:UILayoutConstraintAxisVertical];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    KLBItem *item = self.item;
    self.nameField.text = item.itemName;
    self.serialField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d",item.valueInDollars];
    
    [self.valueField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.imageView.image = [[KLBImageStore sharedStore] imageForKey:item.itemKey];
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = NSLocalizedString(@"None",@"The undefined asset type");
    }
    self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@",@"Asset Type Button Text"), typeLabel];
    
    UIInterfaceOrientation io =
    [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    [self updateFonts];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Clear first responder
    [self.view endEditing:YES];
    // "Save" changes to item
    KLBItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)setItem:(KLBItem *)item
{
    _item = item;
    self.navigationItem.title = item.itemName;
}

//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //[self.valueField resignFirstResponder];
//    [self.view endEditing:YES];
//}
- (IBAction)changeDate:(id)sender {
    KLBDateViewController *dvc = [[KLBDateViewController alloc]init];
    
    dvc.item = self.item;
    
    [self.navigationController pushViewController:dvc animated:YES];
    [dvc release];
}

- (IBAction)takePicture:(id)sender {
    //UIImagePickerController *picControl = [[UIImagePickerController alloc]init];
    UIImagePickerController *picControl = [KLBDetailViewController picController];
    
    if ([self.imagePickerPopover isPopoverVisible])
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        [_imagePickerPopover release];
        self.imagePickerPopover = nil;
    }
    
    // If the device has a camera, take a picture, otherwise,
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picControl.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picControl.delegate = self;
    picControl.allowsEditing = YES;
    
    //present image picker to screen
    //[self presentViewController:picControl animated:YES completion:NULL];
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        UIPopoverController *popoverControl = [[UIPopoverController alloc]
                                               initWithContentViewController:picControl];
        self.imagePickerPopover = popoverControl;
        self.imagePickerPopover.delegate = self;
        
        [popoverControl release];
//        picControl.delegate = nil;
//        [picControl release];
//        picControl = nil;
        
        //popover background view class
        [self.imagePickerPopover setPopoverBackgroundViewClass:[PopoverBackground class]];
        
        // Display the popover controller; sender
        // is the camera bar button item
        [self.imagePickerPopover
         presentPopoverFromBarButtonItem:sender
         permittedArrowDirections:UIPopoverArrowDirectionAny
         animated:YES];
    } else {
        [self presentViewController:picControl animated:YES completion:^()
         {
//             NSLog(@"iphone - image picker control dismissed");
         }];
//        picControl.delegate = nil;
//        [picControl release];
//        picControl = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == self.imagePickerPopover)
    {
        NSLog(@"User dismissed popover: image picker");
        _imagePickerPopover.delegate = nil;
        [_imagePickerPopover release];
        _imagePickerPopover = nil;
    }
    else if (popoverController == self.assetTypePopover)
    {
        KLBAssetTypeViewController *kvc = (KLBAssetTypeViewController *)self.assetTypePopover.contentViewController.childViewControllers[0];
        self.item.assetType = kvc.item.assetType;
        self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@",@"Asset Type Button Text"),[self.item.assetType valueForKey:@"label"]];
        [self.assetTypePopover dismissPopoverAnimated:YES];
        [self.assetTypePopover release];
        [kvc release];
        self.assetTypePopover = nil;
        NSLog(@"User dismissed popover: asset type");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerEditedImage];
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    [[KLBImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    [self.item setThumbnailFromImage:image];
    
    //[image release];
    
    // Take image picker off the screen -
    // you must call this dismiss method
    //[self dismissViewControllerAnimated:YES completion:NULL];
    
    if (self.imagePickerPopover) {
        // Dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        _imagePickerPopover.delegate = nil;
        [_imagePickerPopover release];
        self.imagePickerPopover = nil;
    } else {
        // Dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:NULL];
        //picker.delegate = nil;
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)clearImage:(id)sender {
    self.imageView.image = nil;
    [[KLBImageStore sharedStore] deleteImageForKey:self.item.itemKey];
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // Is it an iPad? No preparation necessary
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    // Is it landscape?
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        // we're setting these navigation items because we will be wrapping this VC with a ui nav VC
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the BNRItem from the store
    [[KLBItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"Wrong initializer"
                format:@"Use initForNewItem:"];
    return nil;
}
- (IBAction)changeItemType:(id)sender {
    [self.view endEditing:YES];
    KLBAssetTypeViewController *kvc = [[KLBAssetTypeViewController alloc] init];
    
    kvc.item = self.item;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if ([self.assetTypePopover isPopoverVisible])
        {
            [self.assetTypePopover dismissPopoverAnimated:YES];
            self.assetTypePopover = nil;
        }
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:kvc];
        [kvc release];
        
        UIPopoverController *popoverControl = [[UIPopoverController alloc] initWithContentViewController:nc];
        self.assetTypePopover = popoverControl;
        self.assetTypePopover.delegate = self;
        
        [self.assetTypePopover
         presentPopoverFromBarButtonItem:sender
         permittedArrowDirections:UIPopoverArrowDirectionAny
         animated:YES];
        
        [nc release];
        [popoverControl release];
    }
    else
    {
        
        [self.navigationController pushViewController:kvc animated:YES];
        [kvc release];
    }
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path
                                                            coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([path count] == 3) {
        isNew = YES;
    }
    return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.itemKey
                 forKey:@"item.itemKey"];
    
    // Save changes into item
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    // Have store save changes to disk
    [[KLBItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *itemKey =
    [coder decodeObjectForKey:@"item.itemKey"];
    for (KLBItem *item in [[KLBItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - UIImagePickerController Singleton
+ (UIImagePickerController *)picController
{
    static UIImagePickerController *picController;
    if (!picController)
    {
        picController = [[UIImagePickerController alloc] init];
    }
    return picController;
}

@end
