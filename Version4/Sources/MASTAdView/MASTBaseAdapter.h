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
//  PUBBaseAdapter.h
//  PUBBaseAdapter
//


#pragma once

// SYSTEM IMPORTS
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// USER IMPORTS
#import "MASTNativeAdapterDelegate.h"
#import "MASTNativeAdAttributes.h"

@class MASTNativeAd;

//
// The enum denotes the Log levels for Adapters.
// The log level set to the bannerView will also be set to adapters, if the
// particular SDK supports log levels.
//
typedef enum {
    PUBAdapterLogNone = -1,
    PUBAdapterLogDebug,
    PUBAdapterLogInfo,
    PUBAdapterLogWarn,
    PUBAdapterLogError
} PUBAdapterLogMode;

//
// This class will be used as base class for integrating any third-party SDK.
// Adapter for every Ad-network SDK must inherit this class.
//
@interface MASTBaseAdapter :NSObject

// This is the adapter delegate which will used to inform the calling view.
// The methods of PUBAdapterDelegate are implemented in bannerView to support
// mediation. The adapter should notify the events of the third party sdk ad views
// in order to have successful integration with PubMatic SDK's mediation framework.
@property(nonatomic, assign) id<MASTNativeAdapterDelegate> delegate;

// This is the rootViewController object which will be used to present modal view
// when user clicks on Ad. This will generally be the parent view of PUBBannerView.

@property(nonatomic,retain) NSDictionary *adapterDictionary;
@property(nonatomic,retain) MASTNativeAdAttributes *adAttributes;
@property (nonatomic, retain) UIViewController* parentViewController;

// It will return the third party SDK network view.
// PubMatic's Mediation framework will call this method before calling loadAd.
@property (nonatomic, strong) UIView* clickableView;


@property (nonatomic,strong) MASTNativeAd *nativeAd;

-(void) sendClickTracker;
-(void) sendTracker;

// This method will return the object of PUBBaseAdapter using the
// class name provided by className parameter. If the class is not
// found, it will return nil.
// This method will be called from PubMatic's Mediation framework.
// This method is already implemented, the derived class need not
// re-implement this method.
+ (MASTBaseAdapter*) getAdapterForClassName:(NSString*) className;


// This method will make the actual request to load ad using the network SDK.
// This method must be implemented by the derived class.
// This method will be called from PubMatic's mediation framework to request for an Ad.
- (void) loadAd;

// This function will be used to map loglevel in corresponding adapter with PubMatic SDK log levels.
// Implement this method if you want to set ad network SDKs log levels with corresponding
// PubMatic SDK log levels.
- (void) setLogLevel:(PUBAdapterLogMode)logMode;

// Release all the resources in this method, such as ad network views.
- (void) destroy;

@end