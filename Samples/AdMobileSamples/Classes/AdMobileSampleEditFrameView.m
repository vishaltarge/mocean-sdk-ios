//
//  AdMobileSampleEditViewController.m
//  AdMobileSamples
//
//  Created by Slava Budnikov on 2/24/12.
//  Copyright (c) 2012 Team Force. All rights reserved.
//

#import "AdMobileSampleEditFrameView.h"

@implementation AdMobileSampleEditFrameView

-(void) sliderChanged:(id) sender
{
	UISlider *slider = (UISlider *)sender;
	if (slider == _sliderHeight)
	{
		[_labelHeightCurent setText:[NSString stringWithFormat:@"height = %.0f",slider.value]];
		_adView.frame = CGRectMake(_adView.frame.origin.x, _adView.frame.origin.y, _adView.frame.size.width, slider.value);
	}
	else if (slider == _sliderWidth)
	{
		[_labelWidthCurent setText:[NSString stringWithFormat:@"width = %.0f",slider.value]];
		_adView.frame = CGRectMake(_adView.frame.origin.x, _adView.frame.origin.y, slider.value, _adView.frame.size.height);
	}
	else if (slider == _sliderPosX)
	{
		[_labelPosXCurent setText:[NSString stringWithFormat:@"pos x = %.0f",slider.value]];
		_adView.frame = CGRectMake( slider.value, _adView.frame.origin.y, _adView.frame.size.width, _adView.frame.size.height);
	}
	else if (slider == _sliderPosY)
	{
		[_labelPosYCurent setText:[NSString stringWithFormat:@"pos y = %.0f",slider.value]];
		_adView.frame = CGRectMake(_adView.frame.origin.x,  slider.value, _adView.frame.size.width, _adView.frame.size.height);
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier banner:(MASTAdView*)adView;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
		_adView = adView;
		//height
		_sliderHeight = [[UISlider alloc] initWithFrame:CGRectMake(-35, 60, 130, 30)];
		[_sliderHeight addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

		CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI * 0.5);
		_sliderHeight.transform = trans;
		[self addSubview:_sliderHeight];

		_labelHeightCurent = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 100, 20)];
		[_labelHeightCurent setText:@"height curent"];
		[_labelHeightCurent setBackgroundColor:[UIColor clearColor]];
		[_labelHeightCurent setTextAlignment:UITextAlignmentCenter];
		_labelHeightCurent.transform = trans;
		[self addSubview:_labelHeightCurent];
		
		//width
		_sliderWidth = [[UISlider alloc] initWithFrame:CGRectMake(20, 160, 280, 30)];
		[_sliderWidth addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_sliderWidth];
		
		_labelWidthCurent = [[UILabel alloc] initWithFrame:CGRectMake(20, 145, 280, 20)];
		[_labelWidthCurent setBackgroundColor:[UIColor clearColor]];
		[_labelWidthCurent setTextAlignment:UITextAlignmentCenter];
		[_labelWidthCurent setText:@"width curent"];
		[self addSubview:_labelWidthCurent];
		
		//pos x
		_sliderPosX = [[UISlider alloc] initWithFrame:CGRectMake(100, 30, 200, 30)];
		[_sliderPosX addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_sliderPosX];
		
		_labelPosXCurent = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 20)];
		[_labelPosXCurent setBackgroundColor:[UIColor clearColor]];
		[_labelPosXCurent setText:@"pos x curent"];
		[self addSubview:_labelPosXCurent];
		
		//pos y
		_sliderPosY = [[UISlider alloc] initWithFrame:CGRectMake(100, 90, 200, 30)];
		[_sliderPosY addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

		[self addSubview:_sliderPosY];
		
		_labelPosYCurent = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 200, 20)];
		[_labelPosYCurent setBackgroundColor:[UIColor clearColor]];
		[_labelPosYCurent setText:@"pos y curent"];
		[self addSubview:_labelPosYCurent];

		[self update];
    }
    return self;
}

- (void)update
{
	[_sliderHeight setMaximumValue:_adView.superview.frame.size.height];
	[_sliderHeight setValue:_adView.frame.size.height];
	[self sliderChanged:_sliderHeight];
	
	[_sliderWidth setMaximumValue:_adView.superview.frame.size.width];
	[_sliderWidth setValue:_adView.frame.size.width];
	[self sliderChanged:_sliderWidth];
	
	[_sliderPosX setMaximumValue:_adView.superview.frame.size.width];
	[_sliderPosX setValue:_adView.frame.origin.x];
	[self sliderChanged:_sliderPosY];
	
	[_sliderPosY setMaximumValue:_adView.superview.frame.size.height];
	NSLog(@"%f",_adView.frame.origin.y);
	[_sliderPosY setValue:_adView.frame.origin.y];
	[self sliderChanged:_sliderPosX];
}

-(void)dealloc
{
	//height
	[_sliderHeight release];
	[_labelHeightCurent release];
	//width
	[_sliderWidth release];
	[_labelWidthCurent release];
	//pos x
	[_sliderPosX release];
	[_labelPosXCurent release];
	//pos y
	[_sliderPosY release];
	[_labelPosYCurent release];
	
	[super dealloc];
}

@end