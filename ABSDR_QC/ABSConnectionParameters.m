//
//  ABSConnectionParameters.m
//  ABSDR_QC
//
//  Created by CIG account on 1/31/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//



/*
 Commands: 0x01 0xFF [0x00] [0x00] [0x00] [0x00] - direct access to engines
 Altitute: 0x02 0xFF [0x00] [0x00] - (sign) and altitude control
 Direction: 0x03 0xFF [0x00] [0x00] - (sign) and direction control
 Rotation: 0x04 0xFF [0x00] [0x00] - (sign) and rotation control
 Rotation: 0x09 0xFF [0x00] [0x00] - change resolution 0-1000 ms

 */

#import "ABSConnectionParameters.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
extern int errno;

#define MAXSIZEPACKET 32

@implementation ABSConnectionParameters

- (void) startServer
{
    unsigned char buffer[MAXSIZEPACKET];
    struct sockaddr_in sa;
    size_t fromlen, recsize;
    
    self.accArrayX = [[NSMutableArray alloc] init];
    self.accArrayY = [[NSMutableArray alloc] init];
    self.accArrayZ = [[NSMutableArray alloc] init];
    self.accArrayT = [[NSMutableArray alloc] init];

    self.rotArrayX = [[NSMutableArray alloc] init];
    self.rotArrayY = [[NSMutableArray alloc] init];
    self.rotArrayZ = [[NSMutableArray alloc] init];
    self.rotArrayT = [[NSMutableArray alloc] init];
    
    self.controlArrayX = [[NSMutableArray alloc] init];
    self.controlArrayY = [[NSMutableArray alloc] init];
    self.controlArrayZ = [[NSMutableArray alloc] init];
    self.controlArrayT = [[NSMutableArray alloc] init];
    
    self.batteryStatus = [[NSMutableArray alloc] init];
    self.altitudePosition = [[NSMutableArray alloc] init];
    self.timer1s = [[NSDate date] timeIntervalSince1970];
    self.batteryLagTime=1.5;
    self.newData=FALSE;
    self.g_E1_S=self.g_E2_S=self.g_E3_S=self.g_E4_S=1;
    self.g_E1_P=self.g_E2_P=self.g_E3_P=self.g_E4_P=1;
    self.g_E1_R=self.g_E2_R=self.g_E3_R=self.g_E4_R=1;
    self.g_E1_Y=self.g_E2_Y=self.g_E3_Y=self.g_E4_Y=1;
    
    self.pidPitch_P=self.pidRoll_P=0.5;
    self.pidPitch_I=self.pidRoll_I=0;
    self.pidPitch_D=self.pidRoll_D=0;
    
    self.pidYaw_P=self.pidYaw_I=self.pidYaw_D=0;

    
    self.engineMin=1000;       ///////////////////////////////
    self.engineMax=2000;      ///////////////////////////////
    
    self.engineOne=self.engineMin;
    self.engineTwo=self.engineMin;
    self.engineThree=self.engineMin;
    self.engineFour=self.engineMin;
    
    self.server_Started=100;
    
    memset(&sa, 0 ,sizeof(sa));
    
    sa.sin_family=AF_INET;
    sa.sin_addr.s_addr=INADDR_ANY;
    sa.sin_port=htons(self.LocalPort.intValue);
    
    if(self.sock_server<=0)
    {
        self.sock_server=socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    

    
        if(-1==bind(self.sock_server, (struct sockaddr *)&sa, sizeof(struct sockaddr)))
        {
            NSLog(@"Error in binding a socket");
            close(self.sock_server);
        }
        NSLog(@"UDP server has started...");
    }
    for (;;)
    {
        recsize=recvfrom(self.sock_server, (void *)buffer, MAXSIZEPACKET, 0, (struct sockaddr *)&sa, (socklen_t *)&fromlen);
        // 0xFF 0x20 - values from 6DOF
        
        
//        inet_ntoa(sa.sin_addr);
        //NSLog(@"<- Rx[%zu] from (%s): ",recsize,inet_ntoa(sa.sin_addr));
        
       // printf("--------parsing--------\n");

        if(buffer[0]==0xFF && buffer[1]==0x20)
        {
            [self parseSensorsData:buffer];
            self.newData=TRUE;
        }
        else
        {
            char temp[MAXSIZEPACKET+1];
            strncpy(temp, (const char *)buffer, MAXSIZEPACKET);
            temp[MAXSIZEPACKET]='\0';
            NSLog(@"%s",temp);
        }
//        printf("---------end----------\n");
    }
    
}

- (void) parseSensorsData: (unsigned char *) data
{
    short temp;
    bool flag=FALSE;

    //engines
    self.engineOne=(data[3]<<8) | data[2];
    self.engineTwo=(data[5]<<8) | data[4];
    self.engineThree=(data[7]<<8) | data[6];
    self.engineFour=(data[9]<<8) | data[8];
    
    //actual_Angles
    temp=(short)((data[11]<<8) | data[10]);
    if(flag==TRUE)   NSLog(@"acc_X: %ud", temp);
//    NSLog(@"act_Ang: %f", (float)temp/10);
    [self AddVariableToMutableArray:self.accArrayX var:((float)temp/10)];

    temp=(data[13]<<8) | data[12];
    if(flag==TRUE)  NSLog(@"acc_Y: %ud", temp);
    [self AddVariableToMutableArray:self.accArrayY var:((float)temp/10)];
    
    temp=(data[15]<<8) | data[14];
    if(flag==TRUE)  NSLog(@"acc_Z: %ud", temp);
    [self AddVariableToMutableArray:self.accArrayZ var:((float)temp/10)];
    
    //set_Angles
    temp=(data[17]<<8) | data[16];
    if(flag==TRUE)  NSLog(@"rot_X: %ud", temp);
    [self AddVariableToMutableArray:self.rotArrayX var:((float)temp/10)];

    temp=(data[19]<<8) | data[18];
    if(flag==TRUE)  NSLog(@"rot_Y: %ud", temp);
    [self AddVariableToMutableArray:self.rotArrayY var:((float)temp/10)];
    
    temp=(data[21]<<8) | data[20];
    if(flag==TRUE)  NSLog(@"rot_Z: %ud", temp);
    [self AddVariableToMutableArray:self.rotArrayZ var:((float)temp/10)];

    //control_Angles
    temp=(data[23]<<8) | data[22];
    if(flag==TRUE) NSLog(@"com_X: %ud", temp);
    [self AddVariableToMutableArray:self.controlArrayX var:((float)temp)];
    
    temp=(data[25]<<8) | data[24];
    if(flag==TRUE)  NSLog(@"com_Y: %ud", temp);
    [self AddVariableToMutableArray:self.controlArrayY var:((float)temp)];
    
    temp=(data[27]<<8) | data[26];
    if(flag==TRUE)  NSLog(@"com_Z: %ud", temp);
    [self AddVariableToMutableArray:self.controlArrayZ var:((float)temp)];

    //battery
    double temp_battery;
    temp=((data[29]<<8) | data[28]);
    temp_battery=(double)temp*3.3/1024;
    temp_battery=temp_battery/0.3;
//    NSLog(@"%f\n", temp_battery);
//    self.batteryPower=self.batteryPower/(2200/(2200+2200));
    if([[NSDate date] timeIntervalSince1970]-self.timer1s>self.batteryLagTime)
    {
        [self AddVariableToMutableArray:self.batteryStatus var:temp_battery];
        self.timer1s = [[NSDate date] timeIntervalSince1970];
    }

    if(flag==TRUE)  NSLog(@"Power: %f", (float)temp);

    //altitude
    temp=((data[31]<<8) | data[30]);
    if(flag==TRUE)  NSLog(@"Altitude: %f", (float)temp/10000);
    [self AddVariableToMutableArray:self.altitudePosition var:(float)temp/10000];

}

- (void) AddVariableToMutableArray:(NSMutableArray *) array var: (float) var
{
    if(array.count>self.maxSize-1)
    {
        [array removeObjectAtIndex:0];
    }
    [array addObject:[NSNumber numberWithFloat:var]];
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
    
    if(self.sock_client<=0)
    {
        if((self.sock_client=socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP))<0)
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
        err=connect(self.sock_client, (const struct sockaddr *) &destination, sizeof(destination));
        if(err<0)
        {
            NSLog(@"Error at connect: %d", errno);
        }
    }
    return YES;
}

- (bool) sendClient:(char *) msg length: (unsigned int) len
{
    struct sockaddr_in destination;
    
    memset(&destination, 0, sizeof(destination));
    destination.sin_family=AF_INET;
    destination.sin_addr.s_addr=inet_addr([self.IPAddress UTF8String]);
    destination.sin_port=htons(self.RemotePort.intValue);
    
    long a=0;
    a=sendto(self.sock_client, msg, len, 0, NULL, 0);
    if(a!=len)
    {
        printf("Mismatch in number of sent bytes!\n");
        printf("Sent: %ld",a);
        printf("Error code: %d", errno);
    }
    else
    {
        /*if(msg[0]=='V')
        {
            char *new_msg=malloc(len+1);
            strncpy(new_msg, msg, len);
            new_msg[len]='\0';
            NSLog(@"-> Tx[%ld]: %s\n", a, new_msg);
            free (new_msg);
            NSLog("@%s", new_msg);
        }*/
    }
    return false;
}

-(void) updateEngineParameters
{
    char *buffer=malloc(sizeof(char)*2+sizeof(unsigned int)*4);
    
    buffer[0]=0xFF;
    buffer[1]=0x01;
    buffer[2]=self.engineOne & 0xFF;
    buffer[3]=(self.engineOne>>8) & 0xFF;
    
    buffer[4]=self.engineTwo & 0xFF;
    buffer[5]=(self.engineTwo>>8) & 0xFF;
    
    buffer[6]=self.engineThree & 0xFF;
    buffer[7]=(self.engineThree>>8) & 0xFF;
    
    buffer[8]=self.engineFour & 0xFF;
    buffer[9]=(self.engineFour>>8) & 0xFF;
    
    //NSLog(@"%d-%d-%d-%d", self.engineOne, self.engineTwo, self.engineThree, self.engineFour);
    
    [self sendClient:buffer length:(sizeof(char)*2+sizeof(unsigned int)*4)];
    self.PackagesSent+=1;
    
    free(buffer);
}

-(void) changeAltitude:(float) step
{
    char *buffer=malloc(sizeof(char)*4);

    buffer[0]=0xFF;
    buffer[1]=0x02;
    
    int temp=(int)round(step);
    
    
    buffer[2]=temp & 0xFF;
    buffer[3]=(temp>>8) & 0xFF;
    
    [self sendClient:buffer length:4];
    self.PackagesSent+=1;
    
    free(buffer);
}
-(void) changeDirection:(float) step
{
    char *buffer=malloc(sizeof(char)*4);
    
    buffer[0]=0xFF;
    buffer[1]=0x03;
    
    int temp=(int)round(step);
    
    
    buffer[2]=temp & 0xFF;
    buffer[3]=(temp>>8) & 0xFF;
    
    [self sendClient:buffer length:4];
    self.PackagesSent+=1;
    
    free(buffer);

}
-(void) changeRotation:(float) step
{
    char *buffer=malloc(sizeof(char)*4);
    
    buffer[0]=0xFF;
    buffer[1]=0x04;
    
    int temp=(int)round(step);
    
    buffer[2]=temp & 0xFF;
    buffer[3]=(temp>>8) & 0xFF;
    
    [self sendClient:buffer length:4];
    self.PackagesSent+=1;
    
    free(buffer);
}

-(void) changeYaw:(float) step
{
    char *buffer=malloc(sizeof(char)*4);
    
    buffer[0]=0xFF;
    buffer[1]=0x31;
    
    int temp=(int)round(step);
    
    
    buffer[2]=temp & 0xFF;
    buffer[3]=(temp>>8) & 0xFF;
    
    [self sendClient:buffer length:4];
    self.PackagesSent+=1;
    
    free(buffer);
    
}

-(void) changeResolutionInterval:(unsigned short) val
{
    char *buffer=malloc(sizeof(char)*4);
    
    buffer[0]=0xFF;
    buffer[1]=0x09;
    buffer[2]=val & 0xFF;
    buffer[3]=(val>>8) & 0xFF;
    
    [self sendClient:buffer length:4];
    self.PackagesSent+=1;
    
    free(buffer);
}


-(void) changeMixerGains:(unsigned short) val gain_1: (double) g1 gain_2: (double) g2 gain_3: (double) g3 gain_4:(double) g4
{
    char *buffer=malloc(sizeof(char)*10);
    
    buffer[0]=0xFF;
    switch (val)
    {
        case 1:
            buffer[1]=0x05;
            break;
        case 2:
            buffer[1]=0x06;
            break;
        case 3:
            buffer[1]=0x07;
            break;
        case 4:
            buffer[1]=0x30;
            break;
            
    }
    
    short g1_t=(short)round(g1*100);
    short g2_t=(short)round(g2*100);
    short g3_t=(short)round(g3*100);
    short g4_t=(short)round(g4*100);
    
    //NSLog(@"%d--%d--%d--%d", g1_t, g2_t, g3_t, g4_t);

    
    buffer[2]=g1_t & 0xFF;
    buffer[3]=(g1_t>>8) & 0xFF;
    
    buffer[4]=g2_t & 0xFF;
    buffer[5]=(g2_t>>8) & 0xFF;
    
    buffer[6]=g3_t & 0xFF;
    buffer[7]=(g3_t>>8) & 0xFF;
    
    buffer[8]=g4_t & 0xFF;
    buffer[9]=(g4_t>>8) & 0xFF;
    
    [self sendClient:buffer length:10];
    self.PackagesSent+=1;
    
    free(buffer);
}

-(void) updatePIDSettings
{
    char *buffer=malloc(sizeof(char)*20);
    
    buffer[0]=0xFF;
    buffer[1]=0x08;
    
    short p1_p=(short)(self.pidPitch_P*100);
    short p1_i=(short)(self.pidPitch_I*100);
    short p1_d=(short)(self.pidPitch_D*100);
    
    short p2_p=(short)(self.pidRoll_P*100);
    short p2_i=(short)(self.pidRoll_I*100);
    short p2_d=(short)(self.pidRoll_D*100);
    
    short p3_p=(short)(self.pidYaw_P*100);
    short p3_i=(short)(self.pidYaw_I*100);
    short p3_d=(short)(self.pidYaw_D*100);
    
    buffer[2]=p1_p & 0xFF;
    buffer[3]=(p1_p>>8) & 0xFF;
    
    buffer[4]=p1_i & 0xFF;
    buffer[5]=(p1_i>>8) & 0xFF;
    
    buffer[6]=p1_d & 0xFF;
    buffer[7]=(p1_d>>8) & 0xFF;
    
    buffer[8]=p2_p & 0xFF;
    buffer[9]=(p2_p>>8) & 0xFF;
    
    buffer[10]=p2_i & 0xFF;
    buffer[11]=(p2_i>>8) & 0xFF;
    
    buffer[12]=p2_d & 0xFF;
    buffer[13]=(p2_d>>8) & 0xFF;
    
    buffer[14]=p3_p & 0xFF;
    buffer[15]=(p3_p>>8) & 0xFF;
    
    buffer[16]=p3_i & 0xFF;
    buffer[17]=(p3_i>>8) & 0xFF;
    
    buffer[18]=p3_d & 0xFF;
    buffer[19]=(p3_d>>8) & 0xFF;
    
    [self sendClient:buffer length:20];
    self.PackagesSent+=1;
    
    free(buffer);
}

@end
