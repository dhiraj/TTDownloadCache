//
//  FlickrListItemTableViewCell.m
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 8/6/16.
//  Copyright © 2016 Dhiraj Gupta. All rights reserved.
//

#import "FlickrListItemTableViewCell.h"
#import "DateTools.h"

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
}
#pragma mark - LifeCycle
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return self;
}

#pragma mark - Exposed
- (void) updateFlickrItemTo:(TTFlickrItem *)item{
    self.myItem = item;
    [self updateDisplayViews];
}

@end
