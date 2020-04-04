//
//  ViewController.m
//  MultiChoiceView
//
//  Created by JerryLiu on 2020/4/4.
//  Copyright © 2020 JerryLiu. All rights reserved.
//

#import "ViewController.h"
#import "RRMultiChoiceView.h"

@interface ViewController ()<RRMultiChoiceViewDelegate>

@property (nonatomic, strong) RRMultiChoiceView *multiChoiceView;

@property (nonatomic, assign) CGRect multiChoiceViewFrame;//双选View的Frame
@property (nonatomic, strong) NSArray <UIImage *> *chooseItemImages;//双选素材包集合
@property (nonatomic, strong) UIImage *chooseToolImage;//双选选择器Image

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _multiChoiceViewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UIImage *top = [UIImage imageNamed:@"top"];
    UIImage *bottom = [UIImage imageNamed:@"bottom"];
    UIImage *tool = [UIImage imageNamed:@"tool"];
    
    _chooseItemImages = @[top, bottom];
    _chooseToolImage = tool;
    
    [self.view addSubview:self.multiChoiceView];
}


- (RRMultiChoiceView *)multiChoiceView {
    if (!_multiChoiceView) {
        _multiChoiceView = [[RRMultiChoiceView alloc] initWithFrame:_multiChoiceViewFrame imagesArray:_chooseItemImages chooseToolImage:_chooseToolImage];
        _multiChoiceView.clickDelegate = self;
        _multiChoiceView.userInteractionEnabled = YES;
    }
    return _multiChoiceView;
}

- (void)itemImageDidClicked:(NSInteger)index {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择了" message:[NSString stringWithFormat:@"%li",(long)index] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"GOOD!" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"复原" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_multiChoiceView recoveryOriUILayout];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
