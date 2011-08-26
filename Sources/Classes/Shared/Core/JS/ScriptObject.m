//
//  ScriptObject.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/23/11.
//

#import "ScriptObject.h"
#import "Utils.h"

@interface ScriptObject()

@property (nonatomic, retain) NSMutableArray* callbacks;

@end

@implementation ScriptObject

@synthesize webView, callbacks;

- (id)init {
    self = [super init];
    if (self) {
        self.callbacks = [NSMutableArray array];
    }
    
    return self;
}

- (void)callBacks {
    self.callbacks = nil;
    self.webView = nil;
    [super dealloc];
}

- (BOOL)registerCallbackForFunction:(NSString*)funcDeclaration
                       functionCode:(NSString*)funcCode
                        argumentVar:(NSString*)argumentVar
                                key:(NSString*)key
                          urlSchame:(NSString*)urlSchame
                           delegate:(id <ScriptCallbackDelegate>)callback {
    if (self.webView) {
        NSString* locationUrl = [NSString stringWithFormat:@"%@://random%d/", urlSchame, [Utils randomInteger:9999]];
        
        NSString* returnCode;
        if (argumentVar) {
            returnCode = [NSString stringWithFormat:@"var resultVarTemp1234 = %@; window.location='%@?' + escape(resultVarTemp1234);", argumentVar, locationUrl];
        } else {
            returnCode = [NSString stringWithFormat:@"window.location='%@';", locationUrl];
        }
        
        NSString* script = [NSString stringWithFormat:@"%@ { %@ %@ };",
                            funcDeclaration,
                            funcCode,
                            returnCode];
        
        NSString* scriptResult = [self.webView stringByEvaluatingJavaScriptFromString:script];
        if (scriptResult) {
            NSMutableDictionary* info = [NSMutableDictionary dictionary];
            [info setObject:locationUrl forKey:@"locationUrl"];
            [info setObject:key forKey:@"key"];
            [info setObject:callback forKey:@"callback"];
            [callbacks addObject:info];
            
            return YES;
        }
    }
    
    return NO;
}

- (void)webView:(UIWebView *)view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeOther) {
        NSURL* url = [request URL];
        NSString* urlString = [[url absoluteString] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"?%@", [url query]] withString:@""];
        
        for (NSDictionary* info in callbacks) {
            NSString* locationUrl = [info objectForKey:@"locationUrl"];
            NSLog(@"%@", locationUrl);
            if ([locationUrl isEqualToString:urlString]) {
                NSString* arg = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
                id <ScriptCallbackDelegate> delegate = [info objectForKey:@"callback"];
                NSString* key = [info objectForKey:@"key"];
                
                if (delegate && [delegate respondsToSelector:@selector(callBacktFire:result:)]) {
                    [delegate callBacktFire:key result:arg];
                }
                
                break;
            }
        }
    }
}

@end
