//
//  MarsData.m
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/22/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//

#import "MarsData.h"

@implementation MarsData

NSUserDefaults *marsData = [NSUserDefaults standardUserDefaults];
NSString * const curiosity = @"curiosity";
NSString * const opportunity = @"opportunity";
NSString * const spirit = @"spirit";
NSDictionary * const rovers = @{@"0":curiosity,@"1":opportunity,@"2":spirit};
NSString * const currentRover = @"currentRover";
NSString * const currentCameras = @"currentCameras";
NSString * const maxSol = @"maxSol";
NSString * const currentSol = @"currentSol";

NSArray * const curiosityCameras = [NSArray arrayWithObjects: @"ALL", @"FHAZ", @"RHAZ", @"MAST", @"CHEMCAM", @"MAHLI", @"MARDI", @"NAVCAM", nil];
NSArray * const opportunityCameras = [NSArray arrayWithObjects: @"ALL", @"FHAZ", @"RHAZ", @"NAVCAM", @"PANCAM", @"MINITES", nil];
NSArray * const spiritCameras = [NSArray arrayWithObjects: @"ALL", @"FHAZ", @"RHAZ", @"NAVCAM", @"PANCAM", @"MINITES", nil];
NSArray * const roverCameras = [NSArray arrayWithObjects: curiosityCameras, opportunityCameras, spiritCameras, nil];
NSString * const selectedCamera = @"selectedCameras";
NSString * const marsPhotos = @"marsPhotos";
NSString * const marsCameraTitles = @"marsCameraTitles";
NSString * const marsPopup = @"marsPopup";

@end
