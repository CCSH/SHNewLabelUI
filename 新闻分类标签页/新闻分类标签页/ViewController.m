//
//  ViewController.m
//  新闻分类标签页
//
//  Created by CSH on 16/6/13.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHSortView.h"

#import "SHChannelCell.h"
#import "SHChannelLabel.h"

#import "UIView+Extension.h"


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

/** 频道数据模型 */
@property (nonatomic, strong) NSArray *channelList;
/** 当前要展示频道 */
@property (nonatomic, strong) NSMutableArray *list_now;


/** 频道列表 */
@property (nonatomic, strong) UIScrollView *smallScrollView;
/** 新闻视图 */
@property (nonatomic, strong) UICollectionView *bigCollectionView;
/** 下划线 */
@property (nonatomic, strong) UIView *underline;
/** 右侧添加删除排序按钮 */
@property (nonatomic, strong) UIButton *sortButton;
/** 分类排序界面 */
@property (nonatomic, strong) SHSortView *sortView;


@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻标签页";
    
    //标签页详情
    [self.view addSubview:self.sortButton];
    //上方滚动的标签
    [self.view addSubview:self.smallScrollView];
    [self.view addSubview:self.sortButton];
    //下方滚动的视图
    [self.view addSubview:self.bigCollectionView];
    
    
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _list_now.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
 
    cell.urlString = _list_now[indexPath.row];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
    
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex >= [self getLabelArrayFromSubviews].count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = [self getLabelArrayFromSubviews].count - 1;
    }
    
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    
    SHChannelLabel *labelLeft  = [self getLabelArrayFromSubviews][leftIndex];
    SHChannelLabel *labelRight = [self getLabelArrayFromSubviews][rightIndex];
    
    labelLeft.scale  = scaleLeft;
    labelRight.scale = scaleRight;
    
    
    // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
    if (scaleLeft == 1 && scaleRight == 0) {
        return;
    }
    
    // 下划线动态跟随滚动
    _underline.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
    _underline.width   = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
}

/** 手指滑动BigCollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.bigCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigCollectionView.width;
    // 滚动标题栏到中间位置
    SHChannelLabel *titleLable = [self getLabelArrayFromSubviews][index];
    CGFloat offsetx   =  titleLable.center.x - _smallScrollView.width * 0.5;
    CGFloat offsetMax = _smallScrollView.contentSize.width - _smallScrollView.width;
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    [_smallScrollView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    
    // 先把之前着色的去色：（快速滑动会导致有些文字颜色深浅不一，点击label会导致之前的标题不变回黑色）
    for (SHChannelLabel *label in [self getLabelArrayFromSubviews]) {
        //非显示标题颜色
        label.textColor = [UIColor blackColor];
    }
    // 下划线滚动并着色
    [UIView animateWithDuration:0.5 animations:^{
        _underline.width = titleLable.textWidth;
        _underline.centerX = titleLable.centerX;
        titleLable.textColor = [UIColor colorWithRed:0.00392 green:0.576 blue:0.871 alpha:1];
    }];
}



#pragma mark - getter
- (NSArray *)channelList
{
    if (_channelList == nil) {
        _channelList = @[@"头条",@"娱乐",@"热点",@"体育",@"泉州",@"网易号",@"财经",@"科技",@"汽车",@"时尚",@"图片",@"跟贴",@"房产",@"直播",@"轻松一刻",@"段子",@"军事",@"历史",@"家居",@"独家",@"游戏",@"健康",@"政务",@"哒哒趣闻",@"美女",@"NBA",@"社会",@"彩票",@"漫画",@"影视歌",@"中国足球",@"国际足球",@"CBA",@"跑步",@"手机",@"数码",@"移动互联",@"云课堂",@"态度公开课",@"旅游",@"读书",@"酒香",@"教育",@"亲子",@"暴雪游戏",@"情感",@"艺术",@"博客",@"论坛",@"型男",@"萌宠"];
    }
    return _channelList;
}

- (UIScrollView *)smallScrollView
{
    if (_smallScrollView == nil) {
        _smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
        _smallScrollView.backgroundColor = [UIColor whiteColor];
        _smallScrollView.showsHorizontalScrollIndicator = NO;
        // 设置频道(可以自网络获取，也可以本地获取，如果本地需要保存数组，方便保存编辑之后的顺序)
        _list_now = self.channelList.mutableCopy;
        [self setupChannelLabel];
        
        // 设置下划线
        [_smallScrollView addSubview:({
            SHChannelLabel *firstLabel = [self getLabelArrayFromSubviews][0];
            
            NSLog(@"%f",firstLabel.textWidth);
            firstLabel.textColor = [UIColor colorWithRed:0.00392 green:0.576 blue:0.871 alpha:1];
            // smallScrollView高度44，取下面4个点的高度为下划线的高度。
            _underline = [[UIView alloc] initWithFrame:CGRectMake(0, 40, firstLabel.textWidth, 4)];
            _underline.centerX = firstLabel.centerX;
            _underline.backgroundColor = [UIColor redColor];
            _underline;
        })];
    }
    return _smallScrollView;
}

- (UICollectionView *)bigCollectionView
{
    if (_bigCollectionView == nil) {
        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGFloat h = HEIGHT - 64 - self.smallScrollView.height;
        CGRect frame = CGRectMake(0, self.smallScrollView.maxY, WIDTH, h);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bigCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _bigCollectionView.backgroundColor = [UIColor whiteColor];
        _bigCollectionView.delegate = self;
        _bigCollectionView.dataSource = self;
        [_bigCollectionView registerClass:[SHChannelCell class] forCellWithReuseIdentifier:@"Cell"];
        
        // 设置cell的大小和细节
        flowLayout.itemSize = _bigCollectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _bigCollectionView.pagingEnabled = YES;
        _bigCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _bigCollectionView;
}

- (UIButton *)sortButton
{

    _sortButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-44, 64, 44, 44)];
    [_sortButton setImage:[UIImage imageNamed:@"ks_home_plus"] forState:UIControlStateNormal];
    _sortButton.backgroundColor = [UIColor whiteColor];
    _sortButton.layer.shadowColor = [UIColor whiteColor].CGColor;
    _sortButton.layer.shadowOpacity = 1;
    _sortButton.layer.shadowRadius = 5;
    _sortButton.layer.shadowOffset = CGSizeMake(-10, 0);
    
    [_sortButton addTarget:self action:@selector(sortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _sortButton;
}

- (SHSortView *)sortView
{
    if (_sortView == nil) {
        _sortView = [[SHSortView alloc] initWithFrame:CGRectMake(_smallScrollView.x,
                                                                 _smallScrollView.y,
                                                                 WIDTH,
                                                                 _smallScrollView.height + _bigCollectionView.height)
                                          channelList:_list_now];
        __block typeof(self) weakSelf = self;
        // 箭头点击回调
        _sortView.arrowBtnClickBlock = ^{
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.sortView.y = -HEIGHT;
                //				weakSelf.tabBarController.tabBar.y -= 49;
                weakSelf.tabBarController.tabBar.y = HEIGHT - 49; // 这么写防止用户多次点击label和排序按钮，造成tabbar错乱
            } completion:^(BOOL finished) {
                [weakSelf.sortView removeFromSuperview];
            }];
        };
        // 排序完成回调
        _sortView.sortCompletedBlock = ^(NSMutableArray *channelList){
            weakSelf.list_now = channelList;
            // 去除旧的排序
            for (SHChannelLabel *label in [weakSelf getLabelArrayFromSubviews]) {
                [label removeFromSuperview];
            }
            // 加入新的排序
            [weakSelf setupChannelLabel];
            // 滚到第一个频道！offset、下划线、着色，都去第一个. 直接模拟第一个label被点击：
            SHChannelLabel *label = [weakSelf getLabelArrayFromSubviews][0];
            UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
            [tap setValue:label forKey:@"view"];
            [weakSelf labelClick:tap];
        };
        // cell按钮点击回调
        _sortView.cellButtonClick = ^(UIButton *button){
            // 模拟label被点击
            for (SHChannelLabel *label in [weakSelf getLabelArrayFromSubviews]) {
                if ([label.text isEqualToString:button.titleLabel.text]) {
                    weakSelf.sortView.arrowBtnClickBlock(); // 关闭sortView
                    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
                    [tap setValue:label forKey:@"view"];
                    [weakSelf labelClick:tap];
                }
            }
        };
    }
    return _sortView;
}


#pragma mark -
/** 设置频道标题 */
- (void)setupChannelLabel
{
    CGFloat margin = 20.0;
    CGFloat x = 8;
    CGFloat h = _smallScrollView.bounds.size.height;
    int i = 0;
    for (NSString *channel in _list_now) {
        SHChannelLabel *label = [SHChannelLabel channelLabelWithTitle:channel];
        label.frame = CGRectMake(x, 0, label.width + margin, h);
        [_smallScrollView addSubview:label];
        
        x += label.bounds.size.width;
        label.tag = i++;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    _smallScrollView.contentSize = CGSizeMake(x + margin + 44, 0);
}

/** 频道Label点击事件 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    SHChannelLabel *label = (SHChannelLabel *)recognizer.view;
    // 点击label后，让bigCollectionView滚到对应位置。
    [_bigCollectionView setContentOffset:CGPointMake(label.tag * _bigCollectionView.frame.size.width, 0)];
    // 重新调用一下滚定停止方法，让label的着色和下划线到正确的位置。
    [self scrollViewDidEndScrollingAnimation:self.bigCollectionView];
}

/** 获取smallScrollView中所有的SHChannelLabel，合成一个数组，因为smallScrollView.subViews中有其他非Label元素 */
- (NSArray *)getLabelArrayFromSubviews
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (SHChannelLabel *label in _smallScrollView.subviews) {
        if ([label isKindOfClass:[SHChannelLabel class]]) {
            [arrayM addObject:label];
        }
    }
    return arrayM.copy;
}

/** 排序按钮点击事件 */
- (void)sortButtonClick
{
    [self.view addSubview:self.sortView];
    _sortView.y = -HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.y += 49;
        _sortView.y = _smallScrollView.y;
    }];
}


@end
