//
//  FactoryTableViewCell.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "FactoryTableViewCell.h"

@implementation FactoryTableViewCell

+ (BaseTableViewCell *)creatTableViewCell:(BaseModel *)model{
    //1、将model类名转成字符串
    NSString *name = NSStringFromClass([model class]);
    //2、获取要创建的cell的类名
    NSString *nameCell = [name stringByAppendingString:@"Cell"];
    Class cellClass = NSClassFromString(nameCell);
    //3、创建cell对象
    BaseTableViewCell *cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    //4、赋值
    [cell setDataWithModel:model];
    //5、返回cell
    return cell;
}

+ (BaseTableViewCell *)creatTableViewCell:(BaseModel *)model tableView:(UITableView *)tabelView indexPath:(NSIndexPath *)indexPath{
    //将模型转化为字符串
    NSString *name = NSStringFromClass([model class]);
    //从重用池中拿到cell
    BaseTableViewCell *cell = [tabelView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];
    [cell setDataWithModel:model];
    return cell;
}

@end
