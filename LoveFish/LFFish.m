//
//  Finish.m
//  LoveFish
//
//  Created by luowanglin on 2018/3/26.
//  Copyright © 2018年 com.luowanglin. All rights reserved.
//

#import "LFFish.h"

@implementation LFFish
// 68:83   41:46   27:37
// 81:98   50:55   31:43
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initElemetLayout];
    }
    return self;
}

- (void)initElemetLayout
{
    _tails = [NSMutableArray array];
    _eyes = [NSMutableArray array];
    _swimReds = [NSMutableArray array];
    _swimBlues = [NSMutableArray array];
    _lives = [NSMutableArray array];
    
    _body = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width * 0.6, self.frame.size.height)];
    _body.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_body];
    
    _tail = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_body.frame) + 5.0, 0.0, self.frame.size.width * 0.4, self.frame.size.height)];//40 45
    _tail.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_tail];
    
    _eye = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
    _eye.center = _body.center;
    _eye.contentMode = UIViewContentModeScaleAspectFit;
    [_body addSubview:_eye];
}

@end
