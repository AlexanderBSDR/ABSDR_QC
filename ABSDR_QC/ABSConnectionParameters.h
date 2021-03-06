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

@property NSMutableArray *controlArrayX;
@property NSMutableArray *controlArrayY;
@property NSMutableArray *controlArrayZ;
@property NSMutableArray *controlArrayT;   //////////

@property NSMutableArray *batteryStatus;
@property NSMutableArray *altitudePosition;

@property double pidPitch_P;
@property double pidPitch_I;
@property double pidPitch_D;

@property double pidRoll_P;
@property double pidRoll_I;
@property double pidRoll_D;

@property double pidYaw_P;
@property double pidYaw_I;
@property double pidYaw_D;

@property double timer1s;
@property double batteryLagTime;
@property bool newData;
@property int server_Started;

@property unsigned short engineOne;
@property unsigned short engineTwo;
@property unsigned short engineThree;
@property unsigned short engineFour;

@property unsigned short engineMax;
@property unsigned short engineMin;
@property double g_E1_S, g_E2_S, g_E3_S, g_E4_S,g_E1_P, g_E2_P, g_E3_P, g_E4_P,g_E1_R, g_E2_R, g_E3_R, g_E4_R, g_E1_Y, g_E2_Y, g_E3_Y, g_E4_Y;

- (void) startServer;
- (bool) sendClient:(char *) msg length: (unsigned int) len;
- (bool) sendServerSocket:(NSString *) ip port:(int) p;

-(void) updateEngineParameters;
-(void) changeAltitude:(float) step;
-(void) changeDirection:(float) step;
-(void) changeRotation:(float) step;
-(void) changeYaw:(float) step;
-(void) changeResolutionInterval:(unsigned short) val;
-(void) changeMixerGains:(unsigned short) val gain_1: (double) g1 gain_2: (double) g2 gain_3: (double) g3 gain_4:(double) g4;

-(void) updatePIDSettings;




- (void) AddVariableToMutableArray:(NSMutableArray *) array var: (float) var;

@end
