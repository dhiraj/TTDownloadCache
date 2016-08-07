//
//  TTDownloadCacheTests.m
//  TTDownloadCacheTests
//
//  Created by Dhiraj Gupta on 08/06/2016.
//  Copyright (c) 2016 Dhiraj Gupta. All rights reserved.
//

// https://github.com/Specta/Specta


SpecBegin(DownloadCache)

describe(@"Basic", ^{

    __block TTDownloadCache * cache = nil;
    __block NSString * jsonURL = nil;
    beforeAll(^{
        cache = [[TTDownloadCache alloc] initWithMaxSize:20000 * 2];
        jsonURL = @"https://api.flickr.com/services/rest/?extras=url_q%2Cowner_name%2Clast_update%2Co_dims&format=json&method=flickr.interestingness.getList&per_page=10&nojsoncallback=1&page=1&api_key=0845bbb79445bf10a0a1ea948aa5dae7";
    });
    
    it(@"should not be nil", ^{
        XCTAssertNotNil(cache);
    });
    
    it(@"can download JSON", ^{
        waitUntil(^(DoneCallback done) {
            [cache dataFromURL:jsonURL withHandler:^(NSData *data, NSString * request, BOOL fromCache) {
                if(data != nil){
                    done();
                }
            } useMemCache:YES];
            
        });
    });
    it(@"JSON can be cached", ^{
        waitUntil(^(DoneCallback done) {
            [cache dataFromURL:jsonURL withHandler:^(NSData *data, NSString * request, BOOL fromCache) {
                if(data != nil && fromCache){
                    done();
                }
            } useMemCache:YES];
        });
    });
});

SpecEnd

