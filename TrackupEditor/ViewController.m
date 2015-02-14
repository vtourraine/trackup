//
//  ViewController.m
//  TrackupEditor
//
//  Created by Vincent Tourraine on 30/01/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

#import "ViewController.h"

#import "TrackupDocument.h"
#import "TrackupExporter.h"
#import "TrackupParser.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (IBAction)exportHTML:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[@"html"];
    [savePanel
     beginSheetModalForWindow:self.view.window
     completionHandler:^(NSModalResponse returnCode) {
         if (returnCode == NSModalResponseOK) {
             TrackupParser *parser = [TrackupParser new];
             TrackupDocument *document = [parser documentFromString:[self.representedObject content]];

             TrackupExporter *exporter = [TrackupExporter new];
             NSString *HTMLString = [exporter HTMLStringFromDocument:document];

             [HTMLString writeToURL:savePanel.URL
                         atomically:YES
                           encoding:NSUTF8StringEncoding
                              error:nil];
         }
     }];
}

@end
