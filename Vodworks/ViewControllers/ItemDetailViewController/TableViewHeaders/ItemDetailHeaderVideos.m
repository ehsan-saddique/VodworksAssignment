//
//  ItemDetailHeaderVideos.m
//  Vodworks
//
//  Created by Ehsan Saddique on 31/12/2016.
//  Copyright © 2016 Ehsan. All rights reserved.
//

#import "ItemDetailHeaderVideos.h"
#import "VideoHeaderCollectionViewCell.h"
#import "Video.h"
#import "UIImageView+AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation ItemDetailHeaderVideos {
    MPMoviePlayerController *moviePlayerController;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    UINib *nib = [UINib nibWithNibName:@"VideoHeaderCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"VideoHeaderCollectionViewCell"];
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mediaDataset.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoHeaderCollectionViewCell *cell = (VideoHeaderCollectionViewCell *) [self.collectionView dequeueReusableCellWithReuseIdentifier:@"VideoHeaderCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *cardImage = [_mediaDataset objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[cardImage valueForKey:@"url"]];
    
    if (_mediaDataset.count == 1) {
        cell.imgArrowRight.hidden = YES;
    }
    else {
        if (indexPath.row == 0) {
            cell.imgArrowRight.hidden = NO;
        }
        else {
            cell.imgArrowRight.hidden = YES;
        }
    }
    
    cell.playButtonTapHandler = ^{
        
        moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [moviePlayerController.view setFrame:self.superview.frame];
        [self.superview addSubview:moviePlayerController.view];
        moviePlayerController.fullscreen = YES;
        [moviePlayerController play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerWillExitFullscreenNotification object:moviePlayerController];
    };
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *as = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *ima = [[AVAssetImageGenerator alloc] initWithAsset:as];
        NSError *err = NULL;
        CMTime time = CMTimeMake(5, 1);
        CGImageRef imgRef = [ima copyCGImageAtTime:time actualTime:NULL error:&err];
        UIImage *currentImg = [[UIImage alloc] initWithCGImage:imgRef];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (currentImg) {
                cell.imgCardImage.hidden = NO;
                cell.imgCardImage.image = currentImg;
            }
        });
    });                                  
    
    return cell;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    
    MPMoviePlayerController *player = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player stop];
        [player.view removeFromSuperview];
    }
}

-(void)MPMoviePlayerThumbnailImageRequestDidFinishNotification: (NSDictionary*)info{
    
    UIImage *image = [info objectForKey:MPMoviePlayerThumbnailImageKey];
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
