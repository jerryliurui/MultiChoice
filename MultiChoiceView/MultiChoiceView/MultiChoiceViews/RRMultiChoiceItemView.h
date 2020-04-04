//
//  RRMultiChoiceItemView.h
//  MultiChoiceView
//
//  选择器单项选择item
//
//  Created by JerryLiu on 2020/4/4.
//  Copyright © 2020 JerryLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRMultiChoiceItemView : UIView

/**
 初始化方法
 
 @param imageSize 图片的实际大小
 @param itemImage 图片
 @return RRMultiChoiceItemView 某一个选项View
 */
- (instancetype)initWithImageSize:(CGSize)imageSize withItemImage:(UIImage *)itemImage;

@end

NS_ASSUME_NONNULL_END
