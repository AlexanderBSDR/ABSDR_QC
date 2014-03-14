//
//  ABSViewControllerFlight.h
//  ABSDR_QC
//
//  Created by CIG account on 2/8/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSConnectionParameters.h"

@interface ABSViewControllerFlight : UIViewController

@property ABSConnectionParameters *ConnectionParameters;
-(IBAction)textFieldReturn:(id)sender;

@end