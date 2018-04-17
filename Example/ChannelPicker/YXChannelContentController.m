//
//  YXChannelContentController.m
//  ChannelPicker_Example
//
//  Created by yaxun on 2018/4/16.
//  Copyright © 2018年 liuyaxun. All rights reserved.
//

#import "YXChannelContentController.h"
#import "YXChannelTitleView.h"
#import "YXChannelViewController.h"

@interface YXChannelContentController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    
    
}
@property(nonatomic, strong) NSArray <NSString *>*titles;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) YXChannelTitleView *titView;

@end

@implementation YXChannelContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"健康",@"摄影"];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.titView];
    
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    int r = arc4random_uniform(255);
    int g = arc4random_uniform(255);
    int b = arc4random_uniform(255);
    cell.backgroundColor = [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.titView associateScrollOffset:scrollView.contentOffset];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}


#pragma mark -

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.view.bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        CGFloat insetTop = [UIApplication sharedApplication].statusBarFrame.size.height + 44 + self.titView.bounds.size.height;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, insetTop, self.view.bounds.size.width, self.view.bounds.size.height - insetTop) collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        
    }
    return _collectionView;
}

- (YXChannelTitleView *)titView {
    
    if (!_titView) {
        CGFloat insetTop = [UIApplication sharedApplication].statusBarFrame.size.height + 44;

        _titView = [[YXChannelTitleView alloc] initWithFrame:CGRectMake(0, insetTop, self.view.bounds.size.width, 44)];
        _titView.titles = self.titles;
        
        __weak __typeof(self)weakSelf = self;
        _titView.clickTitleButton = ^(NSInteger selectIndex) {
            [weakSelf.collectionView setContentOffset:CGPointMake(weakSelf.collectionView.bounds.size.width * selectIndex, 0) animated:NO];
        };
        
        _titView.clickMoreButton = ^{
            YXChannelViewController *vc = [[YXChannelViewController alloc] initWithUnchangeTitles:@[@"要闻",@"河北",@"财经"] selectChanneles:@[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"] unSelectChanneles:@[@[@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击"],@[@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"健康",@"摄影",@"生活",@"旅游",@"韩流",@"探索"],@[@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财",@"综艺",@"美食",@"育儿"]] channelHeaders:@[@"已经选择的频道",@"微财讯",@"惠选股",@"金股棒"] dismissBlock:^(NSArray<NSString *> *inuseTitles) {
            }];
            
            [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        };
    }
    return _titView;
}



@end
