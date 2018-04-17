//
//  YXViewController.m
//  ChannelPicker
//
//  Created by liuyaxun on 04/14/2018.
//  Copyright (c) 2018 liuyaxun. All rights reserved.
//

#import "YXViewController.h"
#import "YXChannelViewController.h"
#import "YXChannelTitleView.h"


@interface YXViewController ()
@property(nonatomic, strong) YXChannelTitleView *topView;

@end

@implementation YXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    YXChannelTitleView *topView = [[YXChannelTitleView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44)];
    
    topView.titles = @[@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"健康",@"摄影"];
    
    [self.view addSubview:topView];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    YXChannelViewController *vc = [[YXChannelViewController alloc] initWithUnchangeTitles:@[@"要闻",@"河北",@"财经"] selectChanneles:@[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"] unSelectChanneles:@[@[@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击"],@[@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"健康",@"摄影",@"生活",@"旅游",@"韩流",@"探索"],@[@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财",@"综艺",@"美食",@"育儿"]] channelHeaders:@[@"已经选择的频道",@"微财讯",@"惠选股",@"金股棒"] dismissBlock:^(NSArray<NSString *> *inuseTitles) {
    }];
    
//    YXChannelController *channel = [[YXChannelController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
