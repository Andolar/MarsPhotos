//
//  PhotoLookup.h
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/19/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//
#import <Foundation/Foundation.h>

@class PhotoLookupDelegate;

@protocol PhotoLookupDelegate <NSObject>

@required
- (void)updateMaxSol;
- (void)lookupComplete;
- (void)lookupError;

@end

@interface PhotoLookup : NSObject

-(void)findMaxSol;
-(void)lookup;
@property (nonatomic, assign) id<PhotoLookupDelegate> delegate;
@end
