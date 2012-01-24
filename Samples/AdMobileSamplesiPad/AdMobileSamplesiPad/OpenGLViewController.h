//
//  OpenGLViewController.h
//  AdMobileSamplesiPad
//
//  Created by Constantine Mureev on 8/10/11.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "EAGLView.h"
#import "MASTAdView.h"

@interface OpenGLViewController : UIViewController {
	MASTAdView*			_adView;
	EAGLView*		eaglView;
    EAGLContext*	context;
    GLuint			program;
    
    BOOL			animating;
    NSInteger		animationFrameInterval;
    CADisplayLink*	displayLink;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

@end
