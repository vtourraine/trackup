//
//  TrackupParser.m
//  trackup
//
//  Created by Vincent Tourraine on 01/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

#import "TrackupParser.h"

#import "TrackupDocument.h"

static NSString * const TrackupDocumentTitlePrefix = @"# ";
static NSString * const TrackupDocumentURLPrefix   = @"http";
static NSString * const TrackupVersionTitlePrefix  = @"## ";
static NSString * const TrackupItemPrefix          = @"- ";
static NSString * const TrackupItemMajorTag        = @"[major] ";

@implementation TrackupParser

- (TrackupDocument *)documentFromString:(NSString *)string {
    TrackupDocument *document = [TrackupDocument new];
    NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    TrackupVersion *currentVersion;
    NSMutableArray *versions = [NSMutableArray array];
    NSMutableArray *currentItems;

    for (NSString *line in lines) {
        if ([line hasPrefix:TrackupDocumentTitlePrefix] && !document.title) {
            document.title = [line substringFromIndex:TrackupDocumentTitlePrefix.length];
        }
        else if ([line hasPrefix:TrackupVersionTitlePrefix]) {
            if (currentVersion) {
                currentVersion.items = currentItems;
                [versions addObject:currentVersion];
            }

            currentVersion = [TrackupVersion new];
            currentVersion.title = [line substringFromIndex:TrackupVersionTitlePrefix.length];
            currentItems = [NSMutableArray array];
        }
        else if ([line hasPrefix:TrackupItemPrefix]) {
            TrackupItem *item = [TrackupItem new];
            NSString *title = [line substringFromIndex:TrackupItemPrefix.length];
            if ([title rangeOfString:TrackupItemMajorTag options:NSCaseInsensitiveSearch].location == 0) {
                item.status = TrackupItemStatusMajor;
                title = [title substringFromIndex:TrackupItemMajorTag.length];
            }

            item.title = title;
            [currentItems addObject:item];
        }
        else if ([line hasPrefix:TrackupDocumentURLPrefix] && !document.URL) {
            document.URL = [NSURL URLWithString:line];
        }
        else if ([line componentsSeparatedByString:@"-"].count == 3) {
            NSArray *components = [line componentsSeparatedByString:@"-"];
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.year  = [components[0] integerValue];
            dateComponents.month = [components[1] integerValue];
            dateComponents.day   = [components[2] integerValue];
            currentVersion.dateComponents = dateComponents;
        }
    }

    if (currentVersion) {
        currentVersion.items = currentItems;
        [versions addObject:currentVersion];
    }
    document.versions = versions;

    return document;
}

@end
