//
//  ViewController.m
//  TexTooth
//
//  Created by Taylor & Alex Triggs on 1/29/13.
//  Copyright (c) 2013 Taylor Triggs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize currentSession;
@synthesize txtMessage;
@synthesize connect;
@synthesize disconnect;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[connect setHidden:NO];
    [disconnect setHidden:YES];
    [super viewDidLoad];
}

-(IBAction)btnConnect:(id) sender {
    picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    
    [connect setHidden:YES];
    [disconnect setHidden:NO];
    [picker show];
}

-(void)peerPickerController:(GKPeerPickerController *)pk
             didConnectPeer:(NSString *)peerID
                  toSession:(GKSession *)session {
    self.currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
}

-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)pk {
    picker.delegate = nil;
    [picker autorelease];
    [connect setHidden:NO];
    [disconnect setHidden:YES];
}

-(IBAction) btnDisconnect:(id) sender {
    [self.currentSession disconnectFromAllPeers];
    [self.currentSession release];
    currentSession = nil;
    [connect setHidden:NO];
    [disconnect setHidden:YES];
}

- (void)session:(GKSession *)session
didFailWithError:(NSError *)error {
	NSLog(@"%@", [error description]);
}

-(void)session:(GKSession *)session
          peer:(NSString *)peerID
didChangeState:(GKPeerConnectionState)state {
	
    switch (state)
    {
        case GKPeerStateConnected:
            NSLog(@"connected");
            break;
            
		case GKPeerStateDisconnected:
            NSLog(@"disconnected");
            [self.currentSession release];
            currentSession = nil;
            [connect setHidden:NO];
            [disconnect setHidden:YES];
            break;
    }
}

- (void)dealloc {
	[txtMessage release];
    [currentSession release];
	[connect release];
    [disconnect release];
	[super dealloc];
}

- (void) mySendDataToPeers:(NSData *) data {
    if (currentSession)
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:GKSendDataReliable
                                          error:nil];
}

-(IBAction) btnSend:(id) sender {
    //—-convert an NSString object to NSData—-
    NSData* data;
    NSString *str = [NSString stringWithString:txtMessage.text];
    data = [str dataUsingEncoding: NSASCIIStringEncoding];
    [self mySendDataToPeers:data];
}

- (void) receiveData:(NSData *)data
            fromPeer:(NSString *)peer
           inSession:(GKSession *)session
             context:(void *)context {
	
    //—-convert the NSData to NSString—-
    NSString* str;
    str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data received"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
	[str release];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end