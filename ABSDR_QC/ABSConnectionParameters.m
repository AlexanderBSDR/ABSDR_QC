//
//  ABSConnectionParameters.m
//  ABSDR_QC
//
//  Created by CIG account on 1/31/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import "ABSConnectionParameters.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
extern int errno;

@implementation ABSConnectionParameters

- (void) startServer
{
    char buffer[1024];
    struct sockaddr_in sa;
    size_t fromlen, recsize;
    
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
    /*    int flags;
     
     flags = fcntl(self.sock, F_GETFL);
     err = fcntl(self.sock, F_SETFL, flags | O_NONBLOCK);
     if (err < 0) {
     NSLog(@"Error at flags: %d", errno);
     }
     */
    return YES;
}

- (bool) sendClient:(char *) msg length: (unsigned int) len
{
    struct sockaddr_in destination;
    
    memset(&destination, 0, sizeof(destination));
    destination.sin_family=AF_INET;
    destination.sin_addr.s_addr=inet_addr([self.IPAddress UTF8String]);
    destination.sin_port=htons(self.RemotePort.intValue);
    
    int a=0;
    a=sendto(self.sock_client, msg, len, 0, NULL, 0);
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


@end
