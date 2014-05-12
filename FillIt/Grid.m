//
//  Grid.m
//  FillIt
//
//  Created by Antti Myllykoski on 5/11/14.
//  Copyright (c) 2014 myllysoftware.com. All rights reserved.
//

#import "Grid.h"

#define UNSET -1
@implementation Grid

int board[5][5];
static NSArray *nums = nil;
int currentNumber;
int latestPosition;
int startPosition;

- (id)init {
	[self reset];
	return [super init];
}

+ (id)alloc {
	return [super alloc];
}

- (void)reset {
	for (int i = 0; i < 5; i++)
		for (int j = 0; j < 5; j++)
			board[i][j] = UNSET;
    
	if (nums == nil) {
		nums = [NSArray arrayWithObjects:@"", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", nil];
	}
    
	currentNumber = 0;
	latestPosition = 0;
    startPosition = 0;
}

- (NSString *)getCurrentNumString {
	return [nums objectAtIndex:currentNumber];
}

- (int)valueAt:(int)position {
	assert((position >= 0) && (position < 25));
	return board[position / 5][position % 5];
}

- (int)valueAt:(int)x y:(int)y {
	assert((x >= 0) && (x < 5) && (y >= 0) && (y < 5));
	return board[x][y];
}

- (int)isSet:(int)position {
	assert((position >= 0) && (position < 25));
	return board[position / 5][position % 5] != UNSET;
}

- (int)isSet:(int)x y:(int)y {
	assert((x >= 0) && (x < 5) && (y >= 0) && (y < 5));
	return board[x][y] != UNSET;
}

- (int)incrementCurrentNumber {
	return ++currentNumber;
}

- (void)setCellValueToCurrentNumber:(int)position {
    if(currentNumber == 1) {
        startPosition = position;
    }
	assert((position >= 0) && (position < 25));
	latestPosition = position;
	board[position / 5][position % 5] = currentNumber;
}

- (int)currentNumber {
	return currentNumber;
}

-(int) getStartPosition {
    return startPosition;
}

- (int)rnd:(int)lo hi:(int)hi {
	if (lo == hi) {
		return lo;
	}
	int r = (int)arc4random_uniform(hi) - lo;
	return r;
}

// Returns number of choices and updates the choices -array with
// the available positions
- (int)getChoices:(int *)choices {
	int x = latestPosition % 5;
	int y = latestPosition / 5;
	int freeIndex = 0;
	int pos = 0;
    
	if (x + 3 < 5) { // X to right
		pos = 5 * y + x + 3;
		if (![self isSet:pos]) {
			choices[freeIndex++] = pos;
		}
	}
	if (x - 3 >= 0) { // X to left
		pos =  5 * y + x - 3;
		if (![self isSet:pos]) {
			choices[freeIndex++] = pos;
		}
	}
	if (y + 3 < 5) { // Y to down
		pos = 5 * (y + 3) + x;
		if (![self isSet:pos]) {
			choices[freeIndex++] = pos;
		}
	}
	if (y - 3 >= 0) { // Y to up
		pos = 5 * (y - 3) + x;
		if (![self isSet:pos]) {
			choices[freeIndex++] = pos;
		}
	}
	if ((x + 2 < 5) && (y - 2 >= 0)) { // north-east
		pos = 5 * (y - 2) + x + 2;
		if (![self isSet:pos]) {
			choices[freeIndex++] = pos;
		}
	}
	if ((x + 2 < 5) && (y + 2 < 5)) { // south-east
		pos = 5 * (y + 2) + x + 2;
		if (![self isSet:pos]) {
			choices[freeIndex++] = pos;
		}
	}
	if ((x - 2 >= 0) && (y + 2 < 5)) { // south-west
		pos = 5 * (y + 2) + x - 2;
		if (![self isSet:pos]) {
			choices[freeIndex++] = pos;
		}
	}
	if ((x - 2 >= 0) && (y - 2 >= 0)) { // north-west
		pos = 5 * (y - 2) + x - 2;
		if (![self isSet:pos]) {
			choices[freeIndex++] = pos;
		}
	}
	return freeIndex;
}

- (int)nextRndCell {
	int ret = UNSET;
	int choices[4] = { 0, 0, 0, 0 };
	int freeIndex = [self getChoices:choices];
	if (freeIndex == 0) {
		ret = UNSET;
	}
	else {
		ret = choices[[self rnd:0 hi:freeIndex]];
	}
	return ret;
}

@end
