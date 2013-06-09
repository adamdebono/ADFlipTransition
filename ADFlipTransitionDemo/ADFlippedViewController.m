//
//  ADFlippedViewController.m
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "ADFlippedViewController.h"

#import "UIViewController+ADFlipTransition.h"

#import "UIColor+Expanded.h"

@interface ADFlippedViewController ()

@property (strong, nonatomic) IBOutlet UILabel *cellNumberLabel;
@property (strong, nonatomic) IBOutlet UIStepper *cellNumberStepper;

@end

@implementation ADFlippedViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIColor *color = [UIColor randomColor];
	[[self view] setBackgroundColor:color];
	[[self cellNumberLabel] setTextColor:[color contrastingColor]];
}

- (void)hideStepper {
	[[self cellNumberLabel] setHidden:YES];
	[[self cellNumberStepper] setHidden:YES];
}

- (void)setCellNumber:(int)number {
	[[self cellNumberStepper] setValue:number];
	[self cellNumberChanged:[self cellNumberStepper]];
}

- (IBAction)backPressed:(id)sender {
	if ([[self cellNumberStepper] isHidden]) {
		[self dismissFlipWithCompletion:NULL];
	} else {
		[self dismissFlipToIndexPath:[NSIndexPath indexPathForItem:[[self cellNumberStepper] value] inSection:0] withCompletion:NULL];
	}
}

- (IBAction)cellNumberChanged:(UIStepper *)sender {
	[[self cellNumberLabel] setText:[NSString stringWithFormat:@"%i", (int)[sender value]]];
}

@end
