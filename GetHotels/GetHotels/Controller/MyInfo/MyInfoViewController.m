//
//  MyInfoViewController.m
//  GetHotels
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"

@interface MyInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UITableView *myInfoTableView;
@property (strong, nonatomic) NSArray *myInfoArr;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _myInfoArr = @[@{@"leftIcon":@"酒店-1",@"title":@"我的酒店"},@{@"leftIcon":@"飞机大",@"title":@"我的航空"},@{@"leftIcon":@"信息",@"title":@"我的消息"},@{@"leftIcon":@"设置",@"title":@"账号社置"},@{@"leftIcon":@"协议",@"title":@"使用协议"},@{@"leftIcon":@"电话",@"title":@"联系客服"}];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myInfoArr.count;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.section];
    cell.leftIcon.image = [UIImage imageNamed:dict[@"leftIcon"]];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 1.f;
}

//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"myInfoToHotels" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"myInfoToAviation" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"myInfoToNews" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"myInfoToSettings" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"myInfoToProtocol" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"myInfoToCallUs" sender:self];
            break;
    }
}




//设置组的底部视图颜色为透明
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}




- (IBAction)loginAction:(UIButton *)sender {
}
@end
