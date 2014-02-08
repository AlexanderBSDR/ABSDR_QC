//
//  ABSViewControllerControlBoard.m
//  ABSDR_QC
//
//  Created by CIG account on 1/31/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import "ABSViewControllerControlBoard.h"
#import "ABSViewControllerLogin.h"
#import "ABSViewControllerFlight.h"

#import "ABSControlParameters.h"

@interface ABSViewControllerControlBoard ()
@property (weak, nonatomic) IBOutlet UILabel *labelSent;
@property (weak, nonatomic) IBOutlet UISlider *engineOneSlider;
@property (weak, nonatomic) IBOutlet UILabel *engineOneLabel;
@property (weak, nonatomic) IBOutlet UIStepper *engineOneStepper;

@property (weak, nonatomic) IBOutlet UIStepper *engineTwoStepper;
@property (weak, nonatomic) IBOutlet UILabel *engineTwoLabel;
@property (weak, nonatomic) IBOutlet UISlider *engineTwoSlider;

@property (weak, nonatomic) IBOutlet UIStepper *engineThreeStepper;
@property (weak, nonatomic) IBOutlet UILabel *engineThreeLabel;
@property (weak, nonatomic) IBOutlet UISlider *engineThreeSlider;

@property (weak, nonatomic) IBOutlet UIStepper *engineFourStepper;
@property (weak, nonatomic) IBOutlet UILabel *engineFourLabel;
@property (weak, nonatomic) IBOutlet UISlider *engineFourSlider;

@property (weak, nonatomic) IBOutlet UIStepper *engineAllStepper;
@property (weak, nonatomic) IBOutlet UILabel *engineAllLabel;
@property (weak, nonatomic) IBOutlet UISlider *engineAllSlider;

@property NSNumber  *old_Slider;
@property NSNumber  *old_Stepper;


@property (weak, nonatomic) IBOutlet UIButton *buttonClicked;

//@property int sock;

@property ABSControlParameters *objParameters;

@end

@implementation ABSViewControllerControlBoard

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


    }
    return self;
}

- (void)viewDidLoad
{
    self.old_Slider=[[NSNumber alloc] init];
    self.old_Stepper=[[NSNumber alloc] init];
    
    self.objParameters = [[ABSControlParameters alloc] init];
    NSNumber *max_int=@255;
    
    self.objParameters.maxValue=max_int;
    [super viewDidLoad];
    
    self.engineOneStepper.maximumValue=self.objParameters.maxValue.doubleValue;
    self.engineOneSlider.maximumValue=self.objParameters.maxValue.doubleValue;
    
    self.engineTwoStepper.maximumValue=self.objParameters.maxValue.doubleValue;
    self.engineTwoSlider.maximumValue=self.objParameters.maxValue.doubleValue;
    
    self.engineThreeStepper.maximumValue=self.objParameters.maxValue.doubleValue;
    self.engineThreeSlider.maximumValue=self.objParameters.maxValue.doubleValue;
    
    self.engineFourStepper.maximumValue=self.objParameters.maxValue.doubleValue;
    self.engineFourSlider.maximumValue=self.objParameters.maxValue.doubleValue;
    
    self.engineAllStepper.maximumValue=self.objParameters.maxValue.doubleValue;
    self.engineAllSlider.maximumValue=self.objParameters.maxValue.doubleValue;

  
    [NSThread detachNewThreadSelector:@selector(startServer) toTarget:self.ConnectionParameters withObject:Nil];
    
    [self.ConnectionParameters sendServerSocket:self.ConnectionParameters.IPAddress port:self.ConnectionParameters.RemotePort.intValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)engineOneStepperChanged:(id)sender {
    NSString *temp=@"Engine #1: ";
    self.objParameters.EngineSpeedOne=[NSNumber numberWithInt:(int)self.engineOneStepper.value];
    
    self.engineOneLabel.text=[temp stringByAppendingString:self.objParameters.EngineSpeedOne.stringValue];
    self.engineOneSlider.value=self.engineOneStepper.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineOneSliderChanged:(id)sender {
    NSString *temp=@"Engine #1: ";
    self.objParameters.EngineSpeedOne=[NSNumber numberWithInt:(int)self.engineOneSlider.value];
    
    self.engineOneLabel.text=[temp stringByAppendingString:self.objParameters.EngineSpeedOne.stringValue];
    self.engineOneStepper.value=self.engineOneSlider.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineTwoSteppedChanged:(id)sender {
    NSString *temp=@"Engine #2: ";
    self.objParameters.EngineSpeedTwo=[NSNumber numberWithInt:(int)self.engineTwoStepper.value];
    self.engineTwoLabel.text=[temp stringByAppendingString:self.objParameters.EngineSpeedTwo.stringValue];
    self.engineTwoSlider.value=self.engineTwoStepper.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineTwoSliderChanged:(id)sender {
    NSString *temp=@"Engine #2: ";
    self.objParameters.EngineSpeedTwo=[NSNumber numberWithInt:(int)self.engineTwoSlider.value];
    
    self.engineTwoLabel.text=[temp stringByAppendingString:self.objParameters.EngineSpeedTwo.stringValue];
    self.engineTwoStepper.value=self.engineTwoSlider.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineThreeStepperChanged:(id)sender {
    NSString *temp=@"Engine #3: ";
    self.objParameters.EngineSpeedThree=[NSNumber numberWithInt:(int)self.engineThreeStepper.value];
    self.engineThreeLabel.text=[temp stringByAppendingString:self.objParameters.EngineSpeedThree.stringValue];
    self.engineThreeSlider.value=self.engineThreeStepper.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineThreeSliderChanged:(id)sender {
    NSString *temp=@"Engine #3: ";
    self.objParameters.EngineSpeedThree=[NSNumber numberWithInt:(int)self.engineThreeSlider.value];
    
    self.engineThreeLabel.text=[temp stringByAppendingString:self.objParameters.EngineSpeedThree.stringValue];
    self.engineThreeStepper.value=self.engineThreeSlider.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineFourSteppedChanged:(id)sender {
    NSString *temp=@"Engine #4: ";
    self.objParameters.EngineSpeedFour=[NSNumber numberWithInt:(int)self.engineFourStepper.value];
    self.engineFourLabel.text=[temp stringByAppendingString:self.objParameters.EngineSpeedFour.stringValue];
    self.engineFourSlider.value=self.engineFourStepper.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}

- (IBAction)engineFourSliderChanged:(id)sender {
    NSString *temp=@"Engine #4: ";
    self.objParameters.EngineSpeedFour=[NSNumber numberWithInt:(int)self.engineFourSlider.value];
    
    self.engineFourLabel.text=[temp stringByAppendingString:self.objParameters.EngineSpeedFour.stringValue];
    self.engineFourStepper.value=self.engineFourSlider.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineAllStepperChanged:(id)sender {

    int delta;
    delta=(int)self.engineAllStepper.value-self.old_Stepper.intValue;
    NSNumber *e1d=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedOne.intValue+delta)];
    NSNumber *e2d=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedTwo.intValue+delta)];
    NSNumber *e3d=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedThree.intValue+delta)];
    NSNumber *e4d=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedFour.intValue+delta)];
    NSNumber *ezero=@0;
    
    NSString *temp1=@"Engine #1: ";
    //self.objParameters.EngineSpeedOne=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedOne.intValue+delta)];
    if(e1d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedOne=self.objParameters.maxValue;
    } else if(e1d.intValue<0)
    {
        self.objParameters.EngineSpeedOne=ezero;
    }
    else
    {
        self.objParameters.EngineSpeedOne=e1d;
    }
    
    self.engineOneLabel.text=[temp1 stringByAppendingString:self.objParameters.EngineSpeedOne.stringValue];
    self.engineOneSlider.value=self.objParameters.EngineSpeedOne.doubleValue;
    self.engineOneStepper.value=self.objParameters.EngineSpeedOne.doubleValue;
    
    NSString *temp2=@"Engine #2: ";
//    self.objParameters.EngineSpeedTwo=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedTwo.intValue+delta)];
    if(e2d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedTwo=self.objParameters.maxValue;
    } else if(e2d.intValue<0)
    {
        self.objParameters.EngineSpeedTwo=ezero;
    }
    else
    {
        self.objParameters.EngineSpeedTwo=e2d;
    }
    
    self.engineTwoLabel.text=[temp2 stringByAppendingString:self.objParameters.EngineSpeedTwo.stringValue];
    self.engineTwoSlider.value=self.objParameters.EngineSpeedTwo.doubleValue;
    self.engineTwoStepper.value=self.objParameters.EngineSpeedTwo.doubleValue;

    NSString *temp3=@"Engine #3: ";
//    self.objParameters.EngineSpeedThree=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedThree.intValue+delta)];
    if(e3d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedThree=self.objParameters.maxValue;
    } else if(e3d.intValue<0)
    {
        self.objParameters.EngineSpeedThree=ezero;
    }
    else
    {
        self.objParameters.EngineSpeedThree=e3d;
    }
    
    self.engineThreeLabel.text=[temp3 stringByAppendingString:self.objParameters.EngineSpeedThree.stringValue];
    self.engineThreeSlider.value=self.objParameters.EngineSpeedThree.doubleValue;
    self.engineThreeStepper.value=self.objParameters.EngineSpeedThree.doubleValue;
    
    NSString *temp4=@"Engine #4: ";
//    self.objParameters.EngineSpeedFour=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedFour.intValue+delta)];
    if(e4d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedFour=self.objParameters.maxValue;
    } else if(e4d.intValue<0)
    {
        self.objParameters.EngineSpeedFour=ezero;
    }
    else
    {
        self.objParameters.EngineSpeedFour=e4d;
    }
    
    self.engineFourLabel.text=[temp4 stringByAppendingString:self.objParameters.EngineSpeedFour.stringValue];
    self.engineFourSlider.value=self.objParameters.EngineSpeedFour.doubleValue;
    self.engineFourStepper.value=self.objParameters.EngineSpeedFour.doubleValue;
    
    self.engineAllSlider.value=self.engineAllStepper.value;
    
    self.old_Stepper=[NSNumber numberWithInt:(int)self.engineAllStepper.value];
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineAllSliderChanged:(id)sender {
    
    int delta;
    delta=(int)self.engineAllSlider.value-self.old_Slider.intValue;
    NSNumber *e1d=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedOne.intValue+delta)];
    NSNumber *e2d=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedTwo.intValue+delta)];
    NSNumber *e3d=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedThree.intValue+delta)];
    NSNumber *e4d=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedFour.intValue+delta)];
    NSNumber *ezero=@0;
//    NSLog(@"Delta: %d", delta);
//    NSLog(@"E1D: %d",self.objParameters.EngineSpeedOne.intValue+delta);
    
    NSString *temp1=@"Engine #1: ";
    if(e1d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedOne=self.objParameters.maxValue;
    } else if(e1d.intValue<0)
    {
        self.objParameters.EngineSpeedOne=ezero;
    }
    else
    {
        self.objParameters.EngineSpeedOne=e1d;
    }
    
    self.engineOneLabel.text=[temp1 stringByAppendingString:self.objParameters.EngineSpeedOne.stringValue];
    self.engineOneSlider.value=self.objParameters.EngineSpeedOne.doubleValue;
    self.engineOneStepper.value=self.objParameters.EngineSpeedOne.doubleValue;
    
    NSString *temp2=@"Engine #2: ";
    if(e2d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedTwo=self.objParameters.maxValue;
    } else if(e2d.intValue<0)
    {
        self.objParameters.EngineSpeedTwo=ezero;
        
    }
    else
    {
        self.objParameters.EngineSpeedTwo=e2d;
    }
    
    self.engineTwoLabel.text=[temp2 stringByAppendingString:self.objParameters.EngineSpeedTwo.stringValue];
    self.engineTwoSlider.value=self.objParameters.EngineSpeedTwo.doubleValue;
    self.engineTwoStepper.value=self.objParameters.EngineSpeedTwo.doubleValue;
    
    NSString *temp3=@"Engine #3: ";
    if(e3d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedThree=self.objParameters.maxValue;
    }  else if(e3d.intValue<0)
    {
        self.objParameters.EngineSpeedThree=ezero;
        
    }
    else
    {
        self.objParameters.EngineSpeedThree=e3d;
    }
    
    self.engineThreeLabel.text=[temp3 stringByAppendingString:self.objParameters.EngineSpeedThree.stringValue];
    self.engineThreeSlider.value=self.objParameters.EngineSpeedThree.doubleValue;
    self.engineThreeStepper.value=self.objParameters.EngineSpeedThree.doubleValue;
    
    NSString *temp4=@"Engine #4: ";
    if(e4d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedFour=self.objParameters.maxValue;
    } else if(e4d.intValue<0)
    {
        self.objParameters.EngineSpeedFour=ezero;
        
    }
    else
    {
        self.objParameters.EngineSpeedFour=e4d;
    }
    
    self.engineFourLabel.text=[temp4 stringByAppendingString:self.objParameters.EngineSpeedFour.stringValue];
    self.engineFourSlider.value=self.objParameters.EngineSpeedFour.doubleValue;
    self.engineFourStepper.value=self.objParameters.EngineSpeedFour.doubleValue;
    
    self.engineAllStepper.value=self.engineAllSlider.value;
    
    self.old_Slider=[NSNumber numberWithInt:(int)self.engineAllSlider.value];
    
    //sending updated parameters
    [self updateEngineParameters];
}

-(void) updateEngineParameters
{
    char *buffer=malloc(sizeof(char)*7);
    
    buffer[0]=0x01;
    buffer[1]=0xFF;
    buffer[2]=(char)self.objParameters.EngineSpeedOne.intValue;
    buffer[3]=(char)self.objParameters.EngineSpeedTwo.intValue;
    buffer[4]=(char)self.objParameters.EngineSpeedThree.intValue;
    buffer[5]=(char)self.objParameters.EngineSpeedFour.intValue;
    buffer[6]='\0';

    [self.ConnectionParameters sendClient:buffer length:6];
    NSNumber *t=[[NSNumber alloc] initWithInt:(self.ConnectionParameters.PackagesSent.intValue+1)];
    self.ConnectionParameters.PackagesSent=t;
    self.labelSent.text=self.ConnectionParameters.PackagesSent.stringValue;
    
    free(buffer);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showFlightBoard"])
    {
        ABSViewControllerFlight *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
    }
}
- (IBAction)clickedButton:(id)sender {
    
    NSLog(@"%@", self.ConnectionParameters.IPAddress);
    NSLog(@"%@", self.ConnectionParameters.RemotePort);
//    NSLog(@"%@", self.ConnectionParameters.LocalPort);
    NSLog(@"%d", self.ConnectionParameters.sock_client);
    NSLog(@"%d", self.ConnectionParameters.sock_server);
}

@end
