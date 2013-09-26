//
//  RGFirstViewController.h
//  Rangen
//
//  Created by Julian on 5/29/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGFirstViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISlider *lengthSlider;
@property (strong, nonatomic) IBOutlet UITextView *numberTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *fromField;
@property (weak, nonatomic) IBOutlet UITextField *toField;
@property (weak, nonatomic) IBOutlet UIButton *resignButton;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *aboutButton;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet UILabel *amountTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;

- (IBAction)generatePressed:(id)sender;
- (IBAction)lengthValueChanged:(id)sender;
- (IBAction)typeValueChanged:(id)sender;
- (IBAction)resignButtonPressed:(id)sender;
-(void)resignOrShowKeyboard;
- (IBAction)aboutButtonTapped:(id)sender;

- (void)grabFromAPI;
- (void)processData:(NSData *)data;
- (void)receivedError:(NSString *)error;

- (void)addStatistics;


@end
