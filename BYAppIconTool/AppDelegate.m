//
//  AppDelegate.m
//  BYAppIconTool
//
//  Created by fuyoufang on 2017/10/11.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import "AppDelegate.h"
#import "BYMainWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property(nonatomic, strong)NSWindowController *mainWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // 加载主视图
    [self loadMainView];
    // 添加通知监听窗口关闭
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow:) name:NSWindowWillCloseNotification object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

#pragma mark - Launch
- (void)loadMainView {
    // 从Storyboard中加载主视图
    NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    BYMainWindowController *mainController = (BYMainWindowController *)[mainStoryboard instantiateInitialController];
    _mainWindowController = mainController;
    [mainController showWindow:self.window];
}

#pragma mark - Close
- (void)closeWindow:(NSNotification *)sender {
    // 当主窗口被关闭的时候关闭程序
    if (sender.object == _mainWindowController.window) {
        _mainWindowController = nil;
        [[NSApplication sharedApplication] terminate:nil];
    }
}

@end
