//
//  ZEAskQuestionTypeView.m
//  nbsj-know
//
//  Created by Stenson on 16/11/15.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//


#define kTableViewCellHeight 50.0f


#import "ZEAskQuestionTypeView.h"

@interface ZEAskQuestionTypeView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITableView * _typeTableView;
    UICollectionView * _collectionView;
    
    NSInteger _currentSelectType;
}

@property (nonatomic,strong) NSMutableArray * typeArr;
@property (nonatomic,strong) NSMutableArray * typeDetailArr;

@end

@implementation ZEAskQuestionTypeView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MAIN_BACKGROUND_COLOR;
        _currentSelectType = 0;
        [self initView];
    }
    return self;
}

-(void)initView
{
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(102, NAV_HEIGHT + 2, SCREEN_WIDTH - 100, SCREEN_HEIGHT - NAV_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册Cell，必须要有
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = MAIN_BACKGROUND_COLOR;

    _typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, 100, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
    _typeTableView.delegate = self;
    _typeTableView.dataSource = self;
    _typeTableView.backgroundColor = MAIN_BACKGROUND_COLOR;
    [self addSubview:_typeTableView];
    _typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _typeTableView.showsVerticalScrollIndicator = NO;
    _typeTableView.showsHorizontalScrollIndicator = NO;
}

-(void)reloadTypeData
{
    NSArray * typeDataArr = [[ZEQuestionTypeCache instance] getQuestionTypeCaches];

    self.typeArr = [NSMutableArray array];
    self.typeDetailArr = [NSMutableArray array];
    
    for (int i = 0 ; i < typeDataArr.count; i ++) {
        NSDictionary * dic = typeDataArr[i];
        NSString * PARENTID = [dic objectForKey:@"PARENTID"];
        
        if ([PARENTID integerValue] == -1) {
            [self.typeArr addObject:dic];
        }
    }
    for (int j = 0; j < self.typeArr.count;  j ++) {
        NSMutableArray * centerArr = [NSMutableArray array];;

        NSDictionary * parentDic = self.typeArr[j];
        NSString * parentCODE = [parentDic objectForKey:@"CODE"];

        for (int i = 0 ; i < typeDataArr.count; i ++) {
            NSDictionary * dic = typeDataArr[i];
            NSString * PARENTID = [dic objectForKey:@"PARENTID"];
            
            if ([PARENTID isEqualToString:parentCODE]) {
                [centerArr addObject:dic];
            }
        }
        
        [self.typeDetailArr addObject:centerArr];
    }
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_currentSelectType >= 0) {
        NSArray * currentArr = self.typeDetailArr[_currentSelectType];
        return currentArr.count;
    }

    return 0;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(03, 0, (SCREEN_WIDTH - 106) / 3 - 6, 44.0f)];
    label.textColor = MAIN_NAV_COLOR;
    
    NSArray * currentArr = self.typeDetailArr[_currentSelectType];
    
    if([currentArr count] == 0){
        return cell;
    }
    
    NSDictionary * dic = currentArr[indexPath.row];
    label.text = [dic objectForKey:@"NAME"];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 106) / 3, 44.0f);
}

//定义每个UICollectionView 的 margin
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 2.0;
}
#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * currentArr = self.typeDetailArr[_currentSelectType];
    
    if([currentArr count] == 0){
        return;
    }
    NSDictionary * dic = currentArr[indexPath.row];
    if([self.delegate respondsToSelector:@selector(didSelectType:typeCode:fatherCode:)]){
        [self.delegate didSelectType:[dic objectForKey:@"NAME"] typeCode:[dic objectForKey:@"CODE"] fatherCode:[dic objectForKey:@"PARENTID"]];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_typeTableView]) {
        return self.typeArr.count;
    }
    return 0 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.01;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    while ([cell.contentView.subviews lastObject]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([tableView isEqual:_typeTableView]) {
        
        cell.contentView.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        CALayer * lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(0, 0, _typeTableView.frame.size.width, 2.0f);
        [cell.contentView.layer addSublayer:lineLayer];
        lineLayer.backgroundColor = [MAIN_BACKGROUND_COLOR CGColor];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSDictionary * dic = self.typeArr[indexPath.row];
        
        UIView * contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 2, _typeTableView.frame.size.width, kTableViewCellHeight - 2.0f)];
        contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:contentView];
        
        UIImageView * contentImage = [[UIImageView alloc]init];
        contentImage.contentMode = UIViewContentModeScaleAspectFit;
        [contentView addSubview:contentImage];
        contentImage.left = 10.0f;
        contentImage.size = CGSizeMake(16.0f, 16.0f);

        contentImage.top = (kTableViewCellHeight - contentImage.height) / 2 ;
        
        [contentImage sd_setImageWithURL:ZENITH_ICON_IMAGEURL([dic objectForKey:@"ICOPATH"]) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
        
        UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(26.0f,0,_typeTableView.frame.size.width - 27 ,kTableViewCellHeight - 2.0f)];
        contentLab.textColor = kTextColor;
        contentLab.userInteractionEnabled = NO;
        contentLab.textColor = MAIN_SUBTITLE_COLOR;
        [contentView addSubview:contentLab];
        contentLab.font = [UIFont systemFontOfSize:13.0f];
        contentLab.numberOfLines = 0;
        [contentLab setText:[dic objectForKey:@"NAME"]];
        contentLab.textAlignment = NSTextAlignmentCenter;
        
        UITapGestureRecognizer *doubleTabGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTabGesture setNumberOfTapsRequired:2];
        [cell addGestureRecognizer:doubleTabGesture];
        
        if (_currentSelectType == indexPath.row) {
            contentView.backgroundColor = MAIN_BACKGROUND_COLOR;

            UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 7.0, 3, 30.0f)];
            [contentView addSubview:maskView];
            maskView.backgroundColor = MAIN_NAV_COLOR_A(0.7);
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_typeTableView isEqual:tableView]) {
        _currentSelectType = indexPath.row;
        [UIView animateWithDuration:0.29 animations:^{
            _typeTableView.frame = CGRectMake(0, NAV_HEIGHT, 100, SCREEN_HEIGHT - NAV_HEIGHT);
            [_typeTableView reloadData];
            [_collectionView reloadData];
        }];
    }
}



-(void)handleDoubleTap:(UIView *)view
{
    NSDictionary * dic = self.typeArr[_currentSelectType];
    if([self.delegate respondsToSelector:@selector(didSelectType:typeCode:fatherCode:)]){
        [self.delegate didSelectType:[dic objectForKey:@"NAME"] typeCode:[dic objectForKey:@"CODE"] fatherCode:[dic objectForKey:@"PARENTID"]];
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
