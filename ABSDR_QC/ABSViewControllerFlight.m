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

//#define FACTORFORCONTROL 0.67

#define MAX_SPEED_ANGLES 360
#define MAX_PITCH_ANGLES MAX_SPEED_ANGLES/2
#define MAX_ROLL_ANGLES MAX_SPEED_ANGLES/2
#define MAX_YAW_ANGLES MAX_SPEED_ANGLES/2

#define MAX_TIME_SAMPLING 200/1000


@interface ABSViewControllerFlight ()
@property (weak, nonatomic) IBOutlet UISlider *sliderRotation;
@property (weak, nonatomic) IBOutlet UISlider *sliderDirection;
@property (weak, nonatomic) IBOutlet UISlider *sliderAltitude;
@property (weak, nonatomic) IBOutlet UISlider *sliderYaw;

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


@property (weak, nonatomic) IBOutlet UITextField *gains_E1_Yaw;
@property (weak, nonatomic) IBOutlet UITextField *gains_E2_Yaw;
@property (weak, nonatomic) IBOutlet UITextField *gains_E3_Yaw;
@property (weak, nonatomic) IBOutlet UITextField *gains_E4_Yaw;

@property double rollLast,pitchLast, speedLast, yawLast;
//@property double speedCumulative, pitchCumulative, rollCumulative;


@property (weak, nonatomic) IBOutlet UIProgressView *progress_E1;
@property (weak, nonatomic) IBOutlet UIProgressView *progress_E2;
@property (weak, nonatomic) IBOutlet UIProgressView *progress_E3;
@property (weak, nonatomic) IBOutlet UIProgressView *progress_E4;
@property (weak, nonatomic) IBOutlet UILabel *label_E1;
@property (weak, nonatomic) IBOutlet UILabel *label_E2;
@property (weak, nonatomic) IBOutlet UILabel *label_E3;
@property (weak, nonatomic) IBOutlet UILabel *label_E4;
@property (weak, nonatomic) IBOutlet UIProgressView *pb;

@property NSTimer* timer1;



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
    
    self.progress_E1.transform=CGAffineTransformConcat(CGAffineTransformMakeRotation(-M_PI_2),CGAffineTransformMakeScale(10.0f, 1.0f));
    self.progress_E2.transform=CGAffineTransformConcat(CGAffineTransformMakeRotation(-M_PI_2),CGAffineTransformMakeScale(10.0f, 1.0f));
    self.progress_E3.transform=CGAffineTransformConcat(CGAffineTransformMakeRotation(-M_PI_2),CGAffineTransformMakeScale(10.0f, 1.0f));
    self.progress_E4.transform=CGAffineTransformConcat(CGAffineTransformMakeRotation(-M_PI_2),CGAffineTransformMakeScale(10.0f, 1.0f));
    
    self.pb.transform=CGAffineTransformConcat(CGAffineTransformMakeRotation(-M_PI_2),CGAffineTransformMakeScale(10.0f, 1.0f));

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
    
    self.sliderYaw.minimumValue=-(MAX_YAW_ANGLES);
    self.sliderYaw.maximumValue=(MAX_YAW_ANGLES);
    self.sliderYaw.value=0;
    
    self.speedLast=CACurrentMediaTime();
    self.pitchLast=CACurrentMediaTime();
    self.rollLast=CACurrentMediaTime();
    self.yawLast=CACurrentMediaTime();

    
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
    
    self.gains_E1_Yaw.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E1_Y];
    self.gains_E2_Yaw.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E2_Y];
    self.gains_E3_Yaw.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E3_Y];
    self.gains_E4_Yaw.text=[[NSString alloc]initWithFormat:@"%1.2f", self.ConnectionParameters.g_E4_Y];
    
    self.timer1=[NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(updateProgressBars) userInfo:nil repeats:YES];
    self.ConnectionParameters.newData=TRUE;

    
    
   // self.sliderAltitude.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) updateProgressBars
{
    if(self.ConnectionParameters.newData==TRUE)
    {
        self.label_E1.text=[[NSString alloc] initWithFormat:@"%d", self.ConnectionParameters.engineOne];
        self.label_E2.text=[[NSString alloc] initWithFormat:@"%d", self.ConnectionParameters.engineTwo];
        self.label_E3.text=[[NSString alloc] initWithFormat:@"%d", self.ConnectionParameters.engineThree];
        self.label_E4.text=[[NSString alloc] initWithFormat:@"%d", self.ConnectionParameters.engineFour];
        
        int range=self.ConnectionParameters.engineMax-self.ConnectionParameters.engineMin;
        
        self.progress_E1.progress=(float)(self.ConnectionParameters.engineOne-self.ConnectionParameters.engineMin)/range;
        self.progress_E2.progress=(float)(self.ConnectionParameters.engineTwo-self.ConnectionParameters.engineMin)/range;
        self.progress_E3.progress=(float)(self.ConnectionParameters.engineThree-self.ConnectionParameters.engineMin)/range;
        self.progress_E4.progress=(float)(self.ConnectionParameters.engineFour-self.ConnectionParameters.engineMin)/range;
    }
    
    self.ConnectionParameters.newData=FALSE;
}



- (IBAction)sliderAltitudeChanged:(id)sender {
    
    if((CACurrentMediaTime()-self.speedLast)>=MAX_TIME_SAMPLING)
    {
        [self.ConnectionParameters changeAltitude:self.sliderAltitude.value];
        //NSLog(@"@Speed: %5.2f", self.sliderAltitude.value);
    }
    self.speedLast=CACurrentMediaTime();
    //NSLog(@"%f", CACurrentMediaTime());
}

- (IBAction)sliderDirectionChanged:(id)sender {

    if((CACurrentMediaTime()-self.pitchLast)>=MAX_TIME_SAMPLING)
    {
        [self.ConnectionParameters changeDirection:self.sliderDirection.value];
        //NSLog(@"@Direction: %5.2f", self.sliderDirection.value);
    }
    self.pitchLast=CACurrentMediaTime();

}
- (IBAction)sliderRotationChanged:(id)sender {

    if((CACurrentMediaTime()-self.rollLast)>=MAX_TIME_SAMPLING)
    {
        [self.ConnectionParameters changeRotation:self.sliderRotation.value];
        //NSLog(@"@Rotation: %5.2f", self.sliderRotation.value);
    }
    
    self.rollLast=CACurrentMediaTime();
}
- (IBAction)sliderYawChanged:(id)sender {
    if((CACurrentMediaTime()-self.yawLast)>=MAX_TIME_SAMPLING)
    {
        [self.ConnectionParameters changeYaw:self.sliderYaw.value];
        //NSLog(@"@Yaw: %5.2f", self.sliderRotation.value);
    }
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
        [self.timer1 invalidate];
        self.timer1 = nil;
    }
    
    if([segue.identifier isEqualToString:@"showGyroBoard"])
    {
        ABSViewControllerGyro *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
        [self.timer1 invalidate];
        self.timer1 = nil;
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
- (IBAction)buttonUpdateMixerSettings4:(id)sender {
    [self.ConnectionParameters changeMixerGains:4 gain_1:self.gains_E1_Yaw.text.floatValue gain_2:self.gains_E2_Yaw.text.floatValue  gain_3:self.gains_E3_Yaw.text.floatValue  gain_4:self.gains_E4_Yaw.text.floatValue ];
    self.ConnectionParameters.g_E1_Y=self.gains_E1_Yaw.text.doubleValue;
    self.ConnectionParameters.g_E2_Y=self.gains_E2_Yaw.text.doubleValue;
    self.ConnectionParameters.g_E3_Y=self.gains_E3_Yaw.text.doubleValue;
    self.ConnectionParameters.g_E4_Y=self.gains_E4_Yaw.text.doubleValue;
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
    [self.ConnectionParameters changeDirection:-self.sliderDirection.value];
    self.sliderDirection.value=0;
}
- (IBAction)rollSliderGetBackToZero:(id)sender {
    [self.ConnectionParameters changeRotation:-self.sliderRotation.value];
    self.sliderRotation.value=0;
}
- (IBAction)pitchSliderGetBackToZero:(id)sender {
    [self.ConnectionParameters changeDirection:-self.sliderDirection.value];
    self.sliderDirection.value=0;
}
- (IBAction)yawSliderGetBackToZero:(id)sender {
    [self.ConnectionParameters changeYaw:-self.sliderYaw.value];
    self.sliderYaw.value=0;
}

- (IBAction)yawSliderGetBackToZeroEveryWhere:(id)sender {
    [self.ConnectionParameters changeYaw:-self.sliderYaw.value];
    self.sliderYaw.value=0;
}

- (IBAction)clickedResetSettings:(id)sender {
    self.ConnectionParameters.engineOne=self.ConnectionParameters.engineMin;
    self.ConnectionParameters.engineTwo=self.ConnectionParameters.engineMin;
    self.ConnectionParameters.engineThree=self.ConnectionParameters.engineMin;
    self.ConnectionParameters.engineFour=self.ConnectionParameters.engineMin;
    self.sliderAltitude.value=0;
    
    [self.ConnectionParameters  changeRotation:0];
    [self.ConnectionParameters  changeDirection:0];
    [self.ConnectionParameters  changeAltitude:0];
    [self.ConnectionParameters updateEngineParameters];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
