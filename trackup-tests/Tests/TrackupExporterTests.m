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

    TrackupVersion *version = [TrackupVersion new];
    version.title = @"v1";
    TrackupItem *itemA = [TrackupItem new];
    itemA.title = @"Item A";
    TrackupItem *itemB = [TrackupItem new];
    itemB.title = @"Item B";
    version.items = @[itemA, itemB];
    document.versions = @[version];

    NSString *HTMLString = [self.exporter HTMLStringFromDocument:document];
    XCTAssertTrue([HTMLString containsString:@"<title>Test Changelog</title>"]);
    XCTAssertTrue([HTMLString containsString:@"<h1>Test Changelog</h1>"]);

    XCTAssertTrue([HTMLString containsString:@"<h2>v1</h2>"]);
    XCTAssertTrue([HTMLString containsString:@"<li>Item A</li>"]);
    XCTAssertTrue([HTMLString containsString:@"<li>Item B</li>"]);
}

@end
