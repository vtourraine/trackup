//
//  TrackupExporter.m
//  trackup
//
//  Created by Vincent Tourraine on 14/02/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

#import "TrackupExporter.h"

#import "TrackupDocument.h"


@implementation TrackupExporter

- (NSString *)HTMLStringFromDocument:(TrackupDocument *)document {
    NSMutableArray *versionsStrings = [NSMutableArray array];
    for (TrackupVersion *version in document.versions) {
        NSMutableArray *itemsStrings = [NSMutableArray array];
        for (TrackupItem *item in version.items) {
            [itemsStrings addObject:
             [NSString stringWithFormat:
              @"        <li>%@</li>\n", item.title]];
        }

        [versionsStrings addObject:
         [NSString stringWithFormat:
          @"    <section>\n"
          @"      <h2>%@</h2>\n"
          @"      <ul>\n"
          @"        %@\n"
          @"      </ul>\n"
          @"    </section>\n",
          version.title,
          [itemsStrings componentsJoinedByString:@""]]];
    }

    return [NSString stringWithFormat:
            @"<html>\n"
            @"  <head>\n"
            @"    <title>%@</title>\n"
            @"  </head>\n"
            @"  <body>\n"
            @"    <h1>%@</h1>\n"
            @"    %@\n"
            @"  </body>\n"
            @"</html>",
            document.title,
            document.title,
            [versionsStrings componentsJoinedByString:@""]];
}

@end
