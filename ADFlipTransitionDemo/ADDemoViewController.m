//
//  ADDemoViewController.m
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "ADDemoViewController.h"

#import "ADFlippedViewController.h"
#import "UIViewController+ADFlipTransition.h"
#import "UIColor+Expanded.h"

@interface ADDemoViewController ()

@end

@implementation ADDemoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[self view] setBackgroundColor:[UIColor randomColor]];
}

- (IBAction)flipModally:(id)sender {
	ADFlippedViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ADFlippedViewController"];
	[viewController hideStepper];
	
	[self flipToViewController:viewController fromView:sender withCompletion:NULL];
}

- (IBAction)flipAsChild:(id)sender {
	
}

@end
