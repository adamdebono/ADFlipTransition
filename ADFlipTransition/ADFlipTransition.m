/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2012-2013 Adam Debono. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#import "ADFlipTransition.h"

#import "UIView+CaptureImage.h"

@class UITransitionView;

@interface ADFlipTransition ()

@property (nonatomic) UIViewController *sourceViewController;
@property (nonatomic) UIView *sourceView;
@property (nonatomic) UIImage *sourceImage;

@property (nonatomic) UIViewController *destinationViewController;
@property (nonatomic) CGSize destinationSize;
@property (nonatomic) UIImage *destinationImage;

@property (nonatomic) UIView *shadowView;
@property (nonatomic) UITapGestureRecognizer *shadowTapGesture;
@property (nonatomic) BOOL presented;

@end

@implementation ADFlipTransition

- (id)init {
	if (self = [super init]) {
		_sourceViewController = nil;
		_sourceView = nil;
		_sourceImage = nil;
		
		_destinationViewController = nil;
		_destinationSize = CGSizeZero;
		_destinationImage = nil;
		
		_animationDuration = 0.5;
		_presented = NO;
		
		_shadowView = [[UIView alloc] init];
		[[self shadowView] setFrame:CGRectMake(0, 0, 1024, 1024)];
		[[self shadowView] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
		
		_shadowTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewTapped:)];
		[[self shadowView] addGestureRecognizer:[self shadowTapGesture]];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
	}
	
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
- (void)setSourceIndexPath:(NSIndexPath *)indexPath inCollectionViewController:(UICollectionViewController *)sourceViewController {
	[self setSourceIndexPath:indexPath inCollectionViewController:sourceViewController withSnapshotImage:nil];
}

- (void)setSourceIndexPath:(NSIndexPath *)indexPath inCollectionViewController:(UICollectionViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage {
	UICollectionView *collectionView = [sourceViewController collectionView];
	if (![[collectionView indexPathsForVisibleItems] containsObject:indexPath]) {
		[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally|UICollectionViewScrollPositionCenteredVertically animated:NO];
		[collectionView reloadData];
		[collectionView setNeedsLayout];
		[collectionView layoutIfNeeded];
	}
	
	UICollectionViewCell *cell = [[sourceViewController collectionView] cellForItemAtIndexPath:indexPath];
	[self setSourceView:cell inViewController:sourceViewController withSnapshotImage:sourceImage];
}
#endif

- (void)setSourceIndexPath:(NSIndexPath *)indexPath inTableViewController:(UITableViewController *)sourceViewController {
	[self setSourceIndexPath:indexPath inTableViewController:sourceViewController withSnapshotImage:nil];
}

- (void)setSourceIndexPath:(NSIndexPath *)indexPath inTableViewController:(UITableViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage {
	UITableViewCell *cell = [[sourceViewController tableView] cellForRowAtIndexPath:indexPath];
	[self setSourceView:cell inViewController:sourceViewController withSnapshotImage:sourceImage];
}

- (void)updateIndexPath:(NSIndexPath *)indexPath {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
	if ([[self sourceViewController] isKindOfClass:[UICollectionViewController class]]) {
		[self setSourceIndexPath:indexPath inCollectionViewController:(UICollectionViewController *)[self sourceViewController] withSnapshotImage:[self sourceImage]];
	} else
#endif
			if ([[self sourceViewController] isKindOfClass:[UITableViewController class]]) {
		UITableView *tableView = [(UITableViewController *)[self sourceViewController] tableView];
		if (![[tableView indexPathsForVisibleRows] containsObject:indexPath]) {
			[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
		}
		
		[self setSourceIndexPath:indexPath inTableViewController:(UITableViewController *)[self sourceViewController] withSnapshotImage:[self sourceImage]];
	}
}

//***********//

- (void)setDestinationViewController:(UIViewController *)destinationViewController {
	[self setDestinationViewController:destinationViewController asChildWithSize:CGSizeZero];
}

- (void)setDestinationViewController:(UIViewController *)destinationViewController withSnapshotImage:(UIImage *)destinationImage {
	[self setDestinationViewController:destinationViewController asChildWithSize:CGSizeZero withSnapshotImage:destinationImage];
}

//***********//

- (void)setDestinationViewController:(UIViewController *)destinationViewController asChildWithSize:(CGSize)destinationSize {
	[self setDestinationViewController:destinationViewController asChildWithSize:destinationSize withSnapshotImage:nil];
}

- (void)setDestinationViewController:(UIViewController *)destinationViewController asChildWithSize:(CGSize)destinationSize withSnapshotImage:(UIImage *)destinationImage {
	_destinationViewController = destinationViewController;
	_destinationSize = destinationSize;
	_destinationImage = destinationImage;
}

#pragma mark - 

- (CGRect)rectBetween:(CGRect)firstRect andRect:(CGRect)secondRect {
	CGRect betweenRect = CGRectZero;
	betweenRect.origin.x = (firstRect.origin.x + secondRect.origin.x) / 2;
	betweenRect.origin.y = (firstRect.origin.y + secondRect.origin.y) / 2;
	betweenRect.size.width = (firstRect.size.width + secondRect.size.width) / 2;
	betweenRect.size.height = (firstRect.size.height + secondRect.size.height) / 2;
	
	return betweenRect;
}

- (CGRect)actualRectInView:(UIView *)view {
	Class transition = NSClassFromString(@"UITransitionView");
	Class layoutContainer = NSClassFromString(@"UILayoutContainerView");
	
	CGRect frame = [view frame];
	UIView *superview = [view superview];
	while (superview && ![superview isKindOfClass:transition] && ![superview isKindOfClass:layoutContainer]) {
		CGRect newFrame = [[superview superview] convertRect:frame fromView:superview];
		if (CGRectEqualToRect(newFrame, CGRectZero)) {
			break;
		}
		frame = newFrame;
				
		superview = [superview superview];
	}
	
	return frame;
}

- (CGRect)fullScreenRect {
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	
	CGRect rect = [window frame];
	if ([[UIApplication sharedApplication] statusBarStyle] == UIStatusBarStyleBlackOpaque) {
		CGFloat height = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])?[[UIApplication sharedApplication] statusBarFrame].size.height:[[UIApplication sharedApplication] statusBarFrame].size.width;
		
		if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
			rect = [self switchRectOrientation:rect];
		}
		
		rect.origin.y += height;
		rect.size.height -= height;
	}
	
	return rect;
}

- (CGRect)switchRectOrientation:(CGRect)rect {
	return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
}

- (CGRect)rectAtCenterOfRect:(CGRect)rect withSize:(CGSize)size {
	size.width = MIN(size.width, rect.size.width);
	size.height = MIN(size.height, rect.size.height);
	return CGRectMake((rect.size.width-size.width)/2+rect.origin.x, (rect.size.height-size.height)/2+rect.origin.y, size.width, size.height);
}

#pragma mark - Events

- (void)deviceOrientationDidChange:(NSNotification *)note {
	if (!CGSizeEqualToSize([self destinationSize], CGSizeZero) && [self presented]) {
		[UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
			[[[self destinationViewController] view] setFrame:[self rectAtCenterOfRect:[self fullScreenRect] withSize:[self destinationSize]]];
		}];
	}
}

- (void)shadowViewTapped:(UITapGestureRecognizer *)sender {
	if ([self presented]) {
		[self reverse];
	}
}

#pragma mark - Animations

- (void)perform {
	[self performWithCompletion:NULL];
}

- (void)performWithCompletion:(void (^)(void))completion {
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	[[self shadowView] removeFromSuperview];
	
	BOOL modal;
	
	CGRect destFrame;
	CGRect srcFrame = [self actualRectInView:[self sourceView]];
	
	UIViewController *srcViewController = [self sourceViewController];
	while ([srcViewController parentViewController]) {
		srcViewController = [srcViewController parentViewController];
	}
	
	//put the destination view controller on screen
	if (CGSizeEqualToSize([self destinationSize], CGSizeZero)) {
		//present destination view modally
		modal = YES;
		
		destFrame = [self fullScreenRect];
		
		[[[self destinationViewController] view] setFrame:destFrame];
		[[[self destinationViewController] view] setNeedsLayout];
		[[[self destinationViewController] view] layoutIfNeeded];
	} else {
		modal = NO;
		
		//add a shadow view
		[[self shadowView] setCenter:[[srcViewController view] center]];
		[[srcViewController view] addSubview:[self shadowView]];
		[[self shadowView] setAlpha:0];
		
		//add destination view as a child
		[srcViewController addChildViewController:[self destinationViewController]];
		[[self destinationViewController] didMoveToParentViewController:srcViewController];
		
		destFrame = [self rectAtCenterOfRect:[self fullScreenRect] withSize:[self destinationSize]];
		
		[[[self destinationViewController] view] setFrame:destFrame];
		[[srcViewController view] addSubview:[[self destinationViewController] view]];
		
		[[[[self destinationViewController] view] layer] setMasksToBounds:YES];
		[[[[self destinationViewController] view] layer] setCornerRadius:3.0f];
		[[[[self destinationViewController] view] layer] setZPosition:1000];
	}
	
	//create the destination animation view
	UIImage *destImage = [self destinationImage]?[self destinationImage]:[[[self destinationViewController] view] captureImage];
	UIImageView *destView = [[UIImageView alloc] initWithImage:destImage];
	[destView setFrame:destFrame];
	[[destView layer] setZPosition:1024];
	[[srcViewController view] addSubview:destView];
	[[[self destinationViewController] view] setHidden:YES];
	
	//create the source animation view and hide the original
	UIImage *srcImage = [self sourceImage]?[self sourceImage]:[[self sourceView] captureImage];
	UIImageView *srcView = [[UIImageView alloc] initWithImage:srcImage];
	[srcView setFrame:srcFrame];
	[[srcView layer] setZPosition:1024];
	[[srcViewController view] addSubview:srcView];
	[[self sourceView] setHidden:YES];
	
	//calculate the size of the views halfway through the animation
	CGRect halfwayFrame = [self rectBetween:srcFrame andRect:destFrame];
	
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
		if (!modal) {
			[[self shadowView] setAlpha:0.5f];
		}
	} completion:^(BOOL finished) {
		//get rid of the source animation view
		[srcView removeFromSuperview];
		[destView setHidden:NO];
		
		//perform the second half of the animation
		CATransform3D destTransform = CATransform3DMakeRotation(0, 0, 1, 0);
		destTransform.m34 = 1.0f/-500;
		[UIView animateWithDuration:[self animationDuration]/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			[[destView layer] setTransform:destTransform];
			[destView setFrame:destFrame];
			
			if (!modal) {
				[[self shadowView] setAlpha:1];
			}
		} completion:^(BOOL finished) {
			//get rid of the destination animation view
			[destView removeFromSuperview];
			
			if (modal) {
				[srcViewController presentViewController:[self destinationViewController] animated:NO completion:NULL];
				[[self sourceView] setHidden:NO];
			}
			
			[[[self destinationViewController] view] setHidden:NO];
			
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
			
			_presented = YES;
			
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
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	BOOL modal;
	
	UIViewController *srcViewController = [self sourceViewController];
	while ([srcViewController parentViewController]) {
		srcViewController = [srcViewController parentViewController];
	}
	
	CGRect destFrame;
	if (CGSizeEqualToSize([self destinationSize], CGSizeZero)) {
		modal = YES;
		destFrame = [self fullScreenRect];
	} else {
		modal = NO;
		destFrame = [[[self destinationViewController] view] frame];
	}
	CGRect srcFrame = [self actualRectInView:[self sourceView]];
	
	//create the destination animation view
	UIImage *destImage = [self destinationImage]?[self destinationImage]:[[[self destinationViewController] view] captureImage];
	UIImageView *destView = [[UIImageView alloc] initWithImage:destImage];
	[destView setFrame:destFrame];
	[[destView layer] setZPosition:1024];
	[[srcViewController view] addSubview:destView];
	
	//remove the destination view from screen
	if (modal) {
		[[self destinationViewController] dismissViewControllerAnimated:NO completion:NULL];
	} else {
		[[[self destinationViewController] view] removeFromSuperview];
		[[self destinationViewController] willMoveToParentViewController:nil];
		[[self destinationViewController] removeFromParentViewController];
	}
	
	//create the source animation view and hide the original
	[[self sourceView] setHidden:NO];
	UIImage *srcImage = [self sourceImage]?[self sourceImage]:[[self sourceView] captureImage];
	UIImageView *srcView = [[UIImageView alloc] initWithImage:srcImage];
	[srcView setFrame:srcFrame];
	[[srcView layer] setZPosition:1024];
	[[srcViewController view] addSubview:srcView];
	[[self sourceView] setHidden:YES];
	
	//calculate the halfway point
	CGRect halfwayFrame = [self rectBetween:srcFrame andRect:destFrame];
	
	//pre-flip the source animation view halfway around and hide it
	CATransform3D preTransform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
	preTransform.m34 = 1.0f/-500;
	[srcView setHidden:YES];
	[[srcView layer] setTransform:preTransform];
	[srcView setFrame:halfwayFrame];
	
	//perform the first half of the animation
	CATransform3D destTransform = CATransform3DMakeRotation(-M_PI/2, 0, 1, 0);
	destTransform.m34 = 1.0f/-500;
	[UIView animateWithDuration:[self animationDuration]/2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		[[destView layer] setTransform:destTransform];
		[destView setFrame:halfwayFrame];
		
		if (!modal) {
			[[self shadowView] setAlpha:0.5f];
		}
	} completion:^(BOOL finished) {
		//get rid of the destination animation view
		[destView removeFromSuperview];
		
		//perform the second half of the animation
		[srcView setHidden:NO];
		CATransform3D srcTransform = CATransform3DMakeRotation(0, 0, 1, 0);
		srcTransform.m34 = 1.0f/-500;
		[UIView animateWithDuration:[self animationDuration]/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			[[srcView layer] setTransform:srcTransform];
			[srcView setFrame:srcFrame];
			
			if (!modal) {
				[[self shadowView] setAlpha:0];
			}
		} completion:^(BOOL finished) {
			[srcView removeFromSuperview];
			[[self sourceView] setHidden:NO];
			
			if (!modal) {
				[[self shadowView] removeFromSuperview];
			}
			
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
			
			_presented = NO;
			
			if (completion) {
				completion();
			}
		}];
	}];
}

@end
