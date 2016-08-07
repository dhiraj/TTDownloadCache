//
//  TTAppDelegate.h
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 08/06/2016.
//  Copyright (c) 2016 Dhiraj Gupta. All rights reserved.
//
#import "TranslatedStrings.h"
#import "DebugHelpers.h"
#import "BUtil.h"
#import "TTDownloadCache.h"
#import "RequestUtils.h"
#import "TTFlickrItem.h"

@import UIKit;

@interface TTAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TTDownloadCache *downloadCache;
@end

@interface UIApplication (SharedAppDelegate)
+(TTAppDelegate*)app;
@end
