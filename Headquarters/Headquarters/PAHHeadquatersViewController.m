//
//  PAHViewController.m
//  Headquarters
//
//  Created by Patrick B. Gibson on 2/17/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "UIColor+Additions.h"

#import "PAHHeadquatersViewController.h"
#import "PAHNumberValueCell.h"
#import "PAHColorControlCell.h"

@interface PAHHeadquatersViewController () <MCSessionDelegate, MCBrowserViewControllerDelegate, PAHColorControlCellDelegate>

// Multipeer
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *peeringSession;
@property (nonatomic, strong) MCBrowserViewController *browser;

// UI
@property (nonatomic, strong) UIView *overlay;

// Model
@property (nonatomic, strong) NSDictionary *overridablesDictionary;


@end

@implementation PAHHeadquatersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.peeringSession = [[MCSession alloc] initWithPeer:self.peerID];
    self.peeringSession.delegate = self;
    
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"Provocateur"
                                                                session:self.peeringSession];
    self.browser.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.browser.minimumNumberOfPeers = 1;
    self.browser.maximumNumberOfPeers = 1;
    self.browser.delegate = self;
    
    self.overridablesDictionary = [NSDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.overridablesDictionary.count == 0) {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             [self.view addSubview:self.overlay];
                         }
                         completion:nil];
    }
}

- (UIView *)overlay
{
    if (!_overlay) {
        UINib *overlayNib = [UINib nibWithNibName:@"ConnectOverlayView" bundle:nil];
        self.overlay = [[overlayNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        self.overlay.frame = self.view.bounds;
    }
    
    return _overlay;
}

#pragma mark - IBActions

- (IBAction)showConnectModal:(id)sender;
{
    [self presentViewController:self.browser animated:YES completion:^{}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.overridablesDictionary allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell;
    
    NSString *key = [self.overridablesDictionary.allKeys objectAtIndex:indexPath.section];
    NSDictionary *overrideableValue = self.overridablesDictionary[key];
    id defaultValue = overrideableValue[@"default"];
    
    // See what kind of cell we are;
    if ([defaultValue isKindOfClass:[NSNumber class]]) {
        PAHNumberValueCell *numberCell = [self.tableView dequeueReusableCellWithIdentifier:@"value" forIndexPath:indexPath];
        
        numberCell.tag = indexPath.section;
//        numberCell.delegate = self;
        
        cell = numberCell;
    } else if ([defaultValue isKindOfClass:[NSString class]]) {
        PAHColorControlCell *colorCell = [self.tableView dequeueReusableCellWithIdentifier:@"color" forIndexPath:indexPath];
        
        colorCell.color = [UIColor colorWithRGBHexString:defaultValue];
        colorCell.tag = indexPath.section;
        colorCell.delegate = self;
        
        cell = colorCell;
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.overridablesDictionary.allKeys objectAtIndex:section];
}

#pragma mark PAHColorControlCellDelegate

- (void)colorControlCell:(PAHColorControlCell *)cell changedColor:(UIColor *)color;
{
    NSString *key = [self.overridablesDictionary.allKeys objectAtIndex:cell.tag];
    [self sendValue:[color RGBHexString] forKey:key];
}

- (IBAction)sendValue:(id)value forKey:(NSString *)key
{
    NSError *error = nil;
    NSDictionary *txDictionary = @{@"key": key, @"value": value};
    NSData *dataPackage = [NSKeyedArchiver archivedDataWithRootObject:txDictionary];
    
    BOOL success = [self.peeringSession sendData:dataPackage
                                         toPeers:self.peeringSession.connectedPeers
                                        withMode:MCSessionSendDataReliable
                                           error:&error];
    
    if (!success && error) {
        NSLog(@"ERROR SENDING: %@", [error localizedDescription]);
    }
}


- (IBAction)colorDidUpdate:(id)sender
{
    // crappy validation for hex codes
    if (!(self.textField.text.length == 3 || self.textField.text.length == 6)) {
        return;
    }
    
    
    NSError *error = nil;
    
    NSDictionary *txDictionary = @{@"key": @"color", @"value": self.textField.text};
    NSData *dataPackage = [NSKeyedArchiver archivedDataWithRootObject:txDictionary];
    
    BOOL success = [self.peeringSession sendData:dataPackage
                                         toPeers:self.peeringSession.connectedPeers
                                        withMode:MCSessionSendDataReliable
                                           error:&error];
    
    if (!success && error) {
        NSLog(@"ERROR SENDING: %@", [error localizedDescription]);
    }
}


#pragma mark MCBrowserViewControllerDelegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.peeringSession.connectedPeers.count > 0) {
        [self.overlay removeFromSuperview];
        self.overlay = nil;
    }
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;
{
    NSLog(@"Session changed state: %@", session);
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
{
//    NSLog(@"Got data: %@", data);
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID;
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress;
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error;
{
    if (error) {
        NSLog(@"ERROR: Couldn't recieve file.");
        return;
    }
    
    if ([resourceName isEqualToString:@"Overridables.plist"]) {
        self.overridablesDictionary = [NSDictionary dictionaryWithContentsOfURL:localURL];
        [self.tableView reloadData];
        [self.overlay removeFromSuperview];
    }
}
@end
