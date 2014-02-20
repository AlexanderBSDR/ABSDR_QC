//
//  ABSViewControllerGyro.m
//  ABSDR_QC
//
//  Created by Alexander Bilyi on 2/8/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import "ABSViewControllerGyro.h"
#import "ABSViewControllerFlight.h"

@interface ABSViewControllerGyro ()

@property (weak, nonatomic) IBOutlet UIImageView *canvasX;
@property (weak, nonatomic) IBOutlet UIImageView *canvasY;
@property (weak, nonatomic) IBOutlet UIImageView *canvasZ;
@property (weak, nonatomic) IBOutlet UIImageView *canvasT;
@property (weak, nonatomic) IBOutlet UIImageView *canvasEngines;
@property (weak, nonatomic) IBOutlet UILabel *engineOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *engineTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *engineThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *engineFourLabel;
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UILabel *resolutionLabel;
@property (weak, nonatomic) IBOutlet UIStepper *resolutionStepper;
=======
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
>>>>>>> 73aab0984ed907a0c2a35b4b2ca734b156f7f410

@property int canvasMaxWidth;
@property int canvasMaxHeight;
@property float conversion_acc;
@property float conversion_gyr;
@property int scaleX;


@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation ABSViewControllerGyro

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
	// Do any additional setup after loading the view.
    
/*    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = .1;
    self.motionManager.gyroUpdateInterval = .1;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyroData, NSError *error){ [self outputRotationData:gyroData.rotationRate];}];
 
 */
    
    self.resolutionStepper.minimumValue=0;
    self.resolutionStepper.maximumValue=1000;
    self.resolutionStepper.value=100;
    self.resolutionStepper.stepValue=5;
    
   
    NSString *temp=[[NSString alloc]initWithFormat:@"%8.0f", self.resolutionStepper.value];
    self.resolutionLabel.text=temp;
    [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(addPoint) userInfo:nil repeats:YES];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.canvasMaxWidth=self.canvasX.frame.size.width;
    self.canvasMaxHeight=self.canvasX.frame.size.height;
    self.conversion_acc=4;
    self.conversion_gyr=4;
    self.scaleX=2;
    self.ConnectionParameters.maxSize=self.canvasMaxWidth/self.scaleX+1;
}

/*-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    self.accX.text = [NSString stringWithFormat:@"Acceleration in X: %.2fg",acceleration.x];
    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    self.accY.text = [NSString stringWithFormat:@"Acceleration in Y: %.2fg",acceleration.y];
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
    self.accZ.text = [NSString stringWithFormat:@"Acceleration in Z: %.2fg",acceleration.z];
    if(fabs(acceleration.z) > fabs(currentMaxAccelZ))
    {
        currentMaxAccelZ = acceleration.z;
    }
    
    self.maxAccX.text = [NSString stringWithFormat:@"Max: %.2f",currentMaxAccelX];
    self.maxAccY.text = [NSString stringWithFormat:@"Max: %.2f",currentMaxAccelY];
    self.maxAccZ.text = [NSString stringWithFormat:@"Max: %.2f",currentMaxAccelZ];

}
-(void)outputRotationData:(CMRotationRate)rotation
{
    self.rotX.text = [NSString stringWithFormat:@"Rotation in X: %.2fr/s",rotation.x];
    if(fabs(rotation.x) > fabs(currentMaxRotX))
    {
        currentMaxRotX = rotation.x;
    }
    self.rotY.text = [NSString stringWithFormat:@"Rotation in Y: %.2fr/s",rotation.y];
    if(fabs(rotation.y) > fabs(currentMaxRotY))
    {
        currentMaxRotY = rotation.y;
    }
    self.rotZ.text = [NSString stringWithFormat:@"Rotation in Z: %.2fr/s",rotation.z];
    if(fabs(rotation.z) > fabs(currentMaxRotZ))
    {
        currentMaxRotZ = rotation.z;
    }
    
    self.maxRotX.text = [NSString stringWithFormat:@"Max: %.2f",currentMaxRotX];
    self.maxRotY.text = [NSString stringWithFormat:@"Max: %.2f",currentMaxRotY];
    self.maxRotZ.text = [NSString stringWithFormat:@"Max: %.2f",currentMaxRotZ];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resetMaxValue:(id)sender {
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
}

- (void) addPoint
{

    [self reDrawCanvasX:self.canvasX accArray:self.ConnectionParameters.accArrayX rotArray:self.ConnectionParameters.rotArrayX];
    [self reDrawCanvasX:self.canvasY accArray:self.ConnectionParameters.accArrayY rotArray:self.ConnectionParameters.rotArrayY];
    [self reDrawCanvasX:self.canvasZ accArray:self.ConnectionParameters.accArrayZ rotArray:self.ConnectionParameters.rotArrayZ];
    [self reDrawCanvasX:self.canvasT accArray:self.ConnectionParameters.accArrayT rotArray:self.ConnectionParameters.rotArrayT];
    
    [self reDrawEngines:self.canvasEngines];

}

-(void) reDrawEngines: (UIImageView *) canvas
{
    
    CGSize size = CGSizeMake(canvas.frame.size.width, canvas.frame.size.height);
<<<<<<< HEAD
//    NSLog(@"width: %f", canvas.frame.size.width);
=======
>>>>>>> 73aab0984ed907a0c2a35b4b2ca734b156f7f410
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, NO);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    CGContextSetLineWidth(context, 1.0f);
    
    
    float box1x=45.0f;
    float box1y=10.0f;
    float box2x=20.0f;
    float box2y=100.0f;
    float box3x=70.0f;
    float box3y=100.0f;
    float box4x=45.0f;
    float box4y=190.0f;
    float box_height=80.0f;
    float box_width=30.0f;
    self.engineOneLabel.text=[NSString stringWithFormat:@"%d", self.ConnectionParameters.engineOne];
    self.engineTwoLabel.text=[NSString stringWithFormat:@"%d", self.ConnectionParameters.engineTwo];
    self.engineThreeLabel.text=[NSString stringWithFormat:@"%d", self.ConnectionParameters.engineThree];
    self.engineFourLabel.text=[NSString stringWithFormat:@"%d", self.ConnectionParameters.engineFour];
    
    self.batteryLabel.text=[NSString stringWithFormat:@"%1.2f", self.ConnectionParameters.batteryPower];
    self.altitudeLabel.text=[NSString stringWithFormat:@"%8.2f", self.ConnectionParameters.altitudeEnterprise];
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextAddRect(context, CGRectMake(box1x, box1y, box_width, box_height));
    CGContextStrokePath(context);
    int range=self.ConnectionParameters.engineMax-self.ConnectionParameters.engineMin;
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextFillRect(context, CGRectMake(box1x, box1y+(box_height*(1-(float)(self.ConnectionParameters.engineOne-self.ConnectionParameters.engineMin)/range)), box_width, box_height-(box_height*(1-(float)(self.ConnectionParameters.engineOne-self.ConnectionParameters.engineMin)/range))));

    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextAddRect(context, CGRectMake(box2x, box2y, box_width, box_height));
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillRect(context, CGRectMake(box2x, box2y+(box_height*(1-(float)(self.ConnectionParameters.engineTwo-self.ConnectionParameters.engineMin)/range)), box_width, box_height-(box_height*(1-(float)(self.ConnectionParameters.engineTwo-self.ConnectionParameters.engineMin)/range))));
    
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextAddRect(context, CGRectMake(box3x, box3y, box_width, box_height));
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillRect(context, CGRectMake(box3x, box3y+(box_height*(1-(float)(self.ConnectionParameters.engineThree-self.ConnectionParameters.engineMin)/range)), box_width, box_height-(box_height*(1-(float)(self.ConnectionParameters.engineThree-self.ConnectionParameters.engineMin)/range))));
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextAddRect(context, CGRectMake(box4x, box4y, box_width, box_height));
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextFillRect(context, CGRectMake(box4x, box4y+(box_height*(1-(float)(self.ConnectionParameters.engineFour-self.ConnectionParameters.engineMin)/range)), box_width, box_height-(box_height*(1-(float)(self.ConnectionParameters.engineFour-self.ConnectionParameters.engineMin)/range))));
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    canvas.image=result;

}

- (void) reDrawCanvasX: (UIImageView *) canvas accArray:(NSMutableArray *)accArray rotArray:(NSMutableArray *)rotArray
{
    
    CGPoint *accArrayCG;
    CGPoint *rotArrayCG;
    accArrayCG=(CGPoint *)malloc(sizeof(CGPoint)*accArray.count);
    rotArrayCG=(CGPoint *)malloc(sizeof(CGPoint)*rotArray.count);
    
    
    for (int i=0; i<accArray.count; i++)
    {
        accArrayCG[i].x=i*self.scaleX;
        @try {
            accArrayCG[i].y=[self reSizeAcc:[[accArray objectAtIndex:i] floatValue]];
        }
        
        @catch(NSException *exception)
        {
            NSLog(@"Exception @objectAtIndex.accArray!\n");
        }
        
    }
    
    for (int i=0; i<rotArray.count; i++)
    {
        rotArrayCG[i].x=i*self.scaleX;
        
        @try {
            rotArrayCG[i].y=[self reSizeAcc:[[rotArray objectAtIndex:i] floatValue]];
        }
    
        @catch(NSException *exception)
        {
            NSLog(@"Exception @objectAtIndex.rotArray!\n");
        }
    
    }

    CGSize size = CGSizeMake(canvas.frame.size.width, canvas.frame.size.height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
 //    CGContextSetShouldAntialias(context, NO);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    CGContextSetLineWidth(context, 1.0f);

    
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextAddLines(context, accArrayCG, accArray.count);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextAddLines(context, rotArrayCG, rotArray.count);
    CGContextStrokePath(context);

    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextStrokeRect(context, CGRectMake(0.0f, 1.0f, size.width-1, size.height-1));
    CGContextStrokePath(context);

    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    canvas.image=result;
    
    free(rotArrayCG);
    free(accArrayCG);
}


-(float) reSizeAcc: (float) var
{
    return ((var+self.conversion_acc)/(2*self.conversion_acc))*self.canvasMaxHeight;
}

-(float) reSizeRot: (float) var
{
    return ((var+self.conversion_gyr)/(2*self.conversion_gyr))*self.canvasMaxHeight;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showBackFlightBoard"])
    {
        ABSViewControllerFlight *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
    }
}

@end
