//
//  Student.h
//  runtimetest
//
//  Created by 胡杨林 on 16/10/8.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

-(void)study:(NSString *)subject andRead:(NSString *)bookName;
-(void)study:(NSString *)subject :(NSString *)bookName;

@end
