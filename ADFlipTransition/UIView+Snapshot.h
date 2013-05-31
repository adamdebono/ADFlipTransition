//
//  UIView+Snapshot.h
//  ADFlipTransition
//
//  Created by Adam Debono on 31/05/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Snapshot)

- (UIImage *)snapshot;
- (UIImage *)snapshotAtRect:(CGRect)rect;

@end
