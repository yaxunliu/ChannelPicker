//
//  YXChannelTitleView.h
//  ChannelPicker_Example
//
//  Created by yaxun on 2018/4/14.
//  Copyright © 2018年 liuyaxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXChannelTitleView : UIView
@property(nonatomic, strong) NSArray <NSString *>*titles;
@property(nonatomic, copy) void(^clickTitleButton)(NSInteger selectIndex);
@property(nonatomic, copy) void(^clickMoreButton)();

- (void)associateScrollOffset:(CGPoint)offset;


@end

