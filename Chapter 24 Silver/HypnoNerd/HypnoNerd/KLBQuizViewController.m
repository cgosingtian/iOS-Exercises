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
            answers = _answers,
            answerShown = _answerShown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Initializing Quiz View Controller");
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
        _answerShown = false;
        
        //tab bar item's title
        self.tabBarItem.title = @"Quiz";
        
        //uiimage
//        UIImage *image = [UIImage imageNamed:@"Time.png"];
//        
//        self.tabBarItem.image = image;
        
        //self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path
                                                            coder:(NSCoder *)coder
{
    return [[self alloc] init];
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
    _answerShown = false;
}
- (IBAction)showAnswer:(id)sender
{
    // What is the answer to the current question?
    NSString *answer = [_answers objectAtIndex:_currentQuestionIndex];
    // Display it in the answer label
        //self.answerLabel.text = answer;
    [_answerField setText:answer];
    _answerShown = false;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NSNumber numberWithInt:_currentQuestionIndex]
                 forKey:@"currentQuestionIndex"];
    
    [coder encodeObject:[NSNumber numberWithBool:_answerShown] forKey:@"answerShown"];
    
    [coder encodeObject:_questions forKey:@"questions"];
    [coder encodeObject:_answers forKey:@"answers"];
    //you may need to save fields onto the item here
    //otherwise changes will be lost
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSNumber *currentQuestionIndexDecoded = [coder decodeObjectForKey:@"currentQuestionIndex"];
    NSNumber *answerShownDecoded = [coder decodeObjectForKey:@"answerShown"];
    NSArray *questionsDecoded = [coder decodeObjectForKey:@"questions"];
    NSArray *answersDecoded = [coder decodeObjectForKey:@"answers"];
    
    _questions = questionsDecoded;
    _answers = answersDecoded;
    
    _answerShown = [answerShownDecoded boolValue];
    _currentQuestionIndex = [currentQuestionIndexDecoded intValue];
    
    if (_questions)
    {
        NSString *question = [_questions objectAtIndex:_currentQuestionIndex];
        [_questionField setText:question];
    }
    
    if (_answerShown)
    {
        if (_answers)
        {
            NSString *answer = [_answers objectAtIndex:_currentQuestionIndex];
            [_answerField setText:answer];
        }
    }
    
    [super decodeRestorableStateWithCoder:coder];
}

@end
