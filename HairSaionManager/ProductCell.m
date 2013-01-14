//
//  ProductCell.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "ProductCell.h"
#import <QuartzCore/QuartzCore.h>
#define MARGIN 13
#define MARGIN_IMAGE_LABEL 20

#define FRAME_CELL_IMAGE_X MARGIN
#define FRAME_CELL_IMAGE_Y MARGIN
#define FRAME_CELL_IMAGE_W (FRAME_CELL_HEIGHT - 2* MARGIN)
#define FRAME_CELL_IMAGE_H FRAME_CELL_IMAGE_W

#define FRAME_CELL_TITLE_X (FRAME_CELL_IMAGE_X + FRAME_CELL_IMAGE_W +MARGIN_IMAGE_LABEL)
#define FRAME_CELL_TITLE_Y FRAME_CELL_IMAGE_Y

#define FRAME_CELL_DETAIL_X FRAME_CELL_TITLE_X
#define FRAME_CELL_DETAIL_Y 45

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //重置imageview大小
    self.imageView.frame = CGRectMake(FRAME_CELL_IMAGE_X, FRAME_CELL_IMAGE_Y, FRAME_CELL_IMAGE_W, FRAME_CELL_IMAGE_H);
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setClipsToBounds:YES];
    
    //重置title label大小
    CGRect rect = self.textLabel.frame;
    int offset = rect.origin.x - FRAME_CELL_TITLE_X;
    rect.origin.x = FRAME_CELL_TITLE_X;
    rect.size.width = rect.size.width + fabs(offset);
    rect.origin.y = FRAME_CELL_TITLE_Y;
    self.textLabel.frame = rect;
    
    //重置detail label大小
    rect = self.detailTextLabel.frame;
    offset = rect.origin.x - FRAME_CELL_TITLE_X;
    rect.origin.x = FRAME_CELL_DETAIL_X;
    rect.size.width = rect.size.width + offset;
    rect.origin.y = FRAME_CELL_DETAIL_Y;
    self.detailTextLabel.frame = rect;
    
    //圆角处理
    CALayer * layer = [self.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor clearColor] CGColor]];

}

@end
