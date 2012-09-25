//
//  MASTSSimple.h
//  MASTSamples
//
//  Created by Jason Dickert on 4/16/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MASTAdView/MASTAdView.h>
#import "MASTSAdConfigController.h"


@interface MASTSSimple : UIViewController <MASTSAdConfigDelegate>

@property (nonatomic, retain) MASTAdView* adView;
@property (nonatomic, retain) MASTSAdConfigController* adConfigController;


- (void)keyboardDidShow:(id)notification;
- (void)keyboardWillHide:(id)notification;

@end
