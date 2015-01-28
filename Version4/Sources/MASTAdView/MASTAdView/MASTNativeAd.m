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
//  MASTNativeAd.m
//  MASTAdView
//
//  Created  on 03/07/14.

//

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "MASTNativeAd.h"
#import "MASTRequestFormatter.h"
#import "MASTDeviceUtil.h"
#import "MASTDefaults.h"
#import "MASTConstants.h"
#import "MASTNativeAdAttributes.h"



#define kdistanceFilter 1000

@interface MASTNativeAd()<MASTNativeAdapterDelegate>

@property(nonatomic,strong)NSArray *impressionTrackerArray;
@property(nonatomic,strong)NSArray *clickTrackerArray;
@property(nonatomic,strong)NSString *landingPageURL;
@property(nonatomic,strong) NSDictionary *adapterAdResponseDictionary;
@property(nonatomic,strong) NSDictionary *nativeAdResponseDictionary;
@property(nonatomic,strong) MASTBaseAdapter *baseAdapter;

-(void) loadImageInView:(UIImageView *)imageView WithURL:(NSString *) urlString;
-(void) parseNativeAdData:(NSData *) responseData;
-(void) resetAdResponse;

@end




@implementation MASTNativeAd
@synthesize zone;
@synthesize error = _error;
@synthesize adServerURL;
@synthesize nativeAdProperties;
@synthesize delegate;
@synthesize nativeAdCoverImageSize=_nativeAdCoverImageSize;
@synthesize nativeAdIconSize=_nativeAdIconSize;
@synthesize nativeAdCTALength = _nativeAdCTALength;
@synthesize nativeAdDescriptionLength = _nativeAdDescriptionLength;
@synthesize nativeAdTitleLength = _nativeAdTitleLength;
@synthesize title=_title;
@synthesize adDescription=_adDescription;
@synthesize callToAction=_callToAction;
@synthesize iconImageURL=_iconImageURL;
@synthesize coverImageURL=_coverImageURL;
@synthesize rating=_rating;
@synthesize impressionTrackerArray=_impressionTrackerArray;
@synthesize clickTrackerArray=_clickTrackerArray;
@synthesize landingPageURL=_landingPageURL;
@synthesize adapterAdResponseDictionary=_adapterAdResponseDictionary;
@synthesize nativeAdResponseDictionary=_nativeAdResponseDictionary;
@synthesize test=_test;
@synthesize adType=_adType;
@synthesize adSubType=_adSubType;
@synthesize thirdpartyFeedId=_thirdpartyFeedId;
@synthesize thirdpartyFeedName=_thirdpartyFeedName;
@synthesize thirdpartyFeedProperties=_thirdpartyFeedProperties;
@synthesize nativeContent=_nativeContent;
@synthesize baseAdapter=_baseAdapter;
@synthesize parentViewController=_parentViewController;
@synthesize clickableView=_clickableView;
@synthesize useAdapter=_useAdapter;
@synthesize adAttributes=_adAttributes;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //_adAttributes;
        
        self.nativeAdProperties = [[NSMutableDictionary alloc] init];
        self.adServerURL=MAST_DEFAULT_AD_SERVER_URL;
        [self.nativeAdProperties setObject:MAST_DEFAULT_NATIVE_AD_TYPE forKey:MASTNativeAdTypeKey];
        [self.nativeAdProperties setObject:MAST_DEFAULT_NATIVE_AD_KEY forKey:MASTNativeAdKey_key];
         [self.nativeAdProperties setObject:MAST_DEFAULT_NATIVE_AD_COUNT forKey:MASTNativeAdCountKey];
         [self.nativeAdProperties setObject:MAST_DEFAULT_VERSION forKey:MASTNativeSDKVersionKey];
        self.useAdapter = YES;
        
        // Fetch the defaults for the cell info (can be overriden as well).
        CTTelephonyNetworkInfo* networkInfo = [CTTelephonyNetworkInfo new];
        CTCarrier* carrier = [networkInfo subscriberCellularProvider];
        NSString* mcc = [carrier mobileCountryCode];
        NSString* mnc = [carrier mobileNetworkCode];
        
        if ([mcc length] > 0)
            [self.nativeAdProperties setValue:[NSString stringWithFormat:@"%@", mcc] forKey:MASTNativeAdRequestMCCKey];
        
        if ([mnc length] > 0)
            [self.nativeAdProperties setValue:[NSString stringWithFormat:@"%@", mnc] forKey:MASTNativeAdRequestMNCKey];
        
    }
    return self;
}

-(void)setNativeContent:(NSString *)nativeContent
{
     [self.nativeAdProperties setObject:nativeContent forKey:MASTNativeAdRequestNativeContentKey];
    _nativeContent=nativeContent;
}

-(void)setNativeAdIconSize:(CGSize)nativeIconSize
{
    if(nativeIconSize.width > 0 && nativeIconSize.height > 0)
    {
        [self.nativeAdProperties setObject:[NSNumber numberWithFloat:nativeIconSize.width] forKey:MASTNativeAdRequestIconSizeX_Key];
        [self.nativeAdProperties setObject:[NSNumber numberWithFloat:nativeIconSize.height] forKey:MASTNativeAdRequestIconSizeY_Key];
        _nativeAdIconSize=nativeIconSize;
    }
    else
    {
        NSLog(@"Warning : Unable to set invalid Icon Size. Please check the same. ");
    }
    
}

-(void) setNativeAdCoverImageSize:(CGSize)nativeCoverImageSize
{
    if(nativeCoverImageSize.width > 0 && nativeCoverImageSize.height > 0)
    {
        [self.nativeAdProperties setObject:[NSNumber numberWithFloat:nativeCoverImageSize.width] forKey:MASTNativeAdRequestImageSizeX_Key];
        [self.nativeAdProperties setObject:[NSNumber numberWithFloat:nativeCoverImageSize.height] forKey:MASTNativeAdRequestImageSizeY_Key];
         [self.nativeAdProperties setObject:[NSNumber numberWithFloat:(nativeCoverImageSize.width/nativeCoverImageSize.height)] forKey:MASTNativeAdRequestImageRatioKey];
        _nativeAdCoverImageSize=nativeCoverImageSize;
    }
    else
    {
        NSLog(@"Warning : Unable to set invalid Image size. Please check the same. ");
    }


}

-(void) setNativeAdCTALength:(CGFloat)nativeAdCTALength
{
    if(nativeAdCTALength > 0)
    {
        [self.nativeAdProperties setObject:[NSNumber numberWithFloat:nativeAdCTALength] forKey:MASTNativeAdRequestCTALengthKey];
        _nativeAdCTALength = nativeAdCTALength;
    }
    else
    {
        NSLog(@"Warning : Unable to set invalid cta length. Please check the same. ");
    }
}

-(void) setNativeAdDescriptionLength:(CGFloat)nativeAdDescriptionLength
{
    if(nativeAdDescriptionLength > 0)
    {
        [self.nativeAdProperties setObject:[NSNumber numberWithFloat:nativeAdDescriptionLength] forKey:MASTNativeAdRequestDescriptionKey ];
        _nativeAdDescriptionLength = nativeAdDescriptionLength;
    }
    else
    {
        NSLog(@"Warning : Unable to set invalid Ad Description Length. Please check the same. ");
    }

}

-(void) setNativeAdTitleLength:(CGFloat)nativeAdTitleLength
{
    if(nativeAdTitleLength > 0)
    {
        [self.nativeAdProperties setObject:[NSNumber numberWithFloat:nativeAdTitleLength] forKey:MASTNativeAdRequestTitleKey];
        _nativeAdTitleLength = nativeAdTitleLength;
    }
    else
    {
        NSLog(@"Warning : Unable to set invalid Ad Title Length. Please check the same. ");
    }

}

-(void) setTest:(BOOL)test
{
    if (test)
        [self.nativeAdProperties setValue:@"1" forKey:MASTNativeAdRequestTestKey];
    _test=test;

}

-(void) update
{
    [self resetAdResponse];
    
    NSURLRequest *request = [MASTRequestFormatter getAdRequestWithRequestParamDictionary:self.nativeAdProperties ForZone:[NSString stringWithFormat:@"%ld",(long)self.zone] andAdServerURL:self.adServerURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError)
        {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
              [self parseNativeAdData:data];
            
            // Error code received, displaying error code to user
            if(_error != nil)
            {
                if([self.delegate respondsToSelector:@selector(MASTAdView:didFailToReceiveAdWithError:)])
                {
                    [self.delegate MASTAdView:self didFailToReceiveAdWithError:_error];
                }
                return;

            }
            
            if( [self.adSubType isEqualToString:MASTNativeAdResponseAdSubTypeNativeKey])
            {
                if((_landingPageURL == nil) ||  (_title==nil && _adDescription == nil && _iconImageURL== nil && _coverImageURL == nil && _rating == 0))
                {
                    // TODO : Error due to invalid ad
                    if([self.delegate respondsToSelector:@selector(MASTAdView:didFailToReceiveAdWithError:)])
                    {
                        NSError *err = [NSError errorWithDomain:@"Invalid Ad Served , Missing  mandatory params in response" code:0 userInfo:nil];
                        [self.delegate MASTAdView:self didFailToReceiveAdWithError:err];
                    }
                    return;

                }
                
                // Delegatingad received call to user
                [self invokeDelegateSelector:@selector(MASTAdViewDidRecieveAd:)];
            }
            // Third party ad received
            else if ([self.adSubType isEqualToString:MASTNativeAdResponseAdSubTypeThirdPartyKey])
            {
                if (!self.useAdapter)
                {
               
                    // Delegating third party ad received to user
                    if ([self.delegate respondsToSelector:@selector(MASTAdView:didReceiveThirdPartyRequest:withParams:)])
                    {
                        [self invokeDelegateBlock:^
                         {
                             [self.delegate MASTAdView:self
                           didReceiveThirdPartyRequest:self.nativeAdProperties
                                            withParams:self.adapterAdResponseDictionary];
                         }];
                    }
                }
                else
                {
                    
                self.baseAdapter = [MASTBaseAdapter getAdapterForClassName:_thirdpartyFeedName];
                self.baseAdapter.adapterDictionary=self.adapterAdResponseDictionary;
                self.baseAdapter.delegate = self;
                self.baseAdapter.nativeAd = self;
                self.baseAdapter.parentViewController = self.parentViewController;
                self.baseAdapter.clickableView = self.clickableView;
                [self.baseAdapter loadAd];
                }


            }
            else{
                
                // TODO: Put no ad to serve error
                if([self.delegate respondsToSelector:@selector(MASTAdView:didFailToReceiveAdWithError:)])
                {
                    NSError *err = [NSError errorWithDomain:@"No Ad to serve at this momentte" code:0 userInfo:nil];
                    [self.delegate MASTAdView:self didFailToReceiveAdWithError:err];
                }
                
            }
            
        }
        else
        {
            // TODO : Error due to network
            if([self.delegate respondsToSelector:@selector(MASTAdView:didFailToReceiveAdWithError:)])
            {
                [self.delegate MASTAdView:self didFailToReceiveAdWithError:connectionError];
            }
        }
    }];
    
}

-(void) parseNativeAdData:(NSData *) responseData
{
    NSError *error;
    NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *adProperties;
    NSDictionary *adInfo=nil;
    
    if(jsonData != nil)
    {
        
        adProperties = [jsonData objectForKey:MASTNativeAdResponseAdsKey];
        adInfo = [adProperties objectAtIndex:0];
    }
    
    if (adInfo != nil)
    {
        _adType=[adInfo objectForKey:MASTNativeAdResponseAdTypeKey];
        _adSubType=[adInfo objectForKey:MASTNativeAdResponseAdSubTypeKey];
        _creativeid = [adInfo objectForKey:MASTNativeAdResponseAdCreativeIdKey];
        
        if( [self.adSubType isEqualToString:MASTNativeAdResponseAdSubTypeNativeKey])
        {
            if(_adAttributes == nil)
            _adAttributes = [[MASTNativeAdAttributes alloc] init];
            
            
            _title = [adInfo objectForKey:MASTNativeAdResponseTitleKey];
            _adDescription = [adInfo objectForKey:MASTNativeAdResponseDescriptionKey];
            _iconImageURL = [[adInfo objectForKey:MASTNativeAdResponseIconImageKey] objectForKey:MASTNativeAdResponseURLKey];
            _coverImageURL = [[adInfo objectForKey:MASTNativeAdResponseMainImageKey] objectForKey:MASTNativeAdResponseURLKey];
            _callToAction = [[adInfo objectForKey:MASTNativeAdResponseCTAKey] objectForKey:MASTNativeAdResponseTextKey];
            _rating = [adInfo objectForKey:MASTNativeAdResponseRatingKey];
            _landingPageURL = [adInfo objectForKey:MASTNativeAdResponseLandingPageURLKey];
        }
        else if ([self.adSubType isEqualToString:MASTNativeAdResponseAdSubTypeThirdPartyKey])
        {
            _thirdpartyFeedId = [adInfo valueForKey:MASTNativeAdResponseFeedIdKey];
            _thirdpartyFeedName = [adInfo objectForKey:MASTNativeAdResponseFeedKey];
            self.adapterAdResponseDictionary= [adInfo objectForKey:MASTNativeAdResponseFeedDataKey];
        }
        else {
            NSString *error_desc = [adInfo objectForKey:@"error"];
            _error = [NSError errorWithDomain:error_desc code:0 userInfo:nil];
            
        }
        
        _impressionTrackerArray = [adInfo objectForKey:MASTNativeAdResponseImpressionTrackerKey];
        _clickTrackerArray = [adInfo objectForKey:MASTNativeAdResponseClickTrackerKey];
        
        self.nativeAdResponseDictionary= [adInfo mutableCopy];
    }
    
    
}


-(void) sendDefaultAdRequest
{
    if(self.adapterAdResponseDictionary != nil)
    {
        if ([[self.adapterAdResponseDictionary objectForKey:@"source"] isEqualToString:@"direct"])
        {
                [self.nativeAdProperties setObject:self.creativeid forKey:MASTNativeAdRequestDirectDefaultKey];
        }
        else if ([[self.adapterAdResponseDictionary objectForKey:@"source"] isEqualToString:@"mediation"])
        {
            [self.nativeAdProperties setObject:self.thirdpartyFeedId forKey:MASTNativeAdRequestMediationDefaultNetworkIDKey];
        }
    }
    
    [self update];
    [self.nativeAdProperties removeObjectForKey:MASTNativeAdRequestDirectDefaultKey];
    [self.nativeAdProperties removeObjectForKey:MASTNativeAdRequestMediationDefaultNetworkIDKey];
    
}

-(void) resetAdResponse
{
    self.nativeAdResponseDictionary = nil;
    self.adapterAdResponseDictionary = nil;
    _title = nil;
    _adDescription = nil;
    _iconImageURL = nil;
    _coverImageURL = nil;
    _callToAction = nil;
    _rating = nil;
    _landingPageURL = nil;
    _thirdpartyFeedId = nil;
    _thirdpartyFeedName = nil;
    _error=nil;

}

// This helper is used for delegate methods that only take self as an argument and
// have a void return.
//
// Should NEVER pass a selector that may have a return object since the compiler/ARC
// may not know how to deal with the memory constraints on anything returned.  For
// delegate methods that expect to return something use the block method below and
// not this helper.
// Can be called from any thread.
- (void)invokeDelegateSelector:(SEL)selector
{
    if ([self.delegate respondsToSelector:selector])
    {
        [self invokeDelegateBlock:^
         {
             // Working around the warning until Apple fixes it.  As stated above
             // the delegate methods used here should have void return types.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
             [self.delegate performSelector:selector withObject:self];
#pragma clang diagnostic pop
         }];
    }
}

// Can be called on any thread but if called on the non-main thread
// will block until the main thread executes the block.
- (void)invokeDelegateBlock:(dispatch_block_t)block
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_sync(queue, block);
    }
}



- (void)setLocationDetectionEnabled:(BOOL)enabled
{
    [self setLocationDetectionEnabledWithSignificantUpdating:YES
                                 distanceFilter:kdistanceFilter
                                desiredAccuracy:kCLLocationAccuracyThreeKilometers];
    
}

- (void)setLocationDetectionEnabledWithSignificantUpdating:(BOOL)significantUpdating
                               distanceFilter:(CLLocationDistance)distanceFilter
                              desiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
    MASTDeviceUtil *deviceUtil = [MASTDeviceUtil sharedInstance];
    [deviceUtil enableAutoLocationRetrivialWithSignificantUpdating:significantUpdating distanceFilter:distanceFilter desiredAccuracy:desiredAccuracy];
    
}

-(void) sendTrackerFromView:(UIView *) view
{
    if(self.baseAdapter != nil)
    {
        [self.baseAdapter sendTracker];
    }
    
    for (NSString *tracker in self.impressionTrackerArray) {
        
        NSURL *url = [NSURL URLWithString:tracker];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if(!connectionError)
            {
                NSLog(@"TrackingURL %@ sent",tracker);
            }
            else
                NSLog(@"TrackingURL %@ not sent",tracker);
                NSLog(@"Connection Error : %@",[connectionError description]);
        }];

      
    }
    
}

-(void) sendClickTracker
{
    if(self.baseAdapter != nil)
    {
        [self.baseAdapter sendClickTracker];
    }
    
    for (NSString *tracker in self.clickTrackerArray) {
        
        NSURL *url = [NSURL URLWithString:tracker];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if(!connectionError)
            NSLog(@"Click TrackingURL %@ sent",tracker);
            else
                 NSLog(@"Click  TrackingURL %@ not sent",tracker);
                NSLog(@"Connection Error : %@",[connectionError description]);
        }];
        
        

    }
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.landingPageURL]];
    
}

-(void)loadCoverImageInView:(UIImageView *)imageView
{
    [self loadImageInView:imageView WithURL:self.coverImageURL];
}

-(void)loadIconImageInView:(UIImageView *)imageView
{
    [self loadImageInView:imageView WithURL:self.iconImageURL];
}

-(void) loadImageInView:(UIImageView *)imageView WithURL:(NSString *) urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        imageView.image = [UIImage imageWithData:data];
        
    }];
}

#pragma mark - Adapter Delegates

- (void) adapterDidReceiveAdWithAdapter:(MASTBaseAdapter*) adapter
{
    NSLog(@"Adapter Received Ad");
    
   
    _iconImageURL = adapter.adAttributes.iconImageURL;
    _coverImageURL = adapter.adAttributes.coverImageURL;
    _title = adapter.adAttributes.title;
    _callToAction = adapter.adAttributes.callToAction;
    _adDescription = adapter.adAttributes.adDescription;
    _rating = adapter.adAttributes.rating;
    
    
    // Delegatingad received call to user
    [self invokeDelegateSelector:@selector(MASTAdViewDidRecieveAd:)];
}

- (void) adapterDidFailToFetchAdWithAdapter:(MASTBaseAdapter *)adapter withError:(NSError *)error
{
    NSLog(@"Adapter failed to receive ad");
    [self sendDefaultAdRequest];
}

// Will be called when the Ad is clicked by the user
- (void) adapterWithAdClickedWithAdapter:(MASTBaseAdapter*) adapter
{
    [self sendClickTracker];
}



@end
