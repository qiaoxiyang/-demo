//
//  ViewController.m
//  转载请注明iOS小乔  http://www.jianshu.com/users/f029d92cedc0/latest_articles
//
//  Created by xiyang on 16/4/26.
//  Copyright © 2016年 xiyang. All rights reserved.
//

#import "XY_ViewController.h"
#import "XY_DisplayPhotosView.h"
#import "XYNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XY_DisplayViewController.h"
@interface XY_ViewController ()

@property (nonatomic, retain) NSMutableArray *urlArr;



@end

@implementation XY_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup  after loading the view, typically from a nib.
    
    self.urlArr = [NSMutableArray array];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)uploadImagesBtnClick {
    
    if (self.displayView.imgArr.count==0||self.displayView.imgArr==nil) {
        NSLog(@"没有图片可以上传");
        return;
    }
    
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (ALAsset *asset in self.displayView.imgArr) {
        //存放的为高清图片
        UIImage *img = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        [imagesArr addObject:img];
    }
    
    [self uploadDataWithImages:imagesArr];
    
    
}

-(void)uploadDataWithImages:(NSMutableArray *)imgesArr{
    
    dispatch_group_t group = dispatch_group_create();
    
    __weak XY_ViewController *weakSelf = self;
    for (UIImage *img in imgesArr) {
        
        dispatch_group_enter(group);
        
        [self uploadImage:img purpose:@"bang_album" successBlock:^(NSDictionary *dic) {
            
            NSLog(@"dic======%@",dic);
            
            dispatch_group_leave(group);


            [weakSelf.urlArr addObject:dic[@"url"]];
            
            
        } failBlock:^(NSError *error) {
            
            NSLog(@"fail===%@",error);
            dispatch_group_leave(group);
        }];
        
    }
    
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传图片成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alerView show];
        });
        
    });
    
    
}


-(void)uploadImage:(UIImage *)image purpose:(NSString *)purpose successBlock:(void (^)(NSDictionary * dic))success failBlock:(void(^)(NSError *error))fail{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    
    NSDictionary *dic = @{
                          @"timestamp" : @"1457403110",
                          @"file"      : imgData,
                          @"xtype"     :@"bang_album",
                          @"token"     : @"8a3dead8022c6c85248efca767c9ecfaf8836617"
                          };
    
    [XYNetworking uploadWithURL:@"upload.php" baseURL:@"http://img.nongji360.com" params:dic fileData:imgData name:@"Filedata" fileName:@"Filedata.jpg" mimeType:@"image/jpeg" progress:^(NSProgress *progress) {
        
//        NSLog(@"%lli,%lli",progress.completedUnitCount,progress.totalUnitCount);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);

    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        fail(error);

    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"seeDisplayImage"]) {
        XY_DisplayViewController *displayVC = segue.destinationViewController;
        if ((self.urlArr.count==self.displayView.imgArr.count)&&self.urlArr.count>0) {
            displayVC.urlArr = self.urlArr;
        }
        
    }
}



@end
