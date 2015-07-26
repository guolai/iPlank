//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"

#define kDuration 0.3

@implementation TSLocateView
@synthesize pickerVc;
@synthesize titleLabel;
@synthesize locatePicker;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        [self.locatePicker  setBackgroundColor:[UIColor lightGrayColor]];
        
        //加载数据
        NSMutableArray *mulArray = [[NSMutableArray alloc] init];
        for (int i = 1; i < 7; i++) {
            NSString *str = [NSString stringWithFormat:@"%d", i];
            [mulArray  addObject:str];
        }
        _roundsArray = [NSArray arrayWithArray:mulArray];
        
        [mulArray removeAllObjects];
        for (int i = 20; i < 999; i++) {
            NSString *str = [NSString stringWithFormat:@"%d", i];
            [mulArray  addObject:str];
        }
        _secArray = [NSArray arrayWithArray:mulArray];
        
        [mulArray removeAllObjects];
        for (int i = 5; i < 30; i++) {
            NSString *str = [NSString stringWithFormat:@"%d", i];
            [mulArray  addObject:str];
        }
        _restArray = [NSArray arrayWithArray:mulArray];
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}
- (void)reloadPickerView
{
    int i = 0;
    for (NSString *str in _roundsArray) {
        if([str isEqualToString:self.pickerVc.strRound])
        {
            [self.locatePicker selectRow:i inComponent:0 animated:YES];
            break;
        }
        i++;
    }
    
    i = 0;
    for (NSString *str in _secArray) {
        if([str isEqualToString:self.pickerVc.strSec])
        {
            [self.locatePicker selectRow:i inComponent:1 animated:YES];
            break;
        }
        i++;
    }
    
    i = 0;
    for (NSString *str in _restArray) {
        if([str isEqualToString:self.pickerVc.strRest])
        {
            [self.locatePicker selectRow:i inComponent:2 animated:YES];
            break;
        }
        i++;
    }
}
#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_roundsArray count];
            break;
        case 1:
            return [_secArray count];
            break;
        case 2:
            return [_restArray count];
            break;
        default:
            return 0;
            break;
    }
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return 60;
//            break;
//        case 1:
//            return [_secArray count];
//            break;
//        case 2:
//            return [_restArray count];
//            break;
//        default:
//            return 0;
//            break;
//    }
//}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return [_roundsArray objectAtIndex:row];
//            break;
//        case 1:
//            return [_secArray objectAtIndex:row];
//            break;
//        case 2:
//            return [_restArray objectAtIndex:row];
//            break;
//        default:
//            return nil;
//            break;
//    }
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [view2 setBackgroundColor:[UIColor clearColor]];
    UILabel *lbl = [[UILabel alloc] initWithFrame:view2.frame];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont boldSystemFontOfSize:30]];
    
    [view2 addSubview:lbl];
    switch (component) {
        case 0:
        {
            NSString *str = [_roundsArray objectAtIndex:row];
            [lbl setText:str];
            [lbl setTextColor:[UIColor redColor]];
        }
            break;
        case 1:
        {
            NSString *str = [_secArray objectAtIndex:row];
            [lbl setText:str];
            [lbl setTextColor:[UIColor purpleColor]];
        }
            break;
        case 2:
        {
            NSString *str = [_restArray objectAtIndex:row];
            [lbl setText:str];
            [lbl setTextColor:[UIColor orangeColor]];
        }
            break;
        default:
            return nil;
            break;
    }

    return view2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            self.pickerVc.strRound = [_roundsArray objectAtIndex:row];
        }
            break;
        case 1:
        {
            self.pickerVc.strSec = [_secArray objectAtIndex:row];
        }
            break;
        case 2:
        {
            self.pickerVc.strRest = [_restArray objectAtIndex:row];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}

@end
