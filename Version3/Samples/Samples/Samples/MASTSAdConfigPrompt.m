//
//  MASTSAdConfigPrompt.m
//  Samples
//
//  Created on 1/14/13.
//  Copyright (c) 2013 mOcean Mobile. All rights reserved.
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
            textField.text = [NSString stringWithFormat:@"%d", zone];
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
