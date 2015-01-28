/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2014 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */


//
//  PUBBaseAdapter.m
//  PUBBaseAdapter
//


// USER IMPORTS
#import "MASTBaseAdapter.h"


@implementation MASTBaseAdapter
@synthesize adapterDictionary=_adapterDictionary;
@synthesize parentViewController=_parentViewController;
@synthesize clickableView=_clickableView;
@synthesize delegate=_delegate;
@synthesize  adAttributes=_adAttributes;

+ (MASTBaseAdapter*) getAdapterForClassName:(NSString*) className
{
    
    id adapter = nil;
    
    if (className != nil)
    {
        Class adapterClass = NSClassFromString(className);
        adapter = [[adapterClass alloc]init] ;
    }
    
    return adapter;
}



- (instancetype)init
{
    self = [super init];
    _parentViewController = nil;
    _adapterDictionary = nil;
    _delegate = nil;
    _adAttributes = nil;
    return self;
}

-(void)trackViewForInteractions:(UIView*)view withViewController:(UIViewController* )viewCotroller{
    
    [NSException raise:NSInternalInconsistencyException
                format:kErrorMsgMustOverrideMethod, NSStringFromSelector(_cmd)];
    
}

- (void)loadAd
{
    [NSException raise:NSInternalInconsistencyException
                format:kErrorMsgMustOverrideMethod, NSStringFromSelector(_cmd)];
}

- (void) setLogLevel:(MASTAdapterLogMode)logMode
{
}

-(void) sendClickTracker
{
    [NSException raise:NSInternalInconsistencyException
                format:kErrorMsgMustOverrideMethod, NSStringFromSelector(_cmd)];
   
}

- (void)destroy
{
    _parentViewController = nil;
    _adapterDictionary =nil;
    _delegate = nil;
    self.adAttributes = nil;
    
    
}

- (void)dealloc
{
    [self destroy];
}

@end