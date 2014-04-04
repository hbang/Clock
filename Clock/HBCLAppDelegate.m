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
	BOOL _menuOpen;
	
	NSArray *_locations;
	
	NSDateFormatter *_timeFormatter;
	NSDateFormatter *_dateFormatter;
	NSDateFormatter *_timezoneFormatter;
	NSDateFormatter *_locationFormatter;
	
	NSFont *_font;
	NSColor *_color;
}

@end

static NSString *const kHBCLLocationName = @"Name";
static NSString *const kHBCLLocationTimeZone = @"TimeZone";
static NSString *const kHBCLLocationMenuItem = @"MenuItem";

@implementation HBCLAppDelegate

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	_statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	_statusItem.highlightMode = YES;
	_statusItem.menu = [[NSMenu alloc] init];
	_statusItem.menu.delegate = self;
	
	_dateMenuItem = [[NSMenuItem alloc] init];
	_dateMenuItem.enabled = NO;
	[_statusItem.menu addItem:_dateMenuItem];
	_timezoneMenuItem = [[NSMenuItem alloc] init];
	_timezoneMenuItem.enabled = NO;
	[_statusItem.menu addItem:_timezoneMenuItem];
	[_statusItem.menu addItem:[NSMenuItem separatorItem]];
	
	_locations = [@[
		@{
			kHBCLLocationName: @"Sydney",
			kHBCLLocationTimeZone: [NSTimeZone timeZoneWithName:@"Australia/NSW"],
			kHBCLLocationMenuItem: [[[NSMenuItem alloc] init] autorelease]
		},
		@{
			kHBCLLocationName: @"US Pacific",
			kHBCLLocationTimeZone: [NSTimeZone timeZoneWithName:@"America/Los_Angeles"],
			kHBCLLocationMenuItem: [[[NSMenuItem alloc] init] autorelease]
		},
		@{
			kHBCLLocationName: @"US East",
			kHBCLLocationTimeZone: [NSTimeZone timeZoneWithName:@"America/New_York"],
			kHBCLLocationMenuItem: [[[NSMenuItem alloc] init] autorelease]
		},
		@{
			kHBCLLocationName: @"London",
			kHBCLLocationTimeZone: [NSTimeZone timeZoneWithName:@"Europe/London"],
			kHBCLLocationMenuItem: [[[NSMenuItem alloc] init] autorelease]
		},
	] retain];
	
	for (NSDictionary *location in _locations) {
		NSMenuItem *menuItem = location[kHBCLLocationMenuItem];
		menuItem.enabled = NO;
		[_statusItem.menu addItem:menuItem];
	}
	
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

#pragma mark - NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu {
	_menuOpen = YES;
	[self updateClock];
}

- (void)menuDidClose:(NSMenu *)menu {
	_menuOpen = NO;
}

#pragma mark - Updating

- (void)updateClock {
	NSDate *date = [NSDate date];
	
	if (_menuOpen) {
		_dateMenuItem.title = [_dateFormatter stringFromDate:date];
		_timezoneMenuItem.title = [_timezoneFormatter stringFromDate:date];
		
		for (NSDictionary *location in _locations) {
			_timeFormatter.timeZone = location[kHBCLLocationTimeZone];
			((NSMenuItem *)location[kHBCLLocationMenuItem]).title = [NSString stringWithFormat:@"%@: %@", location[kHBCLLocationName], [_timeFormatter stringFromDate:date]];
		}
		
		_timeFormatter.timeZone = nil;
	}
	
	[_attributedString replaceCharactersInRange:NSMakeRange(0, _attributedString.string.length) withString:[_timeFormatter stringFromDate:date]];
	[_attributedString setAttributes:@{
		NSFontAttributeName: _font,
		NSForegroundColorAttributeName: _color
	} range:NSMakeRange(0, _attributedString.string.length)];
	
	_statusItem.attributedTitle = _attributedString;
}

@end
