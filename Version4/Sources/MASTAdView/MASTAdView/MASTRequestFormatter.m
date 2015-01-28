/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */

//
//  MASTRequestFormatter.m
//  MASTAdView
//
//  Created  on 22/07/14.

//

#import "MASTRequestFormatter.h"
#import "MASTDeviceUtil.h"

//#define kAdServerURL      @"http://ads.mocean.mobi/ad"
#define kAdServerURL        @"http://localhost/mocean_ads/adapter_ads.html"

#define kAdTimeoutInterval 60.0
#define kHTTPMETHOD        @"GET"
#define kZoneId            @"zone="
#define kUserAgent         @"ua"
#define kLatitude          @"lat"
#define kLongitude         @"long"


@interface MASTRequestFormatter()

+ ( NSString* ) setRequestParamwithRequestParamDictionary:(NSDictionary*)requestParamDictionary ForZone:(NSString *) zone;
+ ( void ) setHeaders: (NSMutableURLRequest* ) adRequest;

@property(nonatomic,strong) NSDictionary *customRequestParamDictionary;
@end

@implementation MASTRequestFormatter
@synthesize customRequestParamDictionary;


+(NSURLRequest *) getAdRequestWithRequestParamDictionary:(NSMutableDictionary*)requestParamDictionary ForZone:(NSString *) zone andAdServerURL:(NSString *) adServerURLString;
{
    
    NSString * adRequestURL = [NSString stringWithFormat:@"%@?%@",adServerURLString,
                               [self setRequestParamwithRequestParamDictionary:requestParamDictionary ForZone:zone]];
    
    adRequestURL = [adRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"AdServerRequest : %@",adRequestURL);
    
    // Create the request which will be loaded by the connection
    NSMutableURLRequest *mutableUrlRequest = [NSMutableURLRequest
                                                requestWithURL:[NSURL URLWithString:adRequestURL]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                timeoutInterval:kAdTimeoutInterval];
    
    
    // Set the request method, i.e. GET or POST
    [mutableUrlRequest setHTTPMethod:kHTTPMETHOD];
    
    // Set the required headers for the request.
    [ self setHeaders: mutableUrlRequest ];
    
    // Setting the cookie handling to NO
    // This will disable the cookie information being sent with every request
    [mutableUrlRequest setHTTPShouldHandleCookies:NO];
    
    return mutableUrlRequest;
    
}

+ ( NSString* ) setRequestParamwithRequestParamDictionary:(NSMutableDictionary *)requestParamDictionary ForZone:(NSString *) zone
{
    MASTDeviceUtil *pubParametersInfo = [MASTDeviceUtil sharedInstance];
    
    NSMutableString *requestParamDataString = [[NSMutableString alloc]  init ];
    
    
    // Appending Zone Id to request
    [requestParamDataString appendString:kZoneId];
    [requestParamDataString appendFormat:@"%@",zone];
    
    
    // Appending UserAgent to request
    [requestParamDictionary setObject:pubParametersInfo.userAgent forKey:kUserAgent];
    
    
    if(pubParametersInfo.isLocationDetectionEnabled)
    {
        // Appending Latitude to request
        if(pubParametersInfo.latitude != nil)
        {
            [requestParamDictionary setObject:pubParametersInfo.latitude forKey:kLatitude];
        }
        
        // Appending Longitude to request
        if(pubParametersInfo.latitude != nil)
        {
            [requestParamDictionary setObject:pubParametersInfo.longitude forKey:kLongitude];
        }
    }

    
    for(NSString *key in requestParamDictionary)
    {
        id value = [requestParamDictionary objectForKey:key];
        
        if(value !=nil)
        {
            [requestParamDataString appendString:[NSString stringWithFormat:@"&%@=",key]];
            
            if([value isKindOfClass:[NSString class]])
            {
                // Determines added value is of type string
                 value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [requestParamDataString appendFormat:@"%@",value];
            }
            else
            {
                // Determines added value is of type NSNumber
                 [requestParamDataString appendFormat:@"%@",[value stringValue]];
            }
        }
       
    }
    
    return requestParamDataString;


}


+ ( void ) setHeaders: (NSMutableURLRequest* ) adRequest
{
    
}

@end
