//
//  RRMultiChoiceTool.m
//  MultiChoiceView
//
//  Created by JerryLiu on 2020/4/4.
//  Copyright © 2020 JerryLiu. All rights reserved.
//

#import "RRMultiChoiceTool.h"
#import <Masonry/Masonry.h>

@interface RRMultiChoiceTool ()

@property (nonatomic, strong) UIImage *chooseImage;
@property (nonatomic, strong) UIImageView *chooseImageView;

@end

@interface RRMultiChoiceTool ()

@end

@implementation RRMultiChoiceTool

- (instancetype)initWithChooseImage:(UIImage *)chooseImage {
    self = [super init];
    if (self) {
        _chooseImage = chooseImage;
        self.userInteractionEnabled = YES;
        [self setupBaseViews];
    }
    return self;
}

- (void)setupBaseViews {
    [self addSubview:self.chooseImageView];
    [_chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UIImageView *)chooseImageView {
    if (!_chooseImageView) {
        _chooseImageView = [UIImageView new];
        _chooseImageView.userInteractionEnabled = YES;
        [_chooseImageView setImage:_chooseImage];
    }
    return _chooseImageView;
}

@end
