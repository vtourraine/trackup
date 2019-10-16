//
//  TrackupDocument.m
//  trackup
//
//  Created by Vincent Tourraine on 01/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

#import "TrackupDocument.h"

@implementation TrackupDocument

@end


@implementation TrackupVersion

- (BOOL)isInProgress {
    for (TrackupItem *item in self.items) {
        if (item.state != TrackupItemStateUnknown) {
            return YES;
        }
    }

    return NO;
}

@end


@implementation TrackupItem

@end
