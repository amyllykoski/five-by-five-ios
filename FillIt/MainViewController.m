//
//  MainViewController.m
//  FillIt
//
//  Created by Antti Myllykoski on 5/10/14.
//  Copyright (c) 2014 myllysoftware.com. All rights reserved.
//

#import "MainViewController.h"
#import "Grid.h"

@interface MainViewController ()
@property Grid *grid;
@property bool showHints;
@property NSTimer *timer;
@property int seconds;
@end
@implementation MainViewController

static int startPos = 0;

- (void)clearBoard {
	for (int i = 0; i < 25; i++) {
		((UITextField *)[_cells objectAtIndex:i]).text = @"";
		[((UITextView *)[_cells objectAtIndex:i])setBackgroundColor :[UIColor clearColor]];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initPrefs];
	[self clearBoard];
	[_bannerView setHidden:NO];
	_grid = [Grid new];
	_seconds = 0;
}

- (NSTimer *)createTimer {
	return [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}

- (void)timerTicked:(NSTimer *)timer {
	NSLog(@"timer");
	_seconds++;
	[_timeLabel setText:[NSString stringWithFormat:@"%i", _seconds]];
}

- (void)stopTimer {
	[_timer invalidate];
}

- (void)initPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	_showHints = [prefs boolForKey:@"showHints"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
	[self initPrefs];
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
	[_bannerView setHidden:NO];
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
	[_bannerView setHidden:YES];
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

- (BOOL)isValidChoice:(int)proposedChoice {
	if ([_grid currentNumber] == 0) {
		[_grid incrementCurrentNumber];
		[_grid setCellValueToCurrentNumber:proposedChoice];
		return YES;
	}
	int choices[4] = { 0, 0, 0, 0 };
	int nbrOfChoices = [_grid getChoices:choices];
	for (int i = 0; i < nbrOfChoices; i++) {
		if (choices[i] == proposedChoice) {
			return YES;
		}
	}
	return NO;
}

- (int)highLightChoices {
	int choices[4] = { 0, 0, 0, 0 };
	int nbrOfChoices = [_grid getChoices:choices];
	for (int i = 0; i < nbrOfChoices; i++) {
		if (_showHints) {
			[((UITextView *)[_cells objectAtIndex:choices[i]])setBackgroundColor :[UIColor yellowColor]];
		}
	}
	return nbrOfChoices;
}

- (void)clearChoices {
	int choices[4] = { 0, 0, 0, 0 };
	int nbrOfChoices = [_grid getChoices:choices];
	for (int i = 0; i < nbrOfChoices; i++) {
		[((UITextView *)[_cells objectAtIndex:choices[i]])setBackgroundColor :[UIColor clearColor]];
	}
}

- (void)flipCell:(int)cellNum duration:(float)duration {
	((UITextView *)[_cells objectAtIndex:cellNum]).text = [_grid getCurrentNumString];
	[UIView beginAnimations:@"Flip" context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
	                       forView:((UITextView *)[_cells objectAtIndex:cellNum]) cache:NO];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}

- (void)analyzeMove:(int)cellNum {
	if ([self highLightChoices] == 0) { // Finished, not completed
		if ([_grid currentNumber] != 25) {
			[self stopTimer];
			[((UITextView *)[_cells objectAtIndex:cellNum])setBackgroundColor :[UIColor redColor]];
			[self flipCell:cellNum duration:3.0];
		}
		else {  // Completed
			[self stopTimer];
			[self saveCompletedGame];
		}
	}
	else {  // Moving on
		[_grid incrementCurrentNumber];
	}
}

- (IBAction)onTap:(id)sender {
	int cellNum = (int)[sender tag] - 1;
	if (![_timer isValid]) {
		_timer = [self createTimer];
	}
	if (![self isValidChoice:cellNum]) {
		return;
	}
    
	[self flipCell:cellNum duration:0.40];
	[self clearChoices];
	[_grid setCellValueToCurrentNumber:cellNum];
	[_scoreLabel setText:[NSString stringWithFormat:@"%i", [_grid currentNumber]]];
	[self analyzeMove:cellNum];
}

- (void)saveCompletedGame {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	int completedGames = (int)[prefs integerForKey:@"completedGames"];
	completedGames |= 1 << [_grid getStartPosition];
	[prefs setInteger:completedGames forKey:@"completedGames"];
	[prefs synchronize];
}

// Internal solution finder
- (void)findSolutions {
	if (startPos > 24)
		startPos = 0;
	int iterations = 0;
	do {
		++iterations;
		[_grid reset];
		[self clearBoard];
	}
	while (![self simulate]);
	[_scoreLabel setText:[NSString stringWithFormat:@"%i", iterations]];
	++startPos;
}

- (void)chooseFirstCell {
	[_grid incrementCurrentNumber];
	int cellNum = [_grid nextRndCell];
	[_grid setCellValueToCurrentNumber:cellNum];
	((UITextView *)[_cells objectAtIndex:cellNum]).text = [_grid getCurrentNumString];
	[_grid incrementCurrentNumber];
}

- (IBAction)startGame:(id)sender {
	[_grid reset];
	[self clearBoard];
	_seconds = 0;
	[_timeLabel setText:@"0"];
	//    [self findSolutions];
}

- (BOOL)simulate {
	int next = startPos; //[_grid nextRndCell];
	[_grid setCellValueToCurrentNumber:next];
	((UITextView *)[_cells objectAtIndex:next]).text = [_grid getCurrentNumString];
	[_grid incrementCurrentNumber];
	while ([_grid currentNumber] <= 25) {
		next = [_grid nextRndCell];
		if (next == -1) {
			return NO;
		}
		[_grid setCellValueToCurrentNumber:next];
		((UITextView *)[_cells objectAtIndex:next]).text = [_grid getCurrentNumString];
		[_grid incrementCurrentNumber];
	}
	return YES;
}

@end
