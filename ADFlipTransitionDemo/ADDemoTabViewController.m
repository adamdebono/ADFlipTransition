//
//  ADDemoTabViewController.m
//  ADFlipTransition
//
//  Created by Adam Debono on 10/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "ADDemoTabViewController.h"

@interface ADDemoTabViewController ()

@end

@implementation ADDemoTabViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
		UIViewController *controller = [[UIStoryboard storyboardWithName:@"CollectionViewStoryboard" bundle:nil] instantiateInitialViewController];
		//[[self tabBar] setItems:[[[self tabBar] items] arrayByAddingObject:controller]];
		[self setViewControllers:[[self viewControllers] arrayByAddingObject:controller] animated:NO];
	}
}

@end
