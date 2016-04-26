//
//  XY_DisplayPhotosView.h
//  NewPersonalCenter
//  转载请注明iOS小乔  http://www.jianshu.com/users/f029d92cedc0/latest_articles
//  Created by xiyang on 16/3/31.
//  Copyright © 2016年 xiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XY_DisplayPhotosView : UIView

@property (nonatomic, copy) void (^updateFrame)();
/**
 *  数组中存放的为ALAsset
 */
@property (nonatomic, retain) NSMutableArray *imgArr;

-(void)displayPhotosViewWithImgArr:(NSMutableArray *)allImgArr isEditView:(BOOL) isEdit;



@end
