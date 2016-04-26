//
//  XY_DisplayViewController.m
//  多图单张上传demo
//
//  Created by xiyang on 16/4/26.
//  Copyright © 2016年 xiyang. All rights reserved.
//

#import "XY_DisplayViewController.h"
#import "XY_DisplayPhotosView.h"
@interface XY_DisplayViewController ()

@end

@implementation XY_DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.displayView displayPhotosViewWithImgArr:self.urlArr isEditView:NO];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
