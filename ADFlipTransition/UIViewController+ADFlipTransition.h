//
//  UIViewController+ADFlipTransition.h
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADFlipTransition.h"

@interface UIViewController (ADFlipTransition)

//the transition that is presented by this view controller
@property (nonatomic) ADFlipTransition *presentedFlipTransition;
//the transition that put this view controller on screen
@property (nonatomic) ADFlipTransition *presentingFlipTransition;

- (void)flipToViewController:(UIViewController *)destinationViewController fromView:(UIView *)sourceView withCompletion:(void (^)(void))completion;
- (void)dismissFlipWithCompletion:(void (^)(void))completion;
- (void)dismissFlipToIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(void))completion;

@end
