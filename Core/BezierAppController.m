#import "BezierAppController.h"
#import "BezierDocument.h"
#import "BezierView.h"
#import "AccessoryViewController.h"

@implementation BezierAppController

- (void)dealloc {
	[_accessoryViewController release], _accessoryViewController = nil;
	[super dealloc];
}

- (void)awakeFromNib
{
	NSString *lastDocument = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastDocument"];
	BOOL isDirectory = FALSE;
	if([[NSFileManager defaultManager] fileExistsAtPath:lastDocument isDirectory:&isDirectory] && !isDirectory) {
		NSURL *documentURL = [NSURL fileURLWithPath:lastDocument];
		if(documentURL)
			[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:documentURL display:TRUE error:nil];
	} else
		[[NSDocumentController sharedDocumentController] openDocument:self];
}

#pragma mark -
#pragma mark IBAction methods
- (IBAction)export:(id)sender {
	
	BezierDocument *document = [[NSDocumentController sharedDocumentController] currentDocument];
	NSWindow *window = [document windowForSheet];
	
	NSSavePanel *panel = [NSSavePanel savePanel];
	[panel setNameFieldLabel:@"Export As:"];
	[panel setCanCreateDirectories:YES];
	[panel setAllowedFileTypes:[NSArray arrayWithObjects:@"png", @"pdf", nil]];
	if (!_accessoryViewController) {
		_accessoryViewController = [[AccessoryViewController alloc] initWithNibName:@"Save Panel Accessory View" bundle:nil];
	}
	[panel setAccessoryView:_accessoryViewController.view];
	
	[panel beginSheetModalForWindow:window completionHandler:
	 
	 ^(NSInteger result) {
		
		if (result == NSFileHandlingPanelOKButton) {
			
			NSString *path = [[panel filename] stringByDeletingPathExtension];

			BezierView *view = document.bezierView;
			NSData *data = [view dataWithPDFInsideRect:view.bounds];
			
			// PDF
			if ([[_accessoryViewController selectedFormat] isEqualToString:@"PDF"]) {
				
				path = [path stringByAppendingPathExtension:@"pdf"];
				
				[data writeToFile:path atomically:YES];
			}
			// PNG
			else if ([[_accessoryViewController selectedFormat] isEqualToString:@"PNG"]) {
				
				path = [path stringByAppendingPathExtension:@"png"];
				
				// create an image representation of the pdf data
				NSImage *image = [[[NSImage alloc] initWithData:data] autorelease];
				CGImageRef imageRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
				
				// create a CGImageDestinationRef instance
				CFURLRef pathURL = (CFURLRef)[NSURL fileURLWithPath:path];
				CFStringRef uti = (CFStringRef)@"public.png";
				CGImageDestinationRef destination = CGImageDestinationCreateWithURL(pathURL, uti, 1, NULL);
				// write it to the path specified
				CGImageDestinationAddImage(destination, imageRef, NULL);
				CGImageDestinationFinalize(destination);
				CFRelease(destination);
			}
		}
	}];
}

@end
