//
//  HBCLAppDelegate.m
//  Clock
//
//  Created by Adam D on 23/10/2013.
//  Copyright (c) 2013 HASHBANG Productions. All rights reserved.
//

#import "HBCLAppDelegate.h"

@interface HBCLAppDelegate () {
	NSStatusItem *_statusItem;
	NSMenuItem *_dateMenuItem;
	NSMenuItem *_timezoneMenuItem;
	NSMutableAttributedString *_attributedString;
	
	NSDateFormatter *_timeFormatter;
	NSDateFormatter *_dateFormatter;
	NSDateFormatter *_timezoneFormatter;
	
	NSFont *_font;
	NSColor *_color;
}

@end

@implementation HBCLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	_statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	_statusItem.highlightMode = YES;
	_statusItem.menu = [[NSMenu alloc] init];
	
	_dateMenuItem = [[NSMenuItem alloc] init];
	_dateMenuItem.enabled = NO;
	[_statusItem.menu addItem:_dateMenuItem];
	_timezoneMenuItem = [[NSMenuItem alloc] init];
	_timezoneMenuItem.enabled = NO;
	[_statusItem.menu addItem:_timezoneMenuItem];
	
	_attributedString = [[NSMutableAttributedString alloc] init];
	
	_timeFormatter = [[NSDateFormatter alloc] init];
	_timeFormatter.dateFormat = @"EEE hh:mm a";
	_dateFormatter = [[NSDateFormatter alloc] init];
	_dateFormatter.dateFormat = @"EEEE, d MMMM y";
	_timezoneFormatter = [[NSDateFormatter alloc] init];
	_timezoneFormatter.dateFormat = @"vvvv (Z)";
	
	_font = [NSFont menuBarFontOfSize:0];
	_color = [NSColor colorWithCalibratedWhite:0.7f alpha:1];
	
	[self updateClock];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
}

- (void)updateClock {
	NSDate *date = [NSDate date];
	
	_dateMenuItem.title = [_dateFormatter stringFromDate:date];
	_timezoneMenuItem.title = [_timezoneFormatter stringFromDate:date];
	
	[_attributedString replaceCharactersInRange:NSMakeRange(0, _attributedString.string.length) withString:[_timeFormatter stringFromDate:date]];
	[_attributedString setAttributes:@{
		NSFontAttributeName: _font,
		NSForegroundColorAttributeName: _color
	} range:NSMakeRange(0, _attributedString.string.length)];
	
	_statusItem.attributedTitle = _attributedString;
}

@end
