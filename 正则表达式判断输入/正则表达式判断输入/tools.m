//
//  tools.m
//  正则表达式判断输入
//
//  Created by 胡杨林 on 16/11/2.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "tools.h"

@implementation tools

+(BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)validateMobile:(NSString *)mobile{
    NSString *phoneRegex = @"^((13[0-9])|(15|^4,\\D])|(18[0,0-9]]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
+(BOOL)validatePhone:(NSString *)phone{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+(BOOL)newvalidatePhone:(NSString *)phone{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5|[0-35-9]|8[025-9])\\d{8}$";
    
    //移动
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //联通
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //电信
    NSString *CT = @"^1(33|53|8[09][0-9]|349)\\d{7]$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    
    return ([regextestmobile evaluateWithObject:phone] || [regextestcm evaluateWithObject:phone] ||[regextestcu evaluateWithObject:phone] || [regextestct evaluateWithObject:phone]);
}
+(BOOL)validateIdentityCard:(NSString *)identityCard{
    if (identityCard.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+(BOOL)validateCarType:(NSString *)CarType{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";   //至少一个汉字
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}

+(BOOL)validateCarNo:(NSString *)carNo{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

+(BOOL)validateNickName:(NSString *)nickname{
    NSString *nickNameRegex = @"^[\u4e00-\u9fa5]{4,8}$"; //4-8个汉字
    NSPredicate *NickNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickNameRegex];
    return [NickNamePredicate evaluateWithObject:nickname];
}

@end














