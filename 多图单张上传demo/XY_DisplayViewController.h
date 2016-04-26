//
//  XY_DisplayViewController.h
//  多图单张上传demo
//
//  Created by xiyang on 16/4/26.
//  Copyright © 2016年 xiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XY_DisplayPhotosView;
@interface XY_DisplayViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *urlArr;
@property (weak, nonatomic) IBOutlet XY_DisplayPhotosView *displayView;

@end
