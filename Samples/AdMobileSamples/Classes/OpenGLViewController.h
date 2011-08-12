//
//  OpenGLViewController.h
//  AdMobileSamples
//
//  Created by Constantine Mureev on 2/18/11.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "EAGLView.h"
#import "AdView.h"


@interface OpenGLViewController : UIViewController {
	AdView*			_adView;
	EAGLView*		eaglView;
    EAGLContext*	context;
    GLuint			program;
    
    BOOL			animating;
    NSInteger		animationFrameInterval;
    CADisplayLink*	displayLink;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;

@end
