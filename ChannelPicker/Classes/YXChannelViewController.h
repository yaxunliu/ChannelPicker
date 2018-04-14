//
//  YXChannelViewController.h
//  Demo
//
//  Created by yaxun on 2018/4/14.
//  Copyright © 2018年 yaxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXChannelViewController : UIViewController


/**
 初始化

 @param unchangTitles 不能改变位置的频道
 @param selectChanneles 已经选择的频道
 @param unSelectChanneles 未选择的频道
 @param headers header信息
 @param dismissBlock 退出的block回调
 */
- (instancetype)initWithUnchangeTitles:(NSArray <NSString *>*)unchangTitles selectChanneles:(NSArray <NSString *>*)selectChanneles unSelectChanneles:(NSArray <NSArray <NSString *>*>*)unSelectChanneles channelHeaders:(NSArray <NSString *>*)headers dismissBlock:(void(^)(NSArray <NSString *>*inuseTitles))dismissBlock;


@end
