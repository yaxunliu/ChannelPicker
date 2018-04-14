//
//  YXChannelCell.h
//  Demo
//
//  Created by yaxun on 2018/4/14.
//  Copyright © 2018年 yaxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXChannelCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

/**
 是否可以拖拽 default YES
 */
@property(nonatomic, assign) BOOL enablePan;

@property(nonatomic, assign) BOOL isMoving;

//@property(nonatomic, assign) BOOL enablePan;

@end
