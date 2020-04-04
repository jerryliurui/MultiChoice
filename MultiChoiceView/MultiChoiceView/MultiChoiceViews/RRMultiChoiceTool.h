//
//  RRMultiChoiceTool.h
//  MultiChoiceView
//
//  选择器工具
//
//  Created by JerryLiu on 2020/4/4.
//  Copyright © 2020 JerryLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRMultiChoiceTool : UIView

/**
 初始化方法
 
 @param chooseImage 图片
 @return RRMultiChoiceTool 选择器View
 */
- (instancetype)initWithChooseImage:(UIImage *)chooseImage;

@end

NS_ASSUME_NONNULL_END
