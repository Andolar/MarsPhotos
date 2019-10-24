//
//  MarsData.h
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/22/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarsData : NSObject

extern NSUserDefaults *marsData;
extern NSString * const curiosity;
extern NSString * const opportunity;
extern NSString * const spirit;
extern NSString * const currentRover;
extern NSString * const currentCameras;
extern NSDictionary * const rovers;

extern NSString * const maxSol;
extern NSString * const currentSol;

extern NSArray * const curiosityCameras;
extern NSArray * const opportunityCameras;
extern NSArray * const spiritCameras;
extern NSArray * const roverCameras;
extern NSString * const selectedCamera;
extern NSString * const marsPhotos;
extern NSString * const marsCameraTitles;
extern NSString * const marsPopup;

@end

NS_ASSUME_NONNULL_END
