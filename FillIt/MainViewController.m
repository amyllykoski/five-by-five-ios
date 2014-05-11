//
//  MainViewController.m
//  FillIt
//
//  Created by Antti Myllykoski on 5/10/14.
//  Copyright (c) 2014 myllysoftware.com. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end
@implementation MainViewController

static NSArray *nums = nil;
int currentNumber;

- (void)resetGrid {
	for (int i = 0; i < 25; i++) {
		((UITextField *)[_cells objectAtIndex:i]).text = @"";
	}
	if (nums == nil) {
		nums = [NSArray arrayWithObjects:@"", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", nil];
	}
    currentNumber = 1;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self resetGrid];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showAlternate"]) {
		[[segue destinationViewController] setDelegate:self];
	}
}

#pragma mark AdBanner delegate methods
/*!
 * @method bannerViewWillLoadAd:
 *
 * @discussion
 * Called when a banner has confirmation that an ad will be presented, but
 * before the resources necessary for presentation have loaded.
 */
- (void)bannerViewWillLoadAd:(ADBannerView *)banner NS_AVAILABLE_IOS(5_0) {
}

/*!
 * @method bannerViewDidLoadAd:
 *
 * @discussion
 * Called each time a banner loads a new ad. Once a banner has loaded an ad, it
 * will display it until another ad is available.
 *
 * It's generally recommended to show the banner view when this method is called,
 * and hide it again when bannerView:didFailToReceiveAdWithError: is called.
 */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
}

/*!
 * @method bannerView:didFailToReceiveAdWithError:
 *
 * @discussion
 * Called when an error has occurred while attempting to get ad content. If the
 * banner is being displayed when an error occurs, it should be hidden
 * to prevent display of a banner view with no ad content.
 *
 * @see ADError for a list of possible error codes.
 */
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
}

/*!
 * @method bannerViewActionShouldBegin:willLeaveApplication:
 *
 * Called when the user taps on the banner and some action is to be taken.
 * Actions either display full screen content modally, or take the user to a
 * different application.
 *
 * The delegate may return NO to block the action from taking place, but this
 * should be avoided if possible because most ads pay significantly more when
 * the action takes place and, over the longer term, repeatedly blocking actions
 * will decrease the ad inventory available to the application.
 *
 * Applications should reduce their own activity while the advertisement's action
 * executes.
 */
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	return YES;
}

/*!
 * @method bannerViewActionDidFinish:
 *
 * Called when a modal action has completed and control is returned to the
 * application. Games, media playback, and other activities that were paused in
 * bannerViewActionShouldBegin:willLeaveApplication: should resume at this point.
 */
- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

- (IBAction)onTap:(id)sender {
    int cellNum = (int)[sender tag] - 1;
	((UITextView *)[_cells objectAtIndex:cellNum]).text = [nums objectAtIndex:currentNumber++];
}

- (IBAction)startGame:(id)sender {
    [self resetGrid];
}

@end
