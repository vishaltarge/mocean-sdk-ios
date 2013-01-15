//
//  MASTSSimple.h
//  MASTSamples
//
//  Created by Jason Dickert on 4/16/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTSAdConfigPrompt.h"


@interface MASTSSimple : UIViewController <MASTSAdConfigPromptDelegate>

@property (nonatomic, retain) MASTAdView* adView;

@end
