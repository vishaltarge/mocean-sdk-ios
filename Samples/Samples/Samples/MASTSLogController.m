//
//  MASTSLogController.m
//  Samples
//
//  Created by Jason Dickert on 4/21/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSLogController.h"

@interface MASTSLogController ()
@property (nonatomic, retain) UITextView* textView;
- (void)refresh;
@end

@implementation MASTSLogController

@synthesize textView;

- (void)dealloc
{
    self.textView = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        UIBarButtonItem* actionButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                       target:self 
                                                                                       action:@selector(action)] autorelease];
        self.navigationItem.rightBarButtonItem = actionButton;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.autoresizesSubviews = YES;
    
    [self.textView removeFromSuperview];
    self.textView = [[[UITextView alloc] initWithFrame:self.view.bounds] autorelease];
    self.textView.autoresizingMask  = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -

- (void)action
{
    UIActionSheet* actionSheet = [[[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self 
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:@"Reset"
                                                     otherButtonTitles:@"Refresh", nil] autorelease];
    
    [actionSheet showInView:self.view];
}

- (void)refresh
{
    NSString* logFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/mOcean_SDK_log.txt"];
    NSString* logContents = [NSString stringWithContentsOfFile:logFile encoding:NSUTF8StringEncoding error:nil];
    
    self.textView.text = logContents;
    
    [self.textView scrollRangeToVisible:NSMakeRange([logContents length], 0)];
}

#pragma mark - 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;

    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        NSString* logFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/mOcean_SDK_log.txt"];
        [@"" writeToFile:logFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }

    [self refresh];
}


@end
