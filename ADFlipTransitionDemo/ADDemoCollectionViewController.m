//
//  ADDemoCollectionViewController.m
//  ADFlipTransition
//
//  Created by Adam Debono on 9/06/13.
//  Copyright (c) 2013 Adam Debono. All rights reserved.
//

#import "ADDemoCollectionViewController.h"

#import "ADFlippedViewController.h"
#import "UICollectionViewController+ADFlipTransition.h"
#import "UIColor+Expanded.h"

@interface ADDemoCollectionViewController ()

@end

@implementation ADDemoCollectionViewController

#pragma mark - Table view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	[[cell contentView] setBackgroundColor:[UIColor colorWithHue:[indexPath row]/100.0f saturation:1 brightness:1 alpha:1]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	ADFlippedViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ADFlippedViewController"];
	
	[viewController view];
	[viewController setCellNumber:[indexPath row]];
	
    [self flipToViewController:viewController fromItemAtIndexPath:indexPath withCompletion:NULL];
}

@end
