//
//  tools.h
//  正则表达式判断输入
//
//  Created by 胡杨林 on 16/11/2.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tools : NSObject
//判断输入是否为邮箱
+(BOOL) validateEmail:(NSString *)email;
//判断输入是否为手机号
+(BOOL)validateMobile:(NSString *)mobile;

+(BOOL)validatePhone:(NSString *)phone;
//加强版手机号判断
+(BOOL)newvalidatePhone:(NSString *)phone;
//车牌号判断
+(BOOL)validateCarNo:(NSString *)carNo;
//车型判断
+(BOOL)validateCarType:(NSString *)CarType;
//昵称
+(BOOL)validateNickName:(NSString *)nickname;
//身份证号
+(BOOL)validateIdentityCard:(NSString *)identityCard;




@end
