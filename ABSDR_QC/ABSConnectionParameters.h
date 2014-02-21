//
//  ABSConnectionParameters.h
//  ABSDR_QC
//
//  Created by CIG account on 1/31/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABSConnectionParameters : NSObject

@property NSString *IPAddress;
@property NSNumber *RemotePort;
@property NSNumber *LocalPort;
@property int PackagesSent;
@property int sock_client;
@property int sock_server;
@property int maxSize;
@property NSMutableArray *accArrayX;
@property NSMutableArray *accArrayY;
@property NSMutableArray *accArrayZ;
@property NSMutableArray *accArrayT;   //////////

@property NSMutableArray *rotArrayX;
@property NSMutableArray *rotArrayY;
@property NSMutableArray *rotArrayZ;
@property NSMutableArray *rotArrayT;   //////////

@property NSMutableArray *batteryStatus;
@property NSMutableArray *altitudePosition;


@property double timer1s;
@property double batteryLagTime;
@property bool newData;


@property unsigned short engineOne;
@property unsigned short engineTwo;
@property unsigned short engineThree;
@property unsigned short engineFour;

@property unsigned short engineMax;
@property unsigned short engineMin;

- (void) startServer;
- (bool) sendClient:(char *) msg length: (unsigned int) len;
- (bool) sendServerSocket:(NSString *) ip port:(int) p;

-(void) updateEngineParameters;
-(void) changeAltitude:(int) step;
-(void) changeDirection:(int) step;
-(void) changeRotation:(int) step;
-(void) changeResolutionInterval:(unsigned short) val;


- (void) AddVariableToMutableArray:(NSMutableArray *) array var: (float) var;

@end
