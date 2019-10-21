//
//  ViewController.m
//  TrackupEditor
//
//  Created by Vincent Tourraine on 30/01/15.
//  Copyright (c) 2015 Studio AMANgA. All rights reserved.
//

#import "ViewController.h"
#import "Trackup_Editor-Swift.h"

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
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK) {
            NSString *text = [self.representedObject content];
            [TrackupCoreBridge saveDocumentWithText:text to:savePanel.URL];
        }
    }];
}

@end
