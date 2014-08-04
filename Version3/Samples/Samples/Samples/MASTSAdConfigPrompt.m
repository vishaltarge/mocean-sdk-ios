//
//  MASTSAdConfigPrompt.m
//  Samples
//
/*
 * PubMatic Inc. (“PubMatic”) CONFIDENTIAL
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

#import "MASTSAdConfigPrompt.h"

@interface MASTSAdConfigPrompt() <UIAlertViewDelegate>
@property (nonatomic, assign) id<MASTSAdConfigPromptDelegate> delegate;
@property (nonatomic, strong) UITextField* zoneField;
@end

@implementation MASTSAdConfigPrompt

@synthesize delegate, zoneField;

- (void)dealloc
{
    self.zoneField = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithDelegate:(id<MASTSAdConfigPromptDelegate>)d zone:(NSInteger)zone;
{
    NSString* message = nil;
    if ([super respondsToSelector:@selector(setAlertViewStyle:)] == NO)
    {
        message = @"\n\n";
    }

    self = [super initWithTitle:@"Zone"
                        message:message
                       delegate:nil
              cancelButtonTitle:@"Cancel"
              otherButtonTitles:@"Refresh", nil];
    
    if (self)
    {
        self.delegate = d;
        [super setDelegate:self];
        
        UITextField* textField = nil;

        if ([super respondsToSelector:@selector(setAlertViewStyle:)])
        {
            [super setAlertViewStyle:UIAlertViewStylePlainTextInput];
            textField = [super textFieldAtIndex:0];
        }
        else
        {
            self.zoneField = [[[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 31)] autorelease];
            [self.zoneField setBorderStyle:UITextBorderStyleRoundedRect];
            [self addSubview:self.zoneField];
            textField = self.zoneField;
        }

        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setBackgroundColor:[UIColor clearColor]];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setPlaceholder:@"Zone"];

        if (zone != 0)
        {
            textField.text = [NSString stringWithFormat:@"%ld", (long)zone];
        }
    }
    return self;
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self.delegate configPromptCancel:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex)
    {
        [self.delegate configPromptCancel:self];
        return;
    }
    
    UITextField* textField = self.zoneField;
    if ([super respondsToSelector:@selector(textFieldAtIndex:)])
    {
        textField = [super textFieldAtIndex:0];
    }

    [self.delegate configPrompt:self refreshWithZone:[textField.text integerValue]];
}

@end
