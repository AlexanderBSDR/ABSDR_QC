//
//  ABSViewControllerLogin.m
//  ABSDR_QC
//
//  Created by CIG account on 1/31/14.
//  Copyright (c) 2014 CIG account. All rights reserved.
//

#import "ABSViewControllerLogin.h"

@interface ABSViewControllerLogin ()
@property (weak, nonatomic) IBOutlet UIButton *ConnectButton;
@property (weak, nonatomic) IBOutlet UITextField *LocalPortBox;
@property (weak, nonatomic) IBOutlet UITextField *RemotePortBox;
@property (weak, nonatomic) IBOutlet UITextField *IPAddressBox;

@end

@implementation ABSViewControllerLogin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.IPAddressBox.text=@"192.168.1.101";
    self.RemotePortBox.text=@"50000";
    self.LocalPortBox.text=@"50000";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ClickedConnect:(id)sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"showControlBoard"])
    {
 //       NSLog(@"HERE!");
        
        ABSViewControllerControlBoard *destView=[segue destinationViewController];
        destView.ConnectionParameters = [[ABSConnectionParameters alloc] init];
        
        destView.ConnectionParameters.IPAddress=self.IPAddressBox.text;
        destView.ConnectionParameters.LocalPort=[NSNumber numberWithInt:[self.LocalPortBox.text intValue]];
        destView.ConnectionParameters.RemotePort=[NSNumber numberWithInt:[self.RemotePortBox.text intValue]];
        
    }
}


@end
