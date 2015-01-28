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
//  MASTSNativeAdControllerViewController.m
//  Samples
//
//  Created  on 04/07/14.

//

#import "MASTSNativeAdControllerViewController.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import "MPNativeAdRendering.h"
#import "MPNativeAdView.h"

#define kTitleKey @"title"
#define kDescriptionKey @"description"
#define kIconKey @"iconImgUrl"
#define kMainImageKey @"mainImageUrl"
#define kCTAKey @"callToAction"


@interface MASTSNativeAdControllerViewController ()<MASTNativeAdDelegate,FBNativeAdDelegate>

@property (retain, nonatomic) IBOutlet UITextView *logTextView;
@property (retain, nonatomic) IBOutlet UIView *refreshButton;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property(nonatomic,strong) MPNativeAd *mpNativeAd;
@property(nonatomic,strong) FBNativeAd * fb_nativeAd;

-(void) getImageFromURL:(NSURL *)fileURL forView:(UIImageView *)imageView;

@end

@implementation MASTSNativeAdControllerViewController
@synthesize nativeAd=_nativeAd;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nativeAd = [[[MASTNativeAd alloc] init] autorelease];
    self.nativeAd.zone=179492;
    self.nativeAd.delegate = self;
    self.nativeAd.test = NO;
    [self.nativeAd setLocationDetectionEnabled:YES];
    self.nativeAd.nativeAdIconSize = self.iconImageView.frame.size;
    self.nativeAd.nativeAdCoverImageSize = self.coverImage.frame.size;
    self.nativeAd.nativeAdDescriptionLength = 150;
    self.nativeAd.nativeAdTitleLength = 30;
    self.nativeAd.nativeContent = @"1,2,3,4,5";
    self.nativeAd.useAdapter = YES;
    // To be set only in case of testing for FAN Network
    [self.nativeAd addTestDeviceId:@"<YOUR DEVICE HASH AS PER FAN NETWORK>" forNetwork:kFaceBook];
    [MASTNativeAd setLogLevel:MASTLogNone];
    [self.nativeAd update];
    self.nativeAdView.hidden =NO;
    if(self.nativeAd){
        [self enableIneractions:NO];
    }
}

-(void)enableIneractions:(BOOL)enableIneractions{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(enableIneractions){
            [[self activityIndicator] stopAnimating];
            
        }else{
            [[self activityIndicator] startAnimating];
            
        }
        [self.refreshButton setUserInteractionEnabled:enableIneractions];
        
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDictionary* )componentsDictionary:(id)aNativeAd{
    
    NSDictionary * dict = nil;
    if([aNativeAd isKindOfClass:[MASTNativeAd class]]){
        
        MASTNativeAd * nativeAd = (MASTNativeAd*)aNativeAd;
        
        dict = @{kTitleKey:nativeAd.title?nativeAd.title:@"",
                 kDescriptionKey:nativeAd.adDescription?nativeAd.adDescription:@"",
                 kIconKey:nativeAd.iconImageURL?nativeAd.iconImageURL:@"",
                 kMainImageKey:nativeAd.coverImageURL?nativeAd.coverImageURL:@"",
                 kCTAKey:nativeAd.callToAction?nativeAd.callToAction:@""};
        
        
    }else if([aNativeAd isKindOfClass:[FBNativeAd class]]){
        
        FBNativeAd * nativeAd = (FBNativeAd*)aNativeAd;
        
        dict = @{kTitleKey:nativeAd.title?nativeAd.title:@"",
                 kDescriptionKey:nativeAd.body?nativeAd.body:@"",
                 kIconKey:nativeAd.icon.url.absoluteString?nativeAd.icon.url.absoluteString:@"",
                 kMainImageKey:nativeAd.coverImage.url.absoluteString?nativeAd.coverImage.url.absoluteString:@"",
                 kCTAKey:nativeAd.callToAction?nativeAd.callToAction:@""};
        
        
    }else if([aNativeAd isKindOfClass:[MPNativeAd class]]){
        
        MPNativeAd * nativeAd = (MPNativeAd*)aNativeAd;
        
        dict = @{kTitleKey:[nativeAd.properties objectForKey:@"title"]?[nativeAd.properties objectForKey:@"title"]:@"",
                 kDescriptionKey:[nativeAd.properties objectForKey:@"text"]?[nativeAd.properties objectForKey:@"text"]:@"",
                 kIconKey:[nativeAd.properties objectForKey:@"iconimage"]?[nativeAd.properties objectForKey:@"iconimage"]:@"",
                 kMainImageKey:[nativeAd.properties objectForKey:@"mainimage"]?[nativeAd.properties objectForKey:@"mainimage"]:@"",
                 kCTAKey:[nativeAd.properties objectForKey:@"ctatext"]?[nativeAd.properties objectForKey:@"ctatext"]:@""};
        
    }
    return dict;
}

-(void)renderNativeAd:(id )nativeAd{
    
    NSDictionary * nativeComponents = [self componentsDictionary:nativeAd];
    self.titleLabelView.text = [nativeComponents objectForKey:kTitleKey];
    self.descriptionTextView.text = [nativeComponents objectForKey:kDescriptionKey];
    [self.nativeAd loadInImageView:self.coverImage withURL:[nativeComponents objectForKey:kMainImageKey]];
    [self.nativeAd loadInImageView:self.iconImageView withURL:[nativeComponents objectForKey:kIconKey]];
    [self.ctaButton setTitle:[nativeComponents objectForKey:kCTAKey] forState:UIControlStateNormal];
    [self trackNativeAdViewForinteration:nativeAd];
}

-(void)trackNativeAdViewForinteration:(id)aNativeAd{
    
    if([aNativeAd isKindOfClass:[MASTNativeAd class]]){
        
        [self.nativeAd trackViewForInteractions:self.nativeAdView withViewController:self];
        
        
    }else if([aNativeAd isKindOfClass:[FBNativeAd class]]){
        
        FBNativeAd * nativeAd = aNativeAd;
        [nativeAd registerViewForInteraction:self.nativeAdView withViewController:self];
        [self.nativeAd sendImpressionTrackers];
        
    }else if([aNativeAd isKindOfClass:[MPNativeAd class]]){
        
        MPNativeAd * nativeAd = aNativeAd;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nativeAdViewDidClick:)];
        [self.nativeAdView addGestureRecognizer:tapGesture];
        [nativeAd trackImpression];
        [self.nativeAd sendImpressionTrackers];
        self.mpNativeAd = nativeAd;
    }
}

#pragma  mark suppliement methods for Natve mopub ad

-(void)nativeAdViewDidClick:(UITapGestureRecognizer*)recognier{
    
    [self.mpNativeAd trackClick];
    [self.nativeAd sendClickTracker];
    [self log:[NSString stringWithFormat:@"%s : %@",__func__,self.mpNativeAd.description]];
    [self.mpNativeAd displayContentForURL:self.mpNativeAd.defaultActionURL rootViewController:self.parentViewController completion:^(BOOL success, NSError *error) {
        
    }];
}
#pragma mark-

#pragma mark MASTNativeAdDelegate methods
- (void)MASTAdViewDidRecieveAd:(MASTNativeAd *)nativeAd
{
    [self enableIneractions:YES];
    NSLog(@"Received Ad");
    [self log:[NSString stringWithFormat:@"Response :=>\n %@",[nativeAd performSelector:@selector(responseLog)]]];
    [self renderNativeAd:nativeAd];
    
}

- (void)MASTAdView:(MASTNativeAd*)aNativeAd didReceiveThirdPartyRequest:(NSDictionary*)properties withParams:(NSDictionary*)params
{
    [self log:[NSString stringWithFormat:@"%s : %@",__func__,properties.description]];
    
    [self enableIneractions:YES];
    
        
        MediationNetwork network = kNone;
        NSString * name = _nativeAd.thirdpartyFeedName;
        if([name isEqualToString:@"MoPub"]){
            network = kMoPub;
        }else if([name isEqualToString:@"FAN"]){
            network = kFaceBook;
        }
    
        if(network!=kNone){
            
            [self loadAdForMediationNetwork:network withParams:params];
        }
        
       NSLog(@"Third party ad received");
}


- (void)MASTAdView:(MASTNativeAd*)nativeAd didFailToReceiveAdWithError:(NSError*)error
{
    NSLog(@"Error encountered");
    [self log:[NSString stringWithFormat:@"Error :=>\n %@",error.localizedDescription]];
    [self.refreshButton setUserInteractionEnabled:YES];
}

- (void)nativeAdDidClick:(MASTNativeAd *)nativeAd{
    
    [self log:[NSString stringWithFormat:@"Native Ad Clicked"]];
    
}

#pragma mark-

#pragma mark All flow is handled by Application -  useAdapter is set to NO

-(void)loadAdForMediationNetwork:(MediationNetwork)network withParams:(NSDictionary*)params{
    
    [self enableIneractions:NO];
    switch (network) {
        case kFaceBook:
        {
            NSString *fb_placementId = [params objectForKey:@"adid"];
            [FBAdSettings addTestDevice:[self.nativeAd testDeviceIdForNetwork:kFaceBook]];
            self.fb_nativeAd = [[[FBNativeAd alloc] initWithPlacementID:fb_placementId] autorelease];
            
            self.fb_nativeAd.delegate = self;
            [self.fb_nativeAd loadAd];
            
            
        }
            break;
        case kMoPub:
        {
            NSString *mobPubPlacemntId = [params objectForKey:@"adid"];
            
            MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:mobPubPlacemntId];
            
            [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
                if (error) {
                    NSLog(@"MoPub Error================> %@", error);
                    [self.nativeAd handleAdNetworkDefault];
                    [self enableIneractions:YES];
                    
                } else {
                    //                    self.mpNativeAd = response;
                    [self displayMoPubAd:response];
                    NSLog(@"Received Native Ad");
                    [self enableIneractions:YES];
                }
                
            }];
            
        }
        default:{
            [self enableIneractions:YES];
        }
            break;
    }
}


-(void)displayMoPubAd:(id )nativeAd{
    
    
    [self renderNativeAd:nativeAd];
    
}


-(void) getImageFromURL:(NSURL *)fileURL forView:(UIImageView *)imageView{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"Image from %@ downloaded",fileURL);
        imageView.image = [UIImage imageWithData:data];
        
    }];
    
}

#pragma mark - FBNativeAdDelegate implementation
- (void)nativeAdDidLoad:(FBNativeAd *)fb_nativeAd
{
    NSLog(@"Ad was loaded, constructing native UI...");
    
    
    // Create native UI using the ad metadata.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // self.adStatusLabel.text = @"";
            [self renderNativeAd:fb_nativeAd];
            [self enableIneractions:YES];
        });
    });
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    NSLog(@" FB Ad failed to load with error: %@", error);
    [self enableIneractions:YES];
    [self.nativeAd handleAdNetworkDefault];
}


- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd
{
    [self.nativeAd sendClickTracker];
}
#pragma mark-

- (void)dealloc {
    [_iconImageView release];
    [_titleLabelView release];
    [_coverImage release];
    [_descriptionTextView release];
    [_ctaButton release];
    [_nativeAd destroy];
    [_nativeAdView release];
    [_fb_nativeAd release];
    [_refreshButton release];
    [_activityIndicator release];
    [_logTextView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setIconImageView:nil];
    [self setTitleLabelView:nil];
    [self setCoverImage:nil];
    [self setDescriptionTextView:nil];
    [self setCtaButton:nil];
    [self setNativeAdView:nil];
    [super viewDidUnload];
}

-(void)reset{
    
    [self.fb_nativeAd unregisterView];
}

- (IBAction)refreshAd:(id)sender {
    
    [self reset];
    [self enableIneractions:NO];
    
    [self.refreshButton setUserInteractionEnabled:NO];
    self.titleLabelView.text = @"<AdTitle>";
    self.descriptionTextView.text = @"<Ad Description Text>";
    self.iconImageView.image = nil;
    self.coverImage.image = nil;
    [self.ctaButton setTitle:@"<CTA Text>" forState:UIControlStateNormal];
    self.fb_nativeAd = nil;
    
    [self.nativeAd update];
}

-(void)log:(NSString*)log{
    
    NSString * text = self.logTextView.text;
    [self.logTextView setText: [text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",log]] ];
}

@end
