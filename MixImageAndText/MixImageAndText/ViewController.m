//
//  ViewController.m
//  MixImageAndText
//
//  Created by 胡杨林 on 2017/11/2.
//  Copyright © 2017年 胡杨林. All rights reserved.
//

#import "ViewController.h"
#import "MytextAttachment.h"


@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textview;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *ShowRichtextLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 80, 414, 200)];
    self.textview.delegate = self;
    self.textview.backgroundColor = [UIColor lightGrayColor];
    [self.textview setFont:[UIFont systemFontOfSize:30]];
    [self.view addSubview:self.textview];
    
    UILabel *showtext = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, 80, 50)];
    showtext.text = @"显示效果:";
    showtext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showtext];
    
    self.ShowRichtextLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 290, 414 - 80, 50)];
    [self.view addSubview:self.ShowRichtextLabel];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 350, 414, 150)];
    self.textLabel.numberOfLines = 0;
    [self.view addSubview:self.textLabel];
    
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];


    
    MytextAttachment *face = [[MytextAttachment alloc] init];
    face.image = [UIImage imageNamed:@"3"];
    [face setBounds:CGRectMake(0, 0, 50, 50)];
    NSMutableAttributedString *attrstr = (NSMutableAttributedString *)[NSAttributedString attributedStringWithAttachment:face];
    [attrstr appendAttributedString:textAttrStr];
    self.textLabel.attributedText = attrstr;
    [self.textview.textStorage insertAttributedString:textAttrStr atIndex:0];
    
    NSInteger width = self.view.frame.size.width;
    UIView *btncontainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - width / 5 * 2, self.view.frame.size.width, width / 5 * 2)];
    [self.view addSubview:btncontainer];
    for (int i = 0; i < 10; i++) {
        int x = i % 5;
        int y = i / 5;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width * x / 5, width / 5 * y, width / 5, width / 5)];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(FaceActionwithButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]] forState:UIControlStateNormal];
        [btncontainer addSubview:btn];
    }
    
    
    
}

-(void)FaceActionwithButton:(UIButton *)btn{
    NSInteger tag = btn.tag - 1000;
    UIImage *ima = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",tag]];
    MytextAttachment *attach = [[MytextAttachment alloc] init];
    attach.image = ima;
    attach.faceName = [NSString stringWithFormat:@"|face0%ld|",tag];
    [attach setBounds:CGRectMake(0, 0, self.textview.font.pointSize, self.textview.font.pointSize)];
    NSLog(@"%f",self.textview.font.pointSize);
    NSAttributedString *attrstr = [NSAttributedString attributedStringWithAttachment:attach];
    [self.textview.textStorage insertAttributedString:attrstr atIndex:self.textview.selectedRange.location];
    self.textview.selectedRange = NSMakeRange(self.textview.selectedRange.location + 1, self.textview.selectedRange.length);
    [self.textview setFont:[UIFont systemFontOfSize:30]];
    [self textViewDidChange:self.textview];
}



-(void)textViewDidChange:(UITextView *)textView{
    NSMutableString *str = [[NSMutableString alloc] initWithString:self.textview.textStorage.string];
    __block NSUInteger base = 0;
    [self.textview.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textview.textStorage.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[MytextAttachment class]]) {
            MytextAttachment *attach = (MytextAttachment *)value;
            [str replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:attach.faceName];
            base += attach.faceName.length - 1;
        }
    }];
    self.ShowRichtextLabel.attributedText = self.textview.textStorage;
    self.textLabel.text = str;
    NSMutableArray *arr = (NSMutableArray *)[str componentsSeparatedByString:@"|"];
    if (arr.count > 1) {  //当数组删除为空的时候，arr会被判定为singleObjectAarray，此时移除元素会报错
        for (int i = 0; i <arr.count; i++) {
            NSString *temp = arr[i];
            if ([temp isEqualToString:@""]) { //连续输入表情时会产生空字符串分割，排除
                [arr removeObject:temp];
            }
        }
    }
    NSLog(@"arr = %@\n",arr);
}
/*
 - (NSString *)getPlainString {
 NSMutableString *plainString = [NSMutableString stringWithString:self.string];
 __block NSUInteger base = 0;
 
 
 
 [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
 options:0
 usingBlock:^(id value, NSRange range, BOOL *stop) {
 if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
 [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
 withString:((EmojiTextAttachment *) value).emojiTag];
 base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
 }
 }];
 
 return plainString;
 }
 */


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textview endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
