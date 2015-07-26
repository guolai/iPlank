//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "PickerViewController.h"

@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private
    NSArray *_roundsArray;
    NSArray	*_secArray;
    NSArray *_restArray;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (nonatomic, weak) PickerViewController *pickerVc;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;
- (void)reloadPickerView;
@end
