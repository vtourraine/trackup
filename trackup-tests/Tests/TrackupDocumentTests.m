//
//  TrackupDocumentTests.m
//  trackup
//
//  Created by Vincent Tourraine on 18/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

@import XCTest;

#import "TrackupDocument.h"

@interface TrackupDocumentTests : XCTestCase

@end


@implementation TrackupDocumentTests

- (void)testIdentifyVersionAsInProgressIfItemsHaveCheckmarks {
    TrackupVersion *version = [TrackupVersion new];
    TrackupItem *item = [TrackupItem new];
    item.state = TrackupItemStateTodo;
    version.items = @[item];
    XCTAssertTrue(version.isInProgress);

    item.state = TrackupItemStateUnknown;
    version.items = @[item];
    XCTAssertFalse(version.isInProgress);
}

@end
