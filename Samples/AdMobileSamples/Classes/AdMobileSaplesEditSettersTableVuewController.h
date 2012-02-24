//
//  AdMobileSaplesEditSettersTableVuewController.h
//  AdMobileSamples
//
//  Created by Slava Budnikov on 2/24/12.
//  Copyright (c) 2012 Team Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"

@interface AdMobileSaplesEditSettersTableVuewController : UITableViewController <UITextFieldDelegate>
{
	MASTAdView		*_adView;
	UITextField		*_site;
	UITextField		*_zone;
}

- (id)initWithStyle:(UITableViewStyle)style banner:(MASTAdView*)adView;

@end