//
//  KLBDetailViewController.m
//  Homepwner
//
//  Created by Chase Gosingtian on 8/5/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBDetailViewController.h"
#import "KLBDateViewController.h"
#import "KLBItem.h"
#import "KLBItemStore.h"
#import "KLBImageStore.h"

@interface KLBDetailViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation KLBDetailViewController

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
    
    UIInterfaceOrientation io =
    [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
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
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *picControl = [[UIImagePickerController alloc]init];
    
    if ([self.imagePickerPopover isPopoverVisible])
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
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
        self.imagePickerPopover = [[UIPopoverController alloc]
                                   initWithContentViewController:picControl];
        self.imagePickerPopover.delegate = self;
        // Display the popover controller; sender
        // is the camera bar button item
        [self.imagePickerPopover
         presentPopoverFromBarButtonItem:sender
         permittedArrowDirections:UIPopoverArrowDirectionAny
         animated:YES];
    } else {
        [self presentViewController:picControl animated:YES completion:NULL];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image from info dictionary
    UIImage *image = info[UIImagePickerControllerEditedImage];
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    [[KLBImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    // Take image picker off the screen -
    // you must call this dismiss method
    //[self dismissViewControllerAnimated:YES completion:NULL];
    
    if (self.imagePickerPopover) {
        // Dismiss it
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        // Dismiss the modal image picker
        [self dismissViewControllerAnimated:YES completion:NULL];
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
- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
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

@end
