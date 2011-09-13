//
//  OrmmaHelper.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 8/29/11.
//

#import <Foundation/Foundation.h>
#import "OrmmaAdaptor.h"
#import "Reachability.h"

@interface OrmmaHelper : NSObject

+ (NSString*)registerOrmmaUpCaseObject;
+ (NSString*)signalReadyInWebView;

+ (NSString*)setState:(ORMMAState)state;
+ (NSString*)setViewable:(BOOL)viewable;
+ (NSString*)setNetwork:(NetworkStatus)status;
+ (NSString*)setSize:(CGSize)size;
+ (NSString*)setMaxSize:(CGSize)size;
+ (NSString*)setScreenSize:(CGSize)size;
+ (NSString*)setDefaultPosition:(CGRect)frame;
+ (NSString*)setOrientation:(UIDeviceOrientation)orientation;
+ (NSString*)setSupports:(NSArray*)supports;
+ (NSString*)setKeyboardShow:(BOOL)isShow;
+ (NSString*)setTilt:(UIAcceleration*)acceleration;
+ (NSString*)setHeading:(CGFloat)heading;
+ (NSString*)setLatitude:(CGFloat)latitude longitude:(CGFloat)longitude accuracy:(CGFloat)accuracy;

+ (NSString*)fireChangeEvent:(NSString*)value;
+ (NSString*)fireShakeEventInWebView;

+ (CGSize)screenSizeForOrientation:(UIDeviceOrientation)orientation;

@end
