//
//  YXChannelCell.m
//  Demo
//
//  Created by yaxun on 2018/4/14.
//  Copyright © 2018年 yaxun. All rights reserved.
//

#import "YXChannelCell.h"

@implementation YXChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"YXChannelCell" owner:nil options:nil][0];
        self.frame = frame;
    }
    return self;
}

- (void)setIsMoving:(BOOL)isMoving {
    self.hidden = isMoving;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.enablePan = YES;
    
}

- (void)setEnablePan:(BOOL)enablePan {
    self.channelNameLabel.textColor = enablePan ? [UIColor blackColor] : [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1];
}

@end
