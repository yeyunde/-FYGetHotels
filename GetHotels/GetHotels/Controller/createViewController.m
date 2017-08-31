//
//  createViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "createViewController.h"

@interface createViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
- (IBAction)createAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation createViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航栏(返回按钮)的样式
- (void)setNavigationItem{
    //设置导航条标题的文字
    self.navigationItem.title = @"会员注册";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(1, 150, 255);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 22, 22);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uiLayout{
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.backView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.backView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.backView.layer.shadowRadius = 4;//阴影半径，默认3
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}
//键盘收回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)createAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if(_phoneTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if(_pwdTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的密码" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if(_pwdTextField.text.length < 6 || _pwdTextField.text.length > 18){
        [Utilities popUpAlertViewWithMsg:@"您的密码必须在6~18之间" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    if (![_confirmTextField.text isEqualToString:_pwdTextField.text]) {
        [Utilities popUpAlertViewWithMsg:@"您的两次输入的密码不一致" andTitle:nil onView:self onCompletion:^{
            _pwdTextField.text = @"";
            _confirmTextField.text = @"";
        }];
        return;
    }
    //判断某个字符串中是否每个字符都是数字(invertedSet:反向设置，Digits：数字)
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_phoneTextField.text.length < 11 || [_phoneTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self onCompletion:^{
        }];
        return;
    }
    [self request];
}
#pragma mark - request网络请求
//注册
- (void) request {
    //创建菊花膜（点击按钮的时候，并显示在当前页面）
    _avi = [Utilities getCoverOnView:self.view];
    //参数
    NSDictionary *para = @{@"tel" : _phoneTextField.text,@"pwd" : _pwdTextField.text};
    //网络请求
    [RequestAPI requestURL:@"/register" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"哈哈:%@",responseObject);
        //当网络请求成功时停止动画
        [_avi stopAnimating];
        if ([responseObject[@"result"] integerValue] == -102) {
            [Utilities popUpAlertViewWithMsg:@"该号码已被注册" andTitle:nil onView:self onCompletion:^{
                
            }];
        }
        if ([responseObject[@"result"] integerValue] == 1) {
            //NSDictionary *content = responseObject[@"content"];
            //NSString *token = content[@"token"];
            //NSLog(@"%@",token);
            //防范式(移除这个键)
            //[[StorageMgr singletonStorageMgr] removeObjectForKey:@"token"];
            //把token存入单例化全局变量中
            //[[StorageMgr singletonStorageMgr] addKey:@"token" andValue:token];
            
            
            
            _phoneTextField.text = @"";
            _pwdTextField.text = @"";
            _confirmTextField.text = @"";
            [Utilities popUpAlertViewWithMsg:@"您已经成功加入我们，快去体验吧" andTitle:nil onView:self onCompletion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self onCompletion:^{
            }];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络似乎不太给力,请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
        }];
        
        
    }];
    
}

@end
