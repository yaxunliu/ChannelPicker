//
//  YXChannelViewController.m
//  Demo
//
//  Created by yaxun on 2018/4/14.
//  Copyright © 2018年 yaxun. All rights reserved.
//

#import "YXChannelViewController.h"
#import "YXChannelCell.h"
#import "YXChannelHeader.h"


//菜单列数
static NSInteger ColumnNumber = 4;
//横向和纵向的间距
static CGFloat CellMarginX = 15.0f;
static CGFloat CellMarginY = 10.0f;

@interface YXChannelViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
}

@property (nonatomic ,strong)YXChannelCell *dragingItem;

@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSArray <NSString *>*unchangTitles;
@property (nonatomic ,strong) NSArray <NSString *>*headerTitles;
@property (nonatomic ,copy) void(^dismissBlock)(NSArray <NSString *>*inuseTitles);

/**
 已选择的频道
 */
@property (nonatomic ,strong) NSMutableArray <NSString *>*selectChanneles;
/**
 所有未选择的频道
 */
@property (nonatomic ,strong) NSMutableArray <NSMutableArray <NSString *>*>*unSelectChanneles;

/**
 已选择的频道(copy)
 */
@property (nonatomic ,strong) NSArray <NSString *>*selectChannelesArr;
/**
 所有未选择的频道(copy)
 */
@property (nonatomic ,strong) NSArray <NSArray <NSString *>*>*unSelectChannelesArr;



@end

@implementation YXChannelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.dismissBlock) {
        self.dismissBlock(self.selectChanneles);
    }
}

#pragma mark - 初始化
- (instancetype)initWithUnchangeTitles:(NSArray <NSString *>*)unchangTitles selectChanneles:(NSArray <NSString *>*)selectChanneles unSelectChanneles:(NSArray <NSArray <NSString *>*>*)unSelectChanneles channelHeaders:(NSArray <NSString *>*)headers dismissBlock:(void(^)(NSArray <NSString *>*inuseTitles))dismissBlock {
    if (self = [super init]) {
        self.unchangTitles = unchangTitles;
        self.selectChannelesArr = selectChanneles;
        self.selectChanneles = [NSMutableArray arrayWithArray:selectChanneles];
        [self mapUnuseTitles:unSelectChanneles];
        self.dismissBlock = dismissBlock;
        self.headerTitles = headers;
    }
    return self;
}


- (void)mapUnuseTitles:(NSArray <NSArray <NSString *>*>*)unSelectChanneles {
    self.unSelectChannelesArr = unSelectChanneles;
    self.unSelectChanneles = [NSMutableArray array];
    for (NSArray *array in unSelectChanneles) {
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:array];
        [self.unSelectChanneles addObject:arrM];
    }
    for (int i = 0; i < self.unSelectChannelesArr.count; i ++) {
        NSArray *array = self.unSelectChannelesArr[i];
        for (int j = 0; j < array.count; j ++) {
            NSString *title = array[j];
            if ([self.selectChanneles containsObject:title]) {
                [self.unSelectChanneles[i] removeObject:title];
            }
        }
    }
}

#pragma mark - collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.unSelectChanneles.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ?  self.selectChanneles.count : [self.unSelectChanneles[section - 1] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXChannelCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSString *title = self.selectChanneles[indexPath.row];
        cell.enablePan = ![self.unchangTitles containsObject:title];
        cell.channelNameLabel.text = title;
    }else {
        cell.channelNameLabel.text = self.unSelectChanneles[indexPath.section - 1][indexPath.row];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    YXChannelHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXChannelHeader" forIndexPath:indexPath];
    header.headerNameLabel.text = self.headerTitles[indexPath.section];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //只剩一个的时候不可删除
        if ([self.collectionView numberOfItemsInSection:0] == 1) {return;}
        //第一个不可删除
        if (indexPath.row <= self.unchangTitles.count - 1) {return;}
        NSString  *channelName = self.selectChanneles[indexPath.row];
        [self.selectChanneles removeObject:channelName];
        int section = [self sectionForSelectChannele:channelName];
        [self.unSelectChanneles[section] insertObject:channelName atIndex:0];
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:section + 1]];
    }else{
        NSString *channel = self.unSelectChanneles[indexPath.section - 1][indexPath.row];
        [self.unSelectChanneles[indexPath.section - 1] removeObject:channel];
        [self.selectChanneles addObject:channel];
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.selectChanneles.count - 1 inSection:0]];
    }
}


/**
 判断当前频道之前所在的分区
 */
- (int)sectionForSelectChannele:(NSString *)channelName {
    for (int i = 0; i < self.unSelectChannelesArr.count ; i ++) {
        for (NSString *channel in self.unSelectChannelesArr[i]) {
            if ([channel isEqualToString:channelName]) {return i;}
        }
    }
    return -1;
}
#pragma mark LongPressMethod
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}

//拖拽开始 找到被拖拽的item
-(void)dragBegin:(CGPoint)point{
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    [_collectionView bringSubviewToFront:_dragingItem];
    YXChannelCell *item = (YXChannelCell*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    item.isMoving = YES;
    _dragingItem.hidden = NO;
    _dragingItem.frame = item.frame;
    _dragingItem.channelNameLabel.text = item.channelNameLabel.text;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
}

//正在被拖拽、、、
- (void)dragChanged:(CGPoint)point{
    if (!_dragingIndexPath) {return;}
    _dragingItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置 如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self rearrangeInUseTitles];
        //更新item位置
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

- (void)rearrangeInUseTitles
{
    NSString *channel = [self.selectChanneles objectAtIndex:_dragingIndexPath.row];
    [self.selectChanneles removeObject:channel];
    [self.selectChanneles insertObject:channel atIndex:_targetIndexPath.row];
}

//拖拽结束
- (void)dragEnd{
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    __weak __typeof(self)weakSelf = self;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.dragingItem.frame = endFrame;
    }completion:^(BOOL finished) {
        weakSelf.dragingItem.hidden = YES;
        YXChannelCell *item = (YXChannelCell *)[weakSelf.collectionView cellForItemAtIndexPath:_dragingIndexPath];
        item.isMoving = NO;
    }];
}

//获取被拖动IndexPath的方法
- (NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath* dragIndexPath = nil;
    if ([_collectionView numberOfItemsInSection:0] == 1) {return dragIndexPath;}
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {continue;}
        //在上半部分中找出相对应的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row >= self.unchangTitles.count) {
                dragIndexPath = indexPath;
            }
            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
- (NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        if (indexPath.section > 0) {continue;}
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row >= self.unchangTitles.count) {
                targetIndexPath = indexPath;
            }
        }
    }
    return targetIndexPath;
}

#pragma mark -
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat cellWidth = (self.view.bounds.size.width - (ColumnNumber + 1) * CellMarginX)/ColumnNumber;
        flowLayout.itemSize = CGSizeMake(cellWidth,cellWidth/2.0f);
        flowLayout.sectionInset = UIEdgeInsetsMake(CellMarginY, CellMarginX, CellMarginY, CellMarginX);
        flowLayout.minimumLineSpacing = CellMarginY;
        flowLayout.minimumInteritemSpacing = CellMarginX;
        flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 40);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        [_collectionView registerNib:[UINib nibWithNibName:@"YXChannelCell" bundle:bundle] forCellWithReuseIdentifier:@"YXChannelCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"YXChannelHeader" bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXChannelHeader"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
        longPress.minimumPressDuration = 0.3f;
        [_collectionView addGestureRecognizer:longPress];
        [_collectionView addSubview:self.dragingItem];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (YXChannelCell *)dragingItem {
    if (!_dragingItem) {
        CGFloat cellWidth = (self.view.bounds.size.width - (ColumnNumber + 1) * CellMarginX)/ColumnNumber;
        _dragingItem = [[YXChannelCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth/2.0f)];
        _dragingItem.hidden = true;
    }
    return _dragingItem;
}

@end

