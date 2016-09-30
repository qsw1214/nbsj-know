//
//  ZEAnswerQuestionsVC.m
//  nbsj-know
//
//  Created by Stenson on 16/8/5.
//  Copyright © 2016年 Hangzhou Zenith Electronic Technology Co., Ltd. All rights reserved.
//

#import "ZEAnswerQuestionsVC.h"
#import "ZEAnswerQuestionsView.h"

#import "ZELookViewController.h"
@interface ZEAnswerQuestionsVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZELookViewControllerDelegate,ZEAnswerQuestionsViewDelegate>
{
    ZEAnswerQuestionsView * _answerQuesView;
}

@property (nonatomic,strong) NSMutableArray * imagesArr;

@end

@implementation ZEAnswerQuestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"回答";
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.imagesArr = [NSMutableArray array];
}

-(void)initView
{
    _answerQuesView = [[ZEAnswerQuestionsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _answerQuesView.delegate = self;
    [self.view addSubview:_answerQuesView];
    [self.view sendSubviewToBack:_answerQuesView];
}

#pragma mark - ZEAskQuesViewDelegate

-(void)takePhotosOrChoosePictures
{
    
    UIAlertController * alertCont= [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * takeAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickController:YES];
    }];
    UIAlertAction * chooseAction = [UIAlertAction actionWithTitle:@"选择一张照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickController:NO];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCont addAction:takeAction];
    [alertCont addAction:chooseAction];
    [alertCont addAction:cancelAction];
    
    [self presentViewController:alertCont animated:YES completion:^{
        
    }];
}


/**
 *  @author Stenson, 16-08-01 16:08:07
 *
 *  选取照片
 *
 *  @param isTaking 是否拍照
 */
-(void)showImagePickController:(BOOL)isTaking;
{
    if (self.imagesArr.count == 3) {
        [self showTips:@"最多上传三张照片"];
        return;
    }
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && isTaking) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * chooseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [_answerQuesView reloadChoosedImageView:chooseImage];
    [self.imagesArr addObject:chooseImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goLookImageView:(NSArray *)imageArr
{
    ZELookViewController * lookVC = [[ ZELookViewController alloc]init];
    lookVC.delegate = self;
    lookVC.imageArr = self.imagesArr;
    [self.navigationController pushViewController:lookVC animated:YES];
}

-(void)goBackViewWithImages:(NSArray *)imageArr
{
    self.imagesArr = [NSMutableArray arrayWithArray:imageArr];
    [_answerQuesView reloadChoosedImageView:imageArr];
}

-(void)rightBtnClick
{
    if (_answerQuesView.inputView.text.length == 0){
        return;
    }
    
    NSDictionary * parametersDic = @{@"limit":@"20",
                                     @"MASTERTABLE":KLB_ANSWER_INFO,
                                     @"MENUAPP":@"EMARK_APP",
                                     @"ORDERSQL":@"",
                                     @"WHERESQL":@"",
                                     @"start":@"0",
                                     @"METHOD":@"addSave",
                                     @"MASTERFIELD":@"SEQKEY",
                                     @"DETAILFIELD":@"",
                                     @"CLASSNAME":@"com.nci.app.biz.klb.Score",
                                     @"DETAILTABLE":@"",};
    NSString * ANSWERLEVEL = nil;
    if ([ZESettingLocalData getISEXPERT]) {
        ANSWERLEVEL = @"2";
    }else{
        ANSWERLEVEL = @"1";
    }
    NSDictionary * fieldsDic =@{@"SEQKEY":@"",
                                @"QUESTIONID":_questionSEQKEY,
                                @"ANSWEREXPLAIN":_answerQuesView.inputView.text,
                                @"ANSWERIMAGE":@"",
                                @"USERHEADIMAGE":[ZESettingLocalData getUSERHHEADURL],
                                @"ANSWERUSERCODE":[ZESettingLocalData getUSERCODE],
                                @"ANSWERUSERNAME":[ZESettingLocalData getNICKNAME],
                                @"ANSWERLEVEL":ANSWERLEVEL,
                                @"ISPASS":@"0",
                                @"ISENABLED":@"0",
                                @"GOODNUMS":@"0"};
    
    NSDictionary * packageDic = [ZEPackageServerData getCommonServerDataWithTableName:@[KLB_ANSWER_INFO]
                                                                           withFields:@[fieldsDic]
                                                                       withPARAMETERS:parametersDic
                                                                       withActionFlag:nil];
    [self progressBegin:nil];
    [ZEUserServer uploadImageWithJsonDic:packageDic
                            withImageArr:self.imagesArr
                           showAlertView:YES
                                 success:^(id data) {
                                     [self progressEnd:nil];
                                     [self showAlertView:@"回答成功" isBack:YES];
                                 } fail:^(NSError *error) {
                                     [self progressEnd:nil];
                                     
                                 }];
    

}

-(void)showAlertView:(NSString *)alertMsg isBack:(BOOL)isBack
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isBack) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
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
