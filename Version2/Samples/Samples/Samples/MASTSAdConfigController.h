//
//  MASTSAdConfigController.h
//  MASTSamples
//
//  Created by Jason Dickert on 4/17/12.
//  Copyright (c) 2012 mOcean Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MASTSAdConfigController;

@protocol MASTSAdConfigDelegate <NSObject>
@required
- (void)updateAdWithConfig:(MASTSAdConfigController*)configController;
@end

@interface MASTSAdConfigController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) id<MASTSAdConfigDelegate> delegate;

@property (nonatomic, assign) NSInteger site;
@property (nonatomic, assign) NSInteger zone;
@property (nonatomic, retain) NSString* buttonTitle;

@end
