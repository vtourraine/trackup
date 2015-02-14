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
static NSString * const TrackupVersionTitlePrefix = @"## ";
static NSString * const TrackupItemPrefix = @"- ";

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
            item.title = [line substringFromIndex:TrackupItemPrefix.length];
            [currentItems addObject:item];
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
