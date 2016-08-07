//
//  HomeViewController.m
//  TTDownloadCache
//
//  Created by Dhiraj Gupta on 8/6/16.
//  Copyright © 2016 Dhiraj Gupta. All rights reserved.
//

#import "HomeViewController.h"
#import "TTAppDelegate.h"
#import "MenuTableViewCell.h"
#import "FlickrInterestingViewController.h"
#import "SingleCancelViewController.h"


typedef void (^MenuHandler)(NSDictionary * item, NSDictionary * userInfo, UITableView * tableView, NSIndexPath * ipath);


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * arrayMenu;
@end

#define SINGLECELL @"SINGLECELL"
@implementation HomeViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    MenuHandler flickrHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
        FlickrInterestingViewController * vc = [[FlickrInterestingViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    };
    MenuHandler singleCancelHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
        SingleCancelViewController * vc = [[SingleCancelViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    };
    MenuHandler clearMemCacheHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
    };
    MenuHandler clearDiskCacheHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
    };
    self.arrayMenu = [@[
                        @{
                            @"title":S_Flickr,
                            @"description":S_ShowInterestingImages,
                            @"handler":[flickrHandler copy],
                            },
                        @{
                            @"title":S_Flickr,
                            @"description":S_CancelFirstImageDownload,
                            @"handler":[singleCancelHandler copy],
                            },
                        @{
                            @"title":S_ClearMemory,
                            @"description":S_PurgeMemCache,
                            @"handler":[clearMemCacheHandler copy],
                            },
                        @{
                            @"title":S_ClearDisk,
                            @"description":S_ClearMemory,
                            @"handler":[clearDiskCacheHandler copy],
                            },
                                       ]
                      mutableCopy];
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 48.0f;
    [self.tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:SINGLECELL];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.title = S_DownloadCache;
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
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayMenu.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:SINGLECELL];
    [cell updateItemTo:self.arrayMenu[indexPath.row]];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * item = self.arrayMenu[indexPath.row];
    MenuHandler handler = item[@"handler"];
    if (!handler) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    handler(item,nil,self.tableView,indexPath);
}

@end
