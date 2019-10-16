//
//  TrackupDocument.h
//  trackup
//
//  Created by Vincent Tourraine on 01/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

@import Foundation;


@interface TrackupDocument : NSObject

@property (copy) NSString *title;
@property (copy) NSArray *versions;
@property (copy) NSURL *URL;

@end


@interface TrackupVersion : NSObject

@property (copy) NSString *title;
@property (copy) NSArray *items;
@property (copy) NSDateComponents *dateComponents;

@property (readonly, getter=isInProgress) BOOL inProgress;

@end


typedef NS_ENUM(NSUInteger, TrackupItemState) {
    TrackupItemStateUnknown,
    TrackupItemStateTodo,
    TrackupItemStateDone,
};

typedef NS_ENUM(NSUInteger, TrackupItemStatus) {
    TrackupItemStatusUnknown,
    TrackupItemStatusMajor
};

@interface TrackupItem : NSObject

@property (copy) NSString *title;
@property (assign) TrackupItemState state;
@property (assign) TrackupItemStatus status;

@end
