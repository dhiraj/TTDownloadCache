//
//  TTDownloadCache.m
//  Pods
//
//  Created by Dhiraj Gupta on 8/6/16.
//
//

#import "TTDownloadCache.h"
#import "TTCacheItem.h"
#import "DebugHelpers.h"

@interface TTDownloadCache ()<NSURLSessionDelegate>
@property (nonatomic,strong) NSURLSession * session;
@property (nonatomic,strong) NSMutableDictionary * dictTaskData;
@property (nonatomic,strong) NSMutableDictionary * dictTaskHandlers;
@property (nonatomic,assign) unsigned long long maxSize;
@property (nonatomic,strong) NSMutableOrderedSet * setLRU;
@property (nonatomic,strong) NSCache * memCache;
@end
@implementation TTDownloadCache
#pragma mark - Private
- (BOOL) isValidDataObject:(id)object{
    if (object != nil && [NSNull null] != object && [object isKindOfClass:[NSData class]]) {
        return [object length] > 0;
    }
    return NO;
}
#pragma mark - Notification Handlers
- (void) appdidReceiveMemoryWarning:(NSNotification *)notification{
    [self.memCache removeAllObjects];
    [self.setLRU removeAllObjects];
    DLog(@"%@",notification);
}
#pragma mark - LifeCycle
- (instancetype) initWithMaxSize:(unsigned long long)byteSize{
    self = [super init];
    if (self) {
        self.maxSize = byteSize;
        self.setLRU = [NSMutableOrderedSet orderedSet];
        self.memCache = [[NSCache alloc] init];
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        config.URLCache = nil;
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.dictTaskData = [NSMutableDictionary dictionary];
        self.dictTaskHandlers = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appdidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    return self;
    
}
- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSURLSession
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    DLog(@"Finished:%@,Eror:%@",task,error);
    DataHandler handler = self.dictTaskHandlers[task];
    NSData * dataForTask = self.dictTaskData[task];
    [self.dictTaskData removeObjectForKey:task];
    [self.dictTaskHandlers removeObjectForKey:task];
    if (error != nil) {
        if (error.code == -999) {
            DLog(@"Cancelled");
            return; //Cancelled
        }
        NSURLResponse * resp = task.response;
        DLog(@"API task:%@ errored with error:%@, response:%@",task,error,resp);
#pragma unused(resp)
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,task.originalRequest.URL.absoluteString,NO);
        });
        return;
    }
    if (![self isValidDataObject:dataForTask]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,task.originalRequest.URL.absoluteString,NO);
        });
        return;
    }
    BOOL useMemCache = [[task.taskDescription substringToIndex:1] isEqualToString:@"1"];
    if (useMemCache) {
        TTCacheItem * item = [[TTCacheItem alloc] initWithKey:task.originalRequest.URL.absoluteString];
        [self.setLRU addObject:item];
        [self.memCache setObject:dataForTask forKey:item];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        handler(dataForTask,task.originalRequest.URL.absoluteString,NO);
    });
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSMutableData * oldDataForTask = self.dictTaskData[dataTask];
    if (![self isValidDataObject:oldDataForTask]) {
        oldDataForTask = [NSMutableData data];
    }
    if ([self isValidDataObject:data]) {
        [oldDataForTask appendData:data];
        DLog(@"Added %lu bytes",(unsigned long)data.length);
#ifdef DEBUG
        NSString * sData = @"";
        if (data.length < 10000) {
            sData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            DLog(@"%@",sData);
        }
#endif
    }
    self.dictTaskData[dataTask] = oldDataForTask;
}
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    DLog(@"%@",error);
}
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    DLog(@"%@",challenge);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
}
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler{
    DLog(@"REDIRECTING: %@->%@",response,request);
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler{
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler{
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    DLog(@"Sent %lld / %lld",totalBytesSent,totalBytesExpectedToSend);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    DLog(@"Response received:%@",response);
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask{
    DLog(@"");
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler{
    DLog(@"");
    completionHandler(proposedResponse);
}

#pragma mark - Exposed
- (NSString *) dataFromURL:(NSString *)request withHandler:(DataHandler)blockName useMemCache:(BOOL)useCache{
    if (useCache) {
        TTCacheItem * requestedItem = [[TTCacheItem alloc] initWithKey:request];
        if ([self.setLRU containsObject:requestedItem]) {
            NSData * data = [self.memCache objectForKey:requestedItem];
            if ([self isValidDataObject:data]) {
                DLog(@"Cache HIT! %@ Bytes:%d",request,data.length);
                blockName(data,request,YES);
                return request;
            }
            else{
                DLog(@"Object for request:%@ evicted?",request);
            }
        }
        else{
            DLog(@"Cache miss");
        }
    }
    NSURLSessionDataTask * task = [self.session dataTaskWithURL:[NSURL URLWithString:request]];
    NSString * uuid = [[NSUUID UUID] UUIDString];
    task.taskDescription = [NSString stringWithFormat:@"%@%@",(useCache)?@"1":@"0",uuid];
    self.dictTaskHandlers[task] = blockName;
    [task resume];
    return uuid;
}
- (void) cancelAllRequestsWithURL:(NSString *)url{
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionDataTask * task in dataTasks) {
            if ([[[task.originalRequest URL] absoluteString] compare:url options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                [task cancel];
                DLog(@"Cancelled :%@",task.originalRequest);
            }
        }
    }];
}
- (void) cancelRequestWithCancelToken:(NSString *)token{
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        for (NSURLSessionDataTask * task in dataTasks) {
            if ([[task.taskDescription substringFromIndex:1] isEqualToString:token]) {
                [task cancel];
                DLog(@"Cancelled :%@",token);
                break;
            }
        }
    }];
}
@end
