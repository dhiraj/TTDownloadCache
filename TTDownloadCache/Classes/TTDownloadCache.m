//
//  TTDownloadCache.m
//  Pods
//
//  Created by Dhiraj Gupta on 8/6/16.
//
//

#import "TTDownloadCache.h"
#import "DebugHelpers.h"

@interface TTDownloadCache ()<NSURLSessionDelegate>
@property (nonatomic,strong) NSURLSession * session;
@property (nonatomic,strong) NSMutableDictionary * dictTaskData;
@property (nonatomic,strong) NSMutableDictionary * dictTaskHandlers;
@end
@implementation TTDownloadCache
#pragma mark - Private
#pragma mark - LifeCycle
- (instancetype) init{
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.dictTaskData = [NSMutableDictionary dictionary];
        self.dictTaskHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}
- (BOOL) isValidDataObject:(id)object{
    if (object != nil && [NSNull null] != object && [object isKindOfClass:[NSData class]]) {
        return [object length] > 0;
    }
    return NO;
}

#pragma mark - NSURLSession
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    DLog(@"Finished:%@,Eror:%@",task,error);
    DictionaryResponseHandler handler = self.dictTaskHandlers[task];
    NSData * dataForTask = self.dictTaskData[task];
    [self.dictTaskData removeObjectForKey:task];
    [self.dictTaskHandlers removeObjectForKey:task];
    if (error != nil) {
        if (error.code == -999) {
            return; //Cancelled
        }
        NSURLResponse * resp = task.response;
        DLog(@"API task:%@ errored with error:%@, response:%@",task,error,resp);
#pragma unused(resp)
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,NO);
        });
        return;
    }
    if (![self isValidDataObject:dataForTask]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,NO);
        });
        return;
    }
    NSError * conversionEror = nil;
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:dataForTask options:NSJSONReadingAllowFragments error:&conversionEror];
    if (conversionEror != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil,NO);
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        handler(dict,NO);
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
- (void) dictionaryResponseFromURLRequest:(NSURLRequest *)request withHandler:(DictionaryResponseHandler)blockName{
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request];
    self.dictTaskHandlers[task] = blockName;
    [task resume];
}
@end
