//
//  MASTSDetailController.m
//  MASTSamples
//
//  Created by Jason Dickert on 4/16/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSDetailController.h"

@interface MASTSDetailController ()
@property (nonatomic, retain) UIToolbar* toolbar;
@property (nonatomic, retain) UIBarButtonItem* titleItem;
@end

@implementation MASTSDetailController

@synthesize menuButton, rightButton;
@synthesize toolbar, titleItem;

- (void)dealloc
{
    self.toolbar = nil;
    self.titleItem = nil;
    
    self.menuButton = nil;
    self.rightButton = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.autoresizesSubviews = YES;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (self.toolbar == nil)
        {
            self.toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 768, 44)] autorelease];
            self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
            
            [self.view addSubview:self.toolbar];
            
            
            NSMutableArray* toolbarItems = [NSMutableArray array];
            [toolbarItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil] autorelease]];
            
            self.titleItem = [[[UIBarButtonItem alloc] initWithTitle:nil
                                                               style:UIBarButtonItemStylePlain
                                                              target:nil
                                                              action:nil] autorelease];
            [toolbarItems addObject:self.titleItem];
            
            [toolbarItems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil] autorelease]];
            
            if (self.rightButton != nil)
                [toolbarItems addObject:self.rightButton];
            
            self.toolbar.items = toolbarItems;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)setMenuButton:(UIBarButtonItem*)button
{
    BOOL hadMenuButton = self.menuButton != nil;
    
    if (menuButton != button)
    {
        [menuButton release];
        menuButton = [button retain];
    }
    
    if (self.toolbar == nil)
        return;
    
    NSMutableArray* toolbarItems = [NSMutableArray arrayWithArray:self.toolbar.items];
    if (hadMenuButton)
        [toolbarItems removeObjectAtIndex:0];
    
    if (self.menuButton != nil)
        [toolbarItems insertObject:self.menuButton atIndex:0];
    
    self.toolbar.items = toolbarItems;
}

- (void)setRightButton:(UIBarButtonItem *)rb
{
    BOOL hadRightButton = self.rightButton != nil;
    
    if (rightButton != rb)
    {
        [rightButton release];
        rightButton = [rb retain];
    }
    
    if (self.toolbar == nil)
        return;
    
    NSMutableArray* toolbarItems = [NSMutableArray arrayWithArray:self.toolbar.items];
    if (hadRightButton)
        [toolbarItems removeLastObject];
    
    if (self.rightButton != nil)
        [toolbarItems addObject:self.rightButton];
    
    self.toolbar.items = toolbarItems;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self.titleItem setTitle:title];
}

- (void)done
{
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
     {
         [self.navigationController popViewControllerAnimated:YES];
     }
}

@end
