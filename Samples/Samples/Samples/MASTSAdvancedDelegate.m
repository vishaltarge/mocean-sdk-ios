//
//  MASTSAdvancedDelegate.m
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/18/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSAdvancedDelegate.h"

@interface MASTSAdvancedDelegate ()
@property (nonatomic, retain) UITextView* textView;
@end

@implementation MASTSAdvancedDelegate

@synthesize textView;

- (void)dealloc
{
    self.textView = nil;
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];

    self.adView.delegate = self;
    
    // Adjust for the status bar, the navigation bar space will trigger an update layout.
    CGRect adjustedFrame = super.view.frame;
    adjustedFrame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    CGRect frame = self.view.bounds;
    //frame.size = adjustedFrame.size;
    
    frame.origin.y = CGRectGetMaxY(self.adConfigController.view.frame) + 15;
    frame.size.height -= frame.origin.y;
    
    [self.textView removeFromSuperview];
    self.textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.editable = NO;
    
    [self.view addSubview:self.textView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger site = 19829;
    NSInteger zone = 88269;
    
    super.adView.site = site;
    super.adView.zone = zone;
    
    super.adConfigController.site = site;
    super.adConfigController.zone = zone;
}

#pragma mark - 

- (void)writeEntry:(NSString*)entry
{
    NSString* text = [self.textView.text stringByAppendingFormat:@"\n%@\n--", entry];
    self.textView.text = text;

    [self.textView scrollRangeToVisible:NSMakeRange(text.length, 0)];
}

#pragma mark -

- (void)willReceiveAd:(id)sender
{
    [self performSelectorOnMainThread:@selector(writeEntry:) 
                           withObject:@"willReceiveAd"
                        waitUntilDone:NO];
}

- (void)didReceiveAd:(id)sender
{
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:@"didReceiveAd"
                        waitUntilDone:NO];
}

- (void)didReceiveThirdPartyRequest:(id)sender content:(NSDictionary*)content
{
    [self performSelectorOnMainThread:@selector(writeEntry:) 
                           withObject:@"didReceiveThirdPartyRequest:content:"
                        waitUntilDone:NO];
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error
{
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:@"didFailToReceiveAd:withError:"
                        waitUntilDone:NO];
}

- (void)adWillStartFullScreen:(id)sender
{
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:@"adWillStartFullScreen:"
                        waitUntilDone:NO];
}

- (void)adDidEndFullScreen:(id)sender
{
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:@"adDidEndFullScreen:"
                        waitUntilDone:NO];
}

- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url
{
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:@"adShouldOpen:withUrl:"
                        waitUntilDone:NO];
    
    return YES;
}

- (void)didClosedAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval
{
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:@"didClosedAd:usageTimeInterval:"
                        waitUntilDone:NO];
}

- (void)ormmaProcess:(id)sender event:(NSString*)event parameters:(NSDictionary*)parameters
{
    [self performSelectorOnMainThread:@selector(writeEntry:) 
                           withObject:@"ormmaProcess:event:parameters:"
                        waitUntilDone:NO];
}

@end
