//
//  SafariActivity.m
//  KTSimpleWebBrowserDemo
//
//  Created by UNI on 2013/12/11.
//  Copyright (c) 2013年 pikab1. All rights reserved.
//

#import "SafariActivity.h"

@implementation SafariActivity {
	NSURL *_URL;
}

- (NSString *)activityType
{
	return NSStringFromClass([self class]);
}

- (NSString *)activityTitle
{
	return @"Open in Safari";
}

- (UIImage *)activityImage
{
	return [UIImage imageNamed:@"ico_safari"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:activityItem]) {
			return YES;
		}
	}
	
	return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			_URL = activityItem;
		}
	}
}

- (void)performActivity
{
	BOOL completed = [[UIApplication sharedApplication] openURL:_URL];
	
	[self activityDidFinish:completed];
}

@end
