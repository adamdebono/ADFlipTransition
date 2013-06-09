//
//  ADDemoTableViewController.m
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "ADDemoTableViewController.h"

#import "ADFlippedViewController.h"
#import "UITableViewController+ADFlipTransition.h"
#import "UIColor+Expanded.h"

@interface ADDemoTableViewController ()

@end

@implementation ADDemoTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
	[[cell textLabel] setText:[NSString stringWithFormat:@"Cell: %i", [indexPath row]]];
	[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
	
	[[cell contentView] setBackgroundColor:[UIColor colorWithHue:[indexPath row]/100.0f saturation:1 brightness:1 alpha:1]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ADFlippedViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ADFlippedViewController"];
	
	[viewController view];
	[viewController setCellNumber:[indexPath row]];
	
    [self flipToViewController:viewController fromItemAtIndexPath:indexPath withCompletion:NULL];
}

@end
