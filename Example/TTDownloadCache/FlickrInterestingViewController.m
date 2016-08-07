//
//  FlickrInterestingViewController.m
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 8/6/16.
//  Copyright © 2016 Dhiraj Gupta. All rights reserved.
//

#import "FlickrInterestingViewController.h"
#import "FlickrListItemTableViewCell.h"
#import "TTAppDelegate.h"
#import "JSONPointer.h"
#import "DateTools.h"

@interface FlickrInterestingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * arrayResults;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL hasMaxed;
@property (nonatomic,copy) DataHandler dataHandlerBlock;
@property (nonatomic,assign) BOOL loadingPage;
@end

#define SINGLECELL @"SINGLECELL"
@implementation FlickrInterestingViewController

#pragma mark - Private
- (void) loadNextPageIfPossible{
    DLog(@"");
    if (!self.loadingPage && !self.hasMaxed) {
        self.loadingPage = YES;
        DLog(@"Loading");
    }
    [[UIApplication app].downloadCache dataFromURLRequest:[self nextPageURLRequest] withHandler:self.dataHandlerBlock];
}
- (void) reloadTableViewByAddingArray:(NSArray *)additional{
    NSRange range = NSMakeRange(self.arrayResults.count, additional.count);
    NSIndexSet * iset = [NSIndexSet indexSetWithIndexesInRange:range];
    NSMutableArray * ipaths = [NSMutableArray arrayWithCapacity:additional.count];
    [iset enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath * ipath = [NSIndexPath indexPathForRow:idx inSection:0];
        [ipaths addObject:ipath];
    }];
    [self.tableView beginUpdates];
    [self.arrayResults addObjectsFromArray:additional];
    [self.tableView insertRowsAtIndexPaths:ipaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}
- (NSURLRequest *) nextPageURLRequest{
    NSString * baseURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/"];
    NSMutableDictionary * params = [@{
                                      @"method":@"flickr.interestingness.getList"
                                      ,@"api_key":@"0845bbb79445bf10a0a1ea948aa5dae7"
                                      ,@"per_page":@"10"
                                      ,@"format":@"json"
                                      ,@"nojsoncallback":@"1"
                                      ,@"extras":@"url_q,owner_name,last_update,o_dims"
                                      } mutableCopy];
    self.page += 1;
    params[@"page"] = @(self.page);
    NSString * fullURLString = [NSString stringWithFormat:@"%@?%@",baseURL,[NSString URLQueryWithParameters:params]];
    NSURL * fullURL = fullURLString.URLValue;
    NSURLRequest * request = [NSURLRequest requestWithURL:fullURL];
    DLog(@"Generated request:%@",request);
    return request;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayResults = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 91.0f;
    [self.tableView registerClass:[FlickrListItemTableViewCell class] forCellReuseIdentifier:SINGLECELL];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.title = S_FlickrInteresting;
    __weak FlickrInterestingViewController * weakSelf = self;
    self.dataHandlerBlock = ^(NSData *data, BOOL fromCache) {
        DLog(@"");
        weakSelf.loadingPage = NO;
        if (!data) {
            weakSelf.hasMaxed = YES;
            return ;
        }
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (![BUtil isValidDictionary:dict]) {
            weakSelf.hasMaxed = YES;
            return;
        }
        NSArray * photos = [dict valueForJSONPointer:@"/photos/photo"];
        if (![BUtil isValidArray:photos]) {
            weakSelf.hasMaxed = YES;
            return;
        }
        NSArray * items = [TTFlickrItem arrayOfModelsFromDictionaries:photos error:nil];
        if (![BUtil isValidArray:items]) {
            weakSelf.hasMaxed = YES;
            return;
        }
        [weakSelf reloadTableViewByAddingArray:items];
//        DLog(@"%@",dict);
    };
    [[UIApplication app].downloadCache dataFromURLRequest:[self nextPageURLRequest] withHandler:self.dataHandlerBlock];
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DLog(@"");
    NSArray * ipaths = [self.tableView indexPathsForSelectedRows];
    if ([BUtil isValidArray:ipaths]) {
        [self.tableView deselectRowAtIndexPath:ipaths[0] animated:YES];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    CGFloat bottomHeight = [self.bottomLayoutGuide length];
    CGFloat topHeight = [self.topLayoutGuide length];
    UIEdgeInsets insets = UIEdgeInsetsMake(topHeight, 0, bottomHeight, 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}
#pragma mark - UITableView
- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (targetContentOffset->y + CGRectGetHeight(scrollView.bounds) >= scrollView.contentSize.height - 50) {
        [self loadNextPageIfPossible];
    }
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayResults.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlickrListItemTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:SINGLECELL];
    TTFlickrItem * item = self.arrayResults[indexPath.row];
    [cell updateFlickrItemTo:item];
//    [cell updateItemTo:self.arrayMenu[indexPath.row]];
    return cell;
}

@end
