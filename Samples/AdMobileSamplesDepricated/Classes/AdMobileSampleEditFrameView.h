//
//  AdMobileSampleEditViewController.h
//  AdMobileSamples
//
//  Created by Slava Budnikov on 2/24/12.
//  Copyright (c) 2012 Team Force. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MASTAdView.h"

@interface AdMobileSampleEditFrameView : UIView
{
	MASTAdView	*_adView;
	//height
	UISlider	*_sliderHeight;
	UILabel		*_labelHeightCurent;
	//width
	UISlider	*_sliderWidth;
	UILabel		*_labelWidthCurent;
	//pos x
	UISlider	*_sliderPosX;
	UILabel		*_labelPosXCurent;
	//pos y
	UISlider	*_sliderPosY;
	UILabel		*_labelPosYCurent;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier banner:(MASTAdView*)adView;
- (id)initWithFrame:(CGRect)frame banner:(MASTAdView*)adView;
- (void)update;

@end