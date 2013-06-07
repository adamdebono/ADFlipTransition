//
//  ADFlipTransition.h
//  ADFlipTransition
//
//  Created by Adam Debono on 31/05/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ADFlipTransition : NSObject

@property (nonatomic) NSTimeInterval animationDuration;

//animate from a subview of the view controller
- (void)setSourceView:(UIView *)sourceView inViewController:(UIViewController *)sourceViewController;
- (void)setSourceView:(UIView *)sourceView inViewController:(UIViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage;

//destination view controller will be shown 'modally'
- (void)setDestinationViewController:(UIViewController *)destinationViewController;
- (void)setDestinationViewController:(UIViewController *)destinationViewController withSnapshotImage:(UIImage *)destinationImage;

//add the destination view controller as a child of the source, with the given frame
- (void)setDestinationViewController:(UIViewController *)destinationViewController asChildWithFrame:(CGRect)destinationFrame;
- (void)setDestinationViewController:(UIViewController *)destinationViewController asChildWithFrame:(CGRect)destinationFrame withSnapshotImage:(UIImage *)destinationImage;

- (void)perform;
- (void)performWithCompletion:(void (^)(void))completion;

//reverse dismisses the destination view
- (void)reverse;
- (void)reverseWithCompletion:(void (^)(void))completion;

@end
