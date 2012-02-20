//
//  TestingViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 7/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdView.h"
#import "NotificationCenter.h"
#import "AdModel.h"
#import "AdView_Private.h"

@interface TestingViewController : UIViewController <AdViewDelegate> {
    UITextField*        _siteTextField;
    UITextField*        _zoneTextField;
    UIButton*           _updateButton;
    //UISegmentedControl* _segmentedControl;
	AdView*             _adView;
    //UITextView*         _textView;
}

@property (retain) NSString* request;
@property (retain) NSString* response;

@end

