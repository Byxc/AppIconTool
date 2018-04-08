//
//  NSImage+BYAddition.h
//  BYAppIconTool
//
//  Created by 白云 on 2017/11/19.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (BYAddition)

/**
 调整Image大小

 @param size Image大小
 @param radius Image圆角
 @return 调整后的Image对象
 */
- (NSImage *)resizeWithSize:(NSSize)size radius:(CGFloat)radius;

/**
 保存Image

 @param imageName Image名
 @param savePath 保存路径
 @return 保存结果
 */
- (BOOL)writePNGWithImageName:(NSString *)imageName savePath:(NSString *)savePath;

/**
 保存Image

 @param imageName Image名
 @param imageSize Image大小
 @param radius Image圆角
 @param scale Image缩放比例(1为原比例)
 @param savePath 保存路径
 @return 保存结果
 */
- (BOOL)writePNGWithImageName:(NSString *)imageName imageSize:(NSSize)imageSize radius:(CGFloat)radius scale:(CGFloat)scale savePath:(NSString *)savePath;

@end
