//
//  BYImageInfoModel.h
//  BYAppIconTool
//
//  Created by 白云 on 2017/11/19.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYImageInfoModel : NSObject

@property(nonatomic,assign)CGFloat width;       // 图片宽度
@property(nonatomic,assign)CGFloat height;      // 图片高度
@property(nonatomic,assign)NSSize size;         // 图片大小
@property(nonatomic,copy)NSString *imageName;   // 图片名

/**
 从字符串解析模型数组

 @param string 字符串
 @return 模型数组
 */
+ (NSArray<BYImageInfoModel *> *)modelsWithString:(NSString *)string;

@end
