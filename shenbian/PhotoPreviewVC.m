    //
//  PhotoPreviewVC.m
//  shenbian
//
//  Created by xhan on 4/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "PhotoPreviewVC.h"
#import "PhotoController.h"
#import "PhotoSubmitVC.h"
#import "PickShopViewController.h"
#import "PickCommodityViewController.h"
#import "AppDelegate.h"
#import "ConfirmCenter.h"
#import "CacheCenter.h"
#import "SBShopInfo.h"


@implementation PhotoPreviewVC
@synthesize sourceType;

- (id)initWithImage:(UIImage*)image
{
	self = [super init];
	self.wantsFullScreenLayout = NO;
	selectedImg = [image retain];
	return self;
}

- (void)dealloc {
	VSSafeRelease(selectedImg);
	VSSafeRelease(selectedImgView);
    [super dealloc];	
}

- (void)loadView {
	[super loadView];
    self.title = NSLocalizedString(@"选择图片", @"");
	self.view.backgroundColor = [UIColor clearColor];
	UIBarButtonItem* cancelBtn = 
	[SBNavigationController buttonItemWithTitle:NSLocalizedString(@"取消",nil)
								   andAction:@selector(onBtnCancel) 
								  inDelegate:self];
	self.navigationItem.leftBarButtonItem = cancelBtn;

	
	//content view
	UIImageView* imageWrapperV = [[UIImageView alloc] initWithFrame:vsr(0,0,320,358)];
	UIImage* imageWrapper = [PNGImage(@"photopreview_bg") stretchableImageWithLeftCapWidth:50 topCapHeight:50];
	imageWrapperV.opaque = YES;
	imageWrapperV.image = imageWrapper;
	
	// selected image
	selectedImgView = [[UIImageView alloc] initWithFrame:vsr(20,15,280,318)];
	selectedImgView.contentMode = UIViewContentModeScaleAspectFit;
	selectedImgView.image = selectedImg;
//	[self.view addSubview:selectedImgView];
	[imageWrapperV addSubview:selectedImgView];
	
	[self addSubview:imageWrapperV];

	VSSafeRelease(imageWrapperV);
	
	//top shadow obj
	[self addSubview:[T imageViewNamed:@"photopreview_top_obj.png"]];
	
	//added two button

    [self addSubview:
	 [T createBtnfromPoint:ccp(10,365)
					 image:PNGImage(@"reselect_photo_n")
              highlightImg:PNGImage(@"reselect_photo_h")
					target:self
				  selector:@selector(onBtnReSelectPhoto)]
	 ];
    
    [self addSubview:
	 [T createBtnfromPoint:ccp(167,365)
					 image:PNGImage(@"photo_next_n")
              highlightImg:PNGImage(@"photo_next_h")
					target:self
				  selector:@selector(onBtnNextStep)]
	 ];    
}

- (void)onBtnReSelectPhoto
{
	Stat(@"photobutton_selpic_renew");
    BOOL isHaveCamera = [PhotoController singleton].isHaveCamera;
	UIActionSheet* sheet;
	if(isHaveCamera){
		sheet = 
		[[UIActionSheet alloc] initWithTitle:@""
									delegate:self
						   cancelButtonTitle:NSLocalizedString(@"取消",nil)
					  destructiveButtonTitle:nil
						   otherButtonTitles:NSLocalizedString(@"拍照上传",nil),
		 NSLocalizedString(@"从相册上传",nil),nil];		
	}else {
		sheet = 
		[[UIActionSheet alloc] initWithTitle:@""
									delegate:self
						   cancelButtonTitle:NSLocalizedString(@"取消",nil)
					  destructiveButtonTitle:nil
						   otherButtonTitles:NSLocalizedString(@"从相册上传",nil),nil];
	}
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    UIWindow* win = [AppDelegate sharedDelegate].window;
    [sheet showInView:win];
	[sheet release];
}

- (void)onBtnUploadFromCamera
{
	[[PhotoController singleton] pickerVC].sourceType = UIImagePickerControllerSourceTypeCamera; 
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)onBtnUploadFromAlbum
{
	[[PhotoController singleton] pickerVC].sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)doCancel
{
    PhotoController *pc = [PhotoController singleton];
    [pc dismissViewController];
}

- (void)onBtnCancel
{
    [[ConfirmCenter sharedInstance] confirmAction:@selector(doCancel) forObject:self withPromptText:@"放弃拍照上传吗？"];
}

- (UIViewController *)nextController
{
    if ([PhotoController singleton].shopId) {
        if ([PhotoController singleton].commodity||![PhotoController singleton].isCommodityShop){
            if (![PhotoController singleton].isCommodityShop) {
                PhotoController *pc = [PhotoController singleton];
                SBShopInfo *shop= [[CacheCenter sharedInstance] lastPhotoShop];
                pc.shopId =shop.shopId;
                pc.shopName = shop.strName;
                pc.commodity=@"";
                
            }
            return [[PhotoSubmitVC new] autorelease];
        } else {
            return [[PickCommodityViewController new] autorelease];
        }
    } else {
        return [[PickShopViewController new] autorelease];
    }
}

- (void)onBtnNextStep
{
	Stat(@"photobutton_selpic_next");
    //starting posting images
    [[PhotoController singleton] postCurrentImage];
    [self.navigationController pushViewController:[self nextController] animated:YES];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    VSSafeRelease(selectedImgView);
}


#pragma mark - actionsheet delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if ([PhotoController singleton].isHaveCamera && buttonIndex == 0) {
            [self onBtnUploadFromCamera];
        } else {
            [self onBtnUploadFromAlbum];
        }
    }
}

@end
