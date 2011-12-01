//
//  Test2.m
//  DeveloperTests
//
//  Created by Константин Муреев on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Test2.h"

@implementation Test2

- (void)refreshButtonAction:(id)sender {
    [_adView update];
}

- (void)setupRightButton {
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonAction:)];
    
    [self.navigationItem setRightBarButtonItem:rightButton];
    [rightButton release];
}

- (void)viewDidLoad {
    [self setupRightButton];
    
	[super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithRed:35 /255.0f
                                                green:31 /255.0f
                                                 blue:32 /255.0f
                                                alpha:1.0];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imageView];
    [imageView release];
    
	_adView = [[AdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    _adView.site = 8061;
    _adView.zone = 20001;
    _adView.backgroundColor = [UIColor whiteColor];
    _adView.adServerUrl = @"http://192.168.1.162/new_mcn/request.php";
    _adView.logMode = AdLogModeAll;
    [self.view addSubview:_adView];
}

- (void)dealloc {
	[_adView release];
	[super dealloc];
}

@end
