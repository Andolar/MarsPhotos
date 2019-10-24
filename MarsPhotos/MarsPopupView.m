//
//  MarsPopupView.m
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/24/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//

#import "MarsPopupView.h"
#import "MarsData.h"

@interface MarsPopupView ()

@end

@implementation MarsPopupView

- (void)viewDidLoad {
    [super viewDidLoad];

    fileManager = [NSFileManager defaultManager];
    NSString *url = [marsData valueForKey:marsPopup];
    NSRegularExpression *photoPattern = [NSRegularExpression regularExpressionWithPattern: @"[^/]*\\.JPG\\z" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *patternHits = [photoPattern matchesInString:url
                                               options:0
                                                 range:NSMakeRange(0, [url length])];
    
    NSString * patternResult;
    if (patternHits != nil) {
        for (NSTextCheckingResult *listingMatch in patternHits) {
            NSRange listingRange = [listingMatch range];
            patternResult = [url substringWithRange:listingRange];
            if (patternResult.length > 0) {
                                   
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0];
                NSString *imagePath = [documentsPath stringByAppendingPathComponent:patternResult];
                if ([self->fileManager fileExistsAtPath:imagePath]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->_marsPopupPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
                    });
                }
            }
        }
    }
}

@end
