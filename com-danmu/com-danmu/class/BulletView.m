//
//  BulletView.m
//  com-danmu
//
//  Created by wgz on 2016/12/8.
//  Copyright © 2016年 fiskz. All rights reserved.
//

#import "BulletView.h"

#define  padding 10

@interface BulletView()

@property (nonatomic,strong) UILabel * lbComment;

@end

@implementation BulletView

//初始化弹幕
-(instancetype)initWithComment:(NSString *) comment
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attr].width;
        self.bounds = CGRectMake(0, 0, width + 2 * padding, 30);
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(padding, 0, width, 30);
    }
    return self;
}

//开始动画
-(void) startAnimation
{
    //根据弹幕的长度执行动画效果
    //根据 V= s/t ，时间相同的情况下，距离越长，速度越快
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //弹幕开始
    if(self.moveStatusBlock)
    {
        self.moveStatusBlock(Start);
    }
    //t = s/v;
    CGFloat speed = wholeWidth/duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    
    [self performSelector:@selector(EnterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^
    {
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished)
    {
        //弹幕结束
        [self removeFromSuperview];
        if(self.moveStatusBlock)
        {
            self.moveStatusBlock(End);
        }
    }];
}

-(void) EnterScreen
{
    if(self.moveStatusBlock)
    {
        self.moveStatusBlock(Enter);
    }
}

//结束动画
-(void) stopAnimation
{
    //停止动画
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview ];
}

-(UILabel *) lbComment
{
    if(!_lbComment)
    {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor blackColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
    }
    [self addSubview:_lbComment];
    return _lbComment;
}

@end
