//
//  CacheController.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/15/11.//

#import "MASTCacheController.h"
#import "MASTNetworkQueue.h"
#import "MASTConstants.h"

@implementation MASTCacheController

- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)loadLinks:(NSArray*)links forAdView:(MASTAdView*)adView request:(NSURLRequest*)request origData:(NSData*)origData {
        if (links && [links count] > 0 && adView && request) {
            NSMutableData* resultData = [NSMutableData dataWithData:origData];
            NSMutableArray* cacheReqests = [NSMutableArray new];
            
            for (NSString* url in links) {
                NSURLRequest* newReq = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0f];
                [cacheReqests addObject:newReq];
            }
            
            __block int count = [cacheReqests count];
            
            for (NSURLRequest* r in cacheReqests) {
                [MASTNetworkQueue loadWithRequest:r completion:^(NSURLRequest *req, NSHTTPURLResponse *response, NSData *data, NSError *error) {
                    if (error) {
                        count--;
                        if (count == 0) {                        
                            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:request, resultData, adView, nil]
                                                                                           forKeys:[NSArray arrayWithObjects:@"request", @"data", @"adView", nil]];
                            [[MASTNotificationCenter sharedInstance] postNotificationName:kFinishAdDownloadNotification object:info];
                        }
                    } else {
                        [resultData setData:[MASTCacheController updateResponse:resultData withNewData:data request:req]];
                        count--;
                        if (count == 0) {                        
                            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:request, resultData, adView, nil]
                                                                                           forKeys:[NSArray arrayWithObjects:@"request", @"data", @"adView", nil]];
                            [[MASTNotificationCenter sharedInstance] postNotificationName:kFinishAdDownloadNotification object:info];
                        }
                    }
                }];
            }
            
            [cacheReqests release];
        }
}

+ (NSData*)updateResponse:(NSData*)origData withNewData:(NSData*)newData request:(NSURLRequest*)request {
    NSString* stringResponse = [[[NSString alloc] initWithData:origData encoding:NSUTF8StringEncoding] autorelease];
    
    NSString* url = [[request URL] absoluteString];
    NSString* dirPath = [NSHomeDirectory() stringByAppendingPathComponent:kPathForFolderCache];
    NSString* fileName = [NSString stringWithFormat:@"%@/%d", url, [newData length]];
    
    NSString* ext = [url pathExtension];
    
    NSString* path = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [MASTUtils md5HashForString:fileName], ext]];
    
    if ([newData length] == 0)
    {
        return [stringResponse dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
		NSString *localUrl = [[NSURL fileURLWithPath:path] absoluteString];
		stringResponse = [stringResponse stringByReplacingOccurrencesOfString:url withString:localUrl];
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        if ([newData writeToFile:path atomically:YES]) {
            NSString *localUrl = [[NSURL fileURLWithPath:path] absoluteString];
            stringResponse = [stringResponse stringByReplacingOccurrencesOfString:url withString:localUrl];
        }
    }
    
    return [stringResponse dataUsingEncoding:NSUTF8StringEncoding];
}

@end
