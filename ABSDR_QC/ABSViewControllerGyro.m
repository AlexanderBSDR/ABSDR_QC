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
@property (weak, nonatomic) IBOutlet UILabel *accX;
@property (weak, nonatomic) IBOutlet UILabel *accY;
@property (weak, nonatomic) IBOutlet UILabel *accZ;
@property (weak, nonatomic) IBOutlet UILabel *maxAccX;
@property (weak, nonatomic) IBOutlet UILabel *maxAccY;
@property (weak, nonatomic) IBOutlet UILabel *maxAccZ;
@property (weak, nonatomic) IBOutlet UILabel *rotX;
@property (weak, nonatomic) IBOutlet UILabel *rotY;
@property (weak, nonatomic) IBOutlet UILabel *rotZ;
@property (weak, nonatomic) IBOutlet UILabel *maxRotX;
@property (weak, nonatomic) IBOutlet UILabel *maxRotY;
@property (weak, nonatomic) IBOutlet UILabel *maxRotZ;

@property (weak, nonatomic) IBOutlet UIImageView *canvasX;
@property (weak, nonatomic) IBOutlet UIImageView *canvasY;
@property (weak, nonatomic) IBOutlet UIImageView *canvasZ;
@property CGPoint *arrayX;
@property int lastPointArrayX;
@property int multiplierX;
@property int canvasSizeX;

@property int conversion_acc;
@property int conversion_gyr;

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
    
    currentMaxAccelX = 0;
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
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    
    
    
    self.lastPointArrayX=0;
    self.multiplierX=1;
    self.conversion_acc=2;
    self.conversion_gyr=1;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.canvasSizeX=self.canvasX.frame.size.width;
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
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
}

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
    
    [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(addPoint) userInfo:nil repeats:YES];

}

- (void) addPoint
{
    NSNumber *accRand=[NSNumber numberWithFloat:self.conversion_acc*2*(((double)rand()/(RAND_MAX)))-self.conversion_acc];
    NSNumber *rotRand=[NSNumber numberWithFloat:self.conversion_gyr*2*(((double)rand()/(RAND_MAX)))-self.conversion_gyr];
    
    if(self.ConnectionParameters.accArrayX.count>self.canvasSizeX-1)
    {
        [self.ConnectionParameters.accArrayX removeObjectAtIndex:0];
    }
    [self.ConnectionParameters.accArrayX addObject:accRand];
    //NSLog(@"%f", [[self.ConnectionParameters.accArrayX objectAtIndex:0] floatValue]);
    
    if(self.ConnectionParameters.rotArrayX.count>self.canvasSizeX-1)
    {
        [self.ConnectionParameters.rotArrayX removeObjectAtIndex:0];
    }
    [self.ConnectionParameters.rotArrayX addObject:rotRand];
    
//    NSLog(@"Numbers in NSMutableArray: %d", self.ConnectionParameters.accArrayX.count);
    
    [self reDrawCanvasX];

}

- (void) reDrawCanvasX
{
    
    CGPoint *accArrayXCG;
    CGPoint *rotArrayXCG;
//    NSLog(@"HERE!");
    accArrayXCG=(CGPoint *)malloc(sizeof(CGPoint)*self.ConnectionParameters.accArrayX.count);
    rotArrayXCG=(CGPoint *)malloc(sizeof(CGPoint)*self.ConnectionParameters.rotArrayX.count);
    
    for (int i=0; i<self.ConnectionParameters.accArrayX.count; i++)
    {
        accArrayXCG[i].x=i;
        accArrayXCG[i].y=[self reSizeAcc:[[self.ConnectionParameters.accArrayX objectAtIndex:i] floatValue]];
        //NSLog(@"%f", accArrayXCG[i].y);
    }
    
    for (int i=0; i<self.ConnectionParameters.rotArrayX.count; i++)
    {
        rotArrayXCG[i].x=i;
        rotArrayXCG[i].y=[self reSizeAcc:[[self.ConnectionParameters.rotArrayX objectAtIndex:i] floatValue]];
    }

    CGSize size = CGSizeMake(self.canvasX.frame.size.width, self.canvasX.frame.size.height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetShouldAntialias(context, NO);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    CGContextSetLineWidth(context, 0.5f);
    CGContextStrokeRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
 
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextAddLines(context, accArrayXCG, self.ConnectionParameters.accArrayX.count);
    
    CGContextStrokePath(context);
    CGContextFillPath(context);

    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextAddLines(context, rotArrayXCG, self.ConnectionParameters.rotArrayX.count);
    
    
    CGContextStrokePath(context);
    CGContextFillPath(context);
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.canvasX.image=result;
    [self.canvasX setNeedsDisplay];
}

-(int) reSizeAcc: (float) var
{
 //   NSLog(@"%f", (var+2)/4*self.canvasX.frame.size.height);
    return (var+2)/4*self.canvasX.frame.size.height;
}

-(int) reSizeRot: (float) var
{
    return (int)(var+1)/2*self.canvasX.frame.size.height;
}

-(void) AddPointToArrayX:(double)x
{
    if(self.lastPointArrayX>=self.canvasSizeX-1)
    {
        for (int i=0;i<self.canvasSizeX-1;i++)
            self.arrayX[i].y=self.arrayX[i+1].y;
        self.lastPointArrayX=self.canvasSizeX-1;
    }
    double tempX=(x+2)/4*60;
    self.arrayX[self.lastPointArrayX]=CGPointMake(self.lastPointArrayX*self.multiplierX, tempX);
    NSLog(@"%f %f %d", self.arrayX[self.lastPointArrayX].x, self.arrayX[self.lastPointArrayX].y, self.lastPointArrayX);
    self.lastPointArrayX+=1;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showBackFlightBoard"])
    {
        ABSViewControllerFlight *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
    }
}

@end
