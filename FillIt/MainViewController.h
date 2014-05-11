//
//  MainViewController.h
//  FillIt
//
//  Created by Antti Myllykoski on 5/10/14.
//  Copyright (c) 2014 myllysoftware.com. All rights reserved.
//

#import "FlipsideViewController.h"
#import <iAd/iAd.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, ADBannerViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *cells;
- (IBAction)onTap:(id)sender;
- (IBAction)startGame:(id)sender;

@end
