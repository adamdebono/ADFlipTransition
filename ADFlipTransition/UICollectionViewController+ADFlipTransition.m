//
//  UICollectionViewController+ADFlipTransition.m
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

#import "UICollectionViewController+ADFlipTransition.h"

#import "UIViewController+ADFlipTransition.h"

@implementation UICollectionViewController (ADFlipTransition)

- (void)flipToViewController:(UIViewController *)destinationViewController fromItemAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(void))completion {
	ADFlipTransition *transition = [[ADFlipTransition alloc] init];
	[transition setSourceIndexPath:indexPath inCollectionViewConroller:self];
	[transition setDestinationViewController:destinationViewController];
	
	[self setPresentedFlipTransition:transition];
	[destinationViewController setPresentingFlipTransition:transition];
	
	[transition performWithCompletion:completion];
}

@end

#endif
