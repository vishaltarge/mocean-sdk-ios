//
//  AdModel.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/1/11.
//

#import <Foundation/Foundation.h>

#import "AdView.h"
#import "AdDelegate.h"
#import "SharedModel.h"
#import "AdDescriptor.h"


@interface AdModel : NSObject {

}

@property (assign) id <AdViewDelegate>	delegate;

@property (readonly) BOOL				readyForDisplay;

@property BOOL							testMode;
@property AdLogMode                     logMode;
@property BOOL							animateMode;
@property BOOL							internalOpenMode;
@property NSInteger						track;
@property NSTimeInterval				updateTimeInterval;
@property (retain) UIImage*				defaultImage;

@property (assign) NSInteger			site;
@property (assign) NSInteger			adZone;
@property AdPremium                     premiumFilter;
@property AdType                        type;
@property (retain) NSString*			keywords;
@property CGSize						minSize;
@property CGSize						maxSize;
@property BOOL                          isUserSetMaxSize;
@property (retain) UIColor*             paramBG;
@property (retain) UIColor*             paramLINK;
@property (retain) NSDictionary*        additionalParameters;
@property (retain) NSString*			adServerUrl;
@property (assign) NSInteger            timeout;

@property (assign) NSInteger			advertiserId;
@property (retain) NSString*			groupCode;

@property (retain) NSString*            country;
@property (retain) NSString*            region;
@property (retain) NSString*            city;
@property (retain) NSString*            area;
@property (retain) NSString*            metro;
@property (retain) NSString*            zip;
@property (retain) NSString*            carrier;

@property NSTimeInterval                showCloseButtonTime;
@property NSTimeInterval                autocloseInterstitialTime;
@property (retain) NSDate*              startDisplayDate;
@property BOOL                          isDisplayed;

@property BOOL                          aligmentCenter;
@property CGSize                        contentSize;

@property CGRect						frame;
@property BOOL                          visibleState;

@property (retain) UIView*              snapshot;
@property (retain) NSData*              snapshotRAWData;
@property (retain) NSDate*              snapshotRAWDataTime;
@property (retain) UIView*              currentAdView;
@property (assign) AdView*              adView;

@property (retain) NSMutableArray*      excampaigns;
@property (retain) AdDescriptor*        descriptor;

@property (assign) BOOL                 loading;

@property (retain) NSString*            latitude;
@property (retain) NSString*            longitude;

- (NSString*)url;
- (NSString*)urlIgnoreValifation;

- (void)cancelAllNetworkConnection;
- (void)closeInternalBrowser;
- (void)pauseVideoViewPlayer;

@end
