//
//  ADFlipTransition.m
//  ADFlipTransition
//
//  Created by Adam Debono on 31/05/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "ADFlipTransition.h"

#import "UIView+Snapshot.h"

@interface ADFlipTransition ()

@property (nonatomic) UIViewController *sourceViewController;
@property (nonatomic) UIView *sourceView;
@property (nonatomic) UIImage *sourceImage;

@property (nonatomic) UIViewController *destinationViewController;
@property (nonatomic) CGRect destinationFrame;
@property (nonatomic) UIImage *destinationImage;

@end

@implementation ADFlipTransition

- (id)init {
	if (self = [super init]) {
		_sourceViewController = nil;
		_sourceView = nil;
		_sourceImage = nil;
		
		_destinationViewController = nil;
		_destinationFrame = CGRectNull;
		_destinationImage = nil;
		
		_animationDuration = 0.5;
	}
	
	return self;
}

#pragma mark - Setters

//*********//
- (void)setSourceView:(UIView *)sourceView inViewController:(UIViewController *)sourceViewController {
	[self setSourceView:sourceView inViewController:sourceViewController withSnapshotImage:nil];
}

- (void)setSourceView:(UIView *)sourceView inViewController:(UIViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage {
	_sourceViewController = sourceViewController;
	_sourceView = sourceView;
	_sourceImage = sourceImage;
}

//***********//

- (void)setDestinationViewController:(UIViewController *)destinationViewController {
	[self setDestinationViewController:destinationViewController asChildWithFrame:CGRectNull];
}

- (void)setDestinationViewController:(UIViewController *)destinationViewController withSnapshotImage:(UIImage *)destinationImage {
	[self setDestinationViewController:destinationViewController asChildWithFrame:CGRectNull withSnapshotImage:destinationImage];
}

//***********//

- (void)setDestinationViewController:(UIViewController *)destinationViewController asChildWithFrame:(CGRect)destinationFrame {
	[self setDestinationViewController:destinationViewController asChildWithFrame:destinationFrame withSnapshotImage:nil];
}

- (void)setDestinationViewController:(UIViewController *)destinationViewController asChildWithFrame:(CGRect)destinationFrame withSnapshotImage:(UIImage *)destinationImage {
	_destinationViewController = destinationViewController;
	_destinationFrame = destinationFrame;
	_destinationImage = destinationImage;
}

#pragma mark - Animations

- (void)perform {
	[self performWithCompletion:NULL];
}

- (void)performWithCompletion:(void (^)(void))completion {
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	BOOL modal;
	
	CGRect destFrame;
	CGRect srcFrame = [[self sourceView] frame];
	
	//put the destination view controller on screen
	if (CGRectEqualToRect([self destinationFrame], CGRectNull)) {
		//present destination view modally
		modal = YES;
		
		destFrame = [[[UIApplication sharedApplication] keyWindow] frame];
		[[[self destinationViewController] view] setFrame:destFrame];
	} else {
		modal = NO;
		
		//add destination view as a child
		[[self sourceViewController] addChildViewController:[self destinationViewController]];
		[[self destinationViewController] didMoveToParentViewController:[self sourceViewController]];
		
		destFrame = [self destinationFrame];
		[[[self destinationViewController] view] setFrame:destFrame];
		[[[self sourceViewController] view] addSubview:[[self destinationViewController] view]];
	}
	
	//create the destination animation view
	UIImage *destImage = [self destinationImage]?[self destinationImage]:[[[self destinationViewController] view] snapshot];
	UIImageView *destView = [[UIImageView alloc] initWithImage:destImage];
	[destView setFrame:destFrame];
	[[destView layer] setZPosition:1024];
	[[[self sourceViewController] view] addSubview:destView];
	[[[self destinationViewController] view] setHidden:YES];
		
	//create the source animation view
	UIImage *srcImage = [self sourceImage]?[self sourceImage]:[[self sourceView] snapshot];
	UIImageView *srcView = [[UIImageView alloc] initWithImage:srcImage];
	[srcView setFrame:srcFrame];
	[[srcView layer] setZPosition:1024];
	[[[self sourceViewController] view] addSubview:srcView];
	[[self sourceView] setHidden:YES];
	
	//calculate the size of the views halway through the animation
	CGRect halfwayFrame = CGRectZero;
	halfwayFrame.origin.x = (srcFrame.origin.x - (srcFrame.origin.x - destFrame.origin.x)) / 2;
	halfwayFrame.origin.y = (srcFrame.origin.y - (srcFrame.origin.y - destFrame.origin.y)) / 2;
	halfwayFrame.size.width = (destFrame.size.width - srcFrame.size.width) / 2 + destFrame.size.width;
	halfwayFrame.size.height = (destFrame.size.height - srcFrame.size.height) / 2 + destFrame.size.height;
	
	//pre-flip the destination view halfway around and hide it
	CATransform3D preTransform = CATransform3DMakeRotation(-M_PI/2, 0, 1, 0);
	preTransform.m34 = 1.0f/-500;
	[[destView layer] setTransform:preTransform];
	[destView setFrame:halfwayFrame];
	
	//perform the first half of the animation
	CATransform3D srcTransform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
	srcTransform.m34 = 1.0f/-500;
	[UIView animateWithDuration:[self animationDuration]/2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		[[srcView layer] setTransform:srcTransform];
		[srcView setFrame:halfwayFrame];
	} completion:^(BOOL finished) {
		//get rid of the source animation view
		[srcView removeFromSuperview];
		[destView setHidden:NO];
		
		//perform the second half of the animation
		CATransform3D destTransform = CATransform3DMakeRotation(0, 0, 1, 0);
		destTransform.m34 = 0;
		[UIView animateWithDuration:[self animationDuration]/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			[[destView layer] setTransform:destTransform];
			[destView setFrame:destFrame];
		} completion:^(BOOL finished) {
			//get rid of the destination animation view
			[destView removeFromSuperview];
			
			if (modal) {
				[[self sourceViewController] presentViewController:[self destinationViewController] animated:NO completion:NULL];
			}
			
			[[self sourceView] setHidden:NO];
			[[[self destinationViewController] view] setHidden:NO];
			
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
			
			if (completion) {
				completion();
			}
		}];
	}];
}

- (void)reverse {
	[self reverseWithCompletion:NULL];
}

- (void)reverseWithCompletion:(void (^)(void))completion {
	
}

@end
