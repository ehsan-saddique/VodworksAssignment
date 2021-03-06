//
//  ItemDetailHeaderVideos.m
//  Vodworks
//
//  Created by Ehsan Saddique on 31/12/2016.
//  Copyright © 2016 Ehsan. All rights reserved.
//

#import "ItemDetailHeaderGallery.h"
#import "GalleryHeaderCollectionViewCell.h"
#import "Video.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"

@implementation ItemDetailHeaderGallery {
    UIImageView *ivFullImage;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    UINib *nib = [UINib nibWithNibName:@"GalleryHeaderCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"GalleryHeaderCollectionViewCell"];
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mediaDataset.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, collectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GalleryHeaderCollectionViewCell *cell = (GalleryHeaderCollectionViewCell *) [self.collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryHeaderCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *cardImage = [_mediaDataset objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[cardImage valueForKey:@"url"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak GalleryHeaderCollectionViewCell *weakCell = cell;
    
    __block BOOL imageLoaded = NO;
    [cell.imgCardImage setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        
                                        weakCell.imgCardImage.image = image;
                                        [weakCell setNeedsLayout];
                                        imageLoaded = YES;
                                        
                                    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                        NSLog(@"image download failed >> %@", error.localizedDescription);
                                        imageLoaded = NO;
                                    }];
    
    cell.imageTapHandler = ^ {
        if (imageLoaded)
            self.imageTapped(weakCell.imgCardImage.image);
    };
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    [self setCellSelection:cell selected:YES firstTimeSelection:NO];
    
    //    [pannedIndexPaths addObject:indexPath];
    //    [self createAppointment];
    
    //    [selectedIdx setValue:@"1" forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    //    if (indexPath.row == 0) {
    //        self.collectionView.scrollEnabled = YES;
    //    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [self setCellSelection:cell selected:NO firstTimeSelection:NO];
}

@end
