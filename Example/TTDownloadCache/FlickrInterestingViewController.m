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

@interface FlickrInterestingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * arrayResults;
@end

#define SINGLECELL @"SINGLECELL"
@implementation FlickrInterestingViewController

#pragma mark - Private
- (void) reloadTableView{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayResults = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 48.0f;
    [self.tableView registerClass:[FlickrListItemTableViewCell class] forCellReuseIdentifier:SINGLECELL];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.title = S_FlickrInteresting;
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
    return self.arrayResults.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlickrListItemTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:SINGLECELL];
//    [cell updateItemTo:self.arrayMenu[indexPath.row]];
    return cell;
}

@end
