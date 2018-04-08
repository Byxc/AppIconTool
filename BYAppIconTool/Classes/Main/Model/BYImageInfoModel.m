//
//  BYImageInfoModel.m
//  BYAppIconTool
//
//  Created by 白云 on 2017/11/19.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import "BYImageInfoModel.h"

@implementation BYImageInfoModel

+ (NSArray<BYImageInfoModel *> *)modelsWithString:(NSString *)string {
    NSMutableArray *modelArrM = [NSMutableArray array];
    NSArray *propertyArr = [string componentsSeparatedByString:@","];
    for (NSString *str in propertyArr) {
        NSArray *sizeArr;
        if ([str containsString:@"x"]) {
            sizeArr = [str componentsSeparatedByString:@"x"];
        }
        else if ([str containsString:@"X"]) {
            sizeArr = [str componentsSeparatedByString:@"X"];
        }
        NSString *sizeXStr = sizeArr.firstObject;
        NSString *sizeYStr = sizeArr.lastObject;
        BYImageInfoModel *model = [BYImageInfoModel new];
        model.width = sizeXStr.floatValue;
        model.height = sizeYStr.floatValue;
        model.size = NSMakeSize(model.width, model.height);
        model.imageName = [NSString stringWithFormat:@"%@x%@",sizeXStr,sizeYStr];
        [modelArrM addObject:model];
    }
    return modelArrM.copy;
}

@end
