//
//  TextEditTableCell.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-12.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "TextEditTableCell.h"
#define MARGIN 10

@implementation TextEditTableCell
@synthesize textField;
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
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.frame;
    rect = self.textLabel.frame;
    self.textField.frame = CGRectMake(MARGIN, 0, self.contentView.frame.size.width - 2*MARGIN, self.contentView.frame.size.height);
    self.textField.font = self.textLabel.font;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [textField becomeFirstResponder];
    // Configure the view for the selected state
}

- (void)setup
{
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0,10,125,25)];
    if (![self.textLabel.text isEqualToString:@""])
    {
        textField.placeholder = self.textLabel.text;
        self.textLabel.text = @"";
    }
    textField.adjustsFontSizeToFitWidth = NO;
    textField.backgroundColor = [UIColor clearColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    //textField.textAlignment = UITextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeNever;
    textField.textAlignment = self.textField.textAlignment;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = self.textField.font;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    //textField.delegate = self;
    //[self addSubview:textField];
    [self.contentView addSubview:textField];
    self.editing = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
