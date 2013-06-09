# ADFlipTransition #

An easy to use presentation animation. Transition from one view controller to another. Can be performed modally or as a at a specific frame. Easily add a transition from a cell in a UICollectionViewController or UITableViewController. There are also categories which provide convenience methods for one-line calls, just as you would present any other modal view controller.

Note that modal presentation currently only supports full screen presentation.

## Requirements ##

- Objective-C ARC
- Xcode 4.4 or above
- iOS 5 or above

## Installation ##

Once you have got the source, you can install the component in two ways.

### As a dependency ###

1. Drag the ADFlipTransition.xcodeproj file into your xcode project. *Make sure that it is not open in another window*
2. Click on the project settings and navigate to the target you wish to install for. Click build phases. Add ADFlipTransition to your 'Target Dependencies'.
3. Add the following to 'Link Binary With Libraries': (If not already)
    - libADFlipTransition
	- QuartzCore
4. Go to the 'Build Setting' tab. Add '-ObjC' and '-all_load' to 'Other Linker Flags'
5. Add the repository's file directory to 'User Header Search Paths'


### Import the files ###

1. Drag ADFlipTransition.h and .m into your project.
2. Add QuartzCore to 'Link Binary With Libraries' in your target's 'Build Phases' (If not already)
3. If you're not using ARC, add -f-objc-arc to ADFlipTransition.m's compiler flags. (In 'Build Phases' -> 'Compile Sources'

## Using ADFlipTransition ##

### One Line Presentation ###

```objectivec
#import "UIViewController+ADFlipTransition.h"

@implementation MyViewController 

- (IBAction)showFlippedViewButtonPressed:(UIButton *)sender {
	FlippedViewController *flippedViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"flippedViewController"];
	[self flipToViewController:flippedViewController fromView:sender withCompletion:NULL];
}

@end
```

Then to dismiss it:

```objectivec
#import UIViewController+ADFlipTransition.h

@implementation FlippedViewController

- (IBAction)backPressed:(UIButton *)sender {
	[self dismissFlipWithCompletion:NULL];
}
```

### From a UICollectionViewController ###

(Or a UITableViewController – just swap '*collection*' for '*table*')

If the index path used refers to a cell which is off-screen, the cell will be scrolled into place (not animated).

```objectivec
#import "UICollectionViewController+ADFlipTransition.h"

@implementation MyCollectionViewController 

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	FlippedViewController *flippedViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"flippedViewController"];
	[self flipToViewController:flippedViewController fromItemAtIndexPath:indexPath withCompletion:NULL];
}

@end
```

Dismiss back to a collection/table view controller the same as normal, or you can update the index path if needed.

```objectivec
#import UIViewController+ADFlipTransition.h

@interface FlippedViewController ()

@property (strong, nonatomic) NSInteger pageNumber;

@end

@implementation FlippedViewController

- (IBAction)backPressed:(UIButton *)sender {
	[self dismissFlipToIndexPath:[NSIndexPath indexPathForRow:[self pageNumber] inSection:0] withCompletion:NULL];
}
```

For more sample code, check out the demo, included with the repository

## License ##

The MIT License (MIT)

Copyright (c) 2013 Adam Debono

This software is provided under the terms of the MIT License (MIT), as provided below. I would greatly appreciate commendation within a 'credits' or 'licenses' section where this is used.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.