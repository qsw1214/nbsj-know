//
//  ZEFindTeamView.m
//  nbsj-know
//
//  Created by Stenson on 17/3/8.
//  Copyright © 2017年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#define kContentTableViewMarginLeft 0.0f
#define kContentTableViewMarginTop  NAV_HEIGHT
#define kContentTableViewWidth      SCREEN_WIDTH
#define kContentTableViewHeight     SCREEN_HEIGHT - NAV_HEIGHT

#import "ZEFindTeamView.h"

#import "ZETeamCircleModel.h"

@implementation ZEFindTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     withData:(NSDictionary *)dataDic;
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

- (void)reloadCellView:(NSDictionary *)dic;
{
    ZETeamCircleModel * teamCircleInfo = [ZETeamCircleModel getDetailWithDic:dic];
    
    UIImageView * detailView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_WIDTH / 3)];
    detailView.contentMode=UIViewContentModeScaleAspectFill;
    detailView.clipsToBounds=YES;
    [self.contentView addSubview:detailView];
    
    UIImageView * detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH / 3, SCREEN_WIDTH / 3)];
    [detailView addSubview:detailImageView];
    [detailImageView sd_setImageWithURL:ZENITH_IMAGEURL(teamCircleInfo.FILEURL) placeholderImage:ZENITH_PLACEHODLER_IMAGE];
    detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    detailImageView.clipsToBounds = YES;    
    
    UILabel * caseNameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 + 10, 15, SCREEN_WIDTH - SCREEN_WIDTH / 3 - 25, 20)];
    caseNameLab.text = teamCircleInfo.TEAMCIRCLENAME;
    [caseNameLab setTextColor:kTextColor];
    caseNameLab.font = [UIFont systemFontOfSize:16];
    [detailView addSubview:caseNameLab];

    NSString * questionTypeLabText = teamCircleInfo.TEAMCIRCLECODENAME;
    float questionTypeLabWidth = [ZEUtil widthForString:questionTypeLabText font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(SCREEN_WIDTH / 5, 30)] ;
    if (IPHONE5_MORE) {
        questionTypeLabWidth += 10;
    }
    UILabel * questionTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 + 10, 40, questionTypeLabWidth, 30)];
    questionTypeLab.text = questionTypeLabText;
    questionTypeLab.numberOfLines = 0;
    questionTypeLab.textAlignment = NSTextAlignmentCenter;
    [questionTypeLab setTextColor:[UIColor whiteColor]];
    questionTypeLab.backgroundColor = RGBA(22, 155, 213, 1);
    questionTypeLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [detailView addSubview:questionTypeLab];
    questionTypeLab.clipsToBounds = YES;
    questionTypeLab.layer.cornerRadius = 5;
    
    NSString * numbersLabText = @"100000人";
    float numbersLabWidth = [ZEUtil widthForString:numbersLabText font:[UIFont systemFontOfSize:kSubTiltlFontSize] maxSize:CGSizeMake(SCREEN_WIDTH / 5, 30)] ;
    if (IPHONE5_MORE) {
        numbersLabWidth += 10;
    }
    UILabel * numbersLab = [[UILabel alloc]initWithFrame:CGRectMake(questionTypeLab.frame.origin.x + questionTypeLab.frame.size.width + (IPHONE6_MORE ? 10 : 5), 40, numbersLabWidth, 30)];
    numbersLab.text = numbersLabText;
    numbersLab.textAlignment = NSTextAlignmentCenter;
    [numbersLab setTextColor:[UIColor whiteColor]];
    numbersLab.backgroundColor = RGBA(252, 170, 105, 1);
    numbersLab.font = [UIFont systemFontOfSize:kSubTiltlFontSize];
    [detailView addSubview:numbersLab];
    numbersLab.clipsToBounds = YES;
    numbersLab.layer.cornerRadius = 5;
    
    UILabel * caseAuthorLab = [[UILabel alloc]initWithFrame:CGRectMake(caseNameLab.frame.origin.x, 70, SCREEN_WIDTH - SCREEN_WIDTH / 3 - 70, 40)];
    caseAuthorLab.text = teamCircleInfo.TEAMMANIFESTO;
    [caseAuthorLab setTextColor:[UIColor lightGrayColor]];
    caseAuthorLab.font = [UIFont systemFontOfSize:13.0f];
    if (IPHONE6_MORE) {
        caseAuthorLab.font = [UIFont systemFontOfSize:kTiltlFontSize];
    }
    [detailView addSubview:caseAuthorLab];
    caseAuthorLab.numberOfLines = 0;
    if (IPHONE6P) {
        caseAuthorLab.top = 80;
    }
    
    UIButton * stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stateBtn.frame = CGRectMake(SCREEN_WIDTH - 60 , 0 , 60, SCREEN_WIDTH / 3 + 10);
    [stateBtn  setTitle:@"申请加入" forState:UIControlStateNormal];
    [self addSubview:stateBtn];
    stateBtn.backgroundColor = MAIN_NAV_COLOR_A(0.9);
//    [stateBtn addTarget:self action:@selector(showQuestionTypeView) forControlEvents:UIControlEventTouchUpInside];
    stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    stateBtn.titleLabel.font = [UIFont systemFontOfSize:kTiltlFontSize];
    stateBtn.titleLabel.numberOfLines = 0;
    stateBtn.clipsToBounds = YES;
    stateBtn.layer.cornerRadius = 5;
}

@end

@implementation ZEFindTeamView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.teamsDataArr = [NSMutableArray array];
        [self initView];
    }
    return self;
}

-(void)initView{
    contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTableView.delegate = self;
    contentTableView.dataSource = self;
    contentTableView.backgroundColor = [UIColor redColor];
    [self addSubview:contentTableView];
    [contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kContentTableViewMarginLeft);
        make.top.mas_equalTo(kContentTableViewMarginTop);
        make.size.mas_equalTo(CGSizeMake(kContentTableViewWidth, kContentTableViewHeight));
    }];
    [contentTableView registerClass:[ZEFindTeamCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Public Method

-(void)reloadFindTeamView:(NSArray *)dataArr;
{
    self.teamsDataArr = [NSMutableArray array];
    [self.teamsDataArr addObjectsFromArray:dataArr];
    [contentTableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teamsDataArr.count;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH / 3 + 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    ZEFindTeamCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZEFindTeamCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellID];
    }
    
    while (cell.contentView.subviews.lastObject) {
        UIView * lastView = cell.contentView.subviews.lastObject;
        [lastView removeFromSuperview];
    }
    [cell reloadCellView:self.teamsDataArr[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
@end