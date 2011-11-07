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

@synthesize adContentType, externalCampaign, externalContent, appId, adId, adType, latitude,longitude, zip, campaignId, trackUrl, serverReponse, serverReponseString;

+ (AdDescriptor*)descriptorFromContent:(NSData*)data frameSize:(CGSize)frameSize aligmentCenter:(BOOL)aligmentCenter {
	AdDescriptor* adDescriptor = [AdDescriptor  new];
	
	if (data) {
        if ([data length] == 0) {
            adDescriptor.adContentType = AdContentTypeEmpty;
        } else {
            adDescriptor.serverReponse = data;
            adDescriptor.externalCampaign = NO;
            
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            adDescriptor.serverReponseString = dataString;
            [dataString release];
            
            adDescriptor.adContentType = AdContentTypeUndefined;
            
            if ([adDescriptor.serverReponseString.lowercaseString rangeOfString:@"<!-- invalid params -->"].location != NSNotFound) {
                adDescriptor.adContentType = AdContentTypeInvalidParams;
            } else if ([adDescriptor.serverReponseString.lowercaseString rangeOfString:@"<!-- error: -1 -->"].location != NSNotFound) {
                adDescriptor.adContentType = AdContentTypeInvalidParams;
            } else if ([AdDescriptorHelper isVideoContent:adDescriptor.serverReponseString]) {
                adDescriptor.adContentType = AdContentTypeMojivaVideo;
            } else if ([AdDescriptorHelper isExternalCampaign:adDescriptor.serverReponseString]) {
                adDescriptor.externalCampaign = YES;
                
                ServerXMLResponseParser* _xmlResponseParser = [[ServerXMLResponseParser alloc] init];
                [_xmlResponseParser startParseSynchronous:adDescriptor.serverReponseString];
                
                adDescriptor.externalContent = _xmlResponseParser.content;
                
                adDescriptor.adContentType = AdContentTypeUndefined;
                
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
    self.externalContent = nil;
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
