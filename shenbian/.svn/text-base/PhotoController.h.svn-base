//
//  NewPhotoController.h
//  shenbian
//
//  Created by xhan on 4/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest+Statistic.h"

@protocol PhotoControllerDelegate <NSObject>

- (void)photoPosted:(BOOL)isSuccessed;
- (void)photoInfoPosted:(BOOL)isSuccessed;
- (void)photoLinkIDPosted:(BOOL)isSuccessed;
//- (void)postProgressSuccessed;
- (void)photoProgressSuccessd:(NSDictionary*)successInfo;

@end


@interface PhotoController : NSObject<UIActionSheetDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
	BOOL isHaveCamera;
	UIImagePickerController* pickerVC;
	UIViewController* rootVC;
	UIImage* neededUploadImg;
    UIImagePickerControllerSourceType sourceType;
    
    NSString *shopId, *shopName;
    NSString *commodity; // name of commodity
    
    
    //network ivars
    NSString* photoLinkID;
    HttpRequest* hcPhotoLinkID;
    HttpRequest* hcPhotoPost;
    HttpRequest* hcMoreInfo;
    BOOL isPhotoPosted;
    
    id<PhotoControllerDelegate> delegate;
	
	NSDictionary *metaData;
}

/* used in present ImagePickerVc */
@property(nonatomic,retain) UIViewController* rootVC;
@property(nonatomic,readonly) BOOL isHaveCamera;

@property(nonatomic,copy) NSString *shopId;
@property(nonatomic,copy) NSString *shopName;
@property(nonatomic,copy) NSString *commodity;
@property(nonatomic,copy) NSString* photoLinkID;
@property(nonatomic,assign) BOOL isCommodityShop;

@property(nonatomic,retain) UIImage* neededUploadImg;
@property(nonatomic,readonly) BOOL isPhotoPosted;

@property(nonatomic,assign) id delegate;

@property(nonatomic, retain) NSDictionary *metaData;

+ (PhotoController*)singleton;
- (void)showActionSheet;
- (void)dismissViewController;
- (void)showImagePicker:(UIImagePickerControllerSourceType)type;
- (void)clean;

//private
- (UIImagePickerController*)pickerVC;



@end


@interface PhotoController (Network)<HttpRequestDelegate>

- (void)remoteLoadPhotoID;
- (void)postCurrentImage;

- (void)postImageInfoWith:(NSString*)comments shareSina:(BOOL)isWeibo;

- (void)cancelRequest;


- (void)_linkIDFetched;
@end

