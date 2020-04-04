//
//  RRMultiChoiceItemView.m
//  MultiChoiceView
//
//  Created by JerryLiu on 2020/4/4.
//  Copyright © 2020 JerryLiu. All rights reserved.
//

#import "RRMultiChoiceItemView.h"
#import "RRCommonDefine.h"
#import <Masonry/Masonry.h>

@interface RRMultiChoiceItemView ()

@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation RRMultiChoiceItemView

- (instancetype)initWithImageSize:(CGSize)imageSize withItemImage:(UIImage *)itemImage {
    self = [super init];
    if (self) {
        _itemImage = itemImage;
        _itemSize = imageSize;
        self.clipsToBounds = YES;
        [self setupBaseViews];
    }
    return self;
}

- (void)setupBaseViews {
    [self addSubview:self.itemImageView];
    [_itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_itemSize.width, _itemSize.width * kRRMultiChoiceAdChooseImageRatio));
        make.center.equalTo(self);
    }];
}

- (UIImageView *)itemImageView {
    if (!_itemImageView) {
        _itemImageView = [UIImageView new];
        [_itemImageView setImage:_itemImage];
    }
    return _itemImageView;
}

@end
