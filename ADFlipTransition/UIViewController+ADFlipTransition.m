//
//  UIViewController+ADFlipTransition.m
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "UIViewController+ADFlipTransition.h"

#import <objc/runtime.h>

@implementation UIViewController (ADFlipTransition)

#pragma mark - Setters

@dynamic presentedFlipTransition;
@dynamic presentingFlipTransition;

static NSString *const kPresentedFlipTransitionKey = @"kPresentedFlipTransition";
static NSString *const kPresentingFlipTransitionKey = @"kPresentingFlipTransition";

- (ADFlipTransition *)presentedFlipTransition {
	return objc_getAssociatedObject(self, (__bridge const void *)kPresentedFlipTransitionKey);
}

- (void)setPresentedFlipTransition:(ADFlipTransition *)presentedFlipTransition {
	objc_setAssociatedObject(self, (__bridge const void *)kPresentedFlipTransitionKey, presentedFlipTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ADFlipTransition *)presentingFlipTransition {
	return objc_getAssociatedObject(self, (__bridge const void *)kPresentingFlipTransitionKey);
}

- (void)setPresentingFlipTransition:(ADFlipTransition *)presentingFlipTransition {
	objc_setAssociatedObject(self, (__bridge const void *)kPresentingFlipTransitionKey, presentingFlipTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Performing

- (void)flipToViewController:(UIViewController *)destinationViewController fromView:(UIView *)sourceView withCompletion:(void (^)(void))completion {
	ADFlipTransition *transition = [[ADFlipTransition alloc] init];
	[transition setSourceView:sourceView inViewController:self];
	[transition setDestinationViewController:destinationViewController];
	
	[self setPresentedFlipTransition:transition];
	[destinationViewController setPresentingFlipTransition:transition];
	
	[transition performWithCompletion:completion];
}

- (void)dismissFlipWithCompletion:(void (^)(void))completion {
	if ([self getPresentingFlipTransition]) {
		[[self getPresentingFlipTransition] reverse];
	} else {
		NSLog(@"View wasn't presented by a flip transition");
	}
}

- (void)dismissFlipToIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(void))completion {
	[[self getPresentingFlipTransition] updateIndexPath:indexPath];
	[self dismissFlipWithCompletion:completion];
}

- (ADFlipTransition *)getPresentingFlipTransition {
	UIViewController *vc = self;
	while (![vc presentingFlipTransition] && [vc parentViewController]) {
		vc = [vc parentViewController];
	}
	
	return [vc presentingFlipTransition];
}

@end
