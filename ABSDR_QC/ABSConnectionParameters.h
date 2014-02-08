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
@property NSNumber *PackagesSent;

@end
