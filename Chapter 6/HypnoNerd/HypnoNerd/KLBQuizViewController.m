//
//  KLBQuizViewController.m
//  Quiz
//
//  Created by Chase Gosingtian on 7/31/14.
//  Copyright (c) 2014 KLab Cyscorpions, Inc. All rights reserved.
//

#import "KLBQuizViewController.h"

//@interface KLBQuizViewController ()
//
//@end

@implementation KLBQuizViewController

@synthesize answerField = _answerField,
            questionField = _questionField,
            currentQuestionIndex = _currentQuestionIndex,
            questions = _questions,
            answers = _answers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create two arrays filled with questions and answers
        // and make the pointers point to them
        self.questions = @[@"From what is cognac made?",
                           @"What is 7+7?",
                           @"What is the capital of Vermont?"];
        self.answers = @[@"Grapes",
                         @"14",
                         @"Montpelier"];
        self.currentQuestionIndex=0;
        
        //tab bar item's title
        self.tabBarItem.title = @"Quiz";
        
        //uiimage
//        UIImage *image = [UIImage imageNamed:@"Time.png"];
//        
//        self.tabBarItem.image = image;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showQuestion:(id)sender
{
    _currentQuestionIndex++;
    if (_currentQuestionIndex >= [_questions count])
    {
        _currentQuestionIndex = 0;
    }
    
    // Get the string at that index in the questions array
    NSString *question = [_questions objectAtIndex:_currentQuestionIndex];
    // Display the string in the question label
        //self.questionField.text = question;
    [_questionField setText:question];
    // Reset the answer label
        //self.answerField.text = @"???";
    [_answerField setText:@"???"];
}
- (IBAction)showAnswer:(id)sender
{
    // What is the answer to the current question?
    NSString *answer = [_answers objectAtIndex:_currentQuestionIndex];
    // Display it in the answer label
        //self.answerLabel.text = answer;
    [_answerField setText:answer];
}

@end
