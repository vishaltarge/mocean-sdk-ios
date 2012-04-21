//
//  MASTSDelegate.m
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/18/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSDelegate.h"

@interface MASTSDelegate ()
@property (nonatomic, retain) UITextView* textView;
@end

@implementation MASTSDelegate

@synthesize textView;

- (void)dealloc
{
    self.textView = nil;
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    // Adjust for the status bar, the navigation bar space will trigger an update layout.
    CGRect adjustedFrame = super.view.frame;
    adjustedFrame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    // Place the config view on the bottom.
    CGRect frame = super.adConfigController.view.frame;
    frame.origin.y = CGRectGetMaxY(adjustedFrame) - frame.size.height;
    super.adConfigController.view.frame = frame;
    
    // Update the autoresizing mask to include adjusting the top margin to cover 
    // the navigation bar and rotation.
    super.adConfigController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
        UIViewAutoresizingFlexibleTopMargin;

    
    // Create a text view that captures delegate usage.
    [self.textView removeFromSuperview];

    frame = super.view.bounds;
    frame.origin.y = CGRectGetMaxY(self.adView.frame);
    frame.size.height -= frame.origin.y + CGRectGetHeight(super.adConfigController.view.frame);
    self.textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.editable = NO;
    
    [self.view addSubview:self.textView];
    [self.view sendSubviewToBack:self.textView];
    
    self.adView.delegate = self;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super.adView update];
}

#pragma mark -

- (void)keyboardWillHide:(id)notification
{
    // Place the config view on the bottom.
    CGRect frame = super.adConfigController.view.frame;
    frame.origin.y = CGRectGetMaxY(self.view.frame) - frame.size.height;
    super.adConfigController.view.frame = frame;
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
    NSMutableString* entry = [NSMutableString stringWithString:@"willReceiveAd"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    
    [self performSelectorOnMainThread:@selector(writeEntry:) 
                           withObject:entry
                        waitUntilDone:NO];
}

- (void)didReceiveAd:(id)sender
{
    NSMutableString* entry = [NSMutableString stringWithString:@"didReceiveAd:"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:entry
                        waitUntilDone:NO];
}

- (void)didReceiveThirdPartyRequest:(id)sender content:(NSDictionary*)content
{
    NSMutableString* entry = [NSMutableString stringWithString:@"didReceiveThirdPartyRequest:content:"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    [entry appendFormat:@"\ncontent: %@", [content description]];
    
    [self performSelectorOnMainThread:@selector(writeEntry:) 
                           withObject:entry
                        waitUntilDone:NO];
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error
{
    NSMutableString* entry = [NSMutableString stringWithString:@"didFailToReceiveAd:withError:"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    [entry appendFormat:@"\nerror: %@", [error description]];
    
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:entry
                        waitUntilDone:NO];
}

- (void)adWillStartFullScreen:(id)sender
{
    NSMutableString* entry = [NSMutableString stringWithString:@"adWillStartFullScreen:"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:entry
                        waitUntilDone:NO];
}

- (void)adDidEndFullScreen:(id)sender
{
    NSMutableString* entry = [NSMutableString stringWithString:@"adDidEndFullScreen:"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:entry
                        waitUntilDone:NO];
}

- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL*)url
{
    NSMutableString* entry = [NSMutableString stringWithString:@"adShouldOpen:withUrl:"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    [entry appendFormat:@"\nurl: %@", [url description]];
    
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:entry
                        waitUntilDone:NO];
    
    return YES;
}

- (void)didClosedAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval
{
    NSMutableString* entry = [NSMutableString stringWithString:@"didClosedAd:usageTimeInterval:"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    [entry appendFormat:@"\nusageTimeInterval: %f", usageTimeInterval];
    
    [self performSelectorOnMainThread:@selector(writeEntry:)
                           withObject:entry
                        waitUntilDone:NO];
}

- (void)ormmaProcess:(id)sender event:(NSString*)event parameters:(NSDictionary*)parameters
{
    NSMutableString* entry = [NSMutableString stringWithString:@"ormmaProcess:event:parameters:"];
    [entry appendFormat:@"\nsender: %@", [sender description]];
    [entry appendFormat:@"\nevent: %@", event];
    [entry appendFormat:@"\nparameters: %@", [parameters description]];
    
    [self performSelectorOnMainThread:@selector(writeEntry:) 
                           withObject:entry
                        waitUntilDone:NO];
}

@end
