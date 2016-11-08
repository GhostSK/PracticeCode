//
//  MLSoftMax.m
//  Softmax识别数字
//
//  Created by 胡杨林 on 16/10/27.
//  Copyright © 2016年 胡杨林. All rights reserved.
//

#import "MLSoftMax.h"

@implementation MLSoftMax

-(id)initWithLoopNum:(int)loopNum
                 dim:(int)dim
                type:(int)type
                size:(int)size
         descentRate:(double)rate{
    self = [super init];
    if (self) {
        _iterNum = loopNum ==0? 500 : loopNum;
        _dim = dim;
        _kType = type;
        _randSize = size == 0? 100 : size;
        _descentRate = rate==0? 0.01:rate;
        _bias = malloc(sizeof(double)* type);
        _theta = malloc((sizeof(double) * type * dim));
        double fillNum = 0.0f;
        vDSP_vfillD(&fillNum, _bias, 1, type);
        _cnn = [[MLCnn alloc]init];
        
    }
    return self;
}

-(void)dealloc{
    if (_bias != NULL) {
        free(_bias);
        _bias = NULL;
    }
    if (_theta != NULL) {
        free(_theta);
        _theta = NULL;
    }
    if (_randomX != NULL) {
        free(_randomX);
        _randomX = NULL;
    }
    if (_randomY != NULL) {
        free(_randomY);
        _randomY = NULL;
    }
}

-(void)randomPick:(int)maxSize{
    long rNum = random();
    for (int i = 0; i < _randSize; i++) {
        _randomX[i] = _image[(rNum + i)%maxSize];
        _randomY[i] = _label[(rNum + i)% maxSize];
    }
}

-(double *)MaxPro:(double *)index{
    double maxNum = 0;
    vDSP_maxvD(index, 1, &maxNum, _kType);
    
    double sum = 0;
    for (int i = 0; i < _kType; i++) {
        index[i] -= maxNum;
        index[i] = expl(index[i]);
        sum += index[i];
    }
    vDSP_vsdivD(index, 1, &sum, index, 1, _kType);
    return index;
}

-(void)updateModel:(double *)index currentPos:(int)pos{
    for (int i = 0; i < _kType; i++) {
        double delta;
        if (i != _randomY[pos]) {
            delta = 0.0 - index[i];
        }else{
            delta = 1.0 - index[i];
        }
        
        _bias[i] += _descentRate * delta;
        double loss = _descentRate * delta / _randSize;
        double *decay = malloc(sizeof(double) * _dim);
        vDSP_vsmulD(_randomX[pos], 1, &loss, decay, 1, _dim);
        double *backLoss = malloc(sizeof(double) * _dim);
        vDSP_vsmulD(_theta + i * _dim, 1, &loss, backLoss, 1, _dim);
        [_cnn backPropagation:backLoss];
        vDSP_vaddD((_theta + i * _dim), 1, decay, 1, (_theta + i * _dim), 1, _dim);
        if (decay != NULL) {
            free(decay);
            decay = NULL;
        }
    }
}

-(void)train{
    _randomX = malloc(sizeof(double) * _randSize);
    _randomY = malloc(sizeof(int) * _randSize);
    double *index = malloc(sizeof(double) * _kType);
    for (int i = 0; i < _iterNum; i++) {
        [self randomPick:_trainNum];
        for (int j = 0; j < _randSize; j++) {
            //calculate wx+b
            _randomX[j] = [_cnn filterImage:_randomX[j] state:YES];
            vDSP_mmulD(_theta, 1, _randomX[j], 1, index, 1, _kType, 1, _dim);
            vDSP_vaddD(index, 1, _bias, 1, index, 1, _kType);
            //valulate exp(wx + b) / sum(exp(wx + b))
            index = [self MaxPro:index];
            [self updateModel:index currentPos:j];
        }
        if (i % 100 == 0) {
            [self testModel];
        }
    }
    if (index != NULL) {
        free(index);
        index = NULL;
    }
}

-(void)saveTrainDataToDisk{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *thetaPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingString:@"/Theta.txt"];
    NSData *data = [NSData dataWithBytes:_theta length:sizeof(double) * _dim * _kType];
    [fileManager createFileAtPath:thetaPath contents:data attributes:nil];
    
    NSString *biasPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingString:@"/bias.txt"];
    data = [NSData dataWithBytes:_bias length:sizeof(double) * _kType];
    [fileManager createFileAtPath:biasPath contents:data attributes:nil];
}

-(void)testModel{
    [self randomPick:_trainNum];
    double correct = 0;
    for (int i = 0; i < _randSize; i++) {
        int pred = [self predict:_randomX[i]];
        if (pred == _randomY[i]) {
            correct++;
        }
    }
    printf("%f%%\n",correct / _randSize * 100.0);
}
-(int)predict:(double *)image{
    double maxNum = 0;
    vDSP_Length label = 0;
    double *index = malloc(sizeof(double) * _kType);
    double *input = [_cnn filterImage:image state:NO];
    vDSP_mmulD(_theta, 1, input, 1, index, 1, _kType, 1, _dim);
    vDSP_vaddD(index, 1, _bias, 1, index, 1, _kType);
    vDSP_maxviD(index, 1, &maxNum, &label, _kType);
    return (int)label;
}

-(int)predict:(double *)image withOldTheta:(double *)theta andBias:(double *)bias{
    double maxNum = 0;
    vDSP_Length label = 0;
    double *index = malloc(sizeof(double) * _kType);
    vDSP_mmulD(theta, 1, image, 1, index, 1, _kType, 1, _dim);
    vDSP_vaddD(index, 1, bias, 1, index, 1, _kType);
    vDSP_maxviD(index, 1, &maxNum, &label, _kType);
    return (int)label;
}
-(void)updateModel:(double *)image label:(int)label{
    double *index = malloc(sizeof(double) * _kType);
    double *input = [_cnn filterImage:image state:YES];
    vDSP_mmulD(_theta, 1, input, 1, index, 1, _kType, 1, _dim);
    vDSP_vaddD(index, 1, _bias, 1, index, 1, _kType);
    index = [self MaxPro:index];
    for (int i = 0; i < _kType; i++) {
        double delta;
        if (i != label) {
            delta = 0.0 - index[i];
        }else{
            delta = 1.0 - index[i];
        }
        _bias[i] += _descentRate * delta;
        double loss = _descentRate * delta;
        double *decay = malloc(sizeof(double ) * _dim);
        vDSP_vsmulD(image, 1, &loss, decay, 1, _dim);
        double *backLoss = malloc(sizeof(double)* _dim);
        vDSP_vsmulD((_theta + i * _dim), 1, &loss, backLoss, 1, _dim);
        [_cnn backPropagation:backLoss];
        vDSP_vaddD((_theta + i * _dim), 1, decay, 1, (_theta + i * _dim), 1, _dim);
        if (decay != NULL) {
            free(decay);
            decay = NULL;
        }
    }
    if (index != NULL) {
        free(index);
        index = NULL;
    }
}



@end




















