//
//  MASTSAdConfigController.m
//  MASTSamples
//
//  Created by Jason Dickert on 4/17/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSAdConfigController.h"

@interface MASTSAdConfigController ()
@property (nonatomic, retain) UILabel* siteLabel;
@property (nonatomic, retain) UILabel* zoneLabel;
@property (nonatomic, retain) UITextField* siteText;
@property (nonatomic, retain) UITextField* zoneText;
@property (nonatomic, retain) UIButton* refreshButton;

@property (nonatomic, assign) id activeInput;
@end

@implementation MASTSAdConfigController

@synthesize siteLabel, zoneLabel, siteText, zoneText, refreshButton, activeInput;
@synthesize delegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.delegate = nil;
    
    self.siteLabel = nil;
    self.zoneLabel = nil;
    self.siteText = nil;
    self.zoneText = nil;
    self.refreshButton = nil;
    
    self.activeInput = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.frame = CGRectMake(0, 0, 320, 39);
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect frame = CGRectMake(0, 5, 35, 29);
    UILabel* label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentRight;
    label.text = @"Site:";
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    self.siteLabel = label;
    
    frame.origin.x += frame.size.width + 1;
    frame.size.width = 75;
    UITextField* text = [[[UITextField alloc] initWithFrame:frame] autorelease];
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.autocorrectionType = UITextAutocorrectionTypeNo;
    text.keyboardType = UIKeyboardTypeNumberPad;
    text.returnKeyType = UIReturnKeyDone;
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.delegate = self;
    [self.view addSubview:text];
    self.siteText = text;    
    
    frame.origin.x += frame.size.width + 3;
    frame.size.width = 40;
    label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentRight;
    label.text = @"Zone:";
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    self.zoneLabel = label;
    
    frame.origin.x += frame.size.width + 1;
    frame.size.width = 75;
    text = [[[UITextField alloc] initWithFrame:frame] autorelease];
    text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text.autocorrectionType = UITextAutocorrectionTypeNo;
    text.keyboardType = UIKeyboardTypeNumberPad;
    text.returnKeyType = UIReturnKeyDone;
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.delegate = self;
    [self.view addSubview:text];
    self.zoneText = text;
    
    frame.origin.x += frame.size.width + 10;
    frame.size.width = 70;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:@"Refresh" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.refreshButton = button;
    
    self.activeInput = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)setSite:(NSInteger)site
{
    self.siteText.text = [[NSNumber numberWithInteger:site] description];
}

- (NSInteger)site
{
    return [self.siteText.text integerValue];
}

- (void)setZone:(NSInteger)zone
{
    self.zoneText.text = [[NSNumber numberWithInteger:zone] description];
}

- (NSInteger)zone
{
    return [self.zoneText.text integerValue];
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    [self.refreshButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (NSString*)buttonTitle
{
    return [self.refreshButton titleForState:UIControlStateNormal];
}

- (void)refresh:(id)sender
{
    [self.activeInput resignFirstResponder];
    
    if (self.delegate != nil)
        [self.delegate updateAdWithConfig:self];
}

#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	self.activeInput = textField;
}

@end
