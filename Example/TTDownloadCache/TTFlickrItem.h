//
//  TTFlickrItem.h
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 8/7/16.
//  Copyright © 2016 Dhiraj Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface TTFlickrItem : JSONModel
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * ownername;
@property (nonatomic,copy) NSString * url_t;
@property (nonatomic,assign) double lastupdate;
/*
{"id":"28164579054","owner":"38945681@N07","secret":"ef7a9528dc","server":"8677","farm":9,"title":"Emergence","ispublic":1,"isfriend":0,"isfamily":0,"lastupdate":"1470507429","ownername":"David Swindler (ActionPhotoTours.com)","url_t":"https:\/\/farm9.staticflickr.com\/8677\/28164579054_ef7a9528dc_t.jpg","height_t":"68","width_t":"100"}
 */
@end
