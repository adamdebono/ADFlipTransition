//
//  UICollectionViewController+ADFlipTransition.h
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

#import <UIKit/UIKit.h>

@interface UICollectionViewController (ADFlipTransition)

- (void)flipToViewController:(UIViewController *)destinationViewController fromItemAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(void))completion;

@end

#endif