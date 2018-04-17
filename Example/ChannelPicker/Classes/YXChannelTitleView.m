//
//  YXChannelTitleView.m
//  ChannelPicker_Example
//
//  Created by yaxun on 2018/4/14.
//  Copyright © 2018年 liuyaxun. All rights reserved.
//

#import "YXChannelTitleView.h"
static CGFloat const space = 15;
static CGFloat const TitleTransformScale = 1.2;


@interface YXChannelTitleView() {
    UIColor *_selectColor;
    UIColor *_normalColor;
    NSArray <UIButton *>*_titButtons;
    UIEdgeInsets _layoutInsets;
    NSInteger _selectIndex;
    CGFloat _lastOffsetX;
    
    CGFloat _startR;
    CGFloat _startG;
    CGFloat _startB;
    CGFloat _endR;
    CGFloat _endG;
    CGFloat _endB;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *navLine;

@end

@implementation YXChannelTitleView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"YXChannelTitleView" owner:nil options:nil][0];
        self.frame = frame;
        _layoutInsets = UIEdgeInsetsMake(0, 15, 0, frame.size.height + 15);
        _selectColor = [UIColor redColor];
        _normalColor = [UIColor whiteColor];
        
        [self setupStartColor:_normalColor];
        [self setupEndColor:_selectColor];
    }
    return self;
}

- (void)setupStartColor:(UIColor *)color
{
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    _startR = components[0];
    _startG = components[1];
    _startB = components[2];
}

- (void)setupEndColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _endR = components[0];
    _endG = components[1];
    _endB = components[2];
}


- (void)setTitles:(NSArray<NSString *> *)titles {
    if (titles.count == 0) { return ;}
    if ([_titles isEqual:titles]) {
        
    }
    _titles = titles;
    [self layoutSubButtons];
}


- (void)layoutSubButtons {
    for (UIView *view in self.scrollView.subviews) {if ([view isKindOfClass:[UIButton class]]) {[view removeFromSuperview];}}
    CGFloat maxWidth = _layoutInsets.left;
    _selectIndex = 0;
    NSMutableArray *buttons = [NSMutableArray array];
    
    for (int i = 0; i < self.titles.count; i ++) {
        NSString *title = self.titles[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchTitleButton:) forControlEvents:UIControlEventTouchDown];
        [btn sizeToFit];
        btn.frame = CGRectMake(maxWidth, 0, btn.frame.size.width, self.frame.size.height);
        if (i == _selectIndex) {
            [self touchTitleButton:btn];
        }
        [self.scrollView addSubview:btn];
        if (i == self.titles.count - 1) {
            maxWidth = (maxWidth + btn.frame.size.width + _layoutInsets.right);
        }else {
            maxWidth = (maxWidth + btn.frame.size.width + space);
        }
        [buttons addObject:btn];
    }
    _titButtons = buttons;
    self.scrollView.contentSize = CGSizeMake(maxWidth, self.frame.size.height);
}


#pragma mark - action

- (void)associateScrollOffset:(CGPoint)offset {
    NSInteger sourceIndex = offset.x / self.bounds.size.width;
    NSInteger targetIndex = sourceIndex + 1;
    CGFloat progress = (offset.x - sourceIndex * self.bounds.size.width) / self.bounds.size.width;
    UIButton *targetButton = nil;
    if (targetIndex < _titButtons.count) {
        targetButton = _titButtons[targetIndex];
    }
    UIButton *sourceButton = _titButtons[sourceIndex];
    _lastOffsetX = offset.x;
    if (progress == 0) {
        [self touchTitleButton:_titButtons[sourceIndex]];
    }
    [self scrollFromSourceButton:sourceButton toTargetButton:targetButton scrollPorgress:progress];
    
}

- (void)scrollFromSourceButton:(UIButton *)sourceButton toTargetButton:(UIButton *)toButton scrollPorgress:(CGFloat)progress {
    // 获取右边缩放
    CGFloat rightSacle = progress;
    // 获取左边缩放比例
    CGFloat leftScale = 1 - rightSacle;
    CGFloat r = _endR - _startR;
    CGFloat g = _endG - _startG;
    CGFloat b = _endB - _startB;
    UIColor *rightColor = [UIColor colorWithRed:_startR + r * rightSacle green:_startG + g * rightSacle blue:_startB + b * rightSacle alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:_startR +  r * leftScale  green:_startG +  g * leftScale  blue:_startB +  b * leftScale alpha:1];
    // 右边颜色
    [toButton setTitleColor:rightColor forState:UIControlStateNormal];
    [sourceButton setTitleColor:leftColor forState:UIControlStateNormal];
    CGFloat scaleTransform = TitleTransformScale;
    scaleTransform -= 1;
    sourceButton.transform = CGAffineTransformMakeScale(leftScale * scaleTransform + 1, leftScale * scaleTransform + 1);
    toButton.transform = CGAffineTransformMakeScale(rightSacle * scaleTransform + 1, rightSacle * scaleTransform + 1);
    
    CGFloat distance = toButton.frame.origin.x - sourceButton.frame.origin.x;
    CGFloat x = sourceButton.frame.origin.x + distance * progress;
    CGFloat y = self.frame.size.height - 1;
    CGFloat width = (toButton.frame.size.width - sourceButton.frame.size.width) * progress + sourceButton.frame.size.width;
    CGFloat height = 1;
    self.navLine.frame = CGRectMake(x, y, width, height);
}


- (void)touchTitleButton:(UIButton *)button {
    if ([button isEqual:_titButtons[_selectIndex]]) return ;
    [button setTitleColor:_selectColor forState:UIControlStateNormal];
    UIButton *selectButton = _titButtons[_selectIndex];
    if (_titButtons.count == 0 ) {
        button.transform = CGAffineTransformMakeScale(TitleTransformScale, TitleTransformScale);;
    }else {
        selectButton.transform = CGAffineTransformIdentity;
    }
    [selectButton setTitleColor:_normalColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.navLine.frame = CGRectMake(button.frame.origin.x, self.frame.size.height - 1, button.frame.size.width, 1);
    }];
    _selectIndex = [_titButtons indexOfObject:button];
    if (self.clickTitleButton) {
        self.clickTitleButton(_selectIndex);
    }    
    // 居中
    CGFloat centerX = self.scrollView.contentOffset.x + self.scrollView.bounds.size.width * 0.5;
    CGFloat offset = button.frame.origin.x - centerX + self.scrollView.contentOffset.x;
    NSLog(@"offset => %f",offset);
    if (offset < _layoutInsets.left ) {
        offset = 0;
    }else if (offset > self.scrollView.contentSize.width - self.scrollView.bounds.size.width) {
        offset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    }
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}


- (IBAction)clickMoreButton:(id)sender {
    if (_clickMoreButton) {
        _clickMoreButton();
    }
}

- (UIView *)navLine {
    
    if (!_navLine) {
        _navLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, 30, 1)];
        _navLine.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:_navLine];
    }
    return _navLine;
    
}


#pragma mark - 获取颜色的RGB 值

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}




@end
