//
//  TrackupExporter.h
//  trackup
//
//  Created by Vincent Tourraine on 14/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

@import Foundation;

@class TrackupDocument;


@interface TrackupExporter : NSObject

@property BOOL includeRoadmap;

@property BOOL includeInProgressVersions;

- (NSString *)HTMLStringFromDocument:(TrackupDocument *)document;

@end
