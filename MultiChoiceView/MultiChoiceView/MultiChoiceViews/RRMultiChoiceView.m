//
//  RRMultiChoiceView.m
//  MultiChoiceView
//
//  Created by JerryLiu on 2020/4/4.
//  Copyright © 2020 JerryLiu. All rights reserved.
//

#import "RRMultiChoiceView.h"
#import "RRCommonDefine.h"
#import "RRMultiChoiceTool.h"
#import "RRMultiChoiceItemView.h"
#import <Masonry/Masonry.h>

typedef void(^RRBlock)(void);

@interface RRMultiChoiceView ()<UIGestureRecognizerDelegate>

//UI
@property (nonatomic, strong) RRMultiChoiceItemView *topChoiceImageView;
@property (nonatomic, strong) RRMultiChoiceItemView *bottomChoiceImageView;
@property (nonatomic, strong) RRMultiChoiceTool *choiceTool;

//Data
@property (nonatomic, strong) NSMutableArray<RRMultiChoiceItemView *> *itemArray;
@property (nonatomic, copy) NSArray<UIImage *> *imagesArray;
@property (nonatomic, strong) UIImage *chooseToolImage;
@property (nonatomic, assign) CGSize currentSize;
@property (nonatomic, assign) BOOL recoveryingTool;
@property (nonatomic, assign) CGFloat chooseToolHeight;

@end

@implementation RRMultiChoiceView

- (instancetype)initWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray chooseToolImage:(UIImage *)chooseToolImage {
    self = [super initWithFrame:frame];
    if (self) {
        _itemArray = [NSMutableArray new];
        _imagesArray = imagesArray;
        _chooseToolImage = chooseToolImage;
        _currentSize = frame.size;
        _chooseToolHeight = frame.size.width * kRRMultiChoiceAdChooseToolRatio;
        self.clipsToBounds = YES;
        [self setupBaseViews];
        [self addGesture];
    }
    return self;
}

- (void)setupBaseViews {
    [self addSubview:self.topChoiceImageView];
    [self addSubview:self.bottomChoiceImageView];
    [self addSubview:self.choiceTool];
    
    [_itemArray addObject:_topChoiceImageView];
    [_itemArray addObject:_bottomChoiceImageView];
    
    [_choiceTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(@(self.chooseToolHeight));
    }];
    
    [_topChoiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.bottom.equalTo(self.choiceTool.mas_centerY);
    }];
    
    [_bottomChoiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.top.equalTo(self.choiceTool.mas_centerY);
    }];
}

- (void)addGesture {
    UIPanGestureRecognizer *choosePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(choosing:)];
    choosePan.delegate = self;
    [self addGestureRecognizer:choosePan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)choosing:(UIPanGestureRecognizer *)pan {
    UIGestureRecognizerState state = [pan state];
    if (state == UIGestureRecognizerStateChanged) {
        CGFloat currentGestureY = [pan translationInView:self].y;
        CGFloat currentY = self.choiceTool.frame.origin.y;
        currentY += currentGestureY;
        [self chooseToolDidPaned:currentY];
        [pan setTranslation:CGPointZero inView:self];
    } else if (state == UIGestureRecognizerStateEnded ||
               state == UIGestureRecognizerStateCancelled){
        [self chooseToolDidEndGesture];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    if (CGRectContainsPoint(self.topChoiceImageView.frame, point)) {
        [self chooseToolDidClicked:YES];
    } else if (CGRectContainsPoint(self.bottomChoiceImageView.frame, point)) {
        [self chooseToolDidClicked:NO];
    }
}

- (RRMultiChoiceItemView *)topChoiceImageView {
    if (!_topChoiceImageView) {
        _topChoiceImageView = [[RRMultiChoiceItemView alloc] initWithImageSize:_currentSize withItemImage:[self configItemImageWithIndex:0]];
        _topChoiceImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _topChoiceImageView;
}

- (RRMultiChoiceItemView *)bottomChoiceImageView {
    if (!_bottomChoiceImageView) {
        _bottomChoiceImageView = [[RRMultiChoiceItemView alloc] initWithImageSize:_currentSize withItemImage:[self configItemImageWithIndex:1]];
        _bottomChoiceImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bottomChoiceImageView;
}

- (RRMultiChoiceTool *)choiceTool {
    if (!_choiceTool) {
        _choiceTool = [[RRMultiChoiceTool alloc] initWithChooseImage:_chooseToolImage];
        _choiceTool.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _choiceTool;
}

- (UIImage *)configItemImageWithIndex:(NSInteger)index {
    if (!_imagesArray) {
        return nil;
    }
    
    if (index >= 0 && index < _imagesArray.count) {
        return [_imagesArray objectAtIndex:index];
    }
    
    return nil;
}

//重新恢复初始布局
- (void)recoveryOriUILayout {
    _userHasChoose = NO;
    _recoveryingTool = NO;
    [_choiceTool mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(@(self.chooseToolHeight));
    }];
    
    [_topChoiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.bottom.equalTo(self.choiceTool.mas_centerY);
    }];
    
    [_bottomChoiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.top.equalTo(self.choiceTool.mas_centerY);
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - HelpFunc

- (void)triggerAdDetailWithIndex:(NSInteger)index {
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(itemImageDidClicked:)]) {
        [self.clickDelegate itemImageDidClicked:index];
    }
}

- (void)chooseToolDidClicked:(BOOL)up {
    __weak typeof(self) ws = self;
    if (up) {
        [self showUnfoldAnimationWithUpDirection:NO withCompletionBlock:^{
            [ws triggerAdDetailWithIndex:kFirstImageIndex];
        }];
    } else {
        [self showUnfoldAnimationWithUpDirection:YES withCompletionBlock:^{
            [ws triggerAdDetailWithIndex:kSecondImageIndex];
        }];
    }
}

- (void)chooseToolDidPaned:(CGFloat)currentY {
    if (!_choiceTool || _recoveryingTool) {
        return;
    }
    
    CGFloat maxTop = self.frame.size.height/2 - kMaxChoiceToolViewMoveValue - _chooseToolHeight/2;
    CGFloat masBottom = self.frame.size.height/2 + kMaxChoiceToolViewMoveValue - _chooseToolHeight/2;
    
    //最上可以移动到的地方
    if (currentY <= -_chooseToolHeight) {
        return;
    }
    
    //最下可以移动到的地方
    if (currentY >= self.frame.size.height) {
        return;
    }
    
    if (currentY <= maxTop) {
        //展开动画+触发进落地页-下方素材的落地页
        [self showUnfoldAnimationWithUpDirection:YES withCompletionBlock:^{
            [self triggerAdDetailWithIndex:kSecondImageIndex];
        }];
    } else if (currentY >= masBottom) {
        //展开动画+触发进落地页-上方素材的落地页
        [self showUnfoldAnimationWithUpDirection:NO withCompletionBlock:^{
            [self triggerAdDetailWithIndex:kFirstImageIndex];
        }];
    } else {
        [_choiceTool mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(currentY);
            make.height.equalTo(@(self.chooseToolHeight));
        }];
        [self layoutIfNeeded];
    }
}

- (void)chooseToolDidEndGesture {
    if (!_choiceTool || _recoveryingTool) {
        return;
    }
    
    CGFloat maxTop = self.frame.size.height/2 - kMaxChoiceToolViewMoveValue - _chooseToolHeight/2;
    CGFloat masBottom = self.frame.size.height/2 + kMaxChoiceToolViewMoveValue - _chooseToolHeight/2;
    
    if (_choiceTool.frame.origin.y > maxTop && _choiceTool.frame.origin.y < masBottom) {
        [self recoveryToolAnimation];
    } else if (_choiceTool.frame.origin.y <= maxTop) {
        //展开动画+触发进落地页-下方素材的落地页
        [self showUnfoldAnimationWithUpDirection:YES withCompletionBlock:^{
            [self triggerAdDetailWithIndex:kSecondImageIndex];
        }];
    } else if (_choiceTool.frame.origin.y >= masBottom) {
        //展开动画+触发进落地页-上方素材的落地页
        [self showUnfoldAnimationWithUpDirection:NO withCompletionBlock:^{
            [self triggerAdDetailWithIndex:kFirstImageIndex];
        }];
    }
}

- (void)recoveryToolAnimation {
    if (_recoveryingTool) {
        return;
    }
    _recoveryingTool = YES;
    [UIView animateWithDuration:0.1 animations:^{
        [_choiceTool mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.centerY.equalTo(self);
            make.height.equalTo(@(_chooseToolHeight));
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _recoveryingTool = NO;
    }];
}

//展开动画
- (void)showUnfoldAnimationWithUpDirection:(BOOL)up withCompletionBlock:(RRBlock)completionBlock {
    if (_userHasChoose) {
        return;
    }

    _userHasChoose = YES;
    if (up) {
        [UIView animateWithDuration:0.29 animations:^{
            [_choiceTool mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.centerY.equalTo(self).offset(-self.frame.size.height/2).priorityHigh();
                make.height.equalTo(@(_chooseToolHeight));
            }];
            [self layoutIfNeeded];
        }];
        
        [UIView animateWithDuration:0.01 delay:0.29 options:UIViewAnimationOptionCurveLinear animations:^{
            [_choiceTool mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.centerY.equalTo(self).offset(-self.frame.size.height/2 - _chooseToolHeight/2).priorityHigh();
                make.height.equalTo(@(_chooseToolHeight));
            }];
            
            [_topChoiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.equalTo(self);
                make.bottom.equalTo(self.mas_top);
            }];
            
            [_bottomChoiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.left.equalTo(self);
                make.top.equalTo(self.mas_top);
            }];
            
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completionBlock) {
                completionBlock();
            }
        }];
    } else {
        [UIView animateWithDuration:0.29 animations:^{
            [_choiceTool mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.centerY.equalTo(self).offset(self.frame.size.height/2).priorityHigh();
                make.height.equalTo(@(_chooseToolHeight));
            }];
            [self layoutIfNeeded];
        }];
        
        [UIView animateWithDuration:0.01 delay:0.29 options:UIViewAnimationOptionCurveLinear animations:^{
            [_choiceTool mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.centerY.equalTo(self).offset(self.frame.size.height/2 + _chooseToolHeight/2).priorityHigh();
                make.height.equalTo(@(_chooseToolHeight));
            }];
            
            [_topChoiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.equalTo(self);
                make.bottom.equalTo(self.mas_bottom);
            }];
            
            [_bottomChoiceImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.left.equalTo(self);
                make.top.equalTo(self.mas_bottom);
            }];
            
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completionBlock) {
                completionBlock();
            }
        }];
    }
}

@end
