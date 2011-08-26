//
//  ScriptObject.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/23/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ScriptCallbackDelegate <NSObject> 
- (void)callBacktFire:(NSString*)key result:(NSString*)result;
@end

@interface ScriptObject : NSObject

@property (nonatomic, retain) UIWebView*        webView;

/*
 * funcCode - js code. use block comments only!
 * returnVar - var name. Ensure var is string. Only string allowed
 *
 * Example:
 * funcDeclaration = @"function fName(arg)"
 * funcCode = @"var result = arg+'test';"
 * argumentVarVar = @"result"
 * urlSchame = @"ormma"
 */

- (BOOL)registerCallbackForFunction:(NSString*)funcDeclaration
                       functionCode:(NSString*)funcCode
                        argumentVar:(NSString*)argumentVar
                                key:(NSString*)key
                          urlSchame:(NSString*)urlSchame
                           delegate:(id <ScriptCallbackDelegate>)callback;

- (void)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
