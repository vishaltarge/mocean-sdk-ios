//
//  SmartAdServerDefaultAd.h
//  SmartAdServer
//
//  Created by Julien Stoeffler on 06/01/10.
//  Copyright 2010 Smart AdServer. All rights reserved.
//
 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SmartAdServerAd : NSObject {
	UIImage *image;
	UIImage *landscapeImage;
	float duration;
	UIColor *backgroundColor;
	NSURL *creativeURL;
	NSURL *redirectURL;
	NSURL *countURL;
	NSString *text;
	UIColor *textColor;
	BOOL expandedAtInit;
	
	BOOL expand;
	BOOL fromTop;
	BOOL skip;
	CGRect skipRect;
	CGRect skipRectLandscape;
	NSURL *creativeLandscapeUrl;
	int creativeType;
	NSString *creativeScript;
	int transitionType;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *landscapeImage;

// Duration in seconds. Not used for a banner ad.
@property float duration;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) NSURL *creativeURL;
@property (nonatomic, retain) NSURL *redirectURL;
// An url that will be called when the user click on your ad
@property (nonatomic, retain) NSURL *countURL;

// In the case of an expandable ad
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
// Expand the ad at initialization
@property BOOL expandedAtInit;

@property BOOL expand;
@property BOOL fromTop;
@property BOOL skip;
@property CGRect skipRect;
@property CGRect skipRectLandscape;
@property (nonatomic, retain) NSURL *creativeLandscapeUrl;
@property int creativeType;
@property (nonatomic, retain) NSString *creativeScript;
@property int transitionType;

// init custom ad
- (id) initWithPortraitImage:(UIImage *)img landscapeImage:(UIImage *)imgLd clickURL:(NSURL *)url;
@end
