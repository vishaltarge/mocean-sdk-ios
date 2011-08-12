//
//  AdDescriptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import <Foundation/Foundation.h>


typedef enum {
	AdContentTypeUndefined = 0,
    AdContentTypeEmpty,
    AdContentTypeInvalidParams,
	AdContentTypeDefaultHtml,
	AdContentTypeMojivaVideo,
	AdContentTypeGreystripe,
	AdContentTypeMillennial,
	AdContentTypeiVdopia,
	AdContentTypeIAd,
	AdContentTypeAdMob,
	AdContentTypeRhythm,
	AdContentTypeSAS
} AdContentType;


@interface AdDescriptor : NSObject {
}

@property (assign) AdContentType adContentType;
@property (retain) NSString* appId;
@property (retain) NSString* adId;
@property (retain) NSString* adType;
@property (retain) NSString* latitude;
@property (retain) NSString* longitude;
@property (retain) NSString* zip;
@property (retain) NSString* campaignId;
@property (retain) NSString* trackUrl;
@property (retain) NSData* serverReponse;
@property (retain) NSString* serverReponseString;

+ (AdDescriptor*)descriptorFromContent:(NSData*)data frameSize:(CGSize)frameSize aligmentCenter:(BOOL)aligmentCenter;

@end