//
//  PhotoLookup.m
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/19/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoLookup.h"
#import "MarsData.h"

#define URL @"https://api.nasa.gov/mars-photos/api/v1/rovers/%@/photos?sol=%@&%@api_key=MNAaOQ4Z4pMYbE0wzCV3MA1MHgk2H9bgLZv6ClEx"
#define CAMERA @"camera=%@&"
#define OK 200

@implementation PhotoLookup

-(void) findMaxSol {
    [self lookup: NO];
}

-(void) lookup {
    [self lookup: YES];
}

-(void) lookup: (BOOL) findPhotos {
    @try {
        
        NSString * rover = [marsData objectForKey: currentRover];
        NSString *camera = [marsData objectForKey: selectedCamera];
        if (camera == nil)
            camera = @"";
        if (![camera isEqualToString: @""])
            camera = [NSString stringWithFormat: CAMERA, camera];
        
        NSString *url = [NSString stringWithFormat:URL, [rovers objectForKey:rover], [marsData objectForKey: currentSol], camera];
        NSLog(@"Url: %@", url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        request.HTTPMethod = @"GET";
        [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
          {
              @try {
                  NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                  long responseStatusCode = [httpResponse statusCode];
                  
                  NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                  if (responseStatusCode == OK) {
                      
                      if (response) {
                          
                          NSMutableArray *photos = [[NSMutableArray alloc] init];
                          photos = response[@"photos"];
                          if (photos) {
                              
                                NSMutableDictionary *photo = [[NSMutableDictionary alloc] init];
                                photo = photos[0];
                                if (photo) {
                                    
                                    if (findPhotos) {
                                        
                                        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
                                        NSMutableArray *titleArray = [[NSMutableArray alloc] init];
                                        for (NSDictionary *photoObj in photos) {
                                                
                                            NSDictionary *cameraInfo = photoObj[@"camera"];
                                            if (cameraInfo) {
                                                
                                                NSString *cameraName = cameraInfo[@"name"];
                                                if (cameraName) {
                                                    [titleArray addObject: cameraName];
                                                    [marsData setObject: titleArray forKey: marsCameraTitles];
                                                } else {
                                                    [titleArray addObject: @""];
                                                    [marsData setObject: titleArray forKey: marsCameraTitles];
                                                }
                                            } else {
                                                [titleArray addObject: @""];
                                                [marsData setObject: titleArray forKey: marsCameraTitles];
                                            }
                                            
                                            NSString *photoUrl = photoObj[@"img_src"];
                                            if (photoUrl) {
                                                
                                                photoUrl = [photoUrl stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                                                [photoArray addObject: photoUrl];
                                                [marsData setObject: photoArray forKey: marsPhotos];
                                            }
                                        }
                                        [self->_delegate lookupComplete];
                                    }
                                    else {
                                        NSMutableDictionary *roverParameters = [[NSMutableDictionary alloc] init];
                                        roverParameters = photo[@"rover"];
                                        if (roverParameters) {
                                            [marsData setInteger: [[roverParameters objectForKey:@"max_sol"] intValue] forKey: maxSol];
                                            [self->_delegate updateMaxSol];
                                        }
                                    }
                                }
                          }
                      }                                       
                  } else {
                      
                      [self->_delegate lookupError];
                  }
                  
              } @catch (NSException *exception) {
                  
                  [self->_delegate lookupError];
              } @finally {
                  
              }
              
          }] resume];
    }
    @catch (NSException *exception) {
        
        [_delegate lookupComplete];
        
        return;
    }
    @finally {
        
    }
}
@end

