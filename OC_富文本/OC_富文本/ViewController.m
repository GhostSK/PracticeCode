//
//  ViewController.m
//  OC_富文本
//
//  Created by 胡杨林 on 16/10/27.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
// NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
// NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
// NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
// NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
// NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
// NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
// NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
// NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
// NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
// NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
// NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
// NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
// NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
// NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
// NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
// NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
// NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
// NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
// NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
// NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
// NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
     */
    UILabel *myFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 440, 50)];
    [self.view addSubview:myFirstLabel];
//    NSMutableAttributedString  初始化
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"一二三四五六七八九十ABCDEFGHIJ0123456789" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    /*
     添加属性
     为某一范围内文字设置多个属性
     -(void)setAttributes:(NSDictionary 8)attrs range:(NSRange)range;
     为某一范围内文字添加某个属性
     -(void)addAttributes:(NSString *)name value:(id)value range:(NSRange)range;
     为某一范围内文字添加多个属性
     -(void)addAttributes:(NSDictionary *)attrs range:(NSRange)range;
     移除某范围内的某个属性
     -(void)removeAttribute:(NSString *)name range:(NSRange)range;
     */
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSBackgroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(0, 2)];
    //范围0-1，字体颜色红色 背景颜色蓝色
    [attributedString addAttributes:@{NSStrikethroughStyleAttributeName:@(9)} range:NSMakeRange(2, 5)];
    //范围2-6  两行删除线
    [attributedString addAttributes:@{NSStrikethroughStyleAttributeName:@(2),NSStrikethroughColorAttributeName:[UIColor greenColor]} range:NSMakeRange(9, 3)];
    //范围9-11 绿色删除线
    [attributedString addAttributes:@{NSStrokeColorAttributeName:[UIColor orangeColor],NSStrokeWidthAttributeName:@(2),NSFontAttributeName:[UIFont systemFontOfSize:30]} range:NSMakeRange(13, 4)];
    //范围13-16 橙色放大空心字
    [attributedString addAttributes:@{NSStrokeColorAttributeName:[UIColor cyanColor],NSStrokeWidthAttributeName:@(-2),NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(17, 3)];
    //范围17-19  荧光字
    [attributedString addAttributes:@{NSExpansionAttributeName:@(1),NSObliquenessAttributeName:@(1)} range:NSMakeRange(20, 2)];
    //范围20-21 斜体+粗体
    [attributedString addAttributes:@{NSKernAttributeName:@(30)} range:NSMakeRange(20, 1)];
    //字符间距 0代表间距禁用
    //这是添加属性的方法
    
    myFirstLabel.attributedText = attributedString;
    
    UITextField *myFirstTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 200, 400, 60)];
    [self.view addSubview:myFirstTextField];
    myFirstTextField.attributedText = attributedString;
    
    UITextView *myFirstTextView = [[UITextView alloc]initWithFrame:CGRectMake(60, 300, 300, 60)];
    [self.view addSubview:myFirstTextView];
    myFirstTextView.attributedText = attributedString;
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
