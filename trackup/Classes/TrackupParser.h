//
//  TrackupParser.h
//  trackup
//
//  Created by Vincent Tourraine on 01/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

@import Foundation;

@class TrackupDocument;


@interface TrackupParser : NSObject

- (TrackupDocument *)documentFromString:(NSString *)string;

@end
