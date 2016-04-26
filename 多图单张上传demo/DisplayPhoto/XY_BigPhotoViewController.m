//
//  XY_BigPhotoViewController.m
//  NewPersonalCenter
//  转载请注明iOS小乔  http://www.jianshu.com/users/f029d92cedc0/latest_articles
//  Created by xiyang on 16/3/31.
//  Copyright © 2016年 xiyang. All rights reserved.
//

#import "XY_BigPhotoViewController.h"
#import "XY_ImageScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface XY_BigPhotoViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *indexLab;

@end

@implementation XY_BigPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

-(void)initSubViews{
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.backgroundColor =[UIColor blackColor];
    UITapGestureRecognizer *tapge = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClick)];
    
    [self.scrollView addGestureRecognizer:tapge];
    [self.view addSubview:self.scrollView];
    UIImage *xy_image;
    for (int i = 0; i<self.imageViewArray.count; i++) {
        
        id content = self.imageViewArray[i];
        if ([content isKindOfClass:[ALAsset class]]) {
            ALAsset *asset = self.imageViewArray[i];
            xy_image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        }else{
            xy_image = self.imageViewArray[i];
        }
        
//        ALAssetRepresentation *represent = [asset defaultRepresentation];
        
        
//        CGFloat im_height = [self getNewScale:xy_image];
//        CGFloat y = (kSCREEN_HEIGHT-64-im_height)/2.0;
//        
//        if (y<=0) {
//            y=0;
//        }
        
        
        XY_ImageScrollView *imgSV = [[XY_ImageScrollView alloc] initWithFrame:CGRectMake(i*kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        
        imgSV.backgroundColor = [UIColor blueColor];
        imgSV.scrollImageView.image = xy_image;
        
        imgSV.scrollImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imgSV.scrollImageView.contentScaleFactor = [[UIScreen mainScreen] scale];
        imgSV.scrollImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.scrollView addSubview:imgSV];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.imageViewArray.count*kSCREEN_WIDTH, 0);
    
    self.scrollView.contentOffset = CGPointMake(self.index * kSCREEN_WIDTH, 0);
    
    self.scrollView.delegate = self;
    self.indexLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-40, kSCREEN_WIDTH, 20)];
    self.indexLab.backgroundColor = [UIColor clearColor];
    self.indexLab.text = [NSString stringWithFormat:@"%li/%li",self.index+1,self.imageViewArray.count];
    self.indexLab.textColor = [UIColor whiteColor];
    self.indexLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.indexLab];
    
}

//
//-(CGFloat)getNewScale:(UIImage *)img{
//    
//    NSInteger scale = [[UIScreen mainScreen] scale];
//    
//    CGFloat bili = kSCREEN_WIDTH/(img.size.width/scale);
//
//    CGFloat height = bili * (img.size.height/scale);
//
//    return height;
//}

-(void)backgroundClick{
    
    
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kSCREEN_WIDTH;
    self.indexLab.text = [NSString stringWithFormat:@"%li/%li",index+1,self.imageViewArray.count];
}











@end
