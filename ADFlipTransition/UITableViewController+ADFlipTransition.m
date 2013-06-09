//
//  UITableViewController+ADFlipTransition.m
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "UITableViewController+ADFlipTransition.h"

#import "UIViewController+ADFlipTransition.h"

@implementation UITableViewController (ADFlipTransition)

- (void)flipToViewController:(UIViewController *)destinationViewController fromItemAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(void))completion {
	ADFlipTransition *transition = [[ADFlipTransition alloc] init];
	[transition setSourceIndexPath:indexPath inTableViewConroller:self];
	[transition setDestinationViewController:destinationViewController];
	
	[self setPresentedFlipTransition:transition];
	[destinationViewController setPresentingFlipTransition:transition];
	
	[transition performWithCompletion:completion];
}

@end
