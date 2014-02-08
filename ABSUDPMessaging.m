//
//  ABSUDPMessaging.m
//  ABSDR_QC
//
//  Created by Alexander Bilyi on 2/2/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import "ABSUDPMessaging.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <unistd.h>

@interface ABSUDPMessaging()

@property (nonatomic, copy,   readwrite) NSString *hostName;
@property (nonatomic, copy,   readwrite) NSData *hostAddress;
@property (nonatomic, assign, readwrite) NSUInteger port;

//- (void)stopHostResolution;
//- (void)stopWithError:(NSError *)error;

@end

@implementation ABSUDPMessaging
{
    CFHostRef _cfHost;
    CFSocketRef _cfSocket;
}
/*
@synthesize delegate = _delegate;
@synthesize hostName = _hostName;
@synthesize hostAddress = _hostAddress;
@synthesize port = _port;

-(id)init
{
    self=[super init];
    if(self!=nil)
    {
        
    }
    return self;
}

-(void) dealloc
{
    [self stop];
}

-(BOOL) isServer
{
    return self.hostName==nil;
}

-(void) stopHostResolution
{
    if(self->_cfHost!=NULL)
    {
        CFHostSetClient(self->_cfHost, NULL, NULL);
        CFHostCancelInfoResolution(self->_cfHost, kCFHostAddresses);
        CFHostUnscheduleFromRunLoop(self->_cfHost, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        CFRelease(self->_cfHost);
        self->_cfHost=NULL;
    }
}

-(void) stop
{
    self.hostName=nil;
    self.hostAddress=nil;
    self.port=0;
    [self stopHostResolution];
    
    if(self->_cfSocket != NULL)
    {
        CFSocketInvalidate(self->_cfSocket);
        CFRelease(self->_cfSocket);
        self->_cfSocket=NULL;
    }
    
}

-(void) echo:(ABSUDPMessaging *)echo didStopWithError:(NSError *) error
{
    NSLog(@"didStopWithError");
}

-(void) noop
{
    
}


-(void) stopWithError:(NSError *)error
{
    [self stop];
    if((self.delegate!=nil)&&[self.delegate respondsToSelector:@selector(echo:didStopWithError:)])
    {
        [self performSelector:@selector(noop) withObject:nil afterDelay:0.0];
        [self.delegate echo:self didStopWithError:error];
    }
}

-(void) startServerOnPort:(NSUInteger)port
{
    assert((port>0)&(port<65536));
    assert(self.port==0);
    
    if(self.port==0)
    {
        BOOL success;
        NSError *error;
        
        success=[self setupSocketConnectedToAddress:nil port:port error:&error];
        
        if(success)
        {
            self.port=port;
            if((self.delegate!=nil) &&([self.delegate respondsToSelector:@selector(echo:didStartWithAddress:)])
               {
                   CFDataRef    localAddress;
                   
                   localAddress=CFSocketCopyAddress(self->_cfSocket);
                   assert(localAddress!=NULL);
                   
                   [self.delegate echo:self didStartWithAddress:(__bridge NSData *)localAddress];
                   
                   CFRelease(localAddress);
               }
               else
               {
                   [self stopWithError:error];
               }
        }
    }
}

               
               
     */
static void SocketReadCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
// This C routine is called by CFSocket when there's data waiting on our
// UDP socket.  It just redirects the call to Objective-C code.
{
    ABSUDPMessaging *obj;
    
    obj = (__bridge ABSUDPMessaging *) info;
    assert([obj isKindOfClass:[ABSUDPMessaging class]]);
    
#pragma unused(s)
    assert(s == obj->_cfSocket);
#pragma unused(type)
    assert(type == kCFSocketReadCallBack);
#pragma unused(address)
    assert(address == nil);
#pragma unused(data)
    assert(data == nil);
    
//    [obj readData];
}


- (BOOL)setupSocketConnectedToAddress:(NSData *)address port:(NSUInteger)port error:(NSError **)errorPtr
// Sets up the CFSocket in either client or server mode.  In client mode,
// address contains the address that the socket should be connected to.
// The address contains zero port number, so the port parameter is used instead.
// In server mode, address is nil and the socket is bound to the wildcard
// address on the specified port.
{
    int err;
    int junk;
    int sock;
    const CFSocketContext context = { 0, (__bridge void *)(self), NULL, NULL, NULL };
    CFRunLoopSourceRef rls;
    
    err = 0;
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        err = errno;
    }

    if (err == 0) {
        struct sockaddr_in      addr;
        
        memset(&addr, 0, sizeof(addr));
        if (address == nil) {
            // Server mode.  Set up the address based on the socket family of the socket
            // that we created, with the wildcard address and the caller-supplied port number.
            addr.sin_len         = sizeof(addr);
            addr.sin_family      = AF_INET;
            addr.sin_port        = htons(port);
            addr.sin_addr.s_addr = INADDR_ANY;
            err = bind(sock, (const struct sockaddr *) &addr, sizeof(addr));
        } else {
            // Client mode.  Set up the address on the caller-supplied address and port
            // number.
            if ([address length] > sizeof(addr)) {
                assert(NO);
                [address getBytes:&addr length:sizeof(addr)];
            } else {
                [address getBytes:&addr length:[address length]];
            }
            assert(addr.sin_family == AF_INET);
            addr.sin_port = htons(port);
            err = connect(sock, (const struct sockaddr *) &addr, sizeof(addr));
        }
        if (err < 0) {
            err = errno;
        }
    }
    
    // From now on we want the socket in non-blocking mode to prevent any unexpected
    // blocking of the main thread.  None of the above should block for any meaningful
    // amount of time.
    
    if (err == 0) {
        int flags;
        
        flags = fcntl(sock, F_GETFL);
        err = fcntl(sock, F_SETFL, flags | O_NONBLOCK);
        if (err < 0) {
            err = errno;
        }
    }
    
    // Wrap the socket in a CFSocket that's scheduled on the runloop.
    
    if (err == 0) {
        self->_cfSocket = CFSocketCreateWithNative(NULL, sock, kCFSocketReadCallBack, SocketReadCallback, &context);
        
        // The socket will now take care of cleaning up our file descriptor.
        
        assert( CFSocketGetSocketFlags(self->_cfSocket) & kCFSocketCloseOnInvalidate );
        sock = -1;
        
        rls = CFSocketCreateRunLoopSource(NULL, self->_cfSocket, 0);
        assert(rls != NULL);
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
        
        CFRelease(rls);
    }
    
    // Handle any errors.
    
    if (sock != -1) {
        junk = close(sock);
        assert(junk == 0);
    }
    assert( (err == 0) == (self->_cfSocket != NULL) );
    if ( (self->_cfSocket == NULL) && (errorPtr != NULL) ) {
        *errorPtr = [NSError errorWithDomain:NSPOSIXErrorDomain code:err userInfo:nil];
    }
    
    return (err == 0);
}



@end
