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
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UITextField *resolutionField;



@property (weak, nonatomic) IBOutlet UILabel *label_Canvas1_Max;
@property (weak, nonatomic) IBOutlet UILabel *label_Canvas1_Curr;
@property (weak, nonatomic) IBOutlet UILabel *label_Canvas1_Min;

@property (weak, nonatomic) IBOutlet UILabel *label_Canvas2_Max;
@property (weak, nonatomic) IBOutlet UILabel *label_Canvas2_Curr;
@property (weak, nonatomic) IBOutlet UILabel *label_Canvas2_Min;

@property (weak, nonatomic) IBOutlet UILabel *label_Canvas3_Max;
@property (weak, nonatomic) IBOutlet UILabel *label_Canvas3_Curr;
@property (weak, nonatomic) IBOutlet UILabel *label_Canvas3_Min;
@property (weak, nonatomic) IBOutlet UILabel *label_X_controller;
@property (weak, nonatomic) IBOutlet UILabel *label_Y_controller;
@property (weak, nonatomic) IBOutlet UILabel *label_Z_controller;
@property (weak, nonatomic) IBOutlet UILabel *label_X_set;
@property (weak, nonatomic) IBOutlet UILabel *label_Y_set;
@property (weak, nonatomic) IBOutlet UILabel *label_Z_set;

@property (weak, nonatomic) IBOutlet UITextField *pidFieldPitch_P;
@property (weak, nonatomic) IBOutlet UITextField *pidFieldPitch_I;
@property (weak, nonatomic) IBOutlet UITextField *pidFieldPitch_D;

@property (weak, nonatomic) IBOutlet UITextField *pidFieldRoll_P;
@property (weak, nonatomic) IBOutlet UITextField *pidFieldRoll_I;
@property (weak, nonatomic) IBOutlet UITextField *pidFieldRoll_D;

@property (weak, nonatomic) IBOutlet UITextField *pidFieldYaw_P;
@property (weak, nonatomic) IBOutlet UITextField *pidFieldYaw_I;
@property (weak, nonatomic) IBOutlet UITextField *pidFieldYaw_D;


@property float *max1, *min1, *max2, *min2, *max3, *min3;



@property int canvasMaxWidth;
@property int canvasMaxHeight;
@property int scaleX;
@property CGPoint *accArrayCG;
@property CGPoint *rotArrayCG;
@property CGPoint *controlArrayCG;


@property double batteryTime;
@property CGColorRef blueColor, redColor, greenColor, yellowColor;

@property NSTimer* timer1;

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
    
    
    self.batteryTime=[[NSDate date] timeIntervalSince1970];
    if(self.ConnectionParameters.server_Started!=100)
    {
        [NSThread detachNewThreadSelector:@selector(startServer) toTarget:self.ConnectionParameters withObject:Nil];
        [self.ConnectionParameters sendServerSocket:self.ConnectionParameters.IPAddress port:self.ConnectionParameters.RemotePort.intValue];
    }
    self.timer1=[NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(addPoint) userInfo:nil repeats:YES];
    
    self.blueColor=[[UIColor blueColor] CGColor];
    self.redColor=[[UIColor redColor] CGColor];
    self.greenColor=[[UIColor greenColor] CGColor];
    self.yellowColor=[[UIColor yellowColor] CGColor];
    self.min1=malloc(8);
    self.min2=malloc(8);
    self.min3=malloc(8);
    self.max1=malloc(8);
    self.max2=malloc(8);
    self.max3=malloc(8);
    
    self.label_Canvas1_Min.text=@"0.0";
    self.label_Canvas1_Curr.text=@"0.0";
    self.label_Canvas1_Max.text=@"0.0";

    self.label_Canvas2_Min.text=@"0.0";
    self.label_Canvas2_Curr.text=@"0.0";
    self.label_Canvas2_Max.text=@"0.0";
    
    self.label_Canvas3_Min.text=@"0.0";
    self.label_Canvas3_Curr.text=@"0.0";
    self.label_Canvas3_Max.text=@"0.0";
    
    self.label_X_controller.text=@"0.0";
    self.label_Y_controller.text=@"0.0";
    self.label_Z_controller.text=@"0.0";

    self.label_X_set.text=@"0.0";
    self.label_Y_set.text=@"0.0";
    self.label_Z_set.text=@"0.0";
    
    self.pidFieldPitch_P.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidPitch_P];
    self.pidFieldPitch_I.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidPitch_I];
    self.pidFieldPitch_D.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidPitch_D];
    
    self.pidFieldRoll_P.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidRoll_P];
    self.pidFieldRoll_I.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidRoll_I];
    self.pidFieldRoll_D.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidRoll_D];
    
    self.pidFieldYaw_P.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidYaw_P];
    self.pidFieldYaw_I.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidYaw_I];
    self.pidFieldYaw_D.text=[[NSString alloc] initWithFormat:@"%2.2f", self.ConnectionParameters.pidYaw_D];
    //NSLog(@"%f", self.ConnectionParameters.pidYaw_P);

    //NSLog(@"Server: %d --- %d", self.ConnectionParameters.sock_server, self.ConnectionParameters.sock_client);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.canvasMaxWidth=self.canvasX.frame.size.width;
    self.canvasMaxHeight=self.canvasX.frame.size.height;
    
    self.scaleX=1;
    self.ConnectionParameters.maxSize=self.canvasMaxWidth/self.scaleX;
    
    self.accArrayCG=(CGPoint *)malloc(sizeof(CGPoint)*self.canvasMaxWidth);
    self.rotArrayCG=(CGPoint *)malloc(sizeof(CGPoint)*self.canvasMaxWidth);
    self.controlArrayCG=(CGPoint *)malloc(sizeof(CGPoint)*self.canvasMaxWidth);

    
    for (int i=0; i<self.canvasMaxWidth; i++)
    {
        self.accArrayCG[i].x=i*self.scaleX;
        self.rotArrayCG[i].x=i*self.scaleX;
        self.controlArrayCG[i].x=i*self.scaleX;

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addPoint
{
    if(self.ConnectionParameters.newData==TRUE)
    {
        [self reDrawCanvasX:self.canvasX accArray:self.ConnectionParameters.accArrayX rotArray:self.ConnectionParameters.rotArrayX control_Angles:self.ConnectionParameters.controlArrayX color1:self.blueColor color2:self.redColor color3:self.greenColor conv1: -90 conv2: -90 conv3: -90 l1:self.label_Canvas1_Max l2:self.label_Canvas1_Curr l3:self.label_Canvas1_Min l_con:self.label_X_controller l_set:self.label_X_set mmax:self.max1 mmin:self.min1];
        [self reDrawCanvasX:self.canvasY accArray:self.ConnectionParameters.accArrayY rotArray:self.ConnectionParameters.rotArrayY control_Angles:self.ConnectionParameters.controlArrayY color1:self.blueColor color2:self.redColor color3:self.greenColor conv1: -90 conv2: -90 conv3: -90 l1:self.label_Canvas2_Max l2:self.label_Canvas2_Curr l3:self.label_Canvas2_Min l_con:self.label_Y_controller l_set:self.label_Y_set mmax:self.max2 mmin:self.min2];
        [self reDrawCanvasX:self.canvasZ accArray:self.ConnectionParameters.accArrayZ rotArray:self.ConnectionParameters.rotArrayZ  control_Angles:self.ConnectionParameters.controlArrayZ color1:self.blueColor color2:self.redColor color3:self.greenColor conv1: -360 conv2: -360 conv3: -360 l1:self.label_Canvas3_Max l2:self.label_Canvas3_Curr l3:self.label_Canvas3_Min l_con:self.label_Z_controller l_set:self.label_Z_set mmax:self.max3 mmin:self.min3];
     //   [self reDrawCanvasX:self.canvasT accArray:self.ConnectionParameters.batteryStatus rotArray:self.ConnectionParameters.altitudePosition control_Angles:nil color1:self.greenColor color2:self.yellowColor color3:self.yellowColor conv1:-1 conv2: -1  conv3: 0 l1:nil l2:nil l3:nil mmax:0 mmin:0];
    
        [self reDrawEngines:self.canvasEngines];
        self.ConnectionParameters.newData=FALSE;
    }

}

-(void) reDrawEngines: (UIImageView *) canvas
{
    
    CGSize size = CGSizeMake(canvas.frame.size.width, canvas.frame.size.height);

    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, NO);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    CGContextSetLineWidth(context, 1.0f);
    
    
    float box1x=20.0f;
    float box1y=5.0f;
    float box2x=70.0f;
    float box2y=5.0f;
    float box3x=20.0f;
    float box3y=90.0f;
    float box4x=70.0f;
    float box4y=90.0f;
    float box_height=80.0f;
    float box_width=30.0f;
    self.engineOneLabel.text=[NSString stringWithFormat:@"%d", self.ConnectionParameters.engineOne];
    self.engineTwoLabel.text=[NSString stringWithFormat:@"%d", self.ConnectionParameters.engineTwo];
    self.engineThreeLabel.text=[NSString stringWithFormat:@"%d", self.ConnectionParameters.engineThree];
    self.engineFourLabel.text=[NSString stringWithFormat:@"%d", self.ConnectionParameters.engineFour];
    
    if([[NSDate date] timeIntervalSince1970]-self.batteryTime>self.ConnectionParameters.batteryLagTime)
    {
        self.batteryTime=[[NSDate date] timeIntervalSince1970];
        [self.batteryLabel setText:[[NSString alloc] initWithFormat:@"%3.2f", [self.ConnectionParameters.batteryStatus.lastObject doubleValue]]];
    }
    
    CGContextSetStrokeColorWithColor(context, self.blueColor);
    CGContextAddRect(context, CGRectMake(box1x, box1y, box_width, box_height));
    CGContextStrokePath(context);
    int range=self.ConnectionParameters.engineMax-self.ConnectionParameters.engineMin;
    CGContextSetFillColorWithColor(context, self.blueColor);
    CGContextFillRect(context, CGRectMake(box1x, box1y+(box_height*(1-(float)(self.ConnectionParameters.engineOne-self.ConnectionParameters.engineMin)/range)), box_width, box_height-(box_height*(1-(float)(self.ConnectionParameters.engineOne-self.ConnectionParameters.engineMin)/range))));

    CGContextSetStrokeColorWithColor(context, self.blueColor);
    CGContextAddRect(context, CGRectMake(box2x, box2y, box_width, box_height));
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, self.blueColor);
    CGContextFillRect(context, CGRectMake(box2x, box2y+(box_height*(1-(float)(self.ConnectionParameters.engineTwo-self.ConnectionParameters.engineMin)/range)), box_width, box_height-(box_height*(1-(float)(self.ConnectionParameters.engineTwo-self.ConnectionParameters.engineMin)/range))));
    
    CGContextSetStrokeColorWithColor(context, self.greenColor);
    CGContextAddRect(context, CGRectMake(box3x, box3y, box_width, box_height));
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, self.greenColor);
    CGContextFillRect(context, CGRectMake(box3x, box3y+(box_height*(1-(float)(self.ConnectionParameters.engineThree-self.ConnectionParameters.engineMin)/range)), box_width, box_height-(box_height*(1-(float)(self.ConnectionParameters.engineThree-self.ConnectionParameters.engineMin)/range))));
    
    CGContextSetStrokeColorWithColor(context, self.greenColor);
    CGContextAddRect(context, CGRectMake(box4x, box4y, box_width, box_height));
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, self.greenColor);
    CGContextFillRect(context, CGRectMake(box4x, box4y+(box_height*(1-(float)(self.ConnectionParameters.engineFour-self.ConnectionParameters.engineMin)/range)), box_width, box_height-(box_height*(1-(float)(self.ConnectionParameters.engineFour-self.ConnectionParameters.engineMin)/range))));
    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    canvas.image=result;
}

- (void) reDrawCanvasX: (UIImageView *) canvas accArray:(NSMutableArray *)accArray rotArray:(NSMutableArray *)rotArray control_Angles:(NSMutableArray *)control_Angles color1:(CGColorRef)color1 color2:(CGColorRef) color2 color3:(CGColorRef) color3 conv1:(float)conversion1 conv2:(float)conversion2 conv3:(float)conversion3 l1:(UILabel *) l_max l2:(UILabel *) l_curr l3:(UILabel *) l_min l_con:(UILabel *) l_controller l_set:(UILabel *) l_set mmax:(float *) maxx mmin:(float *) minx
{
    for (int i=0; i<accArray.count; i++)
    {
//        accArrayCG[i].x=i*self.scaleX;
        @try {
            self.accArrayCG[i].y=[self reSizeAcc:[[accArray objectAtIndex:i] floatValue] conv:conversion1];
        }
        
        @catch(NSException *exception)
        {
            NSLog(@"Exception @objectAtIndex.accArray!\n");
        }
        
    }
    
    for (int i=0; i<rotArray.count; i++)
    {
        @try {
            self.rotArrayCG[i].y=[self reSizeAcc:[[rotArray objectAtIndex:i] floatValue] conv:conversion2];
        }
 
        @catch(NSException *exception)
        {
            NSLog(@"Exception @objectAtIndex.rotArray!\n");
        }
    
    }
    
    if(control_Angles!=nil)
    {
        for (int i=0; i<control_Angles.count; i++)
        {
            @try {
                self.controlArrayCG[i].y=[self reSizeAcc:[[control_Angles objectAtIndex:i] floatValue] conv:conversion3];
            }
            
            @catch(NSException *exception)
            {
                NSLog(@"Exception @objectAtIndex.controlArray!\n");
            }
            
        }
    }

    CGSize size = CGSizeMake(canvas.frame.size.width, canvas.frame.size.height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
 //    CGContextSetShouldAntialias(context, NO);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextSetStrokeColorWithColor(context, color1);
    CGContextAddLines(context, self.accArrayCG, accArray.count);
    CGContextStrokePath(context);
    
    if(control_Angles!=nil)
    {
        CGContextSetStrokeColorWithColor(context, color3);
        CGContextAddLines(context, self.controlArrayCG, control_Angles.count);
        CGContextStrokePath(context);
    }
    
    CGContextSetStrokeColorWithColor(context, color2);
    CGContextAddLines(context, self.rotArrayCG, rotArray.count);
    CGContextStrokePath(context);

    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextStrokeRect(context, CGRectMake(0.0f, 1.0f, size.width-1, size.height-1));
    CGContextStrokePath(context);

    
    UIImage *result=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    canvas.image=result;

    if(l_curr!=nil)
    {
        float current=[[accArray lastObject] floatValue];
        *maxx=max(current, [[l_max text] floatValue]);
        *minx=min(current, [[l_min text] floatValue]);
        l_curr.text=[[NSString alloc]initWithFormat:@"%4.2f", current];
        l_max.text=[[NSString alloc]initWithFormat:@"%4.2f", *maxx];
        l_min.text=[[NSString alloc]initWithFormat:@"%4.2f", *minx];
        l_controller.text=[[NSString alloc]initWithFormat:@"%4.2f", [[control_Angles lastObject]floatValue]];
        l_set.text=[[NSString alloc]initWithFormat:@"%4.2f", [[rotArray lastObject]floatValue]];
    }
}

float min(float a, float b) {
    return a<b ? a : b;
}

float max(float a, float b) {
    return a>b ? a : b;
}


-(float) reSizeAcc: (float) var conv:(float) conversion
{
    return ((var+conversion)/(2*conversion))*self.canvasMaxHeight;
}

-(float) reSizeRot: (float) var conv:(float) conversion
{
    return ((var+conversion)/(2*conversion))*self.canvasMaxHeight;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showBackFlightBoard"])
    {
        ABSViewControllerFlight *destView=[segue destinationViewController];
        destView.ConnectionParameters=self.ConnectionParameters;
        [self.timer1 invalidate];
        self.timer1 = nil;
    }
}

- (IBAction)clickedSetResolution:(id)sender {
    
    [self.ConnectionParameters changeResolutionInterval:(unsigned short)self.resolutionField.text.intValue];
}
- (IBAction)updatePIDSettings:(id)sender {
    
    self.ConnectionParameters.pidPitch_P=[self.pidFieldPitch_P.text floatValue];
    self.ConnectionParameters.pidPitch_I=[self.pidFieldPitch_I.text floatValue];
    self.ConnectionParameters.pidPitch_D=[self.pidFieldPitch_D.text floatValue];
    
    self.ConnectionParameters.pidRoll_P=[self.pidFieldRoll_P.text floatValue];
    self.ConnectionParameters.pidRoll_I=[self.pidFieldRoll_I.text floatValue];
    self.ConnectionParameters.pidRoll_D=[self.pidFieldRoll_D.text floatValue];
    
    self.ConnectionParameters.pidYaw_P=[self.pidFieldYaw_P.text floatValue];
    self.ConnectionParameters.pidYaw_I=[self.pidFieldYaw_I.text floatValue];
    self.ConnectionParameters.pidYaw_D=[self.pidFieldYaw_D.text floatValue];
    
    [self.ConnectionParameters updatePIDSettings];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}



@end
