//
//  ViewController.m
//  InputTableViewDemo
//
//  Created by Hou on 17/6/19.
//  Copyright © 2017年 HoHoDoDo. All rights reserved.
//

#import "ViewController.h"
#import "HDInputTableViewCell.h"


#define SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()
<UITableViewDelegate,
UITableViewDataSource,
HDInputTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSString *identityCard;
@property (nonatomic, strong) NSString *bankCardNo;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *amount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                  style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (NSMutableArray *)dataSources {
    
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
        
        NSString *placeHolders[7] = {
            @"请输入姓名",
            @"请输入身份证号",
            @"请输入借记卡卡号",
            @"请选择银行名称",
            @"请输入银行卡号",
            @"请输入密码",
            @"请输入金额"
        };
        
        NSString *titles[7] = {
            @"姓        名",
            @"身份证号",
            @"银行卡号",
            @"银行名称",
            @"手机号码",
            @"密        码",
            @""
        };
        
        NSString *events[7] = {
            @"cell.type.name",
            @"cell.type.id",
            @"cell.type.card.no",
            @"cell.type.bank.name",
            @"cell.type.phone.no",
            @"cell.type.pwd",
            @"cell.type.amount"
        };
        
        NSString *texts[7] = {@"默认值",@"",@"",@"",@"",@"",@""};
        NSString *icons[7] = {@"",@"",@"",@"",@"userid",@"pw_ico",@"cashicon"};
        
        for (NSInteger i = 0; i < 7; i++) {
            HDInputModel *item   = [[HDInputModel alloc] init];
            item.placeHolder   = placeHolders[i];///设置textfield.placeHolder的值
            item.title         = titles[i];///设置左边标题的值
            item.text          = texts[i];///设置textfield.text的值
            item.event         = events[i];///设置cell事件标识
            item.iconName      = icons[i];///设置左视图icon
            item.clickEnable   = (i == 0 || i == 3);///设置可点击状态，值为YES时，textfield不可编辑，可点击
            item.accessoryView = (i == 3) ? [self accessoryView] : nil; ///设置右视图的view,可自定制例如图形验证码等
            item.keyboardType  = (i == 2 || i == 4) ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault; ///设置键盘类型
            if (i == 6) item.keyboardType = UIKeyboardTypeDecimalPad;
            item.titleMaxWidth = 70; ///可设置标题最大宽度
            item.secureTextEntry = i == 5;///设置密文显示
            item.inputAlignment = (i == 4 || i == 5) ? NSTextAlignmentRight : NSTextAlignmentLeft;///设置输入框文本对齐方式
            [_dataSources addObject:item];
        }
    }
    return _dataSources;
}

#pragma mark - method
- (void)readFormData:(id)sender {
    
    NSLog(@"\n姓名 = %@\n身份证号 = %@\n银行卡号 = %@\n银行名称 = %@\n手机号码 = %@\n密码 = %@\n金额 = %@",@"默认值",
          self.identityCard,
          self.bankCardNo,
          self.bankName,
          self.phoneNo,
          self.password,
          self.amount);
}

#pragma mark - custom view
- (UIView *)accessoryView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (view.height-9)/2, view.width - 15, 9)];
    imageView.image = [UIImage imageNamed:@"down_arrow"];
    [view addSubview:imageView];
    return view;
}

- (UIView *)footerView {
    if (!_footerView) {
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.f)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15.f, 30.f, SCREEN_WIDTH - 30.f, 44.f);
        [button setTitle:@"读取数值" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:218.f/255.f green:44.f/255.f blue:44.f/255.f alpha:1]];
        button.layer.cornerRadius = 4;
        [button addTarget:self action:@selector(readFormData:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
    }
    return _footerView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSources count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.footerView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDInputTableViewCell *cell = [HDInputTableViewCell hd_initInputTableViewCellWithTableView:tableView
                                                                                   identifier:NSStringFromClass([self class])
                                                                                     delegate:self];
    [cell setObject:self.dataSources[indexPath.row]];
    return cell;
    
}

#pragma mark - InputTableViewCellDelegate

- (void)hd_inputTableViewCell:(HDInputTableViewCell *)cell didSelectEvent:(NSString *)event {
    if ([cell.event isEqualToString:@"cell.type.bank.name"]) {
        NSLog(@"银行名称");
    }
}

- (void)hd_inputTableViewCell:(HDInputTableViewCell *)cell textFieldEditingChanged:(NSString *)value {
    
    if ([cell.event isEqualToString:@"cell.type.id"]) {
        self.identityCard = value;
    } else if ([cell.event isEqualToString:@"cell.type.card.no"]) {
        self.bankCardNo = value;
    } else if ([cell.event isEqualToString:@"cell.type.phone.no"]) {
        self.phoneNo = value;
    } else if ([cell.event isEqualToString:@"cell.type.pwd"]) {
        self.password = value;
    } else if ([cell.event isEqualToString:@"cell.type.amount"]) {
        self.amount = value;
    }
}

- (BOOL)hd_inputTableViewCell:(HDInputTableViewCell *)cell textFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL result = YES;
    
    if ([cell.event isEqualToString:@"cell.type.id"]) {
        result = [cell hd_inputLimitLength:18 allowString:nil inputCharacter:string];
    } else if ([cell.event isEqualToString:@"cell.type.card.no"]) {
        result = [cell hd_inputLimitLength:19 allowString:ALLOW_NUMBERS inputCharacter:string];
    } else if ([cell.event isEqualToString:@"cell.type.phone.no"]) {
        result = [cell hd_inputLimitLength:11 allowString:ALLOW_NUMBERS inputCharacter:string];
    } else if ([cell.event isEqualToString:@"cell.type.pwd"]) {
        result = [cell hd_inputLimitLength:16 allowString:nil inputCharacter:string];
    } else if ([cell.event isEqualToString:@"cell.type.amount"]) {
        result = [cell hd_inputLimitLength:7 + 2 + 1 allowString:nil inputCharacter:string];
        if (result) {
            result = [cell hd_amountFormatWithIntegerBitLength:7 digitsLength:2 inputCharacter:string];
        }
    }
    return result;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
