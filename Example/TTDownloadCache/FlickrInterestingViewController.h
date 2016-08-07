//
//  FlickrInterestingViewController.h
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 8/6/16.
//  Copyright © 2016 Dhiraj Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAppDelegate.h"

@interface FlickrInterestingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (void) loadNextPageIfPossible;
@end
