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
@end
@implementation FlickrListItemTableViewCell
#pragma mark - Private
- (void) updateDisplayViews{
    self.textLabel.text = [NSString stringWithFormat:@"%@ - %@",self.myItem.ownername,self.myItem.title];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.myItem.lastupdate];
    self.detailTextLabel.text = date.timeAgoSinceNow;
    [self setNeedsLayout];
    [[UIApplication app].downloadCache dataFromURLRequest:[NSURLRequest GETRequestWithURL:self.myItem.url_q.URLValue parameters:@{}] withHandler:^(NSData *data, BOOL fromCache) {
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
        DLog(@"Got image!");
    }];
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
    CGRect remainder = CGRectInset(mybounds, GAP, GAP);
    CGRect temp;
    CGRectDivide(remainder, &temp, &remainder, 75.0f, CGRectMinXEdge);
    self.imageView.frame = temp;
    CGRectDivide(remainder, &temp, &remainder, GAP, CGRectMinXEdge);
    CGRectDivide(remainder, &temp, &remainder, [BUtil twoThirdsOf:CGRectGetHeight(remainder)], CGRectMinYEdge);
    self.textLabel.frame = temp;
    self.detailTextLabel.frame = remainder;
}

#pragma mark - Exposed
- (void) updateFlickrItemTo:(TTFlickrItem *)item{
    self.myItem = item;
    [self updateDisplayViews];
}

@end
