//
//  MASTSCustom.m
//  AdMobileSamples
//
//  Created by Jason Dickert on 4/18/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import "MASTSCustom.h"
#import "MASTSCustomConfigController.h"


@interface MASTSCustom ()

@end

@implementation MASTSCustom

- (id)init
{
    self = [super init];
    if (self)
    {
        UIBarButtonItem* menuButton = [[[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(menu:)] autorelease];
        self.navigationItem.rightBarButtonItem = menuButton;
    }
    return self;
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

- (void)menu:(id)sender
{
    MASTSCustomConfigController* configController = [[MASTSCustomConfigController new] autorelease];
    configController.delegate = self;
    
    NSMutableDictionary* config = [NSMutableDictionary dictionary];
    [config setValue:[NSNumber numberWithInteger:self.adView.frame.origin.x] forKey:@"x"];
    [config setValue:[NSNumber numberWithInteger:self.adView.frame.origin.y] forKey:@"y"];
    [config setValue:[NSNumber numberWithInteger:self.adView.frame.size.width] forKey:@"width"];
    [config setValue:[NSNumber numberWithInteger:self.adView.frame.size.height] forKey:@"height"];
    [config setValue:[NSNumber numberWithInteger:self.adView.minSize.width] forKey:@"minWidth"];
    [config setValue:[NSNumber numberWithInteger:self.adView.minSize.height] forKey:@"minHeight"];
    [config setValue:[NSNumber numberWithInteger:self.adView.maxSize.width] forKey:@"maxWidth"];
    [config setValue:[NSNumber numberWithInteger:self.adView.maxSize.height] forKey:@"maxHeight"];
    [config setValue:[NSNumber numberWithBool:self.adView.contentAlignment] forKey:@"contentAlignment"];
    [config setValue:[NSNumber numberWithBool:self.adView.internalOpenMode] forKey:@"internalOpenMode"];
    [configController setConfig:config];
    
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:configController] autorelease];
    
    [self presentModalViewController:navController animated:YES];
}

#pragma mark -

- (void)cancelCustomConfig:(MASTSCustomConfigController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)customConfig:(MASTSCustomConfigController *)controller updatedWithConfig:(NSDictionary *)settings
{
    [self dismissModalViewControllerAnimated:YES];
    
    CGRect frame = CGRectMake([[settings valueForKey:@"x"] integerValue],
                              [[settings valueForKey:@"y"] integerValue],
                              [[settings valueForKey:@"width"] integerValue],
                              [[settings valueForKey:@"height"] integerValue]);
    self.adView.frame = frame;
    
    CGSize size = CGSizeMake([[settings valueForKey:@"minWidth"] integerValue],
                             [[settings valueForKey:@"minHeight"] integerValue]);
    self.adView.minSize = size;
    
    size = CGSizeMake([[settings valueForKey:@"maxWidth"] integerValue],
                      [[settings valueForKey:@"maxHeight"] integerValue]);
    self.adView.maxSize = size;

    id value = [settings valueForKey:@"contentAlignment"];
    self.adView.contentAlignment = [value boolValue];
    
    value = [settings valueForKey:@"internalOpenMode"];
    self.adView.internalOpenMode = [value boolValue];
    
    [self.adView update];
}

@end
