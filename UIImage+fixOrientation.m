//
//  UIImage+fixOrientation.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-25.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "UIImage+fixOrientation.h"

@implementation UIImage (additions)

- (UIImage *)fixOrientation {
//    if (self.imageOrientation == UIImageOrientationUp) return self;
//    
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
//    [self drawInRect:(CGRect){0, 0, self.size}];
//    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return normalizedImage;

    return [self fixOrientationWithOrientation:self.imageOrientation];
}


- (UIImage*)mirrored
{
    
    return [self fixOrientationWithOrientation:UIImageOrientationLeftMirrored];
}

- (UIImage*)downMirrored
{
    return [self fixOrientationWithOrientation:UIImageOrientationDownMirrored];
}

- (UIImage*)fixOrientationWithOrientation:(UIImageOrientation) orientation
{
    if (orientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (orientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage*)merge:(UIImage *)image
{
        //    UIImageView* iv = [[UIImageView alloc]initWithImage:img];
    CGFloat objectWidth = CGImageGetWidth(image.CGImage);
    CGFloat objectHeight = CGImageGetHeight(image.CGImage);
    CGRect cameraOverlayFrame = CGRectMake(0, 0, CAMERA_SCREEN_H, CAMERA_SCREEN_W);//controller.cameraOverlayView.frame;
    CGFloat frameWidth = cameraOverlayFrame.size.width;
    CGFloat frameHeight = cameraOverlayFrame.size.height;
    CGFloat ivWidth = 0;
    CGFloat ivHeight = 0;
    //长形
    if (objectWidth/CAMERA_SCREEN_W > objectHeight/CAMERA_SCREEN_H)
    {
        ivWidth = frameWidth;
        ivHeight = objectHeight/(objectWidth/frameWidth);
    }
    //竖型
    else
    {
        ivHeight = frameHeight;
        ivWidth = objectWidth/(objectHeight/frameHeight);
    }
    
    //    iv.frame = CGRectMake((cameraOverlayFrame.size.width-ivWidth)/2, (cameraOverlayFrame.size.height-ivHeight)/2, ivWidth, ivHeight);
    
    UIGraphicsBeginImageContext(CGSizeMake(CAMERA_SCREEN_H, CAMERA_SCREEN_W));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // create rect that fills screen
    CGRect bounds = CGRectMake((cameraOverlayFrame.size.width-ivWidth)/2, (cameraOverlayFrame.size.height-ivHeight)/2, ivWidth, ivHeight);
    
    //CGContextRotateCTM(context, 1.57079633);
    // This is my bkgnd image
    CGContextDrawImage(context, cameraOverlayFrame, self.CGImage);
    //CGContextSetAlpha (context,0.5);
    
    // This is my image to blend in
    CGContextDrawImage(context, bounds, image.CGImage);
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
