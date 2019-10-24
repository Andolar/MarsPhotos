//
//  ViewController.m
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/19/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//

#import "ViewController.h"
#import "PhotoLookup.h"
#import "MarsData.h"

@interface ViewController () <PhotoLookupDelegate, UITextFieldDelegate, UIPickerViewDelegate>

@end

@implementation ViewController

#define MAX_SOL @"Max: %ld Sol"

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.title = @"Lookup";
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSString * cRover = [marsData objectForKey: currentRover];
    if (cRover) {
        [_roverSegmentedControl setSelectedSegmentIndex: [cRover intValue]];
    } else {
        [marsData setObject: @"0" forKey: currentRover];
    }
    
    [marsData setObject: [roverCameras objectAtIndex: [cRover intValue]] forKey: currentCameras];
        
    NSInteger cSol = [marsData integerForKey: currentSol];
    if (!cSol)
        [marsData setInteger: 1 forKey: currentSol];
        
    NSInteger mSol = [marsData integerForKey: maxSol];
    if (mSol)
        [_maxSolLabel setText: [NSString stringWithFormat: MAX_SOL, mSol]];
    else
        [marsData setInteger: 1 forKey: maxSol];
            
    [_solTextField setText: [NSString stringWithFormat:@"%ld", cSol]];
    [marsData synchronize];
    
    [_cameraPickerView reloadAllComponents];
    
    [_spinner startAnimating];
    self->_photoLookup = [[PhotoLookup alloc] init];
    [self->_photoLookup setDelegate:self];
    [self->_photoLookup findMaxSol];
}

- (void) updateMaxSol {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_roverSegmentedControl setEnabled: YES];
        [self->_spinner stopAnimating];
        [self->_maxSolLabel setText: [NSString stringWithFormat: MAX_SOL, [marsData integerForKey: maxSol]]];
        [self->_solTextField setEnabled: YES];
        [self->_solTextField setText: @"1"];
        [marsData setInteger: 1 forKey: currentSol];
        [self showComponents];
    });
}

- (void) showComponents {
    
    [_spinnerLabel setHidden: YES];
    [_maxSolLabel setHidden: NO];
    [_solTextField setHidden: NO];
    [_solLabel setHidden: NO];
    [_cameraLabel setHidden: NO];
    [_cameraPickerView setHidden: NO];
    [_searchButton setHidden: NO];
    [_solTextField setHidden: NO];
}

- (void) hideComponents {
    [_spinnerLabel setHidden: NO];
    [_maxSolLabel setHidden: YES];
    [_solTextField setHidden: YES];
    [_solLabel setHidden: YES];
    [_cameraLabel setHidden: YES];
    [_cameraPickerView setHidden: YES];
    [_searchButton setHidden: YES];
    [_solTextField setHidden: YES];
}

- (void) lookupComplete {
    
}

- (void) lookupError {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendAlert: self withTitle: @"Error" andMessage:[NSString stringWithFormat:@"Something went wrong with the lookup.\r\n\r\nSome data may be incomplete."]];
        
        [self->_roverSegmentedControl setEnabled: YES];
        [self->_spinner stopAnimating];
        [self->_maxSolLabel setText: [NSString stringWithFormat: MAX_SOL, [marsData integerForKey: maxSol]]];
        [self->_solTextField setEnabled: YES];
        [self->_solTextField setText: @"1"];
        [marsData setInteger: 1 forKey: currentSol];
        [self showComponents];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segment {
       
    [marsData setObject: [NSString stringWithFormat:@"%ld", segment.selectedSegmentIndex] forKey: currentRover];
    [marsData setObject: [roverCameras objectAtIndex: segment.selectedSegmentIndex] forKey: currentCameras];
    [marsData setObject: @"" forKey: selectedCamera];
    [_cameraPickerView reloadAllComponents];
    [_cameraPickerView selectRow:0 inComponent:0 animated:YES];
    [_roverSegmentedControl setEnabled: NO];
    [self hideComponents];
    [_spinner startAnimating];
    [self->_photoLookup findMaxSol];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSInteger mSol = [marsData integerForKey: maxSol];
    @try {
        
        NSInteger value = [textField.text intValue];
        if (value < 1 || value > mSol) {
            [self sendAlert: self withTitle: @"Out Of Range" andMessage:[NSString stringWithFormat:@"Please use a value between 1 and %ld", mSol]];
        } else {
            [marsData setInteger: value forKey:currentSol];
        }
    } @catch (NSException *ex) {
    } @finally { }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
        
    return [[marsData objectForKey: currentCameras] count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[marsData objectForKey: currentCameras] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    

    NSString * camera = [[marsData objectForKey: currentCameras] objectAtIndex:(int)row];    
    if ([camera isEqualToString:@"ALL"])
        camera = @"";
    [marsData setObject: camera forKey: selectedCamera];
}

- (IBAction)searchPressed:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [marsData removeObjectForKey: marsPhotos];
        [self dismissViewControllerAnimated:YES completion:NULL];        
        [self performSegueWithIdentifier:@"ShowPhotos" sender:self];
    });    
}

- (void)sendAlert: (UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    alert.popoverPresentationController.sourceView = viewController.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(viewController.view.bounds.size.width / 2.0, viewController.view.bounds.size.height / 2.0, 1.0, 1.0);
    
    [alert addAction:ok];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
