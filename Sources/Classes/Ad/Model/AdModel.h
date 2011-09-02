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

@property (assign) id <AdInterstitialViewDelegate>	delegate;

@property (readonly) BOOL				readyForDisplay;

@property BOOL							testMode;
@property BOOL							logMode;
@property BOOL							animateMode;
@property BOOL							internalOpenMode;
@property NSTimeInterval				updateTimeInterval;
@property (retain) UIImage*				defaultImage;

@property (assign) NSInteger			site;
@property (assign) NSInteger			adZone;
@property AdPremium                     premiumFilter;
@property AdsType                       adsType;
@property AdType                        type;
@property (retain) NSString*			keywords;
@property CGSize						minSize;
@property CGSize						maxSize;
@property (retain) UIColor*             paramBG;
@property (retain) UIColor*             paramLINK;
@property (retain) NSDictionary*        additionalParameters;
@property (retain) NSString*			adServerUrl;

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
@property (retain) UIButton*            closeButton;
@property BOOL                          isDisplayed;

@property BOOL                          aligmentCenter;
@property CGSize                        contentSize;

@property CGRect						frame;

@property (retain) UIView*              snapshot;
@property (retain) NSData*              snapshotRAWData;
@property (retain) NSDate*              snapshotRAWDataTime;
@property (retain) UIView*              currentAdView;

@property (retain) NSMutableArray*      excampaigns;
@property (retain) AdDescriptor*        descriptor;

@property (assign) BOOL                 loading;

@property (retain) NSString*            latitude;
@property (retain) NSString*            longitude;

- (NSString*)url;
- (NSString*)urlIgnoreValifation;

@end
