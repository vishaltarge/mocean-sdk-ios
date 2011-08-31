//
//  AdDescriptorHelper.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/3/11.
//

#import "AdDescriptorHelper.h"


@implementation AdDescriptorHelper

+ (BOOL)isMedialetsContent:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"medialets:launchAd?"];
	
	return textRange.location != NSNotFound;
}

+ (BOOL)isVideoContent:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"<video"];
	
	return textRange.location != NSNotFound;
}


+ (BOOL)isExternalCampaign:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"<!-- client_side_external_campaign"];
	
	return textRange.location != NSNotFound;
}

+ (NSString*)stringByStrippingHTMLcomments:(NSString *)html {
    NSScanner *thescanner;
    NSString *text = nil;
    
    if ([html rangeOfString:@"<!--//"].location == NSNotFound) {
        thescanner = [NSScanner scannerWithString:html];
        
        while ([thescanner isAtEnd] == NO) {
            
            // find start of tag
            [thescanner scanUpToString:@"<!--" intoString:nil] ; 
            
            // find end of tag
            [thescanner scanUpToString:@"-->" intoString:&text] ;
            
            // replace the found tag with a space
            //(you can filter multi-spaces out later if you wish)
            html = [html stringByReplacingOccurrencesOfString:
                    [NSString stringWithFormat:@"%@-->", text] withString:@""];
            
        } // while //
    }
    
    return html;	
}


+ (NSString*)wrapHTML:(NSString *)data frameSize:(CGSize)frameSize aligmentCenter:(BOOL)aligmentCenter {
	/*NSString* html = [NSString stringWithFormat:@"<html><head><style> body { margin:0; padding:0; }</style><script type=\"text/javascript\">%@ %@</script></head><body>%@</body></html>",kJavaScript_ormma_bridge,kJavaScript_ormma, data];
     */
    NSString* html = nil;
    if (aligmentCenter) {
         html = [NSString stringWithFormat:@"<html><head><style> body { margin:0; padding:0; }</style></head><body><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\" width=\"%f\" height=\"%f\"><tr><td align=\"center\" valign=\"middle\"><div id=\"contentheight\"><span id=\"contentwidth\">%@</span></div></td></tr></table></body></html>",frameSize.width, frameSize.height, data];
     } else {
         html = [NSString stringWithFormat:@"<html><head><style> body { margin:0; padding:0; }</style></head><body><div id=\"contentheight\"><span id=\"contentwidth\">%@</span></div></body></html>", data];
     }
    /*
	[html appendFormat:@"<html><head><meta name=\"viewport\" content=\"width=%.0f,minimum-scale=1.0,maximum-scale=1.0\">", formWidth];

	[html appendFormat:@"<style> body { margin:0; padding:0; } img { max-width:%.0f; max-height:%.0f; }</style>", frameSize.width, frameSize.height];
	[html appendString:@"</head><body>"];
	[html appendString:data];
	[html appendString:@"</body></html>"];
	*/
    return html;
}

@end
