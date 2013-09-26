//
//  RGFirstViewController.m
//  Rangen
//
//  Created by Julian on 5/29/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import "RGFirstViewController.h"

@interface RGFirstViewController ()
@end

@implementation RGFirstViewController

@synthesize lengthSlider = _lengthSlider;
@synthesize numberTextView = _numberTextView;
@synthesize typeSegmentedControl = _typeSegmentedControl;
@synthesize fromField = _fromField;
@synthesize toField = _toField;
@synthesize resignButton = _resignButton;
@synthesize amountField = _amountField;
@synthesize aboutButton = _aboutButton;
@synthesize aboutTextView = _aboutTextView;

NSNumber *typeValue;
NSString *type;
CGRect defaultTextFrame;
UIActivityIndicatorView *spinner;
NSMutableArray *processedNumbers;


- (IBAction)generatePressed:(id)sender {
    [_aboutButton setEnabled:NO];
    
    [_resignButton setTitle:@"show" forState:UIControlStateNormal];
    [_fromField resignFirstResponder];
    [_toField resignFirstResponder];
    [_amountField resignFirstResponder];
    
    if([[_amountField text] floatValue] > 1024)
        [_amountField setText:@"1024"];
    [_lengthSlider setValue:[[_amountField text] floatValue] animated:YES];
    
    [_numberTextView setText:@""];
    
    /*
    NSString *loadingText = @"Loading...";
    CGSize size = [loadingText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(_numberTextView.frame.size.width, _numberTextView.frame.size.height)];
    
    UIView *combinedLoading = [[UIView alloc] initWithFrame:CGRectMake(_numberTextView.center.x, _numberTextView.center.y, size.width + 125, 100)];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(combinedLoading.frame.origin.x, combinedLoading.frame.origin.y, size.width, 100)];
    [loadingLabel setText:loadingText];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(loadingLabel.frame.size.width - 100, combinedLoading.frame.origin.y, 100, 100)];
    
    [combinedLoading addSubview:loadingLabel];
    [combinedLoading addSubview:spinner];*/
    
    
    NSString *unformattedDate = @"";
	NSDate *rawDate = [NSDate dateWithTimeIntervalSince1970:[unformattedDate doubleValue]];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	[dateFormatter setDateFormat:@"hh:mm a, MM/dd/yyyy"];
	NSMutableParagraphStyle *mutParaStyle= [[NSMutableParagraphStyle alloc] init];
	[mutParaStyle setAlignment:NSTextAlignmentRight];
	NSString *formattedDate = [dateFormatter stringFromDate:rawDate];
    
	NSMutableAttributedString *dateAttrStr = [[NSMutableAttributedString alloc] initWithString:formattedDate];
	[dateAttrStr setAttributes:nil range:NSMakeRange(0, [dateAttrStr length])];
	[dateAttrStr addAttribute:NSParagraphStyleAttributeName value:mutParaStyle range:NSMakeRange(0, [dateAttrStr length])];
    
    
    NSString *loadingText = @"Reticulating Splines And Shit...";
    CGSize size = [loadingText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(_numberTextView.frame.size.width, _numberTextView.frame.size.height)];
    
    UIView *combinedLoading = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width + 100, 100)];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(combinedLoading.frame.origin.x, combinedLoading.frame.origin.y, size.width, 100)];
    [loadingLabel setFont:[UIFont systemFontOfSize:16]];
    [loadingLabel setTextColor:[UIColor blackColor]];
    [loadingLabel setText:loadingText];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(combinedLoading.frame.origin.x + size.width, combinedLoading.frame.origin.y, 100, 100)];
    [spinner setColor:[UIColor blackColor]];
    [spinner startAnimating];
    
    [combinedLoading setCenter:CGPointMake(_numberTextView.center.x, _numberTextView.center.y)];
    [combinedLoading addSubview:spinner];
    [combinedLoading addSubview:loadingLabel];

    [self.view addSubview:combinedLoading];
    [self grabFromAPI];
}

- (IBAction)lengthValueChanged:(id)sender{
    [_amountField setText:[NSString stringWithFormat:@"%i", (int)[_lengthSlider value]]];
}

- (IBAction)typeValueChanged:(id)sender{
    typeValue = [NSNumber numberWithInteger:[_typeSegmentedControl selectedSegmentIndex]];
}

- (IBAction)resignButtonPressed:(id)sender {
    [self resignOrShowKeyboard];
}

-(void)resignOrShowKeyboard{
    
    if([[[_resignButton titleLabel] text] isEqualToString:@"show"]){
        [_fromField becomeFirstResponder];
        [_resignButton setTitle:@"next" forState:UIControlStateNormal];
    }
    
    else if([[[_resignButton titleLabel] text] isEqualToString:@"next"]){
        [_toField becomeFirstResponder];
        [_resignButton setTitle:@"hide" forState:UIControlStateNormal];
    }
    
    else{
        [_fromField resignFirstResponder];
        [_toField resignFirstResponder];
        [_amountField resignFirstResponder];
        
        if([[_amountField text] floatValue] > 1024)
            [_amountField setText:@"1024"];
        [_lengthSlider setValue:[[_amountField text] floatValue] animated:YES];
        [_resignButton setTitle:@"show" forState:UIControlStateNormal];
    }
}//end resignOrShow

- (IBAction)aboutButtonTapped:(id)sender {

    CGRect properFrame = _aboutTextView.frame;
    properFrame.size.height = _aboutTextView.contentSize.height;
    properFrame.origin.y = -properFrame.size.height;

    if([_generateButton isEnabled]){
        [_aboutTextView setFrame:properFrame];

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            
            [_generateButton setEnabled:NO];
            [_fromField setEnabled:NO];
            [_toField setEnabled:NO];
            [_amountField setEnabled:NO];
            [_resignButton setEnabled:NO];
            
            [_fromField setCenter:CGPointMake(_fromField.center.x, _fromField.center.y + _aboutTextView.frame.size.height)];
            [_toField setCenter:CGPointMake(_toField.center.x, _toField.center.y + _aboutTextView.frame.size.height)];
            [_resignButton setCenter:CGPointMake(_resignButton.center.x, _resignButton.center.y + _aboutTextView.frame.size.height)];
            [_amountTextLabel setCenter:CGPointMake(_amountTextLabel.center.x, _amountTextLabel.center.y + _aboutTextView.frame.size.height)];
            [_amountField setCenter:CGPointMake(_amountField.center.x, _amountField.center.y + _aboutTextView.frame.size.height)];
            [_lengthSlider setCenter:CGPointMake(_lengthSlider.center.x, _lengthSlider.center.y + _aboutTextView.frame.size.height)];
            [_typeSegmentedControl setCenter:CGPointMake(_typeSegmentedControl.center.x, _typeSegmentedControl.center.y + _aboutTextView.frame.size.height)];
            [_numberTextView setCenter:CGPointMake(_numberTextView.center.x, _numberTextView.center.y + _aboutTextView.frame.size.height)];
            
            [_aboutTextView setCenter:CGPointMake([_aboutTextView center].x, [_aboutTextView center].y + properFrame.size.height + 44)];
        } completion:nil];
    }//end if
    
    else{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            
            [_generateButton setEnabled:YES];
            [_fromField setEnabled:YES];
            [_toField setEnabled:YES];
            [_amountField setEnabled:YES];
            [_resignButton setEnabled:YES];

            [_fromField setCenter:CGPointMake(_fromField.center.x, _fromField.center.y - _aboutTextView.frame.size.height)];
            [_toField setCenter:CGPointMake(_toField.center.x, _toField.center.y - _aboutTextView.frame.size.height)];
            [_resignButton setCenter:CGPointMake(_resignButton.center.x, _resignButton.center.y - _aboutTextView.frame.size.height)];
            [_amountTextLabel setCenter:CGPointMake(_amountTextLabel.center.x, _amountTextLabel.center.y - _aboutTextView.frame.size.height)];
            [_amountField setCenter:CGPointMake(_amountField.center.x, _amountField.center.y - _aboutTextView.frame.size.height)];
            [_lengthSlider setCenter:CGPointMake(_lengthSlider.center.x, _lengthSlider.center.y - _aboutTextView.frame.size.height)];
            [_typeSegmentedControl setCenter:CGPointMake(_typeSegmentedControl.center.x, _typeSegmentedControl.center.y - _aboutTextView.frame.size.height)];
            [_numberTextView setCenter:CGPointMake(_numberTextView.center.x, _numberTextView.center.y - _aboutTextView.frame.size.height)];
            
            [_aboutTextView setCenter:CGPointMake([_aboutTextView center].x, -[_aboutTextView center].y + 44)];
        } completion:nil];
    }
    
}//end aboutTapped


-(void)grabFromAPI{

    if(!typeValue)
        type = @"uint8";
    else if([typeValue isEqualToNumber:[NSNumber numberWithInt:0]])
        type = @"uint8";
    else
        type = @"uint16";
    
    NSString *pullString = [NSString stringWithFormat:@"https://qrng.anu.edu.au/API/jsonI.php?length=%i&type=%@", [[_amountField text] integerValue], type];
    NSURL *pullURL = [NSURL URLWithString:pullString];
    
    NSMutableURLRequest *pullRequest = [NSMutableURLRequest requestWithURL:pullURL];
    [pullRequest setHTTPMethod:@"GET"];
        
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:pullRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if ([data length] > 0 && error == nil)
            [self performSelectorOnMainThread:@selector(processData:) withObject:data waitUntilDone:NO];
        
        else if (error != nil)
            [self performSelectorOnMainThread:@selector(receivedError:) withObject:[error localizedDescription] waitUntilDone:NO];
    }];
}

-(void)processData:(NSData *)data{    
    NSString *pullResponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *pullRequestError = nil;

    NSData *pullJSONData = [pullResponseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *pullResults = [NSJSONSerialization JSONObjectWithData:pullJSONData options:0 error:&pullRequestError];
    NSArray *generatedArray = [pullResults objectForKey:@"data"];
    
    int rangeMin = [[_fromField text] intValue];
    int rangeMax = [[_toField text] intValue];
    if([[_toField text] isEqualToString:@""] && [type isEqualToString:@"uint8"])
        rangeMax = 255;
    else if([[_toField text] isEqualToString:@""] && [type isEqualToString:@"uint16"])
        rangeMax = 65535;
    
    NSMutableString *generatedNumbers = [NSMutableString string];
    int count = 0;
    for(NSNumber *n in generatedArray){
                
        int num = [type isEqualToString:@"uint8"]?(round((([n floatValue] * (rangeMax - rangeMin))/255) + rangeMin)):(round((([n floatValue] * (rangeMax - rangeMin))/65535) + rangeMin));
        [processedNumbers addObject:[NSNumber numberWithInt:num]];
        
        if(count == 0)
            [generatedNumbers appendFormat:@"%i", num];
        
        else
            [generatedNumbers appendFormat:@", %i", num];
        
        count++;
    }//end for
    
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
    [_numberTextView setText:[NSString stringWithFormat:@"%@", generatedNumbers]];
    [self addStatistics];
    [_aboutButton setEnabled:YES];
}//end grabWithAPI()

-(void)receivedError:(NSString *)error{
    [_numberTextView setText:[NSString stringWithFormat:@"Failed to generate numbers with error:\n\n> %@", error]];
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}

- (void)addStatistics{
    
    NSMutableDictionary *numberStats = [NSMutableDictionary dictionary];
    //keys are generated numbers
    //objects are amounts of it generated
    
    //for every gen. number in the total numbers array
    for(NSNumber *n in processedNumbers){
        
        if([numberStats objectForKey:[n stringValue]])
            [numberStats setObject:[NSNumber numberWithInt:([[numberStats objectForKey:[n stringValue]] intValue] + 1)] forKey:[n stringValue]];
        
        else
            [numberStats setObject:[NSNumber numberWithInt:1] forKey:[n stringValue]];
    }//end for

    NSArray *unsortedObjects = [[NSSet setWithArray:[numberStats allValues]] allObjects];
    NSArray *sortedArray = [unsortedObjects sortedArrayUsingComparator:^(id firstObject, id secondObject) {
        return [[firstObject stringValue] compare:[secondObject stringValue] options:NSNumericSearch];
    }];
    
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
    //UIFont *regularFont = [UIFont systemFontOfSize:14];
    //NSDictionary *regAttrs = [NSDictionary dictionaryWithObjectsAndKeys:regularFont, NSFontAttributeName, nil];
    NSDictionary *boldAttrs = [NSDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName, nil];
    
    NSMutableAttributedString *formattedStats = [[NSMutableAttributedString alloc] initWithString:@" "];
    for(id s in sortedArray){
        NSString *scopy = [NSString stringWithString:[s stringValue]];
        NSMutableString *allKeys = [NSMutableString stringWithString:@" "];

        for(NSString *key in [numberStats allKeysForObject:[NSNumber numberWithInt:[scopy intValue]]])
            [allKeys appendFormat:@" %@", key];
        
        NSString *isOrAre = ([scopy intValue] > 1)?@"are":@"is";

        NSMutableAttributedString *currFormatted = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nThere %@ %@:\n %@", isOrAre, scopy, allKeys]];
        [currFormatted appendAttributedString:formattedStats];
        
        int length = [[NSString stringWithFormat:@"\n\nThere %@ %@:", isOrAre, scopy] length];
        formattedStats = [[NSMutableAttributedString alloc] initWithAttributedString:currFormatted];
        [formattedStats setAttributes:boldAttrs range:NSMakeRange(0, length)];
    }//end for
    
    NSMutableAttributedString *finalStr= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", [_numberTextView text]]];
    [finalStr appendAttributedString:formattedStats];
                            
    [_numberTextView setAttributedText:finalStr];
    processedNumbers = [NSMutableArray array];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField isEqual:_fromField])
        [_resignButton setTitle:@"next" forState:UIControlStateNormal];
    
    else
        [_resignButton setTitle:@"hide" forState:UIControlStateNormal];
    
}//end didBeginEditing


/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if([textField isEqual:_amountField])
        [_lengthSlider setValue:[[_amountField text] floatValue] animated:YES];
    
    return YES;
}*/

- (BOOL)shouldAutorotate {
    
    if(![_generateButton isEnabled])
        return NO;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIDeviceOrientationLandscapeLeft)
        [_numberTextView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width)];
    
    else if(orientation == UIDeviceOrientationLandscapeRight)
        [_numberTextView setFrame:CGRectMake(self.view.frame.origin.x - 20, self.view.frame.origin.y, self.view.frame.size.height, self.view.frame.size.width)];
        
    else if(orientation == UIDeviceOrientationPortrait)
        [_numberTextView setFrame:defaultTextFrame];
    
    return (orientation != UIDeviceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad{
    
    processedNumbers = [NSMutableArray array];
    defaultTextFrame = _numberTextView.frame;
    //UIActivityIndicatorViewStyleWhiteLarge
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
