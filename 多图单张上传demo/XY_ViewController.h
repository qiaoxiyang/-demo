//
//  ViewController.h
//  转载请注明iOS小乔  http://www.jianshu.com/users/f029d92cedc0/latest_articles
//
//  Created by xiyang on 16/4/26.
//  Copyright © 2016年 xiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XY_DisplayPhotosView;
@interface XY_ViewController : UIViewController

@property (weak, nonatomic) IBOutlet XY_DisplayPhotosView *displayView;
- (IBAction)uploadImagesBtnClick;

@end

