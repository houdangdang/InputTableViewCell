# InputTableViewCell

为繁琐的输入框表单类应用带来福音，方便使用，可高度自定义

基本覆盖常规输入框的样式

![image](https://github.com/HoHoDoDo/InputTableViewCell/blob/master/InputTableViewDemo/screenshots/inputTest.gif?raw=true)

#创建数据源

```
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
```
#tableView代理

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HDInputTableViewCell *cell = [HDInputTableViewCell hd_initInputTableViewCellWithTableView:tableView
                                                                                   identifier:NSStringFromClass([self class])
                                                                                     delegate:self];
    [cell setObject:self.dataSources[indexPath.row]];
    return cell;

}
```

#cell代理

```
- (void)hd_inputTableViewCell:(HDInputTableViewCell *)cell didSelectEvent:(NSString *)event {
    if ([cell.event isEqualToString:@"cell.type.bank.name"]) {
        NSLog(@"选择银行");
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
```

