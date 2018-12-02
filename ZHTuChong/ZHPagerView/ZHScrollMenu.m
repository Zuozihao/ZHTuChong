//
//  ZHScrollMenu.m
//  ZHTuChong
//
//  Created by 左梓豪 on 2018/12/1.
//  Copyright © 2018 左梓豪. All rights reserved.
//

#import "ZHScrollMenu.h"
#import "ZHScrollTitlesCollectionViewCell.h"

@interface ZHScrollMenu ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *titleCollectionView;
@property(nonatomic, strong) UICollectionView *mainCollectionView;
@property(nonatomic, assign) NSInteger lastSelectedSection;//记录上一次选中的标题

@property(nonatomic, strong) UIScrollView *bottomScrollView;
@property(nonatomic, strong) UIView *bottomLine;
@property(nonatomic, assign) CGFloat lineWidth;

@end

@implementation ZHScrollMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configDefaultSetting];
        [self addSubview:self.titleCollectionView];
        [self addSubview:self.mainCollectionView];
        [self addSubview:self.bottomScrollView];
        [self.bottomScrollView addSubview:self.bottomLine];
    }
    return self;
}

- (void)configDefaultSetting {
    self.itemWidth = 80.0f;
    self.titleHeight = 40.0f;
    self.fontSize = 14;
    self.highlightFontSize = 17;
    self.fontColor = [UIColor lightGrayColor];
    self.highlightTitleColor = [UIColor darkTextColor];
    self.showBottomLine = YES;
    self.bottomLineColor = [UIColor redColor];
    self.lineWidth = 25;
    _lastSelectedSection = 0;
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_titles.count > 0) {
        return _titles.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _titleCollectionView) {
        ZHScrollTitlesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleCell" forIndexPath:indexPath];
        cell.TitleLabel.text = _titles[indexPath.section];
        if (indexPath.section == _lastSelectedSection) {
            cell.TitleLabel.font = [UIFont systemFontOfSize:_highlightFontSize];
            cell.TitleLabel.textColor = _highlightTitleColor;
        } else {
            cell.TitleLabel.font = [UIFont systemFontOfSize:_fontSize];
            cell.TitleLabel.textColor = _fontColor;
        }
        return cell;
    }
    if (collectionView == _mainCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MianCell" forIndexPath:indexPath];
        if (indexPath.section % 2 == 0) {
            cell.backgroundColor = [UIColor orangeColor];
        } else {
            cell.backgroundColor = [UIColor cyanColor];
        }
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
    if (collectionView == _titleCollectionView) {
        [_mainCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [_titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self setHilightStyleWithIndexPath:indexPath];
        _bottomLine.frame = CGRectMake(indexPath.section*_itemWidth + (_itemWidth - 25)/2, 0, 25, 3);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _titleCollectionView) {
        _bottomScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);//下划线跟随标题滑动
        return;
    }
    //滑动主体时,标题跟随滑动
    NSInteger section;
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self];
    float rate;
    if (point.x > 0 ) {
        NSLog(@"------往左滑动");
        section = (scrollView.contentOffset.x + _mainCollectionView.frame.size.width - 1)/ _mainCollectionView.frame.size.width;//保证滑动玩之后才会高亮标题,不然会导致一开始滑动就高亮下一个标题
        rate = (section*_mainCollectionView.frame.size.width - scrollView.contentOffset.x ) / _mainCollectionView.frame.size.width;//当前偏移比例
        _bottomLine.frame = CGRectMake(section*_itemWidth - _itemWidth*rate + (_itemWidth - 25)/2, 0, 25 + _itemWidth*rate, 3);
    }else{
        NSLog(@"------往右滑动");
        section = scrollView.contentOffset.x / _mainCollectionView.frame.size.width;
        rate = (scrollView.contentOffset.x - section*_mainCollectionView.frame.size.width) / _mainCollectionView.frame.size.width;//当前偏移比例
        _bottomLine.frame = CGRectMake(section*_itemWidth + (_itemWidth - 25)/2, 0, 25 + _itemWidth*rate, 3);
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    [_titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [_titleCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self setHilightStyleWithIndexPath:indexPath];
}

- (void)setHilightStyleWithIndexPath:(NSIndexPath *)indexPath {
    //先取消上次选中的状态 后高亮当前选择状态
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:_lastSelectedSection];
    ZHScrollTitlesCollectionViewCell *lastCell = (ZHScrollTitlesCollectionViewCell *)[_titleCollectionView cellForItemAtIndexPath:lastIndexPath];
    lastCell.TitleLabel.font = [UIFont systemFontOfSize:_fontSize];
    lastCell.TitleLabel.textColor = _fontColor;
    
    ZHScrollTitlesCollectionViewCell *cell = (ZHScrollTitlesCollectionViewCell *)[_titleCollectionView cellForItemAtIndexPath:indexPath];
    cell.TitleLabel.font = [UIFont systemFontOfSize:_highlightFontSize];
    cell.TitleLabel.textColor = _highlightTitleColor;
    _lastSelectedSection = indexPath.section;
    [_titleCollectionView reloadData];
}

#pragma mark - Getter

- (UICollectionView *)titleCollectionView {
    if (_titleCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(_itemWidth, 40);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        _titleCollectionView.showsHorizontalScrollIndicator = false;
        _titleCollectionView.dataSource = self;
        _titleCollectionView.delegate = self;
        UINib *nib = [UINib nibWithNibName:@"ZHScrollTitlesCollectionViewCell" bundle:nil];
        [_titleCollectionView registerNib:nib forCellWithReuseIdentifier:@"TitleCell"];
    }
    return _titleCollectionView;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = _bottomLineColor;
    }
    return _bottomLine;
}

- (UICollectionView *)mainCollectionView {
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MianCell"];
    }
    return _mainCollectionView;
}

- (UIScrollView *)bottomScrollView {
    if (_bottomScrollView == nil) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
//        _bottomScrollView.backgroundColor = [UIColor grayColor];
    }
    return _bottomScrollView;
}

#pragma mark - Setter

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    NSLog(@"%@",titles);
    [self.mainCollectionView reloadData];
    [self.titleCollectionView reloadData];
    NSIndexPath *firstTitleIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_titleCollectionView selectItemAtIndexPath:firstTitleIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)setTitleHeight:(CGFloat)titleHeight {
    _titleHeight = titleHeight;
    _titleCollectionView.frame = CGRectMake(0, 0, self.frame.size.width, titleHeight);
    _mainCollectionView.frame = CGRectMake(0, CGRectGetMaxY(_titleCollectionView.frame), self.frame.size.width, self.frame.size.height - titleHeight);
    _bottomScrollView.frame = CGRectMake(0, CGRectGetMaxY(_titleCollectionView.frame) - 3, _titleCollectionView.frame.size.width, 3);
    _bottomScrollView.contentSize = CGSizeMake(_titleCollectionView.contentSize.width, 3);
    _bottomLine.frame = CGRectMake((_itemWidth - 25)/2.0, 0, 25, 3);
}

@end
