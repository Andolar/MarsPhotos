//
//  MarsCollectionViewController.m
//  MarsPhotos
//
//  Created by Ernest Fipps on 10/23/19.
//  Copyright © 2019 Ernest Fipps. All rights reserved.
//

#import "MarsCollectionViewController.h"
#import "MarsData.h"
#import "MarsPopupView.h"

@interface MarsCollectionViewController () <PhotoLookupDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation MarsCollectionViewController


- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.title = @"Photos";
    
}

- (void)viewDidLoad {
    fileManager = [NSFileManager defaultManager];
    _thumbnailCache = [[NSCache alloc] init];
    self->_photoLookup = [[PhotoLookup alloc] init];
    [self->_photoLookup setDelegate:self];
    [self->_photoLookup lookup];
}

- (void) updateMaxSol {
    
}

- (void) lookupComplete {

    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_marsCollectionView reloadData];
    });
}

- (void) lookupError {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendAlert: self withTitle: @"Error" andMessage:[NSString stringWithFormat:@"Something went wrong with the lookup.\r\n\r\nPlease try a different sol."]];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSMutableArray *photoArray = [marsData objectForKey:marsPhotos];
    return [photoArray count];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *indexPaths = [collectionView indexPathsForSelectedItems];
    [collectionView deselectItemAtIndexPath:[indexPaths objectAtIndex:0] animated:NO];
    @try {
        
        NSMutableArray *photoArray = [marsData objectForKey:marsPhotos];
        int row = (int)[indexPath row];
        [marsData setObject: photoArray[row] forKey: marsPopup];
        [self dismissViewControllerAnimated:YES completion:NULL];
        [self performSegueWithIdentifier:@"MarsPopupSegue" sender:self];
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger) section{
    return 10.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RoverCollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    int row = (int)[indexPath row];
    UIImageView *imageView = [[cell contentView] viewWithTag:1];

    NSMutableArray *photoArray = [marsData objectForKey:marsPhotos];
        
    UIImage *image = [_thumbnailCache objectForKey: [NSNumber numberWithInt: row]];
    if (image) {
           
           imageView.image = image;
    } else {
    
           const int currentRow = (int)[indexPath row];
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
               
               NSString *url = photoArray[currentRow];
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
                                   NSMutableArray *titleArray = [marsData objectForKey:marsCameraTitles];
                                   UILabel *cameraLabel = [[cell contentView] viewWithTag:2];
                                   [cameraLabel setText: titleArray[currentRow]];
                                   imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
                               });
                           } else {
                                                             
                               NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: photoArray[currentRow]]];
                               UIImage *image;
                               if (data) {
                               
                                   image = [[UIImage alloc] initWithData:data];
                                   [self->_thumbnailCache setObject: image forKey: [NSNumber numberWithInt:currentRow]];
                                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                   NSString *documentsPath = [paths objectAtIndex:0];
                                   NSString *imagePath = [documentsPath stringByAppendingPathComponent:patternResult];
                                   [data writeToFile:imagePath atomically:YES];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                       if (cell) {
                                           
                                           NSMutableArray *titleArray = [marsData objectForKey:marsCameraTitles];
                                           UILabel *cameraLabel = [[cell contentView] viewWithTag:2];
                                           [cameraLabel setText: titleArray[currentRow]];
                                           imageView.image = image;
                                           
                                           NSArray *visibleCells = self.collectionView.visibleCells;
                                           for (UICollectionViewCell *chomp in visibleCells) {
                                               int visibleRow = (int)[[self->_marsCollectionView indexPathForCell:chomp] row];
                                               
                                               if (currentRow == visibleRow) {
                                                   
                                                   NSMutableArray *titleArray = [marsData objectForKey:marsCameraTitles];
                                                   UILabel *cameraLabel = [[cell contentView] viewWithTag:2];
                                                   [cameraLabel setText: titleArray[currentRow]];
                                                   imageView.image = image;
                                               }
                                           }
                                       }
                                   });
                               }
                           }
                       }
                   }
               }
           });
       }
    return cell;
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



