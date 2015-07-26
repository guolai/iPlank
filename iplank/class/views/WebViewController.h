//
//  WebViewController.h
//  iplank
//
//  Created by bob on 6/11/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBViewController.h"

typedef enum
{
    ewebHowToPlank,
    ewebWhyToPlank,
    ewebGirl,
    ewebDonate,
}T_WebContent;



@interface WebViewController : BBViewController
@property (nonatomic, assign) T_WebContent webType;

@end
