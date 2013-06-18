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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * An object which coordinates a custom flip transition to present a view controller.
 */
@interface ADFlipTransition : NSObject

/**
 * The length of time to perform the animation.
 */
@property (nonatomic) NSTimeInterval animationDuration;

/**
 * Setup the sources for the transition. The snapshot image will be
 * taken just before the animation.
 * @param sourceView The view to transition from.
 * @param sourceViewController The view controller to present from.
 */
- (void)setSourceView:(UIView *)sourceView inViewController:(UIViewController *)sourceViewController;
/**
 * Setup the sources for the transition.
 * @param sourceView The view to transition from.
 * @param sourceViewController The view controller to present from.
 * @param sourceImage The placeholder image for the source view. Specifying nil 
 * will take a snapshot just before the animation.
 */
- (void)setSourceView:(UIView *)sourceView inViewController:(UIViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
/**
 * Setup the sources for the transition from a
 * UICollectionViewController. The source view will be automatically taken from
 * the indexPath, and if necessary scrolled into view. The snapshot image will
 * be taken just before the animation.
 * @param indexPath The index path indicating the cell to animate from
 * @param sourceViewController The view controller to present from.
 */
- (void)setSourceIndexPath:(NSIndexPath *)indexPath inCollectionViewController:(UICollectionViewController *)sourceViewController;
/**
 * Setup the sources for the transition from a
 * UICollectionViewController. The source view will be automatically taken from
 * the indexPath, and if necessary scrolled into view.
 * @param indexPath The index path indicating the cell to animate from
 * @param sourceViewController The view controller to present from.
 * @param sourceImage The placeholder image for the source view. Specifying nil
 * will take a snapshot just before the animation.
 */
- (void)setSourceIndexPath:(NSIndexPath *)indexPath inCollectionViewController:(UICollectionViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage;
#endif

/**
 * Setup the sources for the transition from a UITableViewController.
 * The source view will be automatically taken from the indexPath, and if
 * necessary, scrolled into view. The snapshot image will be taken just before
 * the animation.
 * @param indexPath The index path indicating the cell to animate from
 * @param sourceViewController The view controller to present from.
 */
- (void)setSourceIndexPath:(NSIndexPath *)indexPath inTableViewController:(UITableViewController *)sourceViewController;
/**
 * Setup the sources for the transition from a UITableViewController.
 * The source view will be automatically taken from the indexPath, and if
 * necessary.
 * @param indexPath The index path indicating the cell to animate from
 * @param sourceViewController The view controller to present from.
 * @param sourceImage The placeholder image for the source view. Specifying nil
 * will take a snapshot just before the animation.
 */
- (void)setSourceIndexPath:(NSIndexPath *)indexPath inTableViewController:(UITableViewController *)sourceViewController withSnapshotImage:(UIImage *)sourceImage;

/**
 * Update the index path when using a UICollectionViewController or
 * UITableViewController.
 */
- (void)updateIndexPath:(NSIndexPath *)indexPath;

/**
 * Set the view controller to be presented. The snapshot image will be
 * taken just before the animation.
 * @param destinationViewController The view controller to present.
 */
- (void)setDestinationViewController:(UIViewController *)destinationViewController;
/**
 * Set the view controller to be presented.
 * @param destinationViewController The view controller to present.
 * @param destinationImage The placeholder image for the destination view.
 * Specifying nil will take a snapshot just before the animation.
 */
- (void)setDestinationViewController:(UIViewController *)destinationViewController withSnapshotImage:(UIImage *)destinationImage;

/**
 * Set the view controller to be presented. The view controller will
 * be shown as a child view controller in the given frame. The snapshot image
 * will be taken just before the animation.
 * @param destinationViewController The view controller to present.
 * @param destinationSize The size for the destination view controller to take
 * up on the screen.
 */
- (void)setDestinationViewController:(UIViewController *)destinationViewController asChildWithSize:(CGSize)destinationSize;
/**
 * Set the view controller to be presented. The view controller will
 * be shown as a child view controller in the given frame.
 * @param destinationViewController The view controller to present.
 * @param destinationSize The size for the destination view controller to take
 * up on the screen.
 * @param sourceImage The placeholder image for the source view. Specifying nil
 * will take a snapshot just before the animation.
 */
- (void)setDestinationViewController:(UIViewController *)destinationViewController asChildWithSize:(CGSize)destinationSize withSnapshotImage:(UIImage *)destinationImage;

/**
 * Perform the animation.
 */
- (void)perform;
/**
 * Perform the animation.
 * @param completion A block to run on completion. Can be NULL.
 */
- (void)performWithCompletion:(void (^)(void))completion;

/**
 * Reverse the animation.
 */
- (void)reverse;
/**
 * Reverse the animation.
 * @param completion A block to run on completion. Can be NULL.
 */
- (void)reverseWithCompletion:(void (^)(void))completion;

@end
