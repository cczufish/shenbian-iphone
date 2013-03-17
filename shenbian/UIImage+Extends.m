//
//  UIImage+Extends.m
//  shenbian
//
//  Created by MagicYang on 2/26/11.
//  Copyright 2011 personal. All rights reserved.
//

#import "UIImage+Extends.h"


@implementation UIImage (Resizing)

- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate {
	CGFloat destW = width;
	CGFloat destH = height;
	CGFloat sourceW = width;
	CGFloat sourceH = height;
	if (rotate) {
		if (self.imageOrientation == UIImageOrientationRight
			|| self.imageOrientation == UIImageOrientationLeft) {
			sourceW = height;
			sourceH = width;
		}
	}
	
	CGImageRef imageRef = self.CGImage;
	CGContextRef bitmap = CGBitmapContextCreate(NULL,
												destW,
												destH,
												CGImageGetBitsPerComponent(imageRef),
												0,
												CGImageGetColorSpace(imageRef),
												CGImageGetBitmapInfo(imageRef));
	
	if (rotate) {
		if (self.imageOrientation == UIImageOrientationDown) {
			CGContextTranslateCTM(bitmap, sourceW, sourceH);
			CGContextRotateCTM(bitmap, 180 * (M_PI/180));
		} else if (self.imageOrientation == UIImageOrientationLeft) {
			CGContextTranslateCTM(bitmap, sourceH, 0);
			CGContextRotateCTM(bitmap, 90 * (M_PI/180));
		} else if (self.imageOrientation == UIImageOrientationRight) {
			CGContextTranslateCTM(bitmap, 0, sourceW);
			CGContextRotateCTM(bitmap, -90 * (M_PI/180));
		}
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0,0,sourceW,sourceH), imageRef);
	
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* result = [UIImage imageWithCGImage:ref];
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;
}

@end
