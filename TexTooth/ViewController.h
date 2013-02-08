//
//  ViewController.h
//  TexTooth
//
//  Created by Taylor & Alex Triggs on 1/29/13.
//  Copyright (c) 2013 Taylor Triggs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController
    <GKSessionDelegate, GKPeerPickerControllerDelegate> {
    
	GKSession *currentSession;
	IBOutlet UITextField *txtMessage;
	IBOutlet UIButton *connect;
	IBOutlet UIButton *disconnect;
	GKPeerPickerController *picker;
}

@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, retain) UITextField *txtMessage;
@property (nonatomic, retain) UIButton *connect;
@property (nonatomic, retain) UIButton *disconnect;

-(IBAction) btnSend:(id) sender;
-(IBAction) btnConnect:(id) sender;
-(IBAction) btnDisconnect:(id) sender;

@end