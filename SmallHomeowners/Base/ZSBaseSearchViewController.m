//
//  ZSBaseSearchViewController.m
//  ZSMoneytocar
//
//  Created by 黄曼文 on 2017/4/17.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "ZSBaseSearchViewController.h"
#import "ZSOrderListViewController.h"

@interface ZSBaseSearchViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView     *searchImage;
@property (nonatomic,strong) UITextField     *inputTxtfeild;       //输入框
@property (nonatomic,strong) UILabel         *headerLabel;
@property (nonatomic,strong) UIButton        *footerBtn;
@property (nonatomic,strong) NSMutableArray  *historicalDataArray;
@property (nonatomic,copy) NSString        *keyString;          //文件key,用用户id来代替
@end

@implementation ZSBaseSearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //数据填充
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.inputTxtfeild.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ZSViewBackgroundColor;
    [self configureSearchBar];
    [self configureTableView];
    if ([ZSLogInManager readUserInfo].tid) {
        self.keyString = [ZSLogInManager readUserInfo].tid;
    }else{
        self.keyString = @"";
    }
}

#pragma mark 创建搜索bar
- (void)configureSearchBar
{
    [self configureNavgationBar:@"" withBackBtn:NO];
    
    //搜索按钮
    UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backgroundBtn.frame = CGRectMake(GapWidth, kStatusBarHeight+((kNavigationBarHeight-kStatusBarHeight)-30)/2, ZSWIDTH-60, 30);
    backgroundBtn.backgroundColor = ZSColorWhite;
    backgroundBtn.layer.cornerRadius = 15.0f;
    [self.navView addSubview:backgroundBtn];
   
    //搜索图片
    self.searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
    self.searchImage.image = [UIImage imageNamed:@"head_search_1_n"];
    [backgroundBtn addSubview:self.searchImage];
    
    //输入框
    self.inputTxtfeild = [self FieldWithFrame:CGRectMake(30, 0, ZSWIDTH-62-25, 30) FieldText:@"输入客户姓名/身份证号/手机号"];
    self.inputTxtfeild.delegate = self;
    [self.inputTxtfeild becomeFirstResponder];//默认键盘弹出
    [backgroundBtn addSubview:self.inputTxtfeild];

    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(ZSWIDTH-60, kStatusBarHeight+((kNavigationBarHeight-kStatusBarHeight)-30)/2, 60, 30);
    [cancelBtn setTitle:@"  取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ZSColorWhite forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(btnCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:cancelBtn];
}

- (UITextField *)FieldWithFrame:(CGRect )frame FieldText:(NSString *)TSLable
{
    UITextField *textField       = [[UITextField alloc] init];
    textField.frame              = frame;
    textField.borderStyle        = UITextBorderStyleNone;
    textField.textColor          = ZSColorListRight;;
    textField.textAlignment      = NSTextAlignmentLeft;
    textField.placeholder        = TSLable;
    textField.secureTextEntry    = NO;
    textField.backgroundColor    = [UIColor clearColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType      = UIReturnKeySearch;
    textField.font               = [UIFont systemFontOfSize:13];
//    [textField setValue:ZSColorAllNotice forKeyPath:@"_placeholderLabel.textColor"];
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName : ZSColorAllNotice}];
    textField.attributedPlaceholder = arrStr;
    [self.view addSubview:textField];
    return textField;
}

#pragma mark 创建列表
- (void)configureTableView
{
    [self configureTableView:CGRectMake(0, kNavigationBarHeight, ZSWIDTH, ZSHEIGHT-kNavigationBarHeight) withStyle:UITableViewStylePlain];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 48)];
    self.headerLabel.layer.borderColor = ZSColorLine.CGColor;  //边框颜色
    self.headerLabel.layer.borderWidth = 0.5;
    self.headerLabel.textAlignment     = NSTextAlignmentLeft;
    self.headerLabel.text              = @"    历史搜索";
    self.headerLabel.textColor         = ZSColor(102, 102, 102);
    self.headerLabel.font              = [UIFont systemFontOfSize:16];
    self.tableView.tableHeaderView     = self.headerLabel;
    
    self.footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.footerBtn.frame              = CGRectMake(0, 0, ZSWIDTH, CellHeight);
    self.footerBtn.backgroundColor    = [UIColor clearColor];
    self.footerBtn.titleLabel.font    = [UIFont systemFontOfSize:16];
    self.tableView.tableFooterView     = self.footerBtn;
    [self.footerBtn setTitle:@"清除搜索记录" forState:UIControlStateNormal];
    [self.footerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.footerBtn addTarget:self action:@selector(btnFooterAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *view_divider = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZSWIDTH, 0.5)];
    view_divider.backgroundColor = ZSColorLine;
    [self.footerBtn addSubview:view_divider];
}

- (void)reloadData
{
    NSString *path2 = [NSHomeDirectory() stringByAppendingPathComponent:self.filePathString];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path2]].mutableCopy;
    if (array.count > 0) {
        self.historicalDataArray = [[NSMutableArray alloc]init];
        //文件key用的用户id，不一致可能有空值，空值就不要了
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = array[idx];
            NSString *string = [dic objectForKey:self.keyString];
            if (string.length > 0) {
                [self.historicalDataArray addObject:string];
            }
        }];
        
        //有数据再刷新
        if (self.historicalDataArray.count > 0) {
            self.tableView.hidden     = NO;
            self.headerLabel.hidden  = NO;
            self.footerBtn.hidden    = NO;
            [self.tableView reloadData];
        }
        else
        {
            self.tableView.hidden    = YES;
            self.headerLabel.hidden = YES;
            self.footerBtn.hidden   = YES;
        }
    }
    else
    {
        self.tableView.hidden    = YES;
        self.headerLabel.hidden = YES;
        self.footerBtn.hidden   = YES;
    }
}

#pragma mark textField---Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.inputTxtfeild.text.length == 0)
    {
        [ZSTool showMessage:@"请输入需要搜索的内容" withDuration:DefaultDuration];
        return NO;
    }
    else
    {
        [self requestTheSearchContent:self.inputTxtfeild.text];//根据关键字搜索需要搜索的内容
        NSString *string_search = [NSString stringWithFormat:@"%@",self.inputTxtfeild.text];
        NSString *path2 = [NSHomeDirectory() stringByAppendingPathComponent:self.filePathString];
        NSMutableArray *array2 = [NSMutableArray arrayWithContentsOfFile:path2];
        NSMutableArray  *MuArray = [array2 mutableCopy];
        for (int i = 0; i<MuArray.count; i++) {
            //        ZSLOG(@"langArray[%d]=%@", i, MuArray[i]);
            if ([[[MuArray objectAtIndex:i] objectForKey:self.keyString ]isEqualToString:string_search]) {
                [MuArray removeObjectAtIndex:i];
            }
        }
        
        NSDictionary *dic = @{self.keyString:string_search};
        NSArray *array = @[dic];
        NSMutableArray *mutArrary1 = [[NSMutableArray alloc] initWithCapacity:2225];
        [mutArrary1 addObjectsFromArray:MuArray];
        [mutArrary1 addObjectsFromArray:array];
        //数组写文件
        [mutArrary1 writeToFile:path2 atomically:YES];
        [USER_DEFALT setObject:string_search forKey:self.keyString];
        [textField resignFirstResponder];//键盘回收代码

        return YES;
    }
}

- (void)textFieldDone
{
    [self.view endEditing:YES];
}

#pragma mark tableView---Delaget
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.historicalDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifyCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, 0, ZSWIDTH-GapWidth, 0.5)];
        lineView.backgroundColor = ZSColorLine;
        lineView.tag = 1992;
        [cell addSubview:lineView];
    }
    if (self.historicalDataArray.count > 0) {
        cell.textLabel.text = self.historicalDataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.historicalDataArray.count > 0) {
        NSString *string = self.historicalDataArray[indexPath.row];
        [self requestTheSearchContent:string];//根据关键字搜索需要搜索的内容
    }
}

#pragma mark 事件
//返回上级
- (void)btnCancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//清除搜索历史
- (void)btnFooterAction
{
    NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent:self.filePathString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager removeItemAtPath:filePath1 error:nil];
    self.historicalDataArray = 0;
    self.headerLabel.hidden  = YES;
    self.footerBtn.hidden    = YES;
    
    [self.tableView reloadData];
    if (success) {
        [self.tableView reloadData];
    }
}

#pragma mark 根据关键字搜索需要搜索的内容
- (void)requestTheSearchContent:(NSString *)searchSting
{
    //首页列表搜索
    if ([self.filePathString isEqualToString:KAllListSearch])
    {
        ZSOrderListViewController *orderListVC = [[ZSOrderListViewController alloc]init];
        orderListVC.searchKeyWord  = searchSting;
        [self.navigationController pushViewController:orderListVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
