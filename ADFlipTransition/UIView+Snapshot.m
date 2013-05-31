//
//  UIView+Snapshot.m
//  ADFlipTransition
//
//  Created by Adam Debono on 31/05/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIImage *)snapshot {
	return [self snapshotAtRect:CGRectNull];
}

- (UIImage *)snapshotAtRect:(CGRect)rect {
	if (CGRectEqualToRect(rect, CGRectNull)) {
		rect = [self bounds];
	}
	
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
	[[self layer] renderInContext:context];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end
