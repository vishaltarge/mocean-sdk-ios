//
//  AdMobileSamplesBaseViewController.h
//  AdMobileSamples
//
//  Created by Slava Budnikov on 2/18/12.
//  Copyright (c) 2012 Team Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"
#import "MASTAdDelegate.h"

@interface AdMobileSamplesBaseViewController : UIViewController
{
	UIBarButtonItem	*_buttonEdit;	
	MASTAdView		*_adView;
}

@end