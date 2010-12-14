//
//  BezierSavePanelAccessoryView.h
//  Bezier
//
//  Created by Adam Ko on 14/12/2010.
//  Copyright 2010 Imperial College. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AccessoryViewController : NSViewController {
	IBOutlet NSPopUpButton *button;
}

- (NSString *)selectedFormat;

@end
