//
//  AdDescriptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import "AdDescriptor.h"
#import "ServerXMLResponseParser.h"
#import "AdDescriptorHelper.h"


@implementation AdDescriptor

@synthesize adContentType, appId, adId, adType, latitude,longitude, zip, campaignId, trackUrl, serverReponse, serverReponseString;

+ (AdDescriptor*)descriptorFromContent:(NSData*)data frameSize:(CGSize)frameSize aligmentCenter:(BOOL)aligmentCenter {
	AdDescriptor* adDescriptor = [AdDescriptor  new];
	
	if (data) {
        if ([data length] == 0) {
            adDescriptor.adContentType = AdContentTypeEmpty;
        } else {
            adDescriptor.serverReponse = data;
            
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            adDescriptor.serverReponseString = dataString;
            [dataString release];
            
            adDescriptor.adContentType = AdContentTypeUndefined;
            
            if ([adDescriptor.serverReponseString rangeOfString:@"<!-- invalid params -->"].location != NSNotFound) {
                adDescriptor.adContentType = AdContentTypeInvalidParams;
            } else if ([adDescriptor.serverReponseString rangeOfString:@"<!-- Error: 1 ->"].location != NSNotFound) {
                adDescriptor.adContentType = AdContentTypeInvalidParams;
            } else if ([AdDescriptorHelper isVideoContent:adDescriptor.serverReponseString]) {
                adDescriptor.adContentType = AdContentTypeMojivaVideo;
            } else if ([AdDescriptorHelper isExternalCampaign:adDescriptor.serverReponseString]) {
                ServerXMLResponseParser* _xmlResponseParser = [[ServerXMLResponseParser alloc] init];
                [_xmlResponseParser startParseSynchronous:adDescriptor.serverReponseString];
                
                if (_xmlResponseParser.adContentType == AdContentTypeIAd) {
                    adDescriptor.adContentType = AdContentTypeIAd;
                    adDescriptor.adId = _xmlResponseParser.adId;
                    adDescriptor.campaignId = _xmlResponseParser.campaignId;
                    adDescriptor.trackUrl = _xmlResponseParser.trackUrl;
                } else if (_xmlResponseParser.adContentType == AdContentTypeGreystripe) {
                    adDescriptor.adContentType = AdContentTypeGreystripe;
                    adDescriptor.appId = _xmlResponseParser.appId;
                    adDescriptor.campaignId = _xmlResponseParser.campaignId;
                    adDescriptor.trackUrl = _xmlResponseParser.trackUrl;
                } else if (_xmlResponseParser.adContentType == AdContentTypeMillennial) {
                    adDescriptor.adContentType = AdContentTypeMillennial;
                    adDescriptor.appId = _xmlResponseParser.appId;
                    adDescriptor.campaignId = _xmlResponseParser.campaignId;
                    adDescriptor.trackUrl = _xmlResponseParser.trackUrl;
                    adDescriptor.adType = _xmlResponseParser.adType;
                    adDescriptor.latitude = _xmlResponseParser.latitude;
                    adDescriptor.longitude = _xmlResponseParser.longitude;
                    adDescriptor.zip = _xmlResponseParser.zip;
                } else if (_xmlResponseParser.adContentType == AdContentTypeiVdopia) {
                    adDescriptor.adContentType = AdContentTypeiVdopia;
                    adDescriptor.appId = _xmlResponseParser.appId;
                    adDescriptor.campaignId = _xmlResponseParser.campaignId;
                    adDescriptor.trackUrl = _xmlResponseParser.trackUrl;
                } else if (_xmlResponseParser.adContentType == AdContentTypeAdMob) {
                    adDescriptor.adContentType = AdContentTypeAdMob;
                    adDescriptor.appId = _xmlResponseParser.appId;
                    adDescriptor.latitude = _xmlResponseParser.latitude;
                    adDescriptor.longitude = _xmlResponseParser.longitude;
                    adDescriptor.zip = _xmlResponseParser.zip;
                    adDescriptor.campaignId = _xmlResponseParser.campaignId;
                    adDescriptor.trackUrl = _xmlResponseParser.trackUrl;
                } else if (_xmlResponseParser.adContentType == AdContentTypeRhythm) {
                     adDescriptor.adContentType = AdContentTypeRhythm;
                     adDescriptor.appId = _xmlResponseParser.appId;
                     adDescriptor.campaignId = _xmlResponseParser.campaignId;
                     adDescriptor.trackUrl = _xmlResponseParser.trackUrl;
                } else if (_xmlResponseParser.adContentType == AdContentTypeSAS) {
                    adDescriptor.adContentType = AdContentTypeSAS;
                    adDescriptor.appId = _xmlResponseParser.appId;
                    adDescriptor.adId = _xmlResponseParser.adId;
                    adDescriptor.adType = _xmlResponseParser.adType;
                    adDescriptor.campaignId = _xmlResponseParser.campaignId;
                    adDescriptor.trackUrl = _xmlResponseParser.trackUrl;
                } else {
                    adDescriptor.adContentType = AdContentTypeUndefined;
                }
                
                [_xmlResponseParser release];
            } else {
                NSString* clearHtml = [AdDescriptorHelper stringByStrippingHTMLcomments:adDescriptor.serverReponseString];
                if ([clearHtml length] > 0) {
                    adDescriptor.adContentType = AdContentTypeDefaultHtml;
                    adDescriptor.serverReponseString = [AdDescriptorHelper wrapHTML:clearHtml frameSize:frameSize aligmentCenter:aligmentCenter];
                    adDescriptor.serverReponse = [adDescriptor.serverReponseString dataUsingEncoding:NSUTF8StringEncoding];
                } else {
                    adDescriptor.adContentType = AdContentTypeUndefined;
                }
                
            }
        }
	} else {
		adDescriptor.adContentType = AdContentTypeUndefined;
	}
	
	return [adDescriptor autorelease];
}

- (void)dealloc {
	[appId release];
	[adId release];
	[adType release];
	[latitude release];
	[longitude release];
	[zip release];
	[campaignId release];
	[trackUrl release];
	[serverReponse release];
	[serverReponseString release];
	
	[super dealloc];
}

@end
