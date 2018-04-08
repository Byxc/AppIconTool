//
//  BYSourceModel.h
//  BYAppIconTool
//
//  Created by 白云 on 2017/11/19.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DEVICE_IPHONE_KEY @"iPhone"
#define DEVICE_IPAD_KEY @"iPad"
#define DEVICE_APPLEWATCH_KEY @"AppleWatch"
#define DEVICE_MAC_KEY @"Mac"

@interface BYSourceModel : NSObject

@property(nonatomic,copy)NSURL *sourceURL;          // 图片地址
@property(nonatomic,strong)NSImage *originalImage;  // 载入的原图
@property(nonatomic,copy)NSString *infoString;      // 属性字符串
@property(nonatomic,strong)NSMutableSet *devices;   // 设备类型集合
@property(nonatomic,assign)CGFloat radius;          // 圆角大小
@property(nonatomic,assign)BOOL doubleSize;         // 2x图
@property(nonatomic,assign)BOOL tripleSize;         // 3x图
@property(nonatomic,copy)NSString *savePath;        // 保存路径

/**
 输出图片到指定路径
 */
- (void)outputImage;

@end
