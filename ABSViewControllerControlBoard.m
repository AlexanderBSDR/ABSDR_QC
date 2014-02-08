//
//  ABSViewControllerControlBoard.m
//  ABSDR_QC
//
//  Created by CIG account on 1/31/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import "ABSViewControllerControlBoard.h"
#import "ABSViewControllerLogin.h"

#import "ABSControlParameters.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
extern int errno;

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

@property int sock;

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

  
    [NSThread detachNewThreadSelector:@selector(startServer) toTarget:self withObject:Nil];
    
    [self sendServerSocket:self.ConnectionParameters.IPAddress port:self.ConnectionParameters.RemotePort.intValue];
    
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
    
    NSString *temp1=@"Engine #1: ";
    //self.objParameters.EngineSpeedOne=[NSNumber numberWithInt:(int)(self.objParameters.EngineSpeedOne.intValue+delta)];
    if(e1d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedOne=self.objParameters.maxValue;
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
//    NSLog(@"Delta: %d", delta);
//    NSLog(@"E1D: %d",self.objParameters.EngineSpeedOne.intValue+delta);
    
    NSString *temp1=@"Engine #1: ";
    if(e1d.intValue>self.objParameters.maxValue.intValue)
    {
        self.objParameters.EngineSpeedOne=self.objParameters.maxValue;
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

- (void) startServer
{
    NSLog(@"UDP server is starting...");
    
    int sock=socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    
    struct sockaddr_in sa;
    char buffer[1024];
    size_t fromlen, recsize;
    
    memset(&sa, 0 ,sizeof(sa));
    
    sa.sin_family=AF_INET;
    sa.sin_addr.s_addr=INADDR_ANY;
    sa.sin_port=htons(50000);
    
    if(-1==bind(sock, (struct sockaddr *)&sa, sizeof(struct sockaddr)))
    {
        NSLog(@"Error in binding a socket");
        close(sock);
    }
    
    for (;;)
    {
        recsize=recvfrom(sock, (void *)buffer, 1024, 0, (struct sockaddr *)&sa, (socklen_t *)&fromlen);
        buffer[recsize]='\0';
        inet_ntoa(sa.sin_addr);
//        NSString *bufferGot = [[NSString alloc] stringWithCString:buffer encoding:NSASCIIStringEncoding];
        NSLog(@"<- Rx[%zu] from (%s): %s",recsize,inet_ntoa(sa.sin_addr),buffer);
    }
    
}

- (bool) sendServerSocket:(NSString *) ip port:(int) p
{
    struct sockaddr_in destination;
//    int broadcast=1;
    if(ip==nil)
    {
        printf("Ip address is null\n");
        return false;
    }
    
    if((self.sock=socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP))<0)
    {
        printf("Failed to create a socket: %d", errno);
        return false;
    }
    
    memset(&destination, 0, sizeof(destination));
    
    destination.sin_family=AF_INET;
    destination.sin_addr.s_addr=inet_addr([ip UTF8String]);
    destination.sin_port=htons(p);
    
 /*   setsockopt(self.sock, IPPROTO_IP, IP_MULTICAST_IF, &destination, sizeof(destination));
    if(setsockopt(self.sock, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof(broadcast))==-1)
    {
        perror("setsockopt (SO_BROADCAST");
        exit(1);
    }*/
    int err=0;
    err=connect(self.sock, (const struct sockaddr *) &destination, sizeof(destination));
    if(err<0)
    {
        NSLog(@"Error at connect: %d", errno);
    }
    
/*    int flags;
    
    flags = fcntl(self.sock, F_GETFL);
    err = fcntl(self.sock, F_SETFL, flags | O_NONBLOCK);
    if (err < 0) {
        NSLog(@"Error at flags: %d", errno);
    }
*/
    return YES;
}

- (bool) sendServer:(char *) msg length: (unsigned int) len ipAddress:(NSString *) ip port:(int) p
{
    struct sockaddr_in destination;

    memset(&destination, 0, sizeof(destination));
    destination.sin_family=AF_INET;
    destination.sin_addr.s_addr=inet_addr([ip UTF8String]);
    destination.sin_port=htons(p);
    
    int a=0;
    a=sendto(self.sock, msg, len, 0, NULL, 0);
    if(a!=len)
    {
        printf("Mismatch in number of sent bytes!\n");
        NSLog(@"Sent: %d",a);
        printf("Error code: %d", errno);
    }
    else
    {
        NSLog(@"-> Tx: %s", msg);
    }
    return false;
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

    [self sendServer:buffer length:6 ipAddress:self.ConnectionParameters.IPAddress port:self.ConnectionParameters.RemotePort.intValue];
    NSNumber *t=[[NSNumber alloc] initWithInt:(self.ConnectionParameters.PackagesSent.intValue+1)];
    self.ConnectionParameters.PackagesSent=t;
    self.labelSent.text=self.ConnectionParameters.PackagesSent.stringValue;
    
    free(buffer);
}

@end
