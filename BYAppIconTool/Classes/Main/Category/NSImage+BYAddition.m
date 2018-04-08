//
//  NSImage+BYAddition.m
//  BYAppIconTool
//
//  Created by 白云 on 2017/11/19.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import "NSImage+BYAddition.h"

@implementation NSImage (BYAddition)

- (NSImage *)resizeWithSize:(NSSize)size radius:(CGFloat)radius {
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    // 创建空图片
    NSImage *returnImage = [[NSImage alloc] initWithSize:size];
    // 锁定到该图片对象，创建图片处理所需环境
    [returnImage lockFocus];
    // 设置背景颜色
    [[NSColor whiteColor] set];
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, imageW, imageH) xRadius:0 yRadius:0];
    [bgPath fill];
    // 创建圆角的贝塞尔路径
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, imageW, imageH) xRadius:imageW*radius yRadius:imageH*radius];
    // 使用贝塞尔路径进行裁剪
    [bezierPath addClip];
    // 绘制图片
    [self drawInRect:NSMakeRect(0, 0, imageW, imageH) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    // 取消图片对象锁定
    [returnImage unlockFocus];
    return returnImage;
}

- (BOOL)writePNGWithImageName:(NSString *)imageName savePath:(NSString *)savePath {
    return [self writePNGWithImageName:imageName imageSize:self.size radius:0 scale:1 savePath:savePath];
}

- (BOOL)writePNGWithImageName:(NSString *)imageName imageSize:(NSSize)imageSize radius:(CGFloat)radius scale:(CGFloat)scale savePath:(NSString *)savePath {
    NSString *folderPath = [NSString stringWithFormat:@"%@/resultIcon",savePath];
    // 检查文件目录是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"创建文件目录失败:%@",error);
            return NO;
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@.png",folderPath,imageName];
    CGFloat imageScale = scale==0 ? 1:scale;
    
    NSSize size = NSMakeSize(imageSize.width*imageScale, imageSize.height*imageScale);
    // 调整NSImage对象大小
    NSImage *rusultImage = [self resizeWithSize:size radius:radius];
    
    //    NSData *outputData = [[NSBitmapImageRep imageRepWithData:data] representationUsingType:NSPNGFileType properties:@{}];
    // 创建NSBitmapImageRep对象(从位图数据渲染图像，支持GIF, JPEG, TIFF, PNG及原始位图数据的各种排列数据格式)
    NSBitmapImageRep *newRep = [rusultImage unscaledBitmapImageRep];
    // 禁用透明
    newRep.alpha = NO;
    // 获取NSData对象
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:@{}];
    // 使用NSData对象进行写入
    return [pngData writeToFile:path atomically:YES];
}

/**
 获取无缩放的NSBitmapImageRep对象

 @return NSBitmapImageRep对象
 */
- (NSBitmapImageRep *)unscaledBitmapImageRep {
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL // 缓存区地址
                             pixelsWide:self.size.width    //
                             pixelsHigh:self.size.height
                             bitsPerSample:8       // 一个像素的比特数
                             samplesPerPixel:4     // 每个像素的样本
                             hasAlpha:YES          // 是否使用组件相乘
                             isPlanar:NO           //是否使用独立通道
                             colorSpaceName:NSDeviceRGBColorSpace // 数据解析方式
                             bytesPerRow:0         // 在每个数据平面内为每个扫描线分配的字节数。
                             bitsPerPixel:0];      // 每一个像素的数据中实际分配位数,如果您为这个参数指定了0，那么这个对象将使用bps和spp参数中的值来解释每个像素的比特数。
    // 保存图形上下文状态
    [NSGraphicsContext saveGraphicsState];
    // 设置当前图形上下文
    [NSGraphicsContext setCurrentContext:
     // 从NSBitmapImageRep对象快速设置图形上下文
    [NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    // 重绘制NSBitmapImageRep对象
    [self drawAtPoint:NSMakePoint(0, 0)
              fromRect:NSZeroRect
             operation:NSCompositeSourceOver
              fraction:1.0];
    // 恢复图形上下文状态
    [NSGraphicsContext restoreGraphicsState];
    return rep;
}

@end
