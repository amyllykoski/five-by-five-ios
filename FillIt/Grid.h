//
//  Grid.h
//  FillIt
//
//  Created by Antti Myllykoski on 5/11/14.
//  Copyright (c) 2014 myllysoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject
+ (id)alloc;
- (id)init;
- (void)reset;
- (NSString *)getCurrentNumString;
-(void) setCellValueToCurrentNumber:(int) position;
- (int) currentNumber;
- (int) incrementCurrentNumber;
- (int)valueAt:(int)position;
- (int)valueAt:(int)x y:(int)y;
- (int)isSet:(int)position;
- (int)isSet:(int)x y:(int)y;
- (int)nextRndCell;
- (int)getChoices:(int *)choices;

@end
