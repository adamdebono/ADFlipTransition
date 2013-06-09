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

- (void)setSourceIndexPath:(NSIndexPath *)indexPath inCollectionViewConroller:(UICollectionViewController *)sourceViewController {
	[self setSourceIndexPath:indexPath inCollectionViewConroller:sourceViewController withSnapshotImage:nil];
}

- (void)setSourceIndexPath:(NSIndexPath *)indexPath inCollectionViewConroller:(UICollectionViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage {
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

- (void)setSourceIndexPath:(NSIndexPath *)indexPath inTableViewConroller:(UITableViewController *)sourceViewController {
	[self setSourceIndexPath:indexPath inTableViewConroller:sourceViewController withSnapshotImage:nil];
}

- (void)setSourceIndexPath:(NSIndexPath *)indexPath inTableViewConroller:(UITableViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage {
	UITableViewCell *cell = [[sourceViewController tableView] cellForRowAtIndexPath:indexPath];
	[self setSourceView:cell inViewController:sourceViewController withSnapshotImage:sourceImage];
}

- (void)updateIndexPath:(NSIndexPath *)indexPath {
	if ([[self sourceViewController] isKindOfClass:[UICollectionViewController class]]) {
		/*UICollectionView *collectionView = [(UICollectionViewController *)[self sourceViewController] collectionView];
		if (![[collectionView indexPathsForVisibleItems] containsObject:indexPath]) {
			[collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally|UICollectionViewScrollPositionCenteredVertically animated:NO];
			[collectionView reloadData];
		}*/
		
		[self setSourceIndexPath:indexPath inCollectionViewConroller:(UICollectionViewController *)[self sourceViewController] withSnapshotImage:[self sourceImage]];
	} else if ([[self sourceViewController] isKindOfClass:[UITableViewController class]]) {
		UITableView *tableView = [(UITableViewController *)[self sourceViewController] tableView];
		if (![[tableView indexPathsForVisibleRows] containsObject:indexPath]) {
			[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
		}
		
		[self setSourceIndexPath:indexPath inTableViewConroller:(UITableViewController *)[self sourceViewController] withSnapshotImage:[self sourceImage]];
	}
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
	CGRect frame = [view frame];
	UIView *superview = [view superview];
	while (superview) {
		CGRect newFrame = [[superview superview] convertRect:frame fromView:superview];
		if (CGRectEqualToRect(newFrame, CGRectZero)) {
			break;
		}
		frame = newFrame;
		
		superview = [superview superview];
	}
	
	return frame;
}

#pragma mark - Animations

- (void)perform {
	[self performWithCompletion:NULL];
}

- (void)performWithCompletion:(void (^)(void))completion {
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
		
	BOOL modal;
	
	CGRect destFrame;
	CGRect srcFrame = [self actualRectInView:[self sourceView]];
	
	UIViewController *srcViewController = [self sourceViewController];
	
	//put the destination view controller on screen
	if (CGRectEqualToRect([self destinationFrame], CGRectNull)) {
		//present destination view modally
		modal = YES;
		
		while ([srcViewController parentViewController]) {
			srcViewController = [srcViewController parentViewController];
		}
		
		destFrame = [[[self destinationViewController] view] frame];
		
		[[[self destinationViewController] view] setNeedsLayout];
		[[[self destinationViewController] view] layoutIfNeeded];
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
	[[srcViewController view] addSubview:destView];
	[[[self destinationViewController] view] setHidden:YES];
	
	//create the source animation view and hide the original
	UIImage *srcImage = [self sourceImage]?[self sourceImage]:[[self sourceView] snapshot];
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
				[srcViewController presentViewController:[self destinationViewController] animated:NO completion:NULL];
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
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
	BOOL modal;
	
	UIViewController *srcViewController = [self sourceViewController];
	while ([srcViewController parentViewController]) {
		srcViewController = [srcViewController parentViewController];
	}
	
	CGRect destFrame = [[[self destinationViewController] view] frame];
	CGRect srcFrame = [self actualRectInView:[self sourceView]];
	
	//create the destination animation view
	UIImage *destImage = [self destinationImage]?[self destinationImage]:[[[self destinationViewController] view] snapshot];
	UIImageView *destView = [[UIImageView alloc] initWithImage:destImage];
	[destView setFrame:destFrame];
	[[destView layer] setZPosition:1024];
	[[srcViewController view] addSubview:destView];
	
	//remove the destination view from screen
	if (CGRectEqualToRect([self destinationFrame], CGRectNull)) {
		modal = YES;
		
		[[self destinationViewController] dismissViewControllerAnimated:NO completion:NULL];
	} else {
		modal = NO;
		
		[[[self destinationViewController] view] removeFromSuperview];
		[[self destinationViewController] willMoveToParentViewController:nil];
		[[self destinationViewController] removeFromParentViewController];
	}
	
	//create the source animation view and hide the original
	UIImage *srcImage = [self sourceImage]?[self sourceImage]:[[self sourceView] snapshot];
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
		} completion:^(BOOL finished) {
			[srcView removeFromSuperview];
			[[self sourceView] setHidden:NO];
			
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
			
			if (completion) {
				completion();
			}
		}];
	}];
}

@end
