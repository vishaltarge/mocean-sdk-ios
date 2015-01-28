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
#import "MASTResponseParser.h"
#import "MASTBrowser.h"
#import "MASTNativeAdResponse.h"
#import "PUBLoggers.h"


#define kdistanceFilter 1000

@interface MASTNativeAd()<MASTNativeAdapterDelegate,MASTAdBrowserDelegate>

@property(nonatomic,strong) NSMutableArray *impressionTrackerArray;
@property(nonatomic,strong) NSMutableArray *clickTrackerArray;
@property(nonatomic,strong) NSString *landingPageURL;
@property(nonatomic,strong) NSString *thirdPartyFeedSource;
@property(nonatomic,strong) NSDictionary *adapterAdResponseDictionary;
@property(nonatomic,strong) MASTBaseAdapter *baseAdapter;
@property(nonatomic,strong) MASTBrowser * browser;
@property(nonatomic,strong) NSMutableDictionary *testDeviceIdDictionary;
@property(nonatomic,strong) NSDictionary *adapterKeyDictionary;

@property(nonatomic,strong) NSOperationQueue *clickTrackingOperations;
@property(nonatomic,assign) UIBackgroundTaskIdentifier bgTask;
@property(nonatomic,assign) int defCount;

-(void) parseNativeAdData:(NSData *) responseData;
-(void) retrieveAd;
-(void) resetAdResponse;

@property (nonatomic, strong) UIViewController* parentViewController;
@property (nonatomic, strong) UIView* clickableView;


/*
 @method -openInAppBrowserWithURL:withViewCotroller:completionHandler
 @param -
 url - Ladning page URL
 @param -
 controller - UIViewcontroller on which browser is presented
 @param -
 handler - Completon handler
 
 */
-(void) openInAppBrowserWithURL:(NSURL *)url withViewCotroller:(UIViewController *) controller completionHandler:(CompletionHandler)handler;

@end

// LogMode common to class
static MASTLogMode mastLogMode;


@implementation MASTNativeAd
@synthesize zone;
@synthesize error = _error;
@synthesize browser=_browser;
@synthesize adServerURL;
@synthesize adRequestParameters;
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
@synthesize nativeAdLogoImageSize=_nativeAdLogoImageSize;
@synthesize adapterKeyDictionary=_adapterKeyDictionary;
@synthesize thirdPartyFeedSource=_thirdPartyFeedSource;
@synthesize defCount=_defCount;

-(instancetype)initWithAdServer:(NSString *)adServerUrl andZone:(NSInteger )aZone{
    
    self = [super init];
    if (self) {
        [self commonInit];
        self.adServerURL = adServerUrl;
        self.zone = aZone;
    }
    return self;
}

-(void)commonInit{
    
    self.adRequestParameters = [[NSMutableDictionary alloc] init];
    self.adServerURL=MAST_DEFAULT_AD_SERVER_URL;
    [self.adRequestParameters setObject:MAST_DEFAULT_NATIVE_AD_TYPE forKey:MASTNativeAdTypeKey];
    [self.adRequestParameters setObject:MAST_DEFAULT_NATIVE_AD_KEY forKey:MASTNativeAdKey_key];
    [self.adRequestParameters setObject:MAST_DEFAULT_NATIVE_AD_COUNT forKey:MASTNativeAdCountKey];
    [self.adRequestParameters setObject:MAST_DEFAULT_VERSION forKey:MASTNativeSDKVersionKey];
    [PUBLoggers enableLogging:YES];
    self.useAdapter = YES;
    
    
    // Fetch the defaults for the cell info (can be overriden as well).
    CTTelephonyNetworkInfo* networkInfo = [CTTelephonyNetworkInfo new];
    CTCarrier* carrier = [networkInfo subscriberCellularProvider];
    NSString* mcc = [carrier mobileCountryCode];
    NSString* mnc = [carrier mobileNetworkCode];
    
    if ([mcc length] > 0)
        [self.adRequestParameters setValue:[NSString stringWithFormat:@"%@", mcc] forKey:MASTNativeAdRequestMCCKey];
    
    if ([mnc length] > 0)
        [self.adRequestParameters setValue:[NSString stringWithFormat:@"%@", mnc] forKey:MASTNativeAdRequestMNCKey];
    
    self.adapterKeyDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:MASTNativeAdFacebookAdapterClassName, MASTNativeAdResponseFacebookAdKey,MASTNativeAdMoPubAdapterClassName,MASTNativeAdResponseMoPubAdKey,nil];
    
    //To assure approximatley 100% hits for click tracking URLs when app launches landing page url in external App
    self.clickTrackingOperations = [NSOperationQueue new];
    [self.clickTrackingOperations addObserver:self forKeyPath:MASTNativeAdClickTrackingURLBackGroundQueue options:0 context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object: nil];
    
    // Setting LogLevel
    [MASTNativeAd setLogLevel:MASTLogNone];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.adServerURL=MAST_DEFAULT_AD_SERVER_URL;
    }
    return self;
}

-(void)setNativeContent:(NSString *)nativeContent
{
    if(nativeContent != nil)
    {
         [self.adRequestParameters setObject:nativeContent forKey:MASTNativeAdRequestNativeContentKey];
        _nativeContent=nativeContent;
    }
}

-(void)setNativeAdIconSize:(CGSize)nativeIconSize
{
    if(nativeIconSize.width > 0 && nativeIconSize.height > 0)
    {
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeIconSize.width] forKey:MASTNativeAdRequestIconSizeX_Key];
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeIconSize.height] forKey:MASTNativeAdRequestIconSizeY_Key];
        _nativeAdIconSize=nativeIconSize;
    }
    else
    {
        WarnLog(@"Warning : Unable to set invalid Icon Size. Please check the same. ");
    }
    
}

-(void) setNativeAdCoverImageSize:(CGSize)nativeCoverImageSize
{
    if(nativeCoverImageSize.width > 0 && nativeCoverImageSize.height > 0)
    {
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeCoverImageSize.width] forKey:MASTNativeAdRequestImageSizeX_Key];
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeCoverImageSize.height] forKey:MASTNativeAdRequestImageSizeY_Key];
        _nativeAdCoverImageSize=nativeCoverImageSize;
    }
    else
    {
        WarnLog(@"Warning : Unable to set invalid Cover Image size. Please check the same. ");
    }


}

-(void) setNativeAdLogoImageSize:(CGSize)nativeAdLogoImageSize
{
    if(nativeAdLogoImageSize.width > 0 && nativeAdLogoImageSize.height > 0)
    {
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeAdLogoImageSize.width] forKey:MASTNativeAdRequestLogoSizeX_Key];
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeAdLogoImageSize.height] forKey:MASTNativeAdRequestLogoSizeY_Key];
        _nativeAdCoverImageSize=nativeAdLogoImageSize;
    }
    else
    {
        WarnLog(@"Warning : Unable to set invalid Logo Image size. Please check the same. ");
    }
    
    
}

-(void) setNativeAdCTALength:(CGFloat)nativeAdCTALength
{
    if(nativeAdCTALength > 0)
    {
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeAdCTALength] forKey:MASTNativeAdRequestCTALengthKey];
        _nativeAdCTALength = nativeAdCTALength;
    }
    else
    {
        WarnLog(@"Warning : Unable to set invalid cta length. Please check the same. ");
    }
}

-(void) setNativeAdDescriptionLength:(CGFloat)nativeAdDescriptionLength
{
    if(nativeAdDescriptionLength > 0)
    {
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeAdDescriptionLength] forKey:MASTNativeAdRequestDescriptionKey ];
        _nativeAdDescriptionLength = nativeAdDescriptionLength;
    }
    else
    {
        WarnLog(@"Warning : Unable to set invalid Ad Description Length. Please check the same. ");
    }

}

-(void) setNativeAdTitleLength:(CGFloat)nativeAdTitleLength
{
    if(nativeAdTitleLength > 0)
    {
        [self.adRequestParameters setObject:[NSNumber numberWithFloat:nativeAdTitleLength] forKey:MASTNativeAdRequestTitleKey];
        _nativeAdTitleLength = nativeAdTitleLength;
    }
    else
    {
        WarnLog(@"Warning : Unable to set invalid Ad Title Length. Please check the same. ");
    }

}

-(void) setTest:(BOOL)test
{
    if (test)
        [self.adRequestParameters setValue:@"1" forKey:MASTNativeAdRequestTestKey];
    _test=test;

}

+(void) setLogLevel:(MASTLogMode)logMode
{
    mastLogMode = logMode;
    [PUBLoggers setLogMode:logMode];
}

-(NSMutableDictionary * )testDeviceIdDictionary{
    
    if(!_testDeviceIdDictionary){
        
        _testDeviceIdDictionary = [NSMutableDictionary new];
    }
    return _testDeviceIdDictionary;
}

-(void) addTestDeviceId:(NSString *)testDeviceId forNetwork:(MediationNetwork)network
{
    
    [self.testDeviceIdDictionary setObject:testDeviceId forKey:[self keyForNetwork:network]];

}

-(void) removeTestDeviceIdForNetwork:(MediationNetwork)netowrk{
 
    [self.testDeviceIdDictionary removeObjectForKey:[self keyForNetwork:netowrk]];

}

- (NSDictionary *)nativeAdResponseDictionary
{
    NSMutableDictionary *mutable_adInfo = [_nativeAdResponseDictionary mutableCopy];
    [mutable_adInfo removeObjectForKey:MASTNativeAdResponseImpressionTrackerKey];
    [mutable_adInfo removeObjectForKey:MASTNativeAdResponseClickTrackerKey];
    return [mutable_adInfo copy];
    
}

-(NSString *)keyForNetwork:(MediationNetwork )network{
 
    //kept blank instead of nil to avoid failure of method objectForKey of testDeviceIdDictionary
    NSString * key = @"";
    switch(network){
            
        case kFaceBook:{
            
            key = [NSString stringWithFormat:MAST_NATIVE_TEST_DEVICE_ID_KEY,MASTNativeAdFacebookMediation];
        }
        break;
        case kMoPub:{
            
            key = [NSString stringWithFormat:MAST_NATIVE_TEST_DEVICE_ID_KEY,MASTNativeAdMoPubMediation];
        }
        break;
        default:{
            
          key =  @"";
        }
    }
    return key;
}

-(NSString* ) testDeviceIdForNetwork:(MediationNetwork)netowrk{
 
    NSString * testId = [self.testDeviceIdDictionary objectForKey:[self keyForNetwork:netowrk]];
    return testId;
}

// Public api for retrieving ads
-(void) update
{
    @try {
        [self resetAdResponse];
        [self retrieveAd];
    }
    @catch (NSException *exception) {
        
        // It is expected that control will never reach here . However catching any unexpected error and preventing publisher app
        // from crash due to SDK
        DebugLog(@"Some thing went wrong with setup. Please verify !!! ");
    }
   
   
    
}

// Internal function to retrieve ads
-(void) retrieveAd
{
    
    NSURLRequest *request = [MASTRequestFormatter getAdRequestWithRequestParamDictionary:self.adRequestParameters ForZone:[NSString stringWithFormat:@"%ld",(long)self.zone] andAdServerURL:self.adServerURL];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        if(self.adRequestParameters != nil)
        {
            if(!connectionError)
            {
    
                @try
                {
                  [self parseNativeAdData:data];
                }
                // Catch any parsing error and throw invalid ad response error
                @catch(NSException *exception)
                {
                    _error = [NSError errorWithDomain:@"Invalid Ad response encountered !!!!" code:0 userInfo:nil];
                }
                
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
                               didReceiveThirdPartyRequest:self.adRequestParameters
                                                withParams:self.adapterAdResponseDictionary];
                             }];
                        }
                    }
                    else
                    {
                    NSString *adapterName = [self.adapterKeyDictionary objectForKey:_thirdpartyFeedName];
                    self.baseAdapter = [MASTBaseAdapter getAdapterForClassName:adapterName];
                    
                    if(self.baseAdapter != nil)
                    {
                        self.baseAdapter.adapterDictionary=self.adapterAdResponseDictionary;
                        [self.baseAdapter setLogLevel:mastLogMode];
                        self.baseAdapter.delegate = self;
                        self.baseAdapter.nativeAd = self;
                        self.baseAdapter.parentViewController = self.parentViewController;
                        self.baseAdapter.clickableView = self.clickableView;
                        [self.baseAdapter loadAd];
                    }
                    else{
                        ErrorLog(@"%@ Adapter not found !!!!",adapterName);
                        [self handleAdNetworkDefault];
                    }
                    
                    }


                }
                else{
                    
                    if([self.delegate respondsToSelector:@selector(MASTAdView:didFailToReceiveAdWithError:)])
                    {
                        NSError *err = [NSError errorWithDomain:@"No Ad to serve at this momentte" code:0 userInfo:nil];
                        [self.delegate MASTAdView:self didFailToReceiveAdWithError:err];
                    }
                    
                }
                
            }
            else
            {
                if([self.delegate respondsToSelector:@selector(MASTAdView:didFailToReceiveAdWithError:)])
                {
                    [self.delegate MASTAdView:self didFailToReceiveAdWithError:connectionError];
                }
            }
        }
        else
        {
            ErrorLog(@"No instance exists !!!! response ignored");
        }
    }];
    
}

-(void) parseNativeAdData:(NSData *) responseData
{
    NSError *error;
    
    NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    // Checking for error
    if([[jsonData allKeys] containsObject:@"error"])
    {
        NSString *error_desc = [jsonData objectForKey:MASTNativeAdResponseErrorKey];
        _error = [NSError errorWithDomain:error_desc code:0 userInfo:nil];
        return;
        
    }
    else
    {
        MASTResponse *adResponse = [MASTResponseParser parseNativeAd:jsonData];
        
        if ([adResponse isKindOfClass:[MASTAdResponse class]]) {
             MASTAdResponse *mastAdResponse = (MASTAdResponse *)adResponse;
            
            _landingPageURL=[mastAdResponse.landingPageURL description];
            _impressionTrackerArray=[mastAdResponse.impressionTrackerArray mutableCopy];
            _clickTrackerArray=[mastAdResponse.clickTrackerArray mutableCopy];
            _adSubType=mastAdResponse.subtype;
            _creativeid=[NSString stringWithFormat:@"%d",mastAdResponse.creativeId];
            
            
            if ([adResponse isKindOfClass:[MASTNativeAdResponse class]]) {
                
                MASTNativeAdResponse *nativeResponse = (MASTNativeAdResponse *)adResponse;
                
                _title = nativeResponse.nativeAd.title;
                _adDescription = nativeResponse.nativeAd.adDescription;
                _iconImageURL = nativeResponse.nativeAd.iconImageURL;
                _coverImageURL=nativeResponse.nativeAd.coverImageURL;
                _callToAction=nativeResponse.nativeAd.callToAction;
                _rating=nativeResponse.nativeAd.rating;
                
                NSMutableDictionary *adDictionary = [jsonData mutableCopy];
                [adDictionary removeObjectForKey:MASTNativeAdResponseImpressionTrackerKey];
                
                NSMutableDictionary * linkDictionary = [adDictionary objectForKey:MASTNativeAdResponseLinkKey];
                
                if ([[linkDictionary allKeys] containsObject:MASTNativeAdResponseClickTrackerKey]) {
                    [linkDictionary removeObjectForKey:MASTNativeAdResponseClickTrackerKey];
                     [adDictionary setObject:linkDictionary forKey:MASTNativeAdResponseLinkKey];
                }
                
                
                self.nativeAdResponseDictionary = [adDictionary copy];
                
            }
            else if ([adResponse isKindOfClass:[MASTMediationResponse class]])
            {
                MASTMediationResponse *mediationResponse = (MASTMediationResponse *)adResponse;
                
                _thirdpartyFeedId = mediationResponse.mediationId;
                _thirdpartyFeedName = mediationResponse.mediationFeedName;
                _thirdPartyFeedSource = mediationResponse.mediationSource;
                self.adapterAdResponseDictionary= mediationResponse.mediationDataDictionary;
                
                NSMutableDictionary *adDictionary = [jsonData mutableCopy];
                [adDictionary removeObjectForKey:MASTNativeAdResponseImpressionTrackerKey];
                [adDictionary removeObjectForKey:MASTNativeAdResponseClickTrackerKey];
            
                self.nativeAdResponseDictionary = [adDictionary copy];
            }

            
            
        }
        else if ([adResponse isKindOfClass:[MASTErrorResponse class]])
        {
            MASTErrorResponse *errorResponse = (MASTErrorResponse *) adResponse;
            _error = [NSError errorWithDomain:errorResponse.errorMessage code:0 userInfo:nil];
        }
    }
    
    
}


-(void) handleAdNetworkDefault
{
    if(self.adapterAdResponseDictionary != nil)
    {
        if ([_thirdPartyFeedSource isEqualToString:MASTNativeAdResponseDirectKey])
        {
            [self.adRequestParameters setObject:self.creativeid forKey:MASTNativeAdRequestDirectDefaultKey];
        }
        else if ([_thirdPartyFeedSource isEqualToString:MASTNativeAdResponseMediationKey])
        {
            [self.adRequestParameters setObject:self.thirdpartyFeedId forKey:MASTNativeAdRequestMediationDefaultNetworkIDKey];

        }
    }
    
    [self retrieveAd];
}

-(void) resetAdResponse
{
    self.nativeAdResponseDictionary = nil;
    self.adapterAdResponseDictionary = nil;
    self.baseAdapter=nil;
    _defCount=0;
    _creativeid=nil;
    _thirdpartyFeedId=nil;
    _thirdPartyFeedSource=nil;
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
    [self.adRequestParameters removeObjectForKey:MASTNativeAdRequestDirectDefaultKey];
    [self.adRequestParameters removeObjectForKey:MASTNativeAdRequestMediationDefaultNetworkIDKey];
    

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


-(void)trackViewForInteractions:(UIView*)view withViewController:(UIViewController* )viewCotroller{
    
    self.clickableView = view;
    self.parentViewController = viewCotroller;
    
    if(self.baseAdapter != nil)
    {
        [self.baseAdapter trackViewForInteractions:view withViewController:viewCotroller];
        
    }else{
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nativeAdAdDidClick)];
        [view addGestureRecognizer:tapGesture];

    }
    [self sendImpressionTrackers];
}

-(void)nativeAdAdDidClick{

    [self postAdClickAction];
    [self openInAppBrowserWithURL:[NSURL URLWithString:self.landingPageURL] withViewCotroller:self.parentViewController completionHandler:^{
        
    }];

}

-(void)postAdClickAction{
    
    [self sendClickTracker];
    [self invokeDelegateSelector:@selector(nativeAdDidClick:)];

}

-(void) sendImpressionTrackers
{
    
    NSArray *trackerArray= [self.impressionTrackerArray copy];
    
    for (NSString *tracker in trackerArray) {
        
        NSURL *url = [NSURL URLWithString:tracker];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            if(!connectionError)
            {
                [self.impressionTrackerArray removeObject:tracker];
            }
            else{
                ErrorLog(@"Connection Error : %@",[connectionError description]);
            }
        }];
    }
    
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == self.clickTrackingOperations && [keyPath isEqualToString:MASTNativeAdClickTrackingURLBackGroundQueue]) {
        if ([self.clickTrackingOperations.operations count] == 0) {
        
            InfoLog(@"CLick tracking url sent sucessfully !!!");
            [self endBackGroundTask];
            
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

-(void)applicationWillEnterForeground:(NSNotification*)notification{
    
    if(self.bgTask != UIBackgroundTaskInvalid){
        [self endBackGroundTask];
    }
    if([self.clickTrackingOperations operationCount]>0){
        
        [self.clickTrackingOperations setSuspended:NO];
    }
    
}

-(void)endBackGroundTask{

    UIApplication *app = [UIApplication sharedApplication];
    [app endBackgroundTask:self.bgTask];
    self.bgTask = UIBackgroundTaskInvalid;

}

-(void) sendClickTracker
{
    
    UIApplication *app = [UIApplication sharedApplication];
    
    if([[UIDevice currentDevice] isMultitaskingSupported]){
        self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            
            if([self.clickTrackingOperations operationCount]>0){
                
                [self.clickTrackingOperations setSuspended:YES];
            }
        }];
    }
    NSArray *trackerArray= [self.clickTrackerArray copy];
    for (NSString *tracker in trackerArray) {
        
        [self.clickTrackingOperations addOperationWithBlock:^{
            
            
            NSURL *url = [NSURL URLWithString:tracker];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse * responce = nil;
            NSError * error = nil;
            [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&error];
            
            if(!error){
                [self.clickTrackerArray removeObject:tracker];
                
            }
            else{
                ErrorLog(@"Connection Error : %@",[error description]);
            }
            
        }];
        
    }
    
}

-(void) loadInImageView:(UIImageView *)imageView withURL:(NSString *) urlString
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
    InfoLog(@"Adapter Received Ad");
    
   
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
    InfoLog(@"Adapter failed to receive ad");
    [self handleAdNetworkDefault];

}

// Will be called when the Ad is clicked by the user
- (void) adapterWithAdClickedWithAdapter:(MASTBaseAdapter*) adapter
{
    [self postAdClickAction];
}

-(void) destroy
{
    
    self.adServerURL=nil;
    self.nativeContent=nil;
    self.adRequestParameters=nil;
    self.browser=nil;
    self.clickableView = nil;
    _adAttributes=nil;
    _title=nil;
    _adType=nil;
    _adSubType=nil;
    _creativeid=nil;
    _adDescription=nil;
    _callToAction=nil;
    _iconImageURL=nil;
    _coverImageURL=nil;
    _error=nil;
    _thirdpartyFeedName=nil;
    [self.clickTrackingOperations removeObserver:self forKeyPath:@"operationCount"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    self.clickTrackingOperations = nil;
}



-(void) dealloc
{
    [self destroy];
}

#pragma AddOns
-(void) openInAppBrowserWithURL:(NSURL *)url withViewCotroller:(UIViewController *) controller completionHandler:(CompletionHandler)handler{

    self.browser = [[MASTBrowser alloc] init];
    self.browser.delegate=self;
    [controller presentViewController:self.browser animated:YES completion:^{
        [self.browser setURL:url];
        handler();
    }];
}

-(NSString *)responseLog{
    

    NSMutableDictionary * attribues = [NSMutableDictionary dictionaryWithDictionary:self.nativeAdResponseDictionary];
    [attribues removeObjectForKey:MASTNativeAdResponseImpressionTrackerKey];
    [attribues removeObjectForKey:MASTNativeAdResponseClickTrackerKey];
   return attribues.description;
}
#pragma mark- MASTBrowserDelegates

- (void)MASTAdBrowser:(MASTAdBrowser*)browser didFailLoadWithError:(NSError*)error
{
    [self.browser dismissViewControllerAnimated:YES completion:NO];
}


- (void)MASTAdBrowserWillLeaveApplication:(MASTAdBrowser*)browser
{
    [self.browser dismissViewControllerAnimated:YES completion:NO];
}

- (void)MASTAdBrowserClose:(MASTAdBrowser *)browser
{
    self.browser = nil;
    InfoLog(@"In-App Browser Dismissed");
}


@end
