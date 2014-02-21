//
//  ABSViewControllerFlight.m
//  ABSDR_QC
//
//  Created by CIG account on 2/8/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import "ABSViewControllerFlight.h"
#import "ABSViewControllerControlBoard.h"
#import "ABSViewControllerGyro.h"

#define FACTORFORCONTROL 0.67
#define ZERORANGE 30

@interface ABSViewControllerFlight ()
@property (weak, nonatomic) IBOutlet UISlider *sliderRotation;
@property (weak, nonatomic) IBOutlet UISlider *sliderDirection;
@property (weak, nonatomic) IBOutlet UISlider *sliderAltitude;

@end

@implementation ABSViewControllerFlight



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sliderAltitude.transform=CGAffineTransformMakeRotation(-M_PI_2);
    self.sliderDirection.transform=CGAffineTransformMakeRotation(-M_PI_2);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sliderAltitudeChanged:(id)sender {
    [self.ConnectionParameters changeAltitude:[self interpolatedFunction:self.sliderAltitude.value]];
    /*NSLog(@"%@", self.ConnectionParameters.IPAddress);
    NSLog(@"%@", self.ConnectionParameters.RemotePort);
    NSLog(@"%@", self.ConnectionParameters.LocalPort);
    NSLog(@"%d", self.ConnectionParameters.sock_client);
    NSLog(@"%d", self.ConnectionParameters.sock_server);*/
//    NSLog(@"%f", self.sliderAltitude.value);
//    NSLog(@"Adjusted: %d", [self interpolatedFunction:self.sliderAltitude.value]);
}

- (IBAction)sliderDirectionChanged:(id)sender {
    [self.ConnectionParameters changeDirection:[self interpolatedFunction:self.sliderDirection.value]];
}
- (IBAction)sliderRotationChanged:(id)sender {
    [self.ConnectionParameters changeRotation:[self interpolatedFunction:self.sliderRotation.value]];
}


- (int) interpolatedFunction: (float) ch
{
    if(abs(ch)<ZERORANGE) return 0;
    else if(ch>=0) return (int)pow(abs(ch-ZERORANGE), FACTORFORCONTROL);
    else return -(int)pow(abs(ch+ZERORANGE), FACTORFORCONTROL);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showManualBoard"])
    {
        ABSViewControllerControlBoard *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
    }
    
    if([segue.identifier isEqualToString:@"showGyroBoard"])
    {
        ABSViewControllerGyro *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
    }
}

@end
