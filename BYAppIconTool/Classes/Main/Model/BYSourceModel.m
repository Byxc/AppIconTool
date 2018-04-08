//
//  BYSourceModel.m
//  BYAppIconTool
//
//  Created by 白云 on 2017/11/19.
//  Copyright © 2017年 byxc. All rights reserved.
//

#import "BYSourceModel.h"
#import "BYImageInfoModel.h"
#import "NSImage+BYAddition.h"

@interface BYSourceModel()

@property(nonatomic,strong)NSArray<BYImageInfoModel *> *resultArr;

@end

@implementation BYSourceModel

- (instancetype)init {
    if (self = [super init]) {
        self.doubleSize = YES;
        self.tripleSize = YES;
        [self.devices addObject:DEVICE_IPHONE_KEY];
    }
    return self;
}

- (void)outputImage {
    _resultArr = [BYImageInfoModel modelsWithString:self.infoString];
    for (BYImageInfoModel *model in _resultArr) {
        if ([self.originalImage writePNGWithImageName:model.imageName imageSize:model.size radius:_radius scale:0 savePath:self.savePath]) {
            NSLog(@"%@-写入成功",model.imageName);
        }
        else {
            NSLog(@"%@-写入失败",model.imageName);
        }
        if (self.doubleSize) {
            if ([self.originalImage writePNGWithImageName:[NSString stringWithFormat:@"%@@2x",model.imageName] imageSize:model.size radius:_radius scale:2 savePath:self.savePath]) {
                NSLog(@"%@@2x-写入成功",model.imageName);
            }
            else {
                NSLog(@"%@@2x-写入失败",model.imageName);
            }
        }
        if (self.tripleSize) {
            if ([self.originalImage writePNGWithImageName:[NSString stringWithFormat:@"%@@3x",model.imageName] imageSize:model.size radius:_radius scale:3 savePath:self.savePath]) {
                NSLog(@"%@@3x-写入成功",model.imageName);
            }
            else {
                NSLog(@"%@@3x-写入失败",model.imageName);
            }
        }
    }
}

- (NSArray *)deviceInfoArrayWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Source" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    return dict[name];
}

#pragma mark - Setter
- (void)setSourceURL:(NSURL *)sourceURL {
    _sourceURL = sourceURL;
    // 刷新
    _originalImage = nil;
}

#pragma mark - Getter
- (NSImage *)originalImage {
    if (!_originalImage) {
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:_sourceURL];
        _originalImage = [image resizeWithSize:image.size radius:_radius];
    }
    return _originalImage;
}

- (NSString *)infoString {
    if (_infoString == nil) {
        NSMutableArray *deviceArrM = [NSMutableArray array];
        for (NSString *name in _devices) {
            NSArray *deviceArr = [self deviceInfoArrayWithName:name];
            for (NSString *sizeStr in deviceArr) {
                if (![deviceArrM containsObject:sizeStr]) {
                    [deviceArrM addObject:sizeStr];
                }
            }
        }
        _infoString = [deviceArrM componentsJoinedByString:@","];
    }
    return _infoString;
}

- (NSMutableSet *)devices {
    if (!_devices) {
        _devices = [NSMutableSet set];
    }
    return _devices;
}

- (NSString *)savePath {
    _savePath = [[NSUserDefaults standardUserDefaults] objectForKey:@"savePath"];
    return _savePath ? _savePath:@"";
}

@end
