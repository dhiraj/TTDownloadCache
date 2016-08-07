//
//  MenuTableViewCell.m
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 8/6/16.
//  Copyright © 2016 Dhiraj Gupta. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "TTAppDelegate.h"

@interface MenuTableViewCell ()
@property (nonatomic,strong) NSDictionary * myMenuItem;
@end
@implementation MenuTableViewCell

#pragma mark - Private
- (void) updateDisplayViews{
    if (!self.myMenuItem) {
        DLog(@"No item yet!");
        return;
    }
    self.textLabel.text = self.myMenuItem[@"title"];
    self.detailTextLabel.text = self.myMenuItem[@"description"];
    [self setNeedsLayout];
}
#pragma mark - LifeCycle
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
//    if (self) {
//        
//    }
    return self;
}
- (void) updateItemTo:(NSDictionary *)item{
    self.myMenuItem = item;
    [self updateDisplayViews];
}

@end
