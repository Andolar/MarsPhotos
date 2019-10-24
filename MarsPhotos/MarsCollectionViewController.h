//
//  MarsCollectionViewController.h
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/23/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PhotoLookup.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarsCollectionViewController : UICollectionViewController<UICollectionViewDelegate> {
    
    NSFileManager *fileManager;
}

@property (nonatomic, strong) PhotoLookup *photoLookup;
@property (nonatomic, strong) NSCache *thumbnailCache;
@property (nonatomic, strong) IBOutlet UICollectionView *marsCollectionView;

@end

NS_ASSUME_NONNULL_END
