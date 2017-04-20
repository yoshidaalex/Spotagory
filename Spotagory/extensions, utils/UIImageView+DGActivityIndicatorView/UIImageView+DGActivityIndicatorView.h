//
//  UIImageView+ProgressView.h
//
//  Created by Kevin Renskers on 07-06-13.
//  Copyright (c) 2013 Kevin Renskers. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@interface UIImageView (DGActivityIndicatorView)

- (void)sd_setImageWithURL:(NSURL *)url usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView;
- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView;
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock usingDGActivityIndicatorView:(DGActivityIndicatorView *)progressView;
- (void)removeDGActivityIndicatorView;

@end
