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
		[self dismissFlipToIndexPath:[NSIndexPath indexPathForRow:[[self cellNumberStepper] value] inSection:0] withCompletion:NULL];
	}
}

- (IBAction)cellNumberChanged:(UIStepper *)sender {
	[[self cellNumberLabel] setText:[NSString stringWithFormat:@"%i", (int)[sender value]]];
}

@end
