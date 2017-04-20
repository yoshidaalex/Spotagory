//
//  UIImageView+ProgressView.m
//
//  Created by Kevin Renskers on 07-06-13.
//  Copyright (c) 2013 Kevin Renskers. All rights reserved.
//

#import "UIImageView+DGActivityIndicatorView.h"

#define TAG_PROGRESS_VIEW 149469

@implementation UIImageView (DGActivityIndicatorView)

- (void)addDGActivityIndicatorView:(DGActivityIndicatorView *)indicatorView {
    DGActivityIndicatorView *existingActivityIndicatorVie = (DGActivityIndicatorView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingActivityIndicatorVie) {
        if (!indicatorView) {
            indicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallPulse tintColor:[UIColor lightGrayColor]/*[UIColor colorWithHexValue:0x00D2A1]*/ size:25];
        }

        indicatorView.tag = TAG_PROGRESS_VIEW;
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

        float width = indicatorView.frame.size.width;
        float height = indicatorView.frame.size.height;
        float x = (self.frame.size.width / 2.0) - width/2;
        float y = (self.frame.size.height / 2.0) - height/2;
        indicatorView.frame = CGRectMake(x, y, width, height);
        
        [self addSubview:indicatorView];
        
        [indicatorView startAnimating];
    }
}

- (void)removeDGActivityIndicatorView {
    DGActivityIndicatorView *indicatorView = (DGActivityIndicatorView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (indicatorView) {
        [indicatorView removeFromSuperview];
    }
}

- (void)sd_setImageWithURL:(NSURL *)url usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil usingDGActivityIndicatorView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil usingDGActivityIndicatorView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil usingDGActivityIndicatorView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock usingDGActivityIndicatorView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock usingDGActivityIndicatorView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock usingDGActivityIndicatorView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView {
    [self addDGActivityIndicatorView:progressView];
    
    __weak typeof(self) weakSelf = self;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize);
        }
    }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf removeDGActivityIndicatorView];
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}

@end
