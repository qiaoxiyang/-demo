//
//  XYImageScrollView.m
//  转载请注明iOS小乔  http://www.jianshu.com/users/f029d92cedc0/latest_articles
//  Created by lulei on 15/9/10.
//  Copyright (c) 2015年 xiyang. All rights reserved.
//

#import "XY_ImageScrollView.h"

@interface XY_ImageScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation XY_ImageScrollView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //设置状态
        self.minimumZoomScale=1;
        self.maximumZoomScale=2;
        self.pagingEnabled=YES;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        _scrollImageView=[[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_scrollImageView];
        self.delegate=self;
        //添加双击事件
        UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomBigOrSmall:)];
        doubleTap.numberOfTapsRequired=2;
        doubleTap.numberOfTouchesRequired = 1;
//        doubleTap.delegate = self;
        
        
        //添加单击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
//        singleTap.delegate = self;
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [self addGestureRecognizer:doubleTap];
        [self addGestureRecognizer:singleTap];
        
    }
    return self;
}
-(void)zoomBigOrSmall:(UITapGestureRecognizer *)tap{
    if (self.zoomScale>=2) {
        self.zoomScale=1;
    }else{
        CGPoint point=[tap locationInView:self];
        [self zoomToRect:CGRectMake(point.x-20, point.y-20, 80, 80) animated:YES];
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _scrollImageView;
}

-(void)backClick{
    [[self getViewController].navigationController popViewControllerAnimated:YES];
}

-(UIViewController *)getViewController{
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *responder = next.nextResponder;
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}



@end
