//
//  XY_DisplayPhotosView.m
//  NewPersonalCenter
//  转载请注明iOS小乔  http://www.jianshu.com/users/f029d92cedc0/latest_articles
//  Created by xiyang on 16/3/31.
//  Copyright © 2016年 xiyang. All rights reserved.
//

#import "XY_DisplayPhotosView.h"
#import "CTAssetsPickerController.h"
#import "UIImageView+WebCache.h"
#import "XY_BigPhotoViewController.h"
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
static const CGFloat margin = 10 ; //间距

@interface XY_DisplayPhotosView ()<UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    CGFloat width;
}
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, retain) NSMutableArray *photoBtnArr;


@end

@implementation XY_DisplayPhotosView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self initSubViews];
        
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubViews];
    }
    return self;
}


-(void)initSubViews{
    
    
    width = (kSCREEN_WIDTH-5*margin)/4.0;
    
    self.addPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin, 0, width, width)];
    [self.addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"grzx_tianjia"] forState:UIControlStateNormal];
    [self.addPhotoBtn addTarget:self action:@selector(addPhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addPhotoBtn];
    
    self.imgArr = [NSMutableArray array];
    self.photoBtnArr = [NSMutableArray array];
}

-(void)addPhotoBtnClick{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册中选取" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:[self getViewController].view];
    
    
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


- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    
    if (assets.count == 0) {
        return ;
    }
    
    
    
    [self.imgArr addObjectsFromArray:assets];
    if (self.imgArr.count>=4) {
        if (self.updateFrame) {
            self.updateFrame();
        }
    }
    
    [self displayPhotosViewWithImgArr:self.imgArr isEditView:YES];
}

-(void)displayPhotosViewWithImgArr:(NSMutableArray *)allImgArr isEditView:(BOOL) isEdit{
    
    int row = 4;
    int line = 4;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat add_x = 0;
    CGFloat add_y = 0;
    
    if (self.photoBtnArr.count>0) {
        
        for (NSInteger i=self.photoBtnArr.count; i>0; i--) {
            UIButton *btn = self.photoBtnArr[i-1];
            [btn removeFromSuperview];
            btn = nil;
        }
    }

    for (int i = 0; i<allImgArr.count; i++) {
        
       
        
        x = i%row;
        y = i/line;
        
        UIImageView *displayImg = [[UIImageView alloc] init];
        displayImg.userInteractionEnabled = YES;
        [displayImg setFrame:CGRectMake(x*width+(x+1)*margin, y*(width+margin), width, width)];
        displayImg.tag = i;
        
        
        
        [displayImg setContentScaleFactor:[[UIScreen mainScreen] scale]];
        displayImg.contentMode = UIViewContentModeScaleAspectFill;
        displayImg.clipsToBounds = YES;
        displayImg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        id content = allImgArr[i];
        if ([content isKindOfClass:[ALAsset class]]) {
            ALAsset *asset = allImgArr[i];

            [displayImg setImage:[UIImage imageWithCGImage:asset.thumbnail]];
        }else if ([content isKindOfClass:[UIImage class]]){

            [displayImg setImage:allImgArr[i]];
        }
        else{
            [displayImg sd_setImageWithURL:[NSURL URLWithString:allImgArr[i]] placeholderImage:[UIImage imageNamed:@"is_placeholdImg"]];
        }
        
        
        [self addSubview:displayImg];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayImgClick:)];
        [displayImg addGestureRecognizer:tap];
        
        add_x = (i+1)%row*width+((i+1)%row+1)*margin;
        add_y = (i+1)/line*(width+margin);
        [self.photoBtnArr addObject:displayImg];
    }
    
    [self.addPhotoBtn setFrame:CGRectMake(add_x, add_y, width, width)];
    
    if (!isEdit) {
        self.addPhotoBtn.hidden = YES;
        return;
    }
    if (allImgArr.count==8) {
        self.addPhotoBtn.hidden = YES;
    }else{
        self.addPhotoBtn.hidden = NO;
    }
    
    
}


-(void)displayImgClick:(UITapGestureRecognizer *)tap{
    
    UIImageView *imgView = tap.view;

    XY_BigPhotoViewController *bigPhotoViewController = [[XY_BigPhotoViewController alloc] init];
    bigPhotoViewController.index = imgView.tag;
    bigPhotoViewController.imageViewArray = self.imgArr;

    [[self getViewController].navigationController pushViewController:bigPhotoViewController animated:YES];
    
    
}


#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 8-self.imgArr.count;
        picker.assetsFilter = [ALAssetsFilter allAssets];
        picker.delegate = self;
        
        [[self getViewController] presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex==1){
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            //存储方式
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            picker.allowsEditing = YES;
            [[self getViewController] presentViewController:picker animated:YES completion:Nil];
            
            //拍照
            [picker takePicture];
            
        }else
        {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            
        }
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    [self.imgArr addObject:image];
    
    if (self.imgArr.count==4) {
        if (self.updateFrame) {
            self.updateFrame();
        }
    }
}









@end
