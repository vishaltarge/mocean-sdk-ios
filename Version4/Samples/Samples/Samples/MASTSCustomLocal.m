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
//  MASTSCustomLocal.m
//  Samples
//
//  Created on 11/20/12.

//

#import "MASTSCustomLocal.h"

@interface MASTSCustomLocal ()

@end

@implementation MASTSCustomLocal

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger zone = 0;
    
    super.adView.zone = zone;
    
    // A bit goofy but keeps setFirstAppear hidden in the parent class and
    // overrides it to not do an update since the zone is invalid given
    // the goal of this sample is to show locally derived ad content.
    BOOL value = NO;
    SEL sel = sel_registerName("setFirstAppear:");
    NSMethodSignature* sig = [super methodSignatureForSelector:sel];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:sel];
    [invocation setArgument:&value atIndex:2];
    [invocation invoke];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString* content = @"<div align='center'><script src=\"mraid.js\"></script><script type='text/javascript'>function showAd(){} function openUrl(){mraid.open('https://itunes.apple.com/us/app/find-my-friends/id466122094?mt=8&uo=4');} if (mraid.getState() == 'loading'){mraid.addEventListener('ready',showAd);}else{showAd();}</script></head><body style='margin:0;border:0;'><span style='size:10px;' onclick='openUrl();'>Open</span></div>";
    
    MASTMoceanAdDescriptor* descriptor = [MASTMoceanAdDescriptor descriptorWithRichMediaContent:content];
    
    [super.adView renderWithAdDescriptor:descriptor];
}

@end
