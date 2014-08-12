//
//  KLBQuizViewController.h
//  Quiz
//
//  Created by Chase Gosingtian on 7/31/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLBQuizViewController : UIViewController

@property (nonatomic, assign) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;

@property (nonatomic,unsafe_unretained) IBOutlet UILabel *questionField;
@property (nonatomic,unsafe_unretained) IBOutlet UILabel *answerField;

- (IBAction)showQuestion:(id)sender;
- (IBAction)showAnswer:(id)sender;

@end
