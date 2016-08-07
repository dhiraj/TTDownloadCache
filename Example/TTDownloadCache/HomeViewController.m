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
#import "MBProgressHUD.h"
@import QuickLook;


typedef void (^MenuHandler)(NSDictionary * item, NSDictionary * userInfo, UITableView * tableView, NSIndexPath * ipath);


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * arrayMenu;
@end

#define SINGLECELL @"SINGLECELL"
@implementation HomeViewController

#pragma mark - LifeCycle
- (NSString *) pdfFilePath{
    NSString * cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString * filePath = [[cachePath stringByAppendingPathComponent:@"Demo PDF file"] stringByAppendingPathExtension:@"pdf"];
    return filePath;
}
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
    MenuHandler pdfHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Downloading PDF...";
        [[UIApplication app].downloadCache dataFromURL:@"http://www.pdf995.com/samples/pdf.pdf" withHandler:^(NSData *data, NSString *originalURL, BOOL fromCache) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![BUtil isValidDataObject:data]) {
                DLog(@"Couldn't download, skipping!");
                return ;
            }
            NSFileManager * fileman = [NSFileManager defaultManager];
            NSString * filePath = [self pdfFilePath];
            [fileman removeItemAtPath:filePath error:nil];
            [data writeToFile:filePath atomically:NO];
            QLPreviewController * vc = [[QLPreviewController alloc] initWithNibName:nil bundle:nil];
            vc.dataSource = self;
            [self.navigationController pushViewController:vc animated:YES];
            DLog(@"Downloaded");
            
        } useMemCache:NO];
    };
    MenuHandler clearMemCacheHandler = ^void(NSDictionary * item,NSDictionary *userInfo, UITableView * tableView, NSIndexPath * ipath){
        DLog(@"%@, %@",item,userInfo);
        [[UIApplication app].downloadCache clearMemCache];
        [BUtil showOkAlertWithTitle:S_ClearMemory message:S_ClearedMemory];
        [tableView deselectRowAtIndexPath:ipath animated:YES];
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
                            @"title":S_PDF,
                            @"description":S_NonCachedPDFDownload,
                            @"handler":[pdfHandler copy],
                            },
                        @{
                            @"title":S_ClearMemory,
                            @"description":S_PurgeMemCache,
                            @"handler":[clearMemCacheHandler copy],
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
#pragma mark - QLPreviewController
- (NSInteger) numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSURL * url = [self pdfFilePath].URLValue;
    return url;
}
@end
