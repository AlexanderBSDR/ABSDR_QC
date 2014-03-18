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

@property double  old_Slider;
@property double  old_Stepper;


@property (weak, nonatomic) IBOutlet UIButton *buttonClicked;

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
    
    [super viewDidLoad];

    
    self.old_Slider=self.ConnectionParameters.engineMin;
    self.old_Stepper=self.ConnectionParameters.engineMin;
    
    self.engineOneStepper.maximumValue=self.ConnectionParameters.engineMax;
    self.engineOneSlider.maximumValue=self.ConnectionParameters.engineMax;
    self.engineOneStepper.minimumValue=self.ConnectionParameters.engineMin;
    self.engineOneSlider.minimumValue=self.ConnectionParameters.engineMin;
    self.engineOneStepper.value=self.ConnectionParameters.engineOne;
    self.engineOneSlider.value=self.ConnectionParameters.engineOne;
    
    self.engineTwoStepper.maximumValue=self.ConnectionParameters.engineMax;
    self.engineTwoSlider.maximumValue=self.ConnectionParameters.engineMax;
    self.engineTwoStepper.minimumValue=self.ConnectionParameters.engineMin;
    self.engineTwoSlider.minimumValue=self.ConnectionParameters.engineMin;
    self.engineTwoStepper.value=self.ConnectionParameters.engineTwo;
    self.engineTwoSlider.value=self.ConnectionParameters.engineTwo;
    
    self.engineThreeStepper.maximumValue=self.ConnectionParameters.engineMax;
    self.engineThreeSlider.maximumValue=self.ConnectionParameters.engineMax;
    self.engineThreeStepper.minimumValue=self.ConnectionParameters.engineMin;
    self.engineThreeSlider.minimumValue=self.ConnectionParameters.engineMin;
    self.engineThreeStepper.value=self.ConnectionParameters.engineThree;
    self.engineThreeSlider.value=self.ConnectionParameters.engineThree;
    
    self.engineFourStepper.maximumValue=self.ConnectionParameters.engineMax;
    self.engineFourSlider.maximumValue=self.ConnectionParameters.engineMax;
    self.engineFourStepper.minimumValue=self.ConnectionParameters.engineMin;
    self.engineFourSlider.minimumValue=self.ConnectionParameters.engineMin;
    self.engineFourStepper.value=self.ConnectionParameters.engineFour;
    self.engineFourSlider.value=self.ConnectionParameters.engineFour;
    
    self.engineAllStepper.maximumValue=self.ConnectionParameters.engineMax;
    self.engineAllSlider.maximumValue=self.ConnectionParameters.engineMax;
    self.engineAllStepper.minimumValue=self.ConnectionParameters.engineMin;
    self.engineAllSlider.minimumValue=self.ConnectionParameters.engineMin;
    self.engineAllStepper.value=self.ConnectionParameters.engineMin;
    self.engineAllSlider.value=self.ConnectionParameters.engineMin;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)engineOneStepperChanged:(id)sender {
    NSString *temp=@"Engine #1: ";
    self.ConnectionParameters.engineOne=(unsigned short)self.engineOneStepper.value;
    
    self.engineOneLabel.text=[temp stringByAppendingFormat:@"%d",self.ConnectionParameters.engineOne];
    self.engineOneSlider.value=self.engineOneStepper.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineOneSliderChanged:(id)sender {
    NSString *temp=@"Engine #1: ";
    self.ConnectionParameters.engineOne=(unsigned short)self.engineOneSlider.value;
    
    self.engineOneLabel.text=[temp stringByAppendingFormat:@"%d",self.ConnectionParameters.engineOne];
    self.engineOneStepper.value=self.engineOneSlider.value;
    //NSLog(@"Eng one: %d", )
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineTwoSteppedChanged:(id)sender {
    NSString *temp=@"Engine #2: ";
    self.ConnectionParameters.engineTwo=(unsigned short)self.engineTwoStepper.value;
    
    self.engineTwoLabel.text=[temp stringByAppendingFormat:@"%d",self.ConnectionParameters.engineTwo];
    self.engineTwoSlider.value=self.engineTwoStepper.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineTwoSliderChanged:(id)sender {
    NSString *temp=@"Engine #2: ";
    self.ConnectionParameters.engineTwo=(unsigned short)self.engineTwoSlider.value;
    
    self.engineTwoLabel.text=[temp stringByAppendingFormat:@"%d",self.ConnectionParameters.engineTwo];
    self.engineTwoStepper.value=self.engineTwoSlider.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineThreeStepperChanged:(id)sender {
    NSString *temp=@"Engine #3: ";
    self.ConnectionParameters.engineThree=(unsigned short)self.engineThreeStepper.value;

    self.engineThreeLabel.text=[temp stringByAppendingFormat:@"%d",self.ConnectionParameters.engineThree];
    self.engineThreeSlider.value=self.engineThreeStepper.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineThreeSliderChanged:(id)sender {
    NSString *temp=@"Engine #3: ";
    self.ConnectionParameters.engineThree=(unsigned short)self.engineThreeSlider.value;
    
    self.engineThreeLabel.text=[temp stringByAppendingFormat:@"%d",self.ConnectionParameters.engineThree];
    self.engineThreeStepper.value=self.engineThreeSlider.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineFourSteppedChanged:(id)sender {
    NSString *temp=@"Engine #4: ";
    self.ConnectionParameters.engineFour=(unsigned short)self.engineFourStepper.value;
    
    self.engineFourLabel.text=[temp stringByAppendingFormat:@"%d",self.ConnectionParameters.engineFour];
    self.engineFourSlider.value=self.engineFourStepper.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}

- (IBAction)engineFourSliderChanged:(id)sender {
    NSString *temp=@"Engine #4: ";
    self.ConnectionParameters.engineFour=(unsigned short)self.engineFourSlider.value;
    
    self.engineFourLabel.text=[temp stringByAppendingFormat:@"%d",self.ConnectionParameters.engineFour];
    self.engineFourStepper.value=self.engineFourSlider.value;
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineAllStepperChanged:(id)sender {

    int delta;
    delta=(int)self.engineAllStepper.value-self.old_Stepper;
    
    NSString *temp1=@"Engine #1: ";
    //self.objParameters.EngineSpeedOne=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedOne.intValue+delta)];
    if(self.ConnectionParameters.engineOne+delta>self.ConnectionParameters.engineMax)
    {
        self.ConnectionParameters.engineOne=self.ConnectionParameters.engineMax;
    } else if(self.ConnectionParameters.engineOne+delta<self.ConnectionParameters.engineMin)
    {
        self.ConnectionParameters.engineOne=self.ConnectionParameters.engineMin;
    }
    else
    {
        self.ConnectionParameters.engineOne+=delta;
    }
    
    self.engineOneLabel.text=[temp1 stringByAppendingFormat:@"%d",self.ConnectionParameters.engineOne];
    
    self.engineOneSlider.value=self.ConnectionParameters.engineOne;
    self.engineOneStepper.value=self.ConnectionParameters.engineOne;
    
    NSString *temp2=@"Engine #2: ";
//    self.objParameters.EngineSpeedTwo=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedTwo.intValue+delta)];
    if(self.ConnectionParameters.engineTwo+delta>self.ConnectionParameters.engineMax)
    {
        self.ConnectionParameters.engineTwo=self.ConnectionParameters.engineMax;
    } else if(self.ConnectionParameters.engineTwo+delta<self.ConnectionParameters.engineMin)
    {
        self.ConnectionParameters.engineTwo=self.ConnectionParameters.engineMin;
    }
    else
    {
        self.ConnectionParameters.engineTwo+=delta;
    }
    
    self.engineTwoLabel.text=[temp2 stringByAppendingFormat:@"%d",self.ConnectionParameters.engineTwo];
    
    self.engineTwoSlider.value=self.ConnectionParameters.engineTwo;
    self.engineTwoStepper.value=self.ConnectionParameters.engineTwo;

    NSString *temp3=@"Engine #3: ";
//    self.objParameters.EngineSpeedThree=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedThree.intValue+delta)];
    if(self.ConnectionParameters.engineThree+delta>self.ConnectionParameters.engineMax)
    {
        self.ConnectionParameters.engineThree=self.ConnectionParameters.engineMax;
    } else if(self.ConnectionParameters.engineThree+delta<self.ConnectionParameters.engineMin)
    {
        self.ConnectionParameters.engineThree=self.ConnectionParameters.engineMin;
    }
    else
    {
        self.ConnectionParameters.engineThree+=delta;
    }
    
    self.engineThreeLabel.text=[temp3 stringByAppendingFormat:@"%d",self.ConnectionParameters.engineThree];
    
    self.engineThreeSlider.value=self.ConnectionParameters.engineThree;
    self.engineThreeStepper.value=self.ConnectionParameters.engineThree;
    
    NSString *temp4=@"Engine #4: ";
//    self.objParameters.EngineSpeedFour=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedFour.intValue+delta)];
    if(self.ConnectionParameters.engineFour+delta>self.ConnectionParameters.engineMax)
    {
        self.ConnectionParameters.engineFour=self.ConnectionParameters.engineMax;
    } else if(self.ConnectionParameters.engineFour+delta<self.ConnectionParameters.engineMin)
    {
        self.ConnectionParameters.engineFour=self.ConnectionParameters.engineMin;
    }
    else
    {
        self.ConnectionParameters.engineFour+=delta;
    }
    
    self.engineFourLabel.text=[temp4 stringByAppendingFormat:@"%d",self.ConnectionParameters.engineFour];
    
    self.engineFourSlider.value=self.ConnectionParameters.engineFour;
    self.engineFourStepper.value=self.ConnectionParameters.engineFour;
    
    self.engineAllSlider.value=self.engineAllStepper.value;
    
    self.old_Stepper=round(self.engineAllStepper.value);
    
    //sending updated parameters
    [self updateEngineParameters];
}
- (IBAction)engineAllSliderChanged:(id)sender {
    
    int delta;
    delta=(int)round(self.engineAllSlider.value)-self.old_Slider;
    NSLog(@"Delta: %d", delta);
//    NSLog(@"E1D: %d",self.objParameters.EngineSpeedOne.intValue+delta);
    
    NSString *temp1=@"Engine #1: ";
    if(self.ConnectionParameters.engineOne+delta>self.ConnectionParameters.engineMax)
    {
        self.ConnectionParameters.engineOne=self.ConnectionParameters.engineMax;
    } else if(self.ConnectionParameters.engineOne+delta<self.ConnectionParameters.engineMin)
    {
        self.ConnectionParameters.engineOne=self.ConnectionParameters.engineMin;
    }
    else
    {
        self.ConnectionParameters.engineOne+=delta;
    }
    
    self.engineOneLabel.text=[temp1 stringByAppendingFormat:@"%d",self.ConnectionParameters.engineOne];
    self.engineOneSlider.value=self.ConnectionParameters.engineOne;
    self.engineOneStepper.value=self.ConnectionParameters.engineOne;
    
    NSString *temp2=@"Engine #2: ";
    if(self.ConnectionParameters.engineTwo+delta>self.ConnectionParameters.engineMax)
    {
        self.ConnectionParameters.engineTwo=self.ConnectionParameters.engineMax;
    } else if(self.ConnectionParameters.engineTwo+delta<self.ConnectionParameters.engineMin)
    {
        self.ConnectionParameters.engineTwo=self.ConnectionParameters.engineMin;
    }
    else
    {
        self.ConnectionParameters.engineTwo+=delta;
    }
    
    self.engineTwoLabel.text=[temp2 stringByAppendingFormat:@"%d",self.ConnectionParameters.engineTwo];
    self.engineTwoSlider.value=self.ConnectionParameters.engineTwo;
    self.engineTwoStepper.value=self.ConnectionParameters.engineTwo;
    
    NSString *temp3=@"Engine #3: ";
    if(self.ConnectionParameters.engineThree+delta>self.ConnectionParameters.engineMax)
    {
        self.ConnectionParameters.engineThree=self.ConnectionParameters.engineMax;
    } else if(self.ConnectionParameters.engineThree+delta<self.ConnectionParameters.engineMin)
    {
        self.ConnectionParameters.engineThree=self.ConnectionParameters.engineMin;
    }
    else
    {
        self.ConnectionParameters.engineThree+=delta;
    }
    
    self.engineThreeLabel.text=[temp3 stringByAppendingFormat:@"%d",self.ConnectionParameters.engineThree];
    self.engineThreeSlider.value=self.ConnectionParameters.engineThree;
    self.engineThreeStepper.value=self.ConnectionParameters.engineThree;
    
    NSString *temp4=@"Engine #4: ";
    if(self.ConnectionParameters.engineFour+delta>self.ConnectionParameters.engineMax)
    {
        self.ConnectionParameters.engineFour=self.ConnectionParameters.engineMax;
    } else if(self.ConnectionParameters.engineFour+delta<self.ConnectionParameters.engineMin)
    {
        self.ConnectionParameters.engineFour=self.ConnectionParameters.engineMin;
    }
    else
    {
        self.ConnectionParameters.engineFour+=delta;
    }
    
    self.engineFourLabel.text=[temp4 stringByAppendingFormat:@"%d",self.ConnectionParameters.engineFour];
    self.engineFourSlider.value=self.ConnectionParameters.engineFour;
    self.engineFourStepper.value=self.ConnectionParameters.engineFour;
    
    self.engineAllStepper.value=self.engineAllSlider.value;
    
    self.old_Slider=round(self.engineAllSlider.value);
    
    //sending updated parameters
    [self updateEngineParameters];
}

-(void) updateEngineParameters
{

    [self.ConnectionParameters updateEngineParameters];
    NSString *str = [NSString stringWithFormat:@"%d",self.ConnectionParameters.PackagesSent];
    self.labelSent.text=str;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showFlightBoard"])
    {
        ABSViewControllerFlight *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
    }
}

@end
