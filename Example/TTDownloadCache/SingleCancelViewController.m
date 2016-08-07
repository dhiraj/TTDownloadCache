//
//  SingleCancelViewController.m
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 8/7/16.
//  Copyright © 2016 Dhiraj Gupta. All rights reserved.
//

#import "SingleCancelViewController.h"
#import "FlickrListItemTableViewCell.h"
@interface SingleCancelViewController ()
@property (nonatomic,strong) TTFlickrItem * item;
@end

@implementation SingleCancelViewController

#define SINGLECELL @"SINGLECELL"
- (void) viewDidLoad{
    self.item = [[TTFlickrItem alloc] initWithDictionary:@{
                                                           @"id": @"28764691366",
                                                           @"owner": @"124740911@N06",
                                                           @"secret": @"8d6c08c760",
                                                           @"server": @"8323",
                                                           @"farm": @9,
                                                           @"title": @"image",
                                                           @"ispublic": @1,
                                                           @"isfriend": @0,
                                                           @"isfamily": @0,
                                                           @"lastupdate": @"1470543765",
                                                           @"ownername": @"junsorex",
                                                           @"url_q": @"https://farm9.staticflickr.com/8323/28764691366_8d6c08c760_q.jpg",
                                                           @"height_q": @"150",
                                                           @"width_q": @"150"
                                                           } error:nil];
    [super viewDidLoad];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlickrListItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SINGLECELL];
    if (indexPath.row == 0) {
        [cell updateFlickrItemTo:self.item cancelImageLoad:YES];
    }
    else{
        [cell updateFlickrItemTo:self.item cancelImageLoad:NO];
    }
    return cell;
}
- (void) loadNextPageIfPossible{/*Don't load data, we're displaying dummy cells*/}

@end
