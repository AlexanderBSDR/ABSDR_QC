//
//  ABSUDPMessaging.h
//  ABSDR_QC
//
//  Created by Alexander Bilyi on 2/2/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>

@protocol ABSUDPDelegate;

@interface ABSUDPMessaging : NSObject

//-(void) startServerOnPort:(NSUInteger)port;
-(BOOL) setupSocketConnectedToAddress:(NSData *)address port:(NSUInteger)port error:(NSError **)errorPtr;
//-(void) stop;

@property (nonatomic, weak,   readwrite) id<ABSUDPDelegate>    delegate;
@property (nonatomic, copy,   readonly ) NSString *hostName;
@property (nonatomic, assign, readonly ) NSUInteger port;
@property (nonatomic, copy,   readonly ) NSData *hostAddress;
@end


//@protocol ABSUDPMessaging<NSObject>
//@optional

//-(void) echo:(ABSUDPMessaging *)echo didStartWithAddress:(NSData *) address;
//-(void) echo:(ABSUDPMessaging *)echo didStopWithError:(NSError *) error;

//@end