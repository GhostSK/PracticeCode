//
//  MyTableViewCell.m
//  cell点击展开demo
//
//  Created by 胡杨林 on 17/1/4.
//  Copyright © 2017年 胡杨林. All rights reserved.
//

#import "MyTableViewCell.h"

@interface MyTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@end



@implementation MyTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mytableview];
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.mytableview dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    NSInteger num = indexPath.row;
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld个cell",num];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger num = indexPath.row;
    NSLog(@"选择了第%ld个子cell",num);
}

-(UITableView *)mytableview{
    if (!_mytableview) {
        self.mytableview = [[UITableView alloc]init];
        self.mytableview.delegate = self;
        self.mytableview.dataSource = self;
    }
    _mytableview.frame = CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height - 80);
    return _mytableview;
}
-(void)A1{
    _mytableview.frame = CGRectMake(0, 80, self.bounds.size.width, self.bounds.size.height - 80);
    [_mytableview reloadData];
}

@end
