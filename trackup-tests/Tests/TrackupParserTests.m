//
//  TrackupParserTests.m
//  trackup
//
//  Created by Vincent Tourraine on 14/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

@import XCTest;

#import "TrackupParser.h"
#import "TrackupDocument.h"

@interface TrackupParserTests : XCTestCase

@property (strong) TrackupParser *parser;

@end


@implementation TrackupParserTests

- (void)setUp {
    [super setUp];
    self.parser = [TrackupParser new];
}

- (void)tearDown {
    self.parser = nil;
    [super tearDown];
}


- (void)testParseTitle {
    NSString *string =
    @"# Test\n"
    @"\n"
    @"qwerty...";

    TrackupDocument *document = [self.parser documentFromString:string];
    XCTAssertEqualObjects(document.title, @"Test");
}

- (void)testParseVersion {
    NSString *string =
    @"## v1.2\n"
    @"\n"
    @"2015-01-20\n"
    @"\n"
    @"- Thing A\n"
    @"- Thing B\n"
    @"";

    TrackupDocument *document = [self.parser documentFromString:string];
    XCTAssertEqual(document.versions.count, 1);

    TrackupVersion *version = document.versions.firstObject;
    XCTAssertEqualObjects(version.title, @"v1.2");

    XCTAssertEqual(version.dateComponents.year,  2015);
    XCTAssertEqual(version.dateComponents.month, 1);
    XCTAssertEqual(version.dateComponents.day,   20);
}

- (void)testParseItems {
    NSString *string =
    @"## v1.2\n"
    @"\n"
    @"- Thing A\n"
    @"- Thing B\n"
    @"";

    TrackupDocument *document = [self.parser documentFromString:string];
    TrackupVersion *version = document.versions.firstObject;
    XCTAssertEqual(version.items.count, 2);

    TrackupItem *item1 = version.items[0];
    XCTAssertEqualObjects(item1.title, @"Thing A");
    TrackupItem *item2 = version.items[1];
    XCTAssertEqualObjects(item2.title, @"Thing B");
}

@end
