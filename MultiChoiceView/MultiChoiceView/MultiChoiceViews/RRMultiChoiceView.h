//
//  RRMultiChoiceView.h
//  MultiChoiceView
//
//  选择器控件
//
//  Created by JerryLiu on 2020/4/4.
//  Copyright © 2020 JerryLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RRMultiChoiceViewDelegate <NSObject>

- (void)itemImageDidClicked:(NSInteger)index;

@end

@interface RRMultiChoiceView : UIView

@property (nonatomic, weak) id<RRMultiChoiceViewDelegate> clickDelegate;

//用户是否已经做出了选择
@property (nonatomic, assign) BOOL userHasChoose;

/**
 初始化方法
 
 @param frame frame
 @param imagesArray 图片集合
 @param chooseToolImage 选择器图片
 @return NTESNBStartupMultiChoiceAdView 返回双选View
 */
- (instancetype)initWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray chooseToolImage:(UIImage *)chooseToolImage;

/**
 复原操作
 */
- (void)recoveryOriUILayout;

@end

NS_ASSUME_NONNULL_END
