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
@property NSMutableArray *accArrayT;

@property NSMutableArray *rotArrayX;
@property NSMutableArray *rotArrayY;
@property NSMutableArray *rotArrayZ;
@property NSMutableArray *rotArrayT;

@property int engOne;
@property int engTwo;
@property int engThree;
@property int engFour;

- (void) startServer;
- (bool) sendClient:(char *) msg length: (unsigned int) len;
- (bool) sendServerSocket:(NSString *) ip port:(int) p;

-(void) updateEngineParameters:(int) engineOne engineO: (int) engineTwo engineT: (int)engineThree engineF: (int) engineFour;
-(void) changeAltitude:(int) step;
-(void) changeDirection:(int) step;
-(void) changeRotation:(int) step;

- (void) AddVariableToMutableArray:(NSMutableArray *) array var: (float) var;

union floatType
{
    unsigned char bytes[4];
    float f;
};


@end
