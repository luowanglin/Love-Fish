//
//  ViewController.m
//  LoveFish
//
//  Created by luowanglin on 16/1/14.
//  Copyright © 2016年 com.luowanglin. All rights reserved.
//768 x 1024

#import "ViewController.h"


@interface ViewController ()
{
    UIView *motherFish;
    UIImageView *motherBody;
    UIImageView *motherTail;
    UIImageView *motherEye;
    UIView *childFish;
    UIImageView *childBody;
    UIImageView *childTail;
    UIImageView *childEye;
    
    NSMutableArray *bigTails;
    NSMutableArray *bigEyes;
    NSMutableArray *bigSwimS;
    NSMutableArray *bigSwimBlueS;
    NSMutableArray *babyEyes;
    NSMutableArray *babyTails;
    NSMutableArray *babyFades;
    NSMutableArray *dustImgs;
    NSMutableArray *fruits;
    
    int motherFishEatCount;//鱼妈妈吃到的果实
    
   
    NSMutableArray *shapLayerS;//海葵果实母体
    CADisplayLink *displaylink;//layer 动画链
    CAShapeLayer *shaplayer;//海葵layer （operation layer）
//    CAShapeLayer *shaplaye;
//    CFTimeInterval firstTime;//
    int height;//设备高度
    int width;//设备宽度
//    int loopcount;
    int rootXs[50];//绘制海葵起点x坐标
    int endYs[50];//绘制海葵结束点y坐标
    int offset;//海葵摆动位移
    
//    NSTimer *timerMoveFish;
    int count;//为dust的左右移动 记录sin值
    CGPoint fishMoveDestinPoint;//记录点击位置 鱼的移动位置
    
//    BOOL islive;//
    UILabel *score;//用于显示得分的label
    int scoreCount;//等分总数
    CATextLayer *lifeLabel;//用于CALayer层的生命值显示
    int lifecount;
    int lifeValue;
    BOOL isTouch;//是否有被点击 （防止随机移动方法的调用干扰）
    BOOL isStopFishRandomMove;//记录随机移动是否可执行
    
    UIImage *buttonImage;//按钮背景图片 （使用createbackgroundimage方法描绘）
    NSTimer *dustMoveTimerBegin;//欢迎界面
    UIView *viewFace;//欢迎页面容器
    
    UILabel *logoLabel;//开始页标题
    UILabel *labChildSay;//小鱼语句label
    UILabel *labMomSay;//鱼妈妈的语句label
    UIButton *startButton;//开始按钮
    BOOL iswellcomeNoTouch;//开始页面标志是否响应touch begin方法
    
    
    CATextLayer *orageTextLayer;//开始页面橘黄提醒layer
    CATextLayer *blueTextLayer;//开始页面蓝色提醒layer
    CAShapeLayer *orageImagLayer;//开始页面橘黄image layer
    CAShapeLayer *blueImagLayer;//开始页面蓝色image layer
    
    
    //计时器
    NSTimer *timerMoveFish;
    NSTimer *dustMoveTimer;
    NSTimer *blueFruitTimer;
    NSTimer *eatFoodColliTimer;
    NSTimer *foodMoveTimer;
    NSTimer *lifeTimer;
    
    //游戏结束
    UIView *gameOverView;
    
    CADisplayLink *displayLi;//点击画圆动画
    CAShapeLayer *eatlayer;
    
    AVPlayer *player;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scoreCount = 0;
    count = 0;
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    for (int i = 0; i < 50; i++) {
        int rootX = i * 21 + (rand() % 9) * 2;
        int endY = height - rand() % 100 - 200;
        rootXs[i] = rootX;
        endYs[i] = endY;
    }
    [self wellcomeInterface];
//    [self initForBegin];
//    [self startDisplay];


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    isTouch = YES;
    for (UITouch *touch in touches) {
        fishMoveDestinPoint = [touch previousLocationInView:self.view];
        isStopFishRandomMove = YES;
        if (!iswellcomeNoTouch) {
            
//            [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                [motherFish setTransform:(CGAffineTransformMakeRotation([self autoRotateAngleWithDistin:fishMoveDestinPoint]))];
//                [childFish setTransform:(CGAffineTransformMakeRotation([self autoRotateAngleWithDistin:fishMoveDestinPoint]))];
//                motherFish.center = fishMoveDestinPoint;
//            } completion:^(BOOL finished) {
//                //            [self eatFoodCollision];
//                [motherFish setTransform:(CGAffineTransformIdentity)];
//                [childFish setTransform:(CGAffineTransformIdentity)];
//                isTouch = NO;
//            }];
            [UIView animateWithDuration:1.f animations:^{
                [motherFish setTransform:(CGAffineTransformMakeRotation([self autoRotateAngleWithDistin:fishMoveDestinPoint]))];
                [childFish setTransform:(CGAffineTransformMakeRotation([self autoRotateAngleWithDistin:fishMoveDestinPoint]))];
                motherFish.center = fishMoveDestinPoint;

            } completion:^(BOOL finished) {
                [motherFish setTransform:(CGAffineTransformIdentity)];
                [childFish setTransform:(CGAffineTransformIdentity)];
                isTouch = NO;
            }];
        }
    }
}

/*
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        fishMoveDestinPoint = [touch previousLocationInView:self.view];
        isStopFishRandomMove = YES;
//        [UIView animateWithDuration:1.f animations:^{
//            motherFish.center = fishMoveDestinPoint;
//        }];
        [UIView animateWithDuration:1.f delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            motherFish.center = fishMoveDestinPoint;
        } completion:^(BOOL finished) {
            [self eatFoodCollision];
        }];

    }
}
*/

//获取屏幕点击位置的角度
- (double)getAngleLocation:(CGPoint)locationPoint{
    double pi = atan2(-motherFish.center.y + self.view.bounds.size.height/2,motherFish.center.x - self.view.bounds.size.width/2);
    double angle = pi * 180 / M_PI;
    NSLog(@"motherfish:%lf",angle);
        return angle;
}

//实现开始展示及初始化
- (void)startDisplay{
    displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAction:)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

//实现展示链 的方法
- (void)displayAction:(CADisplayLink*)display{
    
    shaplayer.path = [[self pathWithInterval:display.timestamp]CGPath];
}

//添加CAShapelayer 及初始化
- (void)addShapLayerWithOpacity:(CGFloat)opacity{
    shaplayer = [CAShapeLayer layer];
    shaplayer.frame = CGRectMake(0, 0, 400, 368);
    shaplayer.fillColor = [[UIColor clearColor]CGColor];
    shaplayer.lineWidth = 20;
    shaplayer.strokeColor = [[[UIColor purpleColor]colorWithAlphaComponent:opacity]CGColor];
    shaplayer.lineCap = @"round";

    shapLayerS = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        NSString *blue = @"blue";
        NSString *red = @"fruit";
        int randFruit = arc4random() % 10;
        layer.contents = (__bridge id _Nullable)[[UIImage imageNamed:[NSString stringWithFormat:@"%@",randFruit > 3 ? blue : red]]CGImage];
        layer.frame = CGRectMake(rootXs[i*5], endYs[i*5]+70, 18, 18);
        layer.opacity = (arc4random() % 10) * 0.1;
        [shaplayer addSublayer:layer];
        [shapLayerS addObject:layer];
    }
    
    [self.view.layer addSublayer:shaplayer];
}

//贝塞尔曲线路径的实现
- (UIBezierPath*)pathWithInterval:(NSTimeInterval)intervar{
    UIBezierPath *beziPath = [[UIBezierPath alloc]init];
    offset = sin(intervar) * 100;
    
    for (int i = 0;i < 10;i++) {
        CAShapeLayer *shapla = [shapLayerS objectAtIndex:i];
        shapla.frame = CGRectMake(rootXs[i*5] + offset, endYs[i*5]+100, 20, 20);
    }
    for (int i = 0; i < 50; i++) {
        [beziPath moveToPoint:CGPointMake(rootXs[i], height)];
        [beziPath addQuadCurveToPoint:CGPointMake(rootXs[i] + offset, endYs[i]) controlPoint:CGPointMake(rootXs[i], height - 150)];
    }
    return beziPath;
}

//初始化
- (void)initForBegin{
    
    UIImageView *imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.jpg"]];
    imgview.frame = CGRectMake(0, 0, 1024, 768);
    [self.view addSubview:imgview];
    
//fruit 的初始化
    fruits = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *blue = @"blue";
        NSString *red = @"fruit";
        int randFruit = arc4random() % 10;
        UIImageView *bluefruit = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",randFruit > 3 ? red : blue]]];
        bluefruit.accessibilityIdentifier = [NSString stringWithFormat:@"%@",randFruit > 3 ? red : blue];
        int random = arc4random() % 49;
        bluefruit.center = CGPointMake(rootXs[random], endYs[random]);
        [fruits addObject:bluefruit];
    }
 
//得分标榜
    score = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-200, 20, 400, 50)];
    score.text = @"score:0";
    score.font = [UIFont  fontWithName:@"ArialRoundedMTBold" size:50];
    score.textAlignment = NSTextAlignmentCenter;
    score.textColor = [UIColor whiteColor];
    [self.view addSubview:score];

//声明值标榜
    [self addShapLayerWithOpacity:0.6];//提前调用此方法 一初始化shaplayer
    
    lifeLabel = [[CATextLayer alloc]init];
    [lifeLabel setFont:@"ArialRoundedMTBold"];
    [lifeLabel setFontSize:50];
    [lifeLabel setFrame:CGRectMake(width/2-50, height-100, 100, 50)];
    [lifeLabel setWrapped:YES];
    [lifeLabel setString:@"0"];
    [lifeLabel setAlignmentMode:kCAAlignmentCenter];
    [lifeLabel setForegroundColor:[[UIColor whiteColor] CGColor]];
    [lifeLabel setContentsScale:[UIScreen mainScreen].scale];
    [shaplayer addSublayer:lifeLabel];

    
//初始化浮游物、小鱼、鱼妈妈
    [self initWithMotherFishAddTo:self.view bodyRect:CGRectMake(0, 0, 50, 57) tailRect:CGRectMake(35, 6, 40, 45) fishContainer:CGRectMake(200, 400, 80, 60) fishEyeRect:CGRectMake(0, 0, 10, 10) rotateAngle:0];
    [self initWithChildFishAddTo:self.view bodyRect:CGRectMake(0, 0, 35, 40) tailRect:CGRectMake(28, 5, 20, 30) fishContainer:CGRectMake(200, 400, 60, 40) fishEyeRect:CGRectMake(0, 0, 8, 8) rotateAngle:0];
    [self initWithDustNumber:30];

//计时器 鱼妈妈的随机移动 浮游物的左右移动 果实的的生成 碰撞检测 果实的向上移动
    timerMoveFish = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(moveFish) userInfo:nil repeats:YES];
    [timerMoveFish fire];
    dustMoveTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(dustMoveAction) userInfo:nil repeats:YES];
    [dustMoveTimer fire];
    blueFruitTimer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(foodCreateAction) userInfo:nil repeats:YES];
    [blueFruitTimer fire];
    eatFoodColliTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(eatFoodCollision) userInfo:nil repeats:YES];
    [eatFoodColliTimer fire];
    foodMoveTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(foodMoveAction) userInfo:nil repeats:YES];
    [foodMoveTimer fire];
    lifeTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeLife) userInfo:nil repeats:YES];
    [lifeTimer fire];
    
  /*
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = lifeLabel.bounds;
    [lifeLabel.layer addSublayer:textLayer];
    textLayer.foregroundColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    UIFont *font = [UIFont fontWithName:@"ArialRoundedMTBold" size:50];
    CFStringRef fontname = (__bridge CFStringRef)(font.fontName);
    CGFontRef fontRef = CGFontCreateWithFontName(fontname);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    textLayer.string = @"0";
  */
}

//改变生命值时间
- (void)changeLife{
    
    if (lifecount > 18) {
        lifecount = 0;
    }else{
        lifecount ++;
    }
    
//    lifeValue = lifecount % 21 + 1;
    [lifeLabel setString:[NSString stringWithFormat:@"%d",19-lifecount]];
    
    if (lifecount == 19) {
        NSLog(@"game over!");
        [self gameOver];
    }else{
        childBody.image = babyFades[lifecount];
    }
}

//实现鱼的随机动画
- (void)moveFish{
    if (isStopFishRandomMove && !iswellcomeNoTouch) {
        isTouch = YES;
        [UIView animateWithDuration:2.f animations:^{
            motherFish.center = fishMoveDestinPoint;
            childFish.center = fishMoveDestinPoint;
        } completion:^(BOOL finished) {
           
            isTouch = NO;
        }];
        isStopFishRandomMove = NO;
    }else{
        CGFloat randomX = arc4random() % 300 + 300;
        CGFloat randomY = arc4random() % 100 + 300;
        isTouch = NO;

        [UIView animateWithDuration:2.f animations:^{
            motherFish.center = CGPointMake(randomX, randomY);
            childFish.center = CGPointMake(randomX + 60, randomY);
        } completion:^(BOOL finished) {
            isTouch = YES;
        }];
    }
}

//自动旋转头部角度
- (CGFloat)autoRotateAngleWithDistin:(CGPoint)tapPoint{
    CGFloat angle = 0;
    if (motherFish.center.x < tapPoint.x && motherFish.center.y > tapPoint.y) {
        angle = -( M_PI+M_PI_4);
    }else if(motherFish.center.x < tapPoint.x && motherFish.center.y < tapPoint.y){
        angle = M_PI_4+M_PI;
    }else if (motherFish.center.x > tapPoint.x && motherFish.center.y > tapPoint.y){
        angle = M_PI_4;
    }else{
        angle = -M_PI_4;
    }
    
    return angle;
}

//浮游物的左右移动
- (void)dustMoveAction{
    count++;//提供变换的sin值 为dust左右摆动
    int dustMoveOffSet = sin(count)*40;
    [UIView animateWithDuration:1.f animations:^{
        for (UIImageView *imgview in dustImgs) {
            CGPoint point = imgview.center;
            point.x += dustMoveOffSet;
            imgview.center = point;
        }
    }];
    
}

//食物的产生
-(void)foodCreateAction{
    int coun = 0;
    for (UIImageView *imgview in fruits) {
        if (imgview.tag == 0 && coun <= 10) {
            coun++;
            int random = arc4random() % 49;
            int randomY = arc4random() % 50 + 10;
            int random1 = arc4random() % 5 + 2;
//            int randomup = arc4random() % 10 + 5;
            imgview.center = CGPointMake(rootXs[random], 700-randomY);
            [imgview setTransform:(CGAffineTransformMakeScale(0.01, 0.01))];
            [UIView animateWithDuration:random1 animations:^{
                [imgview setTransform:(CGAffineTransformMakeScale(1, 1))];
            } completion:^(BOOL finished) {
                imgview.tag = 1;
            }];
            [self.view addSubview:imgview];
        }
        
    }
}

//捕食物的碰撞检测
- (void)eatFoodCollision{
    if (!isTouch) {
        for (UIImageView *food in fruits) {
            if (food.tag == 1) {
                double distance = [self caculaterBetweenPoint:food.center pointT:motherFish.center];
                if (distance < 40) {
                    food.tag = 0;
                    if ([food.accessibilityIdentifier  isEqual: @"blue"]) {
                        scoreCount += 2;
                    }else{
                        scoreCount++;
                    }
                    score.text = [NSString stringWithFormat:@"score:%d",scoreCount];
                    lifecount = 0;
                    if (motherFishEatCount < 7) {
                        motherFishEatCount++;
                    }
                    [self playSound];
                        [UIView animateWithDuration:0.5 animations:^{
                            [food setTransform:(CGAffineTransformMakeScale(5, 5))];
                        } completion:^(BOOL finished) {
                            
                            [food removeFromSuperview];
                            motherBody.image = bigSwimBlueS[motherFishEatCount];
                        }];
                }
            }
        }
    }else if ([self caculaterBetweenPoint:childFish.center pointT:motherFish.center] == 10){
        lifecount -= motherFishEatCount;
        if (lifecount < 0) {
            lifecount = 0;
        }
        motherFishEatCount = 0;
    }
    
    
}

//播放声音
- (void)playSound{
    NSString *str = [[NSBundle mainBundle]pathForResource:@"Bite.wav" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:str];
    player = [[AVPlayer alloc]initWithURL:url];
    [player play];
}

//食物的移动
- (void)foodMoveAction{
    for (UIImageView *food in fruits) {
        if (food.tag == 1) {
            if (food.center.y > 10) {
                int random = arc4random() % 5;
                int randomX = sin(arc4random());
                [UIView animateWithDuration:random/0.1*random delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    food.center = CGPointMake(food.center.x+randomX, food.center.y - random);
                } completion:^(BOOL finished) {
                    
                }];

            }else{
                [food removeFromSuperview];
                food.tag = 0;
            }
            
        }
    }
}

//计算两点间的距离
- (double)caculaterBetweenPoint:(CGPoint)point1 pointT:(CGPoint)point2{
    return sqrt(pow(point1.x - point2.x-10, 2) + pow(point1.y - point2.y, 2));
}

//child fish 的初始化
- (void)initWithChildFishAddTo:(UIView*)superview bodyRect:(CGRect)rectB tailRect:(CGRect)rectT fishContainer:(CGRect)rectC fishEyeRect:(CGRect)rectE rotateAngle:(float)angle{
    babyEyes = [NSMutableArray array];
    for ( int i = 0; i < 2; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"babyEye%d",i]];
        if (img) {
            [babyEyes addObject:img];
        }
    }
    
    
    babyFades = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"babyFade%d",i]];
        if (img) {
            [babyFades addObject:img];
        }
    }
    
    babyTails = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"babyTail%d",i]];
        if (img) {
            [babyTails addObject:img];
        }
    }
    
    childFish = [[UIView alloc]initWithFrame:rectC];//200 400 60 40
    [superview addSubview:childFish];
    [childFish setTransform:(CGAffineTransformMakeRotation(angle))];
    
    childBody = [[UIImageView alloc]init];
    childBody.image = [UIImage imageNamed:@"babyFade0"];
    childBody.frame = rectB;//0 0 35 40
//    childBody.animationImages = babyFades;
//    childBody.animationDuration = 3.0;
//    childBody.animationRepeatCount = -1;
//    [childBody startAnimating];
    [childFish addSubview:childBody];
    
    childTail = [[UIImageView alloc]init];
    childTail.frame = rectT;//0 0 20 30
//    childTail.center = CGPointMake(childBody.center.x + 20, childBody.center.y);
    childTail.image = [UIImage imageNamed:@"babyTail0"];
    childTail.animationImages = babyTails;
    childTail.animationRepeatCount = -1;
    childTail.animationDuration = 1.0;
    [childTail startAnimating];
    [childFish addSubview:childTail];
    
    childEye = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"babyEye0"]];
    childEye.frame = rectE;//0 0 8 8
    childEye.center = CGPointMake(childBody.center.x, childBody.center.y);
    childEye.animationImages = babyEyes;
    childEye.animationRepeatCount = -1;
    childEye.animationDuration = 1.5;
    [childEye startAnimating];
    [childFish addSubview:childEye];

}

//mother fish 的初始化
- (void)initWithMotherFishAddTo:(UIView*)superview bodyRect:(CGRect)rectB tailRect:(CGRect)rectT fishContainer:(CGRect)rectC fishEyeRect:(CGRect)rectE rotateAngle:(float)angle{
    bigTails = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"bigTail%d",i]];
        if (img) {
            [bigTails addObject:img];
            
        }
    }
    
    bigEyes = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"bigEye%d",i]];
        if (img) {
            [bigEyes addObject:img];
        }
    }
    
    bigSwimS = [NSMutableArray array];
    for (int i =0; i < 8; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"bigSwim%d",i]];
        if (img) {
            [bigSwimS addObject:img];
        }
    }
    
    bigSwimBlueS = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"bigSwimBlue%d",i]];
        if (img) {
            [bigSwimBlueS addObject:img];
        }
    }

    motherFish = [[UIView alloc]initWithFrame:rectC];//200 400 80 60
    [superview addSubview:motherFish];
    isStopFishRandomMove = NO;
    [motherFish setTransform:(CGAffineTransformMakeRotation(angle))];
    
    motherBody = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bigSwim0"]];
    motherBody.frame = rectB;//50 57
    [motherFish addSubview:motherBody];
    
    
    motherTail = [[UIImageView alloc]initWithFrame:rectT];//40 45
    motherTail.image = [UIImage imageNamed:@"bigTail0"];
    [motherTail setAnimationImages:bigTails];
//    CGPoint point = motherBody.center;
//    point.x += 30;
//    motherTail.center = point;
    motherTail.animationDuration = 0.5;
    motherTail.animationRepeatCount = -1;
    [motherTail startAnimating];
    [motherFish addSubview:motherTail];
    
    motherEye = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"babyEye0"]];
    motherEye.frame = rectE;// 10 10
    motherEye.center = motherBody.center;
    motherEye.animationImages = bigEyes;
    motherEye.animationDuration = 2.f;
    motherEye.animationRepeatCount = -1;
    [motherEye startAnimating];
    [motherBody addSubview:motherEye];

}

//浮游物的初始化
- (void)initWithDustNumber:(int)number{
    NSMutableArray *dusts = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"dust%d",i]];
        if (img) {
            [dusts addObject:img];
        }
    }
    dustImgs = [NSMutableArray array];
    for (int i = 0;i < number;i++) {
        CGFloat x = arc4random() % 1000 + 40;
        CGFloat y = arc4random() % 750 + 10;
        int randomKind = arc4random() % 7;
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgview.center =  CGPointMake(x, y);
        imgview.image = dusts[randomKind];
        [self.view addSubview:imgview];
        [dustImgs addObject:imgview];
    }

}

//开始界面
- (void)wellcomeInterface{
    UIImageView *imgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    imgeView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:imgeView];
 
    iswellcomeNoTouch = YES;
    
    //创建开始按钮
    startButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self creatBackgroundImg];
    startButton.frame = CGRectMake(0, 0, 100, 50);
    startButton.center = CGPointMake(width/2, height-200);
    [startButton setTitle:@"start" forState:(UIControlStateNormal)];
    startButton.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
    [startButton setBackgroundImage:buttonImage forState:(UIControlStateNormal)];
    startButton.layer.masksToBounds = YES;
    startButton.layer.cornerRadius = 10.0;
    [startButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startAction:) forControlEvents:(UIControlEventTouchUpInside)];
  
    
    //logo 标题
    logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2-100, height - 730, 200, 100)];
    logoLabel.text = @"Glow";
    logoLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:80];
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:logoLabel];
    
    //创建提示语
    labChildSay = [[UILabel alloc]initWithFrame:CGRectMake(width/2 - 300, height - 400, 650, 50)];
    labChildSay.text = @"-Mom,night is coming,I'm a little afraid of..dark...";
    labChildSay.textAlignment = NSTextAlignmentCenter;
    labChildSay.textColor = [UIColor whiteColor];
    labChildSay.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
    [self.view addSubview:labChildSay];
    
    labMomSay = [[UILabel alloc]initWithFrame:CGRectMake(width/2 - 300, height - 360, 600, 50)];
    labMomSay.text = @"-Don't worry,I'll lighten the world for you.";
    labMomSay.textAlignment = NSTextAlignmentCenter;
    labMomSay.textColor = [UIColor whiteColor];
    labMomSay.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
    [self.view addSubview:labMomSay];
    
    //添加mother fish 和 child fish
    [self initWithMotherFishAddTo:self.view bodyRect:CGRectMake(0, 0, 100, 100) tailRect:CGRectMake(80, 18, 40, 70) fishContainer:CGRectMake(width/2-100, height-600, 150, 150) fishEyeRect:CGRectMake(0, 0, 15, 15) rotateAngle:M_PI_4];
    [self initWithChildFishAddTo:self.view bodyRect:CGRectMake(0, 0, 50, 50) tailRect:CGRectMake(40, 5, 20, 40) fishContainer:CGRectMake(width/2-30, height-500, 80, 50) fishEyeRect:CGRectMake(0, 0, 10, 10) rotateAngle:M_PI_4];
    
    
    [self addShapLayerWithOpacity:0.3];
   
    [self startDisplay];
   
    [self initWithDustNumber:60];
    //生成fruit layer
    [self creatLayerLabelTo:shaplayer context:@"you need energy to make it" frame:CGRectMake(width/2-165, height-80, 350, 30) newTextLayel:orageTextLayer];
    [self creatLayerImageTo:shaplayer WithName:@"fruit" frame:CGRectMake(width/2-180, height-80+8, 20, 20) imageShapeLayer:orageImagLayer];
    //生成blue fruit layer
    [self creatLayerLabelTo:shaplayer context:@"blue ones can make double" frame:CGRectMake(width/2-165, height-50, 350, 30) newTextLayel:blueTextLayer];
    [self creatLayerImageTo:shaplayer WithName:@"blue" frame:CGRectMake(width/2-180+3, height-50+8, 15, 15) imageShapeLayer:blueImagLayer];
    
    dustMoveTimerBegin = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(dustMoveAction) userInfo:nil repeats:YES];
    [dustMoveTimerBegin fire];
   
}

//创建button 背景图片
- (void)creatBackgroundImg{
    //创建rect 框架 -- 背景图片
    CGRect rect = CGRectMake(0, 0, 100, 100);
    //开始图形化
    UIGraphicsBeginImageContext(rect.size);
    //获得图形化上下文
    CGContextRef contex = UIGraphicsGetCurrentContext();
    //填充颜色为上下文
    CGContextSetFillColorWithColor(contex, [UIColor colorWithRed:0.26 green:0.52 blue:0.96 alpha:1.0].CGColor);
    //加入框架约束
    CGContextFillRect(contex, rect);
    //创建图片对象 从图形化上下文
    buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束图形化
    UIGraphicsEndImageContext();
    
}


//生成layer标签
- (void)creatLayerLabelTo:(CALayer*)layer context:(NSString*)text frame:(CGRect)rect newTextLayel:(CATextLayer*)textlayer{
    textlayer = [[CATextLayer alloc] init];
    //    [label setFont:@"Helvetica-Bold"];
    [textlayer setFont:@"ArialRoundedMTBold"];
    [textlayer setFontSize:25];
    [textlayer setFrame:rect];
    [textlayer setString:text];
    [textlayer setAlignmentMode:kCAAlignmentCenter];
    [textlayer setForegroundColor:[[UIColor whiteColor] CGColor]];
    textlayer.contentsScale = [UIScreen mainScreen].scale;
    [shaplayer addSublayer:textlayer];

}

//生成layerimage标签
- (void)creatLayerImageTo:(CALayer*)layer WithName:(NSString*)imageName frame:(CGRect)rect imageShapeLayer:(CAShapeLayer*)imaglayer{
    imaglayer = [CAShapeLayer layer];
    imaglayer.contents = (__bridge id _Nullable)([[UIImage imageNamed:imageName]CGImage]);
    imaglayer.frame = rect;
    [layer addSublayer:imaglayer];
}

//创建光照动画
- (void)creatLigthAnimation{
    UIBezierPath *bezeiPath = [[UIBezierPath alloc]init];
    [bezeiPath addArcWithCenter:CGPointMake(width/2, height-600) radius:10 startAngle:0 endAngle:360 clockwise:YES];
    
}

//开始按钮的实现
- (void)startAction:(UIButton*)sender{
    [self playSound];
   [UIView animateWithDuration:1.f animations:^{
       [motherFish setTransform:(CGAffineTransformIdentity)];
   } completion:^(BOOL finished) {
       [UIView animateWithDuration:2.f animations:^{
           [childFish setTransform:CGAffineTransformIdentity];
           [motherFish setFrame:CGRectMake(-400, motherFish.center.y, motherFish.bounds.size.width, motherFish.bounds.size.height)];
           [childFish setFrame:CGRectMake(-80, childFish.center.y+50, childFish.bounds.size.width, childFish.bounds.size.height)];
           [logoLabel setAlpha:0];
           [labChildSay setAlpha:0];
           [labMomSay setAlpha:0];
           [startButton setAlpha:0];
       } completion:^(BOOL finished) {
           [logoLabel removeFromSuperview];
           [labMomSay removeFromSuperview];
           [labChildSay removeFromSuperview];
           [startButton removeFromSuperview];
           [self initForBegin];
           iswellcomeNoTouch = NO;

       }];
       logoLabel = nil;
       labChildSay = nil;
       labMomSay = nil;
       startButton = nil;
       blueImagLayer = nil;
       blueTextLayer = nil;
       orageImagLayer = nil;
       orageTextLayer = nil;
       //    shaplayer = nil;

   }];
    
}

//shape layer 动画
- (void)basicAnimationAddTo:(CALayer*)layer{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"translation"];
    animation.fromValue = [NSValue valueWithCATransform3D:(CATransform3DMakeTranslation(layer.position.x, layer.position.y, 0))];
    animation.toValue = [NSValue valueWithCATransform3D:(CATransform3DMakeTranslation(layer.position.x,layer.position.y + 200, 0))];
    animation.duration = 3;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:@"translation"];
}

//游戏结束
- (void)gameOver{
//    [timerMoveFish invalidate];
    [dustMoveTimer invalidate];
    [blueFruitTimer invalidate];
    [eatFoodColliTimer invalidate];
    [foodMoveTimer invalidate];
    [lifeTimer invalidate];
    
    gameOverView = [[UIView alloc]initWithFrame:CGRectMake(width/2-250, height-700, 500, 400)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 200)];
    label.text = @"game over";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:60];
    label.textColor = [UIColor whiteColor];
    UIButton *contibtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    contibtn.frame = CGRectMake(200, 300, 100, 50);
    [contibtn setTitle:@"back" forState:(UIControlStateNormal)];
    contibtn.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
    [self creatBackgroundImg];
    [contibtn setBackgroundImage:buttonImage forState:(UIControlStateNormal)];
    contibtn.layer.cornerRadius = 5;
    contibtn.layer.masksToBounds = YES;
    [contibtn addTarget:self action:@selector(continuePlay) forControlEvents:(UIControlEventTouchUpInside)];
    
    [gameOverView addSubview:contibtn];
    [gameOverView addSubview:label];
    [self.view addSubview:gameOverView];
    
    
    for (UIImageView *img in fruits) {
        if (img) {
            [img removeFromSuperview];
            img.tag = 0;
        }
    }
    
    iswellcomeNoTouch = YES;
}

//重新游戏
- (void)continuePlay{

    [UIView animateWithDuration:2.f animations:^{
        gameOverView.alpha = 0;
    } completion:^(BOOL finished) {
        [gameOverView removeFromSuperview];
        timerMoveFish = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(moveFish) userInfo:nil repeats:YES];
        [timerMoveFish fire];
        dustMoveTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(dustMoveAction) userInfo:nil repeats:YES];
        [dustMoveTimer fire];
        blueFruitTimer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(foodCreateAction) userInfo:nil repeats:YES];
        [blueFruitTimer fire];
        eatFoodColliTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(eatFoodCollision) userInfo:nil repeats:YES];
        [eatFoodColliTimer fire];
        foodMoveTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(foodMoveAction) userInfo:nil repeats:YES];
        [foodMoveTimer fire];
        lifeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeLife) userInfo:nil repeats:YES];
        [lifeTimer fire];

        iswellcomeNoTouch = NO;
    }];
    gameOverView = nil;
}

/*
//迟到食物动画
- (void)eatAnimation{
    [self addEatLayer];
    displayLi = [CADisplayLink displayLinkWithTarget:self selector:@selector(paintCircle:)];
    [displayLi addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

//画圆动画
- (void)paintCircle:(CADisplayLink*)display{
    eatlayer.path = [[self circleBerzeiPath:display.timestamp]CGPath];
}

//berzei path
- (UIBezierPath*)circleBerzeiPath:(NSTimeInterval)time{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    CGFloat radiu = time * 2;
    if (radiu > 20) {
        [displayLi invalidate];
    }else{
        [path addArcWithCenter:fishMoveDestinPoint radius:radiu startAngle:M_PI endAngle:M_PI clockwise:YES];
    }
    return path;
}

//添加eat layer
- (void)addEatLayer{
    eatlayer = [CAShapeLayer layer];
    eatlayer.frame = CGRectMake(0, 0, 400, 368);
    eatlayer.fillColor = [[UIColor clearColor]CGColor];
    eatlayer.lineWidth = 20;
    eatlayer.strokeColor = [[UIColor purpleColor]colorWithAlphaComponent:0.6].CGColor;
    eatlayer.lineCap = @"round";
    [self.view.layer addSublayer:eatlayer];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

















