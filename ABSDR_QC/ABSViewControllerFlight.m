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
#define MAX_PITCH_ANGLES 180
#define MAX_ROLL_ANGLES 180
#define MAX_SPEED_ANGLES 360
//#define ZERORANGE_SPEED 10
//#define ZERORANGE_ANGLES (ZERORANGE_SPEED/2)



//#define MAX_PITCH_SLIDER_SETTINGS pow(MAX_PITCH_ANGLES, 1/FACTORFORCONTROL)+ZERORANGE_ANGLES
//#define MAX_ROLL_SLIDER_SETTINGS pow(MAX_ROLL_ANGLES, 1/FACTORFORCONTROL)+ZERORANGE_ANGLES
//#define MAX_SPEED_SLIDER_SETTINGS pow(MAX_SPEED_ANGLES, 1/FACTORFORCONTROL)+ZERORANGE_SPEED



@interface ABSViewControllerFlight ()
@property (weak, nonatomic) IBOutlet UISlider *sliderRotation;
@property (weak, nonatomic) IBOutlet UISlider *sliderDirection;
@property (weak, nonatomic) IBOutlet UISlider *sliderAltitude;

@property (weak, nonatomic) IBOutlet UITextField *gains_E1_Speed;
@property (weak, nonatomic) IBOutlet UITextField *gains_E2_Speed;
@property (weak, nonatomic) IBOutlet UITextField *gains_E3_Speed;
@property (weak, nonatomic) IBOutlet UITextField *gains_E4_Speed;

@property (weak, nonatomic) IBOutlet UITextField *gains_E1_Pitch;
@property (weak, nonatomic) IBOutlet UITextField *gains_E2_Pitch;
@property (weak, nonatomic) IBOutlet UITextField *gains_E3_Pitch;
@property (weak, nonatomic) IBOutlet UITextField *gains_E4_Pitch;

@property (weak, nonatomic) IBOutlet UITextField *gains_E1_Roll;
@property (weak, nonatomic) IBOutlet UITextField *gains_E2_Roll;
@property (weak, nonatomic) IBOutlet UITextField *gains_E3_Roll;
@property (weak, nonatomic) IBOutlet UITextField *gains_E4_Roll;
@property double rollLast,pitchLast, speedLast;



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
    // NSLog(@"%f", MAX_PITCH_SLIDER_SETTINGS);
    // NSLog(@"%f", MAX_ROLL_SLIDER_SETTINGS);
    // NSLog(@"%f", MAX_SPEED_SLIDER_SETTINGS);
    
    self.sliderAltitude.minimumValue=0;
    self.sliderAltitude.maximumValue=(MAX_SPEED_ANGLES);
    self.sliderAltitude.value=0;
    
    self.sliderRotation.minimumValue=-(MAX_ROLL_ANGLES);
    self.sliderRotation.maximumValue=(MAX_ROLL_ANGLES);
    self.sliderRotation.value=0;
    
    self.sliderDirection.minimumValue=-(MAX_PITCH_ANGLES);
    self.sliderDirection.maximumValue=(MAX_PITCH_ANGLES);
    
    self.sliderDirection.value=0;
    
    self.gains_E1_Speed.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E1_S];
    self.gains_E2_Speed.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E2_S];
    self.gains_E3_Speed.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E3_S];
    self.gains_E4_Speed.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E4_S];

    self.gains_E1_Pitch.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E1_P];
    self.gains_E2_Pitch.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E2_P];
    self.gains_E3_Pitch.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E3_P];
    self.gains_E4_Pitch.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E4_P];
    
    self.gains_E1_Roll.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E1_R];
    self.gains_E2_Roll.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E2_R];
    self.gains_E3_Roll.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E3_R];
    self.gains_E4_Roll.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E4_R];
    
    
   // self.sliderAltitude.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sliderAltitudeChanged:(id)sender {
    [self.ConnectionParameters changeAltitude:self.sliderAltitude.value-self.speedLast];
    self.speedLast=self.sliderAltitude.value;
    /*NSLog(@"%@", self.ConnectionParameters.IPAddress);
    NSLog(@"%@", self.ConnectionParameters.RemotePort);
    NSLog(@"%@", self.ConnectionParameters.LocalPort);
    NSLog(@"%d", self.ConnectionParameters.sock_client);
    NSLog(@"%d", self.ConnectionParameters.sock_server);*/
//    NSLog(@"%f", self.sliderAltitude.value);
//    NSLog(@"Adjusted: %d", [self interpolatedFunction:self.sliderAltitude.value]);
}

- (IBAction)sliderDirectionChanged:(id)sender {
    if(self.pitchLast!=self.sliderDirection.value)
    [self.ConnectionParameters changeDirection:-(self.sliderDirection.value-self.pitchLast)];
    self.pitchLast=-self.sliderDirection.value;
   // NSLog(@"Direction: %f", -[self interpolatedFunctionAngles:self.sliderDirection.value]);
}
- (IBAction)sliderRotationChanged:(id)sender {
    if(self.rollLast!=self.sliderRotation.value)
    [self.ConnectionParameters changeRotation:(self.sliderRotation.value-self.rollLast)];
    self.rollLast=self.sliderRotation.value;
   // NSLog(@"ROtaion: %f", [self interpolatedFunctionAngles:self.sliderRotation.value]);
}

/*- (float) interpolatedFunctionSpeed: (float) ch
{
    if(abs(ch)<ZERORANGE_SPEED) return 0;
    else return (float)pow(ch-ZERORANGE_SPEED, FACTORFORCONTROL);
}


- (float) interpolatedFunctionAngles: (float) ch
{
    if(abs(ch)<ZERORANGE_ANGLES) return 0;
    else if(ch>=0) return (float)pow(abs(ch-ZERORANGE_ANGLES), FACTORFORCONTROL);
    else return -(float)pow(abs(ch+ZERORANGE_ANGLES), FACTORFORCONTROL);
}*/

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
- (IBAction)buttonUpdateMixerSettings:(id)sender {
    [self.ConnectionParameters changeMixerGains:1 gain_1:self.gains_E1_Speed.text.floatValue gain_2:self.gains_E2_Speed.text.floatValue  gain_3:self.gains_E3_Speed.text.floatValue  gain_4:self.gains_E4_Speed.text.floatValue ];
    
    self.ConnectionParameters.g_E1_S=self.gains_E1_Speed.text.doubleValue;
    self.ConnectionParameters.g_E2_S=self.gains_E2_Speed.text.doubleValue;
    self.ConnectionParameters.g_E3_S=self.gains_E3_Speed.text.doubleValue;
    self.ConnectionParameters.g_E4_S=self.gains_E4_Speed.text.doubleValue;
}
- (IBAction)buttonUpdateMixerSettings2:(id)sender {
    [self.ConnectionParameters changeMixerGains:2 gain_1:self.gains_E1_Pitch.text.floatValue gain_2:self.gains_E2_Pitch.text.floatValue  gain_3:self.gains_E3_Pitch.text.floatValue  gain_4:self.gains_E4_Pitch.text.floatValue ];
    
    self.ConnectionParameters.g_E1_P=self.gains_E1_Pitch.text.doubleValue;
    self.ConnectionParameters.g_E2_P=self.gains_E2_Pitch.text.doubleValue;
    self.ConnectionParameters.g_E3_P=self.gains_E3_Pitch.text.doubleValue;
    self.ConnectionParameters.g_E4_P=self.gains_E4_Pitch.text.doubleValue;
}
- (IBAction)buttonUpdateMixerSettings3:(id)sender {
    [self.ConnectionParameters changeMixerGains:3 gain_1:self.gains_E1_Roll.text.floatValue gain_2:self.gains_E2_Roll.text.floatValue  gain_3:self.gains_E3_Roll.text.floatValue  gain_4:self.gains_E4_Roll.text.floatValue ];
    self.ConnectionParameters.g_E1_R=self.gains_E1_Roll.text.doubleValue;
    self.ConnectionParameters.g_E2_R=self.gains_E2_Roll.text.doubleValue;
    self.ConnectionParameters.g_E3_R=self.gains_E3_Roll.text.doubleValue;
    self.ConnectionParameters.g_E4_R=self.gains_E4_Roll.text.doubleValue;
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)rollSliderGetBackToZeroEveryWhere:(id)sender {
    [self.ConnectionParameters changeRotation:-self.sliderRotation.value];
    self.sliderRotation.value=0;
}
- (IBAction)pitchSliderGetBackToZeroEveryWhere:(id)sender {
    [self.ConnectionParameters changeDirection:+self.sliderDirection.value];
    self.sliderDirection.value=0;
}
- (IBAction)rollSliderGetBackToZero:(id)sender {
    [self.ConnectionParameters changeRotation:-self.sliderRotation.value];
    self.sliderRotation.value=0;
}
- (IBAction)pitchSliderGetBackToZero:(id)sender {
    [self.ConnectionParameters changeDirection:+self.sliderDirection.value];
    self.sliderDirection.value=0;
}

@end
