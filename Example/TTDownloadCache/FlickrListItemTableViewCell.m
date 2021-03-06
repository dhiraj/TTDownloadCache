//
//  FlickrListItemTableViewCell.m
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 8/6/16.
//  Copyright © 2016 Dhiraj Gupta. All rights reserved.
//

#import "FlickrListItemTableViewCell.h"
#import "DateTools.h"
#import "TTAppDelegate.h"

@interface FlickrListItemTableViewCell ()
@property (nonatomic,strong) TTFlickrItem * myItem;
@property (nonatomic,assign) BOOL fetchingImage;
@property (nonatomic,strong) NSString * cancelToken;
@property (nonatomic,assign) BOOL cancelImageLoadImmediately;
@end
@implementation FlickrListItemTableViewCell
#pragma mark - Private
- (void) updateDisplayViews{
    self.textLabel.text = [NSString stringWithFormat:@"%@ - %@",self.myItem.ownername,self.myItem.title];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.myItem.lastupdate];
    self.detailTextLabel.text = date.timeAgoSinceNow;
    [self setNeedsLayout];
    self.fetchingImage = YES;
    NSString * fetchingURL = self.myItem.url_q;
    TTDownloadCache * cache = [UIApplication app].downloadCache;
    self.cancelToken = [cache dataFromURL:fetchingURL withHandler:^(NSData *data,NSString * originalRequest, BOOL fromCache) {
        self.fetchingImage = NO;
        if (![BUtil string:originalRequest isSameAs:fetchingURL]) {
            DLog(@"Image for some other request, returning");
            return ;
        }
        if (!data) {
            DLog(@"Could not get data, returning");
            return ;
        }
        UIImage * img = [UIImage imageWithData:data];
        if (!img) {
            DLog(@"Could not form image from data, returning");
            return;
        }
        self.imageView.image = img;
        [self setNeedsLayout];
    } useMemCache:YES];
    if (self.cancelImageLoadImmediately) {
        [cache cancelRequestWithCancelToken:self.cancelToken];
        //DKG: Switch lines to see the difference between single cancel and cancel all
//        [cache cancelAllRequestsWithURL:self.myItem.url_q];
    }
}
- (void) cancelCurrentImageLoad{
    if (self.fetchingImage) {
        DLog(@"Cancel");
        [[UIApplication app].downloadCache cancelRequestWithCancelToken:self.cancelToken];
    }
    self.imageView.image = nil;
}
#pragma mark - LifeCycle
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.textLabel.numberOfLines = 3;
    }
    return self;
}
- (void) layoutSubviews{
    [super layoutSubviews];
    CGRect mybounds = self.contentView.bounds;
    CGRect remainder = CGRectInset(mybounds, GAP, GAP_HALF);
    CGRect temp;
    CGRectDivide(remainder, &temp, &remainder, 75.0f, CGRectMinXEdge);
    self.imageView.frame = temp;
    CGRectDivide(remainder, &temp, &remainder, GAP, CGRectMinXEdge);
    CGRectDivide(remainder, &temp, &remainder, [BUtil twoThirdsOf:CGRectGetHeight(remainder)], CGRectMinYEdge);
    self.textLabel.frame = temp;
    self.detailTextLabel.frame = remainder;
}

#pragma mark - Exposed
- (void) updateFlickrItemTo:(TTFlickrItem *)item cancelImageLoad:(BOOL)cancel{
    self.cancelImageLoadImmediately = cancel;
    if (self.myItem != nil) {
        [self cancelCurrentImageLoad];
    }
    self.myItem = item;
    [self updateDisplayViews];
}
- (void) updateFlickrItemTo:(TTFlickrItem *)item{
    [self updateFlickrItemTo:item cancelImageLoad:NO];
}
@end
