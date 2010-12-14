#import <WebKit/WebKit.h>
#import "AJKFileSystemObserverDelegate.h"

@class BezierView, AJKPlugin, AJKFileSystemObserver;


@interface BezierDocument : NSDocument <AJKFileSystemObserverDelegate> {
	BezierView *bezierView;
	IBOutlet NSSplitView *splitView;
	IBOutlet WebView *consoleView;
	
	NSURL *fileURL, *directoryURL;
	NSString *consoleHTMLTemplate;
	AJKPlugin *plugin;
	AJKFileSystemObserver *fileSystemObserver;
}

@property (assign) IBOutlet BezierView *bezierView;
@property (assign) NSURL *fileURL;
@property (assign) AJKPlugin *plugin;


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
- (IBAction)refreshConsoleView:(id)sender;
//- (IBAction)clearConsole:(id)sender;

// File system observation
- (void)fileSystemDidChange:(NSArray *)change observer:(AJKFileSystemObserver *)fileSystemObserver;

@end
