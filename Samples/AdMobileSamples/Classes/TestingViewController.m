//
//  TestingViewController.m
//  AdMobileSamples
//
//  Created by Constantine Mureev on 7/1/11.
//  Copyright 2011 Team Force LLC. All rights reserved.
//

#import "TestingViewController.h"


@implementation TestingViewController

@synthesize request, response;


- (void)textFieldDone:(id)sender {
    [sender resignFirstResponder];
}

- (void)pickOne:(id)sender {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        if (self.request) {
            _textView.text = self.request;
        } else {
            _textView.text = @"";
        }
    } else {
        if (self.response) {
            _textView.text = self.response;
        } else {
            _textView.text = @"";
        }
    }
} 

- (void)update:(id)sender {
    self.request = nil;
    [self pickOne:_segmentedControl];
    _adView.site = [[_siteTextField text] intValue];
    _adView.zone = [[_zoneTextField text] intValue];
    _adView.type = AdTypeAll;
    [_adView update];
}

- (void)sendRequest:(NSNotification*)notification {
    if ([notification object] == _adView) {
        self.request = [[_adView adModel] url];
        
        if ([NSThread isMainThread]) {
            [self pickOne:_segmentedControl];
        } else {
            [self performSelectorOnMainThread:@selector(pickOne:)
                                   withObject:_segmentedControl
                                waitUntilDone:NO];
        }
    }
}

- (void)adDownloadedWithResponse:(NSNotification*)notification {
    NSDictionary *info = [notification object];
	MASTAdView* adView = [info objectForKey:@"adView"];
    
    if (_adView == adView) {
        NSData* data = [info objectForKey:@"data"];
        
        NSString* dataResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.response = dataResponse;
        [dataResponse release];
        
        if ([NSThread isMainThread]) {
            [self pickOne:_segmentedControl];
        } else {
            [self performSelectorOnMainThread:@selector(pickOne:)
                                   withObject:_segmentedControl
                                waitUntilDone:NO];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(sendRequest:) name:kStartAdDownloadNotification object:nil];
    [[MASTNotificationCenter sharedInstance] addObserver:self selector:@selector(adDownloadedWithResponse:) name:kFinishAdDownloadNotification object:nil];
	
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    	
	_adView = [[MASTAdView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) site:8061 zone:20249];
	_adView.updateTimeInterval = 0; // disable updates
	_adView.logMode = YES;
    _adView.delegate = self;
	_adView.defaultImage = [UIImage imageNamed:@"DefaultImage (320x50).png"];
    
    _siteTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width/2 - 15, 25)];
    _siteTextField.text = @"8061";
    _siteTextField.returnKeyType = UIReturnKeyDone;
    _siteTextField.placeholder = @"Site";
    _siteTextField.adjustsFontSizeToFitWidth = YES;
	[_siteTextField setBorderStyle:UITextBorderStyleRoundedRect];
	[_siteTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_siteTextField addTarget:self 
                  action:@selector(textFieldDone:) 
        forControlEvents:UIControlEventEditingDidEndOnExit];  
    
    _zoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 + 5, 70, self.view.frame.size.width/2 - 15, 25)];
    _zoneTextField.text = @"20249";
    _zoneTextField.returnKeyType = UIReturnKeyDone;
    _zoneTextField.placeholder = @"Zone";
    _zoneTextField.adjustsFontSizeToFitWidth = YES;
	[_zoneTextField setBorderStyle:UITextBorderStyleRoundedRect];
	[_zoneTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_zoneTextField addTarget:self 
                     action:@selector(textFieldDone:) 
           forControlEvents:UIControlEventEditingDidEndOnExit];  
    
    _updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_updateButton retain];
    _updateButton.frame = CGRectMake(10, 110, self.view.frame.size.width - 20, 44);
    [_updateButton setTitle:@"Update Me!" forState:UIControlStateNormal];
    [_updateButton addTarget:self
                     action:@selector(update:)
           forControlEvents:UIControlEventTouchUpInside];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:
                         [NSArray arrayWithObjects:
                          @"Request",
                          @"Response",
                          nil]];
    _segmentedControl.frame = CGRectMake(10, 164, self.view.frame.size.width - 20, 44);
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
    _segmentedControl.selectedSegmentIndex = 0;
	[_segmentedControl addTarget:self
                          action:@selector(pickOne:)
                forControlEvents:UIControlEventValueChanged];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 218, self.view.frame.size.width - 20, self.view.frame.size.height - 270)];
    _textView.editable = NO;
    
	[self.view addSubview:_segmentedControl];
    //segmentedControl.momentary = YES;
    
	[self.view addSubview:_siteTextField];
	[self.view addSubview:_zoneTextField];
	[self.view addSubview:_updateButton];
	[self.view addSubview:_segmentedControl];
	[self.view addSubview:_textView];
    
	[self.view addSubview:_adView];
}

- (void) dealloc {
    [[MASTNotificationCenter sharedInstance] removeObserver:self];
    _adView.delegate = nil;
	[_adView release];
    
    [_siteTextField release];
    [_zoneTextField release];
    [_updateButton release];
    [_segmentedControl release];
    [_textView release];
     
	[super dealloc];
}

- (void)willReceiveAd:(id)sender {
    [_updateButton setTitle:@"Start updating..." forState:UIControlStateNormal];
    _updateButton.enabled = NO;
    _updateButton.alpha = 0.5;
}

- (void)didReceiveAd:(id)sender {
    [_updateButton setTitle:@"Done! Update Me!" forState:UIControlStateNormal];
    _updateButton.enabled = YES;
    _updateButton.alpha = 1;
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error {
    self.response = nil;
    if ([NSThread isMainThread]) {
        [self pickOne:_segmentedControl];
    } else {
        [self performSelectorOnMainThread:@selector(pickOne:)
                               withObject:_segmentedControl
                            waitUntilDone:NO];
    }
    [_updateButton setTitle:@"Fail! Update Me!" forState:UIControlStateNormal];
    _updateButton.alpha = 1;
    _updateButton.enabled = YES;
}

@end