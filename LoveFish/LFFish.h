//
//  Finish.h
//  LoveFish
//
//  Created by luowanglin on 2018/3/26.
//  Copyright © 2018年 com.luowanglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFFish : UIView
@property(nonatomic,strong)UIImageView *body;
@property(nonatomic,strong)UIImageView *tail;
@property(nonatomic,strong)UIImageView *eye;
@property(nonatomic,strong)NSMutableArray<UIImage*> *tails;
@property(nonatomic,strong)NSMutableArray<UIImage*> *eyes;
@property(nonatomic,strong)NSMutableArray<UIImage*> *swimReds;
@property(nonatomic,strong)NSMutableArray<UIImage*> *swimBlues;
@property(nonatomic,strong)NSMutableArray<UIImage*> *lives;
@end
