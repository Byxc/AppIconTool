//
//  ImageSelectViewController.m
//  BYAppIconTool
//
//  Created by fuyoufang on 2017/10/11.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import "BYImageSelectViewController.h"
#import "BYDragDropView.h"
#import "BYSourceModel.h"
#import "NSImage+BYAddition.h"

typedef NS_ENUM(NSUInteger, BYDeviceType) {
    BYDeviceTypeIphone = 100,
    BYDeviceTypeIpad,
    BYDeviceTypeAppleWatch,
    BYDeviceTypeMac,
    BYDeviceTypeCustom
};

typedef NS_ENUM(NSUInteger, BYImageInfo) {
    BYImageInfoRadius = 200,
    BYImageInfoDouble,
    BYImageInfoTriple,
};

@interface BYImageSelectViewController ()<BYDragDropViewDelegate>

@property (weak) IBOutlet NSButton *imageButton;
@property (weak) IBOutlet NSButton *radiusButton;
@property (weak) IBOutlet NSButton *doubleButton;
@property (weak) IBOutlet NSButton *tripleButon;
@property (weak) IBOutlet NSButton *selectButton;
@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSButton *pathButton;
@property (weak) IBOutlet NSTextField *propertyTextField;
@property (weak) IBOutlet NSButton *iPhoneButton;
@property (weak) IBOutlet NSButton *iPadButton;
@property (weak) IBOutlet NSButton *appWatchButton;
@property (weak) IBOutlet NSButton *macButton;
@property (weak) IBOutlet NSButton *customButton;
@property(nonatomic,strong)BYSourceModel *sourceModel;

@end

@implementation BYImageSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOfView];
    [self updateViewShow];
}

- (void)setOfView {
    /// 设置拖拽视图
    BYDragDropView *view    = (BYDragDropView *)self.view;
    view.delegate           = self;
    
    // 设置图片按钮不使用按钮高亮
    [(NSButtonCell *)self.imageButton.cell setHighlightsBy:NSNoCellMask];
}

- (void)updateViewShow {
    // 设置属性按钮状态
    self.radiusButton.state = self.sourceModel.radius != 0 ? NSControlStateValueOn:NSControlStateValueOff;
    self.doubleButton.state = self.sourceModel.doubleSize ? NSControlStateValueOn:NSControlStateValueOff;
    self.tripleButon.state = self.sourceModel.tripleSize ? NSControlStateValueOn:NSControlStateValueOff;
    self.propertyTextField.stringValue = self.sourceModel.infoString;
    self.iPhoneButton.state = NSControlStateValueOff;
    self.iPadButton.state = NSControlStateValueOff;
    self.appWatchButton.state = NSControlStateValueOff;
    self.macButton.state = NSControlStateValueOff;
    for (NSString *deviceStr in self.sourceModel.devices) {
        if ([deviceStr isEqualToString:DEVICE_IPHONE_KEY]) {
            self.iPhoneButton.state = NSControlStateValueOn;
        }
        if ([deviceStr isEqualToString:DEVICE_IPAD_KEY]) {
            self.iPadButton.state = NSControlStateValueOn;
        }
        if ([deviceStr isEqualToString:DEVICE_APPLEWATCH_KEY]) {
            self.appWatchButton.state = NSControlStateValueOn;
        }
        if ([deviceStr isEqualToString:DEVICE_MAC_KEY]) {
            self.macButton.state = NSControlStateValueOn;
        }
    }
    self.pathTextField.stringValue = self.sourceModel.savePath;
}

- (void)updateImageURL:(NSURL *)imageURL {
    // 更新资源地址
    self.sourceModel.sourceURL = imageURL;
    // 更新界面显示
    self.imageButton.image = self.sourceModel.originalImage;
}

#pragma mark - Open File Explorer
- (void)openFileExplorer {
    // 使用NSOpenPanel组件选取图片文件
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];          // 设置可选择文件
    [panel setCanChooseDirectories:NO];     // 设置不可选择目录
    [panel setAllowsMultipleSelection:NO];  // 设置不允许使用多选
    NSArray *fileType = @[
                          @"png",
                          @"jpg",
                          @"jpeg",
                          @"gif",
                          ];
    [panel setAllowedFileTypes:fileType];   // 设置允许使用的文件类型
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        [self updateImageURL:[panel URL]];  // 选择图片后更新源图片的资源地址
    }
}

#pragma mark - BYDragDropViewDelegate
- (void)disposeDragingFiles:(NSArray *)files {
    // 获取拖拽入的图片资源地址并进行更新
    [self updateImageURL:[NSURL fileURLWithPath:files.firstObject]];
}

#pragma mark - Action
- (IBAction)openFileExplorerAction:(id)sender {
    // 打开文件选取器
    [self openFileExplorer];
}

- (IBAction)cornerRadiusButtonClickAction:(NSButton *)sender {
    switch (sender.tag) {
        case BYImageInfoRadius:
            // 是否启用圆角
            _sourceModel.radius = sender.state == NSControlStateValueOn ? 0.125:0;
            break;
        case BYImageInfoDouble:
            // 是否启用2x图
            self.sourceModel.doubleSize = sender.state == NSControlStateValueOn ? YES:NO;
            break;
        case BYImageInfoTriple:
            // 是否使用3x图
            self.sourceModel.tripleSize = sender.state == NSControlStateValueOn ? YES:NO;
            break;
    }
}

- (IBAction)pathButtonClickAction:(id)sender {
    // 使用NSOpenPanel组件选取保存路径
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];           // 不可选取文件
    [panel setCanChooseDirectories:YES];    // 开启文件夹选取
    [panel setAllowsMultipleSelection:NO];  // 禁止多选
    
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        // 更新保存路径
        self.sourceModel.savePath = [panel URL].path;
        // 更新界面显示
        self.pathTextField.stringValue = self.sourceModel.savePath;
        // 使用偏好设置保存路径地址
        [[NSUserDefaults standardUserDefaults] setObject:self.sourceModel.savePath  forKey:@"savePath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



- (IBAction)typeButtonClickAction:(NSButton *)sender {
    // 更新平台设置
    NSString *deviceName = nil;
    if (sender.tag == BYDeviceTypeIphone) {
        deviceName = DEVICE_IPHONE_KEY;
    }
    else if (sender.tag == BYDeviceTypeIpad) {
        deviceName = DEVICE_IPAD_KEY;
    }
    else if (sender.tag == BYDeviceTypeAppleWatch) {
        deviceName = DEVICE_APPLEWATCH_KEY;
    }
    else if (sender.tag == BYDeviceTypeMac) {
        deviceName = DEVICE_MAC_KEY;
    }
    if (sender.state == NSControlStateValueOn) {
        [self.sourceModel.devices addObject:deviceName];
    }
    else {
        [self.sourceModel.devices removeObject:deviceName];
    }
    // 强制刷新属性字符串(懒加载)
    self.sourceModel.infoString = nil;
    // 更新视图显示
    [self updateViewShow];
}

- (IBAction)customButtonClickAction:(NSButton *)sender {
    // 是否开启自定义输入(是否允许文本框输入)
    self.propertyTextField.enabled = sender.state == NSControlStateValueOn;
}

- (IBAction)sureButtonClickAction:(id)sender {
    // 检查参数完整性
    if (!self.sourceModel.sourceURL) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"请选择图片";
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
        return;
    }
    if (!self.sourceModel.savePath) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"请选选择保存路径";
        [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
        return;
    }
    else {
        // 更新属性字符串
        self.sourceModel.infoString = self.propertyTextField.stringValue;
        // 根据设置输出并保存文件
        [self.sourceModel outputImage];
        // 打开保存的路径文件夹，方便查看输出结果
        [[NSWorkspace sharedWorkspace] openFile:[NSString stringWithFormat:@"%@/resultIcon",self.sourceModel.savePath]];
    }
}

#pragma mark - Getter
- (BYSourceModel *)sourceModel {
    if (!_sourceModel) {
        _sourceModel = [BYSourceModel new];
    }
    return _sourceModel;
}

@end
