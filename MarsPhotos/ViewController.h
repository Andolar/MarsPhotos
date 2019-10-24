//
//  ViewController.h
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/19/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoLookup.h"

@interface ViewController : UIViewController <PhotoLookupDelegate> {
    
}

@property (nonatomic, strong) PhotoLookup *photoLookup;
@property (nonatomic, strong) IBOutlet UIPickerView *cameraPickerView;
@property (nonatomic, strong) IBOutlet UITextField *solTextField;
@property (nonatomic, strong) IBOutlet UILabel *solLabel;
@property (nonatomic, strong) IBOutlet UILabel *spinnerLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxSolLabel;
@property (nonatomic, strong) IBOutlet UILabel *cameraLabel;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;
@property (nonatomic, strong) IBOutlet UISegmentedControl *roverSegmentedControl;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;

-(IBAction)textFieldDidEndEditing:(UITextField *)textField;
-(IBAction)segmentedControlValueChanged:(UISegmentedControl *)segment;
-(IBAction)searchPressed:(id)sender;

@end

