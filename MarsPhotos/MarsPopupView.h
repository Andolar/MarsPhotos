//
//  MarsPopupView.h
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/24/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarsPopupView : UIViewController {
    
    NSFileManager *fileManager;
}

@property (nonatomic, strong) IBOutlet UIImageView *marsPopupPhoto;

@end

NS_ASSUME_NONNULL_END
