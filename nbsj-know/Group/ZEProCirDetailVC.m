//
//  ZEProCirDetailVC.m
//  nbsj-know
//
//  Created by Stenson on 16/9/27.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEProCirDetailVC.h"
#import "ZEProCirDeatilView.h"

#import "ZEProCirDynamicVC.h"

@interface ZEProCirDetailVC ()<ZEProCirDeatilViewDelegate>
{
    ZEProCirDeatilView * detailView;
}
@end

@implementation ZEProCirDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _PROCIRCLENAME;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_enter_group_type == ENTER_GROUP_TYPE_DEFAULT) {
        [self.rightBtn setTitle:@"加入他们" forState:UIControlStateNormal];
    }
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self isShowJoin];
    
    [self proCirecleMember];
}


-(void)proCirecleMember
{
    NSDictionary * parametersDic = @{@"limit":@"10",
                                     @"MASTERTABLE":KLB_PROCIRCLE_USER_POS,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SUMPOINTS DESC",
                                     @"WHERESQL":[NSString stringWithFormat:@" PROCIRCLECODE = '%@' ",_PROCIRCLECODE],
                                     @"start":@"0",
                                     @"METHOD":METHOD_SEARCH,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.klb.app.procirclestatus.ProcircleUserPos",
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"PROCIRCLECODE":_PROCIRCLECODE,
                                @"QUESTIONSUM":@"",
                                @"ANSWERSUM":@"",
                                @"ANSWERTAKESUM":@"",
                                @"SUMPOINTS":@"",
                                @"NICKNAME":@"",
                                };
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_USER_POS]
                                                                           withFields:@[fieldsDic]
                                                                        withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 
                                 NSArray * memberArr = [ZEUtil getServerData:data withTabelName:KLB_PROCIRCLE_USER_POS];
                                 if ([memberArr isKindOfClass:[NSArray class]]) {
                                     [detailView reloadSection:1 scoreDic:nil memberData:memberArr];
                                 }
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)isShowJoin
{
    NSDictionary * parametersDic = @{@"limit":@"-1",
                                     @"MASTERTABLE":KLB_PROCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"SYSCREATEDATE desc",
                                     @"WHERESQL":[NSString stringWithFormat:@"PROCIRCLECODE='%@' and USERCODE='%@'",_PROCIRCLECODE,[ZESettingLocalData getUSERCODE]],
                                     @"start":@"0",
                                     @"METHOD":@"search",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 NSArray * arr = [ZEUtil getServerData:data withTabelName:KLB_PROCIRCLE_REL_USER];
                                 if(arr.count == 0){
                                     self.rightBtn.hidden = NO;
                                 }else{
                                     [self.rightBtn setTitle:@"退出圈子" forState:UIControlStateNormal];
                                     [self.rightBtn removeTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
                                     [self.rightBtn addTarget:self action:@selector(exitCircle) forControlEvents:UIControlEventTouchUpInside];
                                 }
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)rightBtnClick
{
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_PROCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"PROCIRCLECODE":_PROCIRCLECODE,
                                @"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"STATUS":@"1",
                                @"NICKNAME":[ZESettingLocalData getNICKNAME],
                                @"USERNAME":[ZESettingLocalData getNAME],
                                @"USERTYPE":[ZESettingLocalData getUSERTYPE]};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"加入成功"];

                                 [self.rightBtn setTitle:@"退出圈子" forState:UIControlStateNormal];
                                 [self.rightBtn removeTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
                                 [self.rightBtn addTarget:self action:@selector(exitCircle) forControlEvents:UIControlEventTouchUpInside];

                                 [self proCirecleMember];
                                 
                             } fail:^(NSError *errorCode) {
                             }];
}

-(void)exitCircle
{
    NSDictionary * parametersDic = @{@"limit":@"4",
                                     @"MASTERTABLE":KLB_PROCIRCLE_REL_USER,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":METHOD_DELETE,
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":BASIC_CLASS_NAME,
                                     @"DETAILTABLE":@"",};
    
    NSDictionary * fieldsDic =@{@"USERCODE":[ZESettingLocalData getUSERCODE],
                                @"PROCIRCLECODE":_PROCIRCLECODE};

    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_PROCIRCLE_REL_USER]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [ZEUserServer getDataWithJsonDic:packageDic
                       showAlertView:NO
                             success:^(id data) {
                                 [self showTips:@"退出成功"];
                                 [self.rightBtn setTitle:@"加入圈子" forState:UIControlStateNormal];
                                 [self.rightBtn removeTarget:self action:@selector(exitCircle) forControlEvents:UIControlEventTouchUpInside];
                                 [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
                                 [self proCirecleMember];
                             } fail:^(NSError *errorCode) {
                             }];

}

-(void)initView{
    detailView = [[ZEProCirDeatilView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:detailView];
    detailView.delegate =self;
    [self.view sendSubviewToBack:detailView];
    [detailView reloadSection:0 scoreDic:self.PROCIRCLEDataDic memberData:nil];
}

-(void)goDynamic
{
    ZEProCirDynamicVC * dynamicVC =[[ZEProCirDynamicVC alloc]init];
    dynamicVC.PROCIRCLECODE = self.PROCIRCLECODE;
    [self.navigationController pushViewController:dynamicVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
