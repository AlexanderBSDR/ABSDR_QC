//
//  ABSViewControllerFlight.m
//  ABSDR_QC
//
//  Created by CIG account on 2/8/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import "ABSViewControllerFlight.h"
#import "ABSViewControllerControlBoard.h"

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
    [self.ConnectionParameters sendClient:"Alexa" length:6];
    NSLog(@"%@", self.ConnectionParameters.IPAddress);
    NSLog(@"%@", self.ConnectionParameters.RemotePort);
    NSLog(@"%@", self.ConnectionParameters.LocalPort);
    NSLog(@"%d", self.ConnectionParameters.sock_client);
    NSLog(@"%d", self.ConnectionParameters.sock_server);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showManualBoard"])
    {
        NSLog(@"Going back!");
        ABSViewControllerControlBoard *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
    }
}

@end
