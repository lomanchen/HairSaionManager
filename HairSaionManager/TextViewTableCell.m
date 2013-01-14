//
//  TextViewTableCell.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-12.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "TextViewTableCell.h"
#define MARGIN 10
@implementation TextViewTableCell
@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [textView becomeFirstResponder];
    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = CGRectMake(MARGIN, 0, self.contentView.frame.size.width - 2*MARGIN, self.contentView.frame.size.height);
    self.textView.font = self.textLabel.font;
}
- (void)setup
{
    self.frame = CGRectMake(0, 0, 512, 400);
    textView = [[UITextView alloc]init];
    textView.backgroundColor = [UIColor clearColor];
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.autocapitalizationType = UITextAutocapitalizationTypeWords;
    //textView.textAlignment = UITextAlignmentLeft;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.returnKeyType = UIReturnKeyDone;
    textView.textAlignment = self.textView.textAlignment;
    textView.font = self.textView.font;
    //textView.delegate = self;
    //[self addSubview:textView];
    [self.contentView addSubview:textView];
    self.editing = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
