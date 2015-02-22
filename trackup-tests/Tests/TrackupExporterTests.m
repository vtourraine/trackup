//
//  TrackupExporterTests.m
//  trackup
//
//  Created by Vincent Tourraine on 14/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

@import XCTest;

#import "TrackupExporter.h"
#import "TrackupDocument.h"

@interface TrackupExporterTests : XCTestCase

@property (strong) TrackupExporter *exporter;

@end


@implementation TrackupExporterTests

- (void)setUp {
    [super setUp];
    self.exporter = [TrackupExporter new];
}

- (void)tearDown {
    self.exporter = nil;
    [super tearDown];
}


- (void)testExportHTML {
    TrackupDocument *document = [TrackupDocument new];
    document.title = @"Test";

    TrackupVersion *version1 = [TrackupVersion new];
    version1.title = @"v1.0";
    TrackupItem *itemA = [TrackupItem new];
    itemA.title = @"Item A";
    itemA.status = TrackupItemStatusMajor;
    TrackupItem *itemB = [TrackupItem new];
    itemB.title = @"Item B";
    version1.items = @[itemA, itemB];

    TrackupVersion *version2 = [TrackupVersion new];
    version2.title = @"v1.0.1";

    document.versions = @[version1, version2];

    NSString *HTMLString = [self.exporter HTMLStringFromDocument:document];
    XCTAssertTrue([HTMLString rangeOfString:@"<title>Test - Release Notes</title>"].location != NSNotFound);
    XCTAssertTrue([HTMLString rangeOfString:@"<h1>Test Release Notes</h1>"].location != NSNotFound);

    XCTAssertTrue([HTMLString rangeOfString:@"<h2>v1.0</h2>"].location != NSNotFound);
    XCTAssertTrue([HTMLString rangeOfString:@"<li class=\"major\">Item A</li>"].location != NSNotFound);
    XCTAssertTrue([HTMLString rangeOfString:@"<li>Item B</li>"].location != NSNotFound);

    XCTAssertTrue([HTMLString rangeOfString:@"<h3>v1.0.1</h3>"].location != NSNotFound,
                  @"minor updates (x.x.N) should have a level 3 header");
}

@end
