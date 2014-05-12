//
//  FlipsideViewController.m
//  FillIt
//
//  Created by Antti Myllykoski on 5/10/14.
//  Copyright (c) 2014 myllysoftware.com. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [self initUI];
    [super viewDidLoad];
}

-(void) initUI {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool showHints = [prefs boolForKey:@"showHints"];
    bool appStarts = [prefs boolForKey:@"appStarts"];
    NSInteger bestTime = [prefs integerForKey:@"bestTime"];
    [_hintSwitch setOn:showHints];
    [_appStartSwitch setOn:appStarts];
    [_timeLabel setText:[NSString stringWithFormat:@"%li", (long)bestTime]];
    int completedGames = (int)[prefs integerForKey:@"completedGames"];
    [self populateGameGrid:completedGames];
}

-(void) populateGameGrid:(int) completedGames {
    int mask = 1;
    for(int i = 0; i < 25; i++) {
        if(completedGames & mask) {
            [_games[i] setBackgroundColor:[UIColor greenColor]];
        }
        mask = mask << 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool showHints = [_hintSwitch isOn];
    bool appStarts = [_appStartSwitch isOn];
    [prefs setBool:showHints forKey:@"showHints" ];
    [prefs setBool:appStarts forKey:@"appStarts"];
    [prefs synchronize];
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
