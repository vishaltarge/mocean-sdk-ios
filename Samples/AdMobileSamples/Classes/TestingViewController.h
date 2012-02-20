//
//  TestingViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 7/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
//#import "MASTNotificationCenter.h"
//#import "MASTAdModel.h"
//#import "MASTAdView_Private.h"

@interface TestingViewController : UIViewController <MASTAdViewDelegate> {
    UITextField*        _siteTextField;
    UITextField*        _zoneTextField;
    UIButton*           _updateButton;
    //UISegmentedControl* _segmentedControl;
	MASTAdView*             _adView;
    //UITextView*         _textView;
}

@property (retain) NSString* request;
@property (retain) NSString* response;

@end

