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
 */

#import "ABSConnectionParameters.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
extern int errno;

@implementation ABSConnectionParameters

- (void) startServer
{
    unsigned char buffer[1024];
    struct sockaddr_in sa;
    size_t fromlen, recsize;
    
    self.accArrayX = [[NSMutableArray alloc] init];
    self.rotArrayX = [[NSMutableArray alloc] init];
    
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
        recsize=recvfrom(self.sock_server, (void *)buffer, 1024, 0, (struct sockaddr *)&sa, (socklen_t *)&fromlen);
        buffer[recsize]='\0';
        // 0x20 0xFF - values fro 6DOF
        
        if(buffer[0]==0x20)
        {
            if(buffer[1]==0xFF) [self parseSensorsData:buffer];
        }
        inet_ntoa(sa.sin_addr);
        NSLog(@"<- Rx[%zu] from (%s): %s",recsize,inet_ntoa(sa.sin_addr),buffer);
        
    }
    
}

- (void) parseSensorsData: (unsigned char *) data
{
    union floatType byte;
    
    byte.bytes[0]=data[2];
    byte.bytes[1]=data[3];
    byte.bytes[2]=data[4];
    byte.bytes[3]=data[5];
    
    NSLog(@"acc_X: %f", byte.f);
    [self AddVariableToMutableArray:self.accArrayX var:byte.f];
    
    byte.bytes[0]=data[6];
    byte.bytes[1]=data[7];
    byte.bytes[2]=data[8];
    byte.bytes[3]=data[9];
    
    NSLog(@"acc_Y: %f", byte.f);
    [self AddVariableToMutableArray:self.accArrayY var:byte.f];
    
    byte.bytes[0]=data[10];
    byte.bytes[1]=data[11];
    byte.bytes[2]=data[12];
    byte.bytes[3]=data[13];
    
    NSLog(@"acc_Z: %f", byte.f);
    [self AddVariableToMutableArray:self.accArrayZ var:byte.f];
    
    byte.bytes[0]=data[14];
    byte.bytes[1]=data[15];
    byte.bytes[2]=data[16];
    byte.bytes[3]=data[17];
    
    NSLog(@"rot_X: %f", byte.f);
    [self AddVariableToMutableArray:self.rotArrayX var:byte.f];
    
    byte.bytes[0]=data[18];
    byte.bytes[1]=data[19];
    byte.bytes[2]=data[20];
    byte.bytes[3]=data[21];
    
    NSLog(@"rot_Y: %f", byte.f);
    [self AddVariableToMutableArray:self.rotArrayY var:byte.f];
    
    byte.bytes[0]=data[22];
    byte.bytes[1]=data[23];
    byte.bytes[2]=data[24];
    byte.bytes[3]=data[25];
    
    NSLog(@"rot_Z: %f", byte.f);
    [self AddVariableToMutableArray:self.rotArrayZ var:byte.f];
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
        NSLog(@"Sent: %ld",a);
        printf("Error code: %d", errno);
    }
    else
    {
        char *new_msg=malloc(len+1);
        strncpy(new_msg, msg, len);
        new_msg[len]='\0';
        NSLog(@"-> Tx: %s", new_msg);
        free (new_msg);
    }
    return false;
}

-(void) updateEngineParameters:(int) engineOne engineO: (int) engineTwo engineT: (int)engineThree engineF: (int) engineFour
{
    char *buffer=malloc(sizeof(char)*6);
    
    buffer[0]=0x01;
    buffer[1]=0xFF;
    buffer[2]=(char)engineOne;
    buffer[3]=(char)engineTwo;
    buffer[4]=(char)engineThree;
    buffer[5]=(char)engineFour;
   // buffer[6]='\0';
    
    [self sendClient:buffer length:6];
    self.PackagesSent+=1;
    
    free(buffer);
}

-(void) changeAltitude:(int) step
{
    char *buffer=malloc(sizeof(char)*4);

    buffer[0]=0x02;
    buffer[1]=0xFF;
    if(step>0)
    {
        buffer[2]=(char)'+';
    }
    else
    {
        buffer[2]=(char)'-';
    }
    
    buffer[3]=(char)abs(step);
    
    [self sendClient:buffer length:4];
    self.PackagesSent+=1;
    
    free(buffer);
}
-(void) changeDirection:(int) step
{
    char *buffer=malloc(sizeof(char)*4);
    
    buffer[0]=0x03;
    buffer[1]=0xFF;
    if(step>0)
    {
        buffer[2]=(char)'+';
    }
    else
    {
        buffer[2]=(char)'-';
    }
    
    buffer[3]=(char)abs(step);
    
    [self sendClient:buffer length:4];
    self.PackagesSent+=1;
    
    free(buffer);

}
-(void) changeRotation:(int) step
{
    char *buffer=malloc(sizeof(char)*4);
    
    buffer[0]=0x03;
    buffer[1]=0xFF;
    if(step>0)
    {
        buffer[2]=(char)'+';
    }
    else
    {
        buffer[2]=(char)'-';
    }
    
    buffer[3]=(char)abs(step);
    
    [self sendClient:buffer length:4];
    self.PackagesSent+=1;
    
    free(buffer);
}

@end
