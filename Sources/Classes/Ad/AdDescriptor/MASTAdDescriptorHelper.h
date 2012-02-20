//
//  AdDescriptorHelper.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/3/11.
//

#import <Foundation/Foundation.h>


@interface MASTAdDescriptorHelper : NSObject {}

+ (BOOL)isMedialetsContent:(NSString *)data;
+ (BOOL)isVideoContent:(NSString *)data;
+ (BOOL)isExternalCampaign:(NSString *)data;
+ (NSString*)stringByStrippingHTMLcomments:(NSString *)html;
+ (NSString*)wrapHTML:(NSString *)data frameSize:(CGSize)frameSize aligmentCenter:(BOOL)aligmentCenter;

@end
