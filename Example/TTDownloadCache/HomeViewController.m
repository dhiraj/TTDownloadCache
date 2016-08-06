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


typedef void (^MenuHandler)(NSDictionary * item, NSDictionary * userInfo, UITableView * tableView, NSIndexPath * ipath);


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * arrayMenu;
@end

#define SINGLECELL @"SINGLECELL"
@implementation HomeViewController

#pragma mark - Private
- (void) reloadTableView{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    MenuHandler flickrHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
        //        [vc presentViewController:[BUtil navigationControllerWithRoot:submitVC] animated:YES completion:nil];
    };
    MenuHandler clearMemCacheHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
        //        [vc presentViewController:[BUtil navigationControllerWithRoot:submitVC] animated:YES completion:nil];
    };
    MenuHandler clearDiskCacheHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
        //        [vc presentViewController:[BUtil navigationControllerWithRoot:submitVC] animated:YES completion:nil];
    };
    self.arrayMenu = [@[
                        @{
                            @"title":@"Flickr",
                            @"description":@"Show interesting images",
                            @"handler":[flickrHandler copy],
                            },
                        @{
                            @"title":@"Clear Memory",
                            @"description":@"Purge Memory Cache",
                            @"handler":[clearMemCacheHandler copy],
                            },
                        @{
                            @"title":@"Clear Disk",
                            @"description":@"Purge Disk Cache",
                            @"handler":[clearDiskCacheHandler copy],
                            },
                                       ]
                                mutableCopy],
    
    
    
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

@end
