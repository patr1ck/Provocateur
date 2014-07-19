//
//  Provocateur.m
//  Provocateur
//
//  Created by Patrick B. Gibson on 2/17/14.
//  Copyright (c) 2014 Pacific Helm. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "Provocateur.h"

#define kProvocateurServiceType @"Provocateur"

@interface Provocateur () <MCSessionDelegate, MCAdvertiserAssistantDelegate>

// Multipeer
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *peeringSession;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

// Value tracking
@property (nonatomic, strong) NSDictionary *defaultValueDictionary;
@property (nonatomic, strong) NSMapTable *keyToBlockMap;

@end

@implementation Provocateur

+ (id)sharedInstance;
{
    static dispatch_once_t once;
    static Provocateur *sharedProvocateur;
    dispatch_once(&once, ^ {
        sharedProvocateur = [[self alloc] init];
        [sharedProvocateur setup];
    });
    return sharedProvocateur;
}

- (void)listen;
{
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [appInfo objectForKey:@"CFBundleDisplayName"];
    NSString *displayName = [deviceName stringByAppendingFormat:@": %@", appName];
    
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    self.peeringSession = [[MCSession alloc] initWithPeer:self.peerID];
    self.peeringSession.delegate = self;
    
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:kProvocateurServiceType
                                                           discoveryInfo:nil
                                                                 session:self.peeringSession];
    self.advertiser.delegate = self;
    [self.advertiser start];
}

- (void)configureKey:(NSString *)key usingBlock:(ProvocateurBlock)block;
{
    [self.keyToBlockMap setObject:block forKey:key];
    
    // Run with initial value from plist
    if ([self.defaultValueDictionary objectForKey:key] && self.defaultValueDictionary[key][@"default"]) {
        block(self.defaultValueDictionary[key][@"default"]);
    } else {
        NSLog(@"ERROR: Couldn't configure key: doesn't exist in the Overridables.plist");
    }
    
}

- (void)configureNewKey:(NSString *)key withDefaultValue:(id)defaultValue options:(NSDictionary *)options usingBlock:(ProvocateurBlock)block;
{
    // Create the value in our dictionary
}

#pragma mark - Private

- (void)setup
{
    self.keyToBlockMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsObjectPersonality
                                                   valueOptions:NSPointerFunctionsObjectPointerPersonality
                                                       capacity:100];
    
    NSString *defaultsFilePath = [[NSBundle mainBundle] pathForResource:@"Overridables" ofType:@"plist"];
	self.defaultValueDictionary = [NSDictionary dictionaryWithContentsOfFile:defaultsFilePath];
}

#pragma mark MCAdvertiserAssistantDelegate

// An invitation will be presented to the user
- (void)advertiserAssitantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant;
{
    NSLog(@"Presenting invite");
}

// An invitation was dismissed from screen
- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant;
{
    NSLog(@"Dismissing invite");
}

#pragma mark MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;
{
    NSLog(@"Session changed state: %@", session);
    
    
    if (state == MCSessionStateConnected) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Overridables" withExtension:@"plist"];
        
        // there should be only one peer
        if (session.connectedPeers.count != 1) {
            NSLog(@"More or less than 1 peer connected. Bailing.");
            return;
        }
        MCPeerID *hq = session.connectedPeers[0];
        
        [session sendResourceAtURL:url
                          withName:@"Overridables.plist"
                            toPeer:hq
             withCompletionHandler:^(NSError *error) {
                 if (error) {
                     NSLog(@"Error sending file to peer: %@", [error localizedDescription]);
                 } else {
                     NSLog(@"Sent Overriables.plist to peer.");
                 }
             }];
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
{
    NSLog(@"Got data: %@", data);
    
    NSDictionary *rxDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *key = rxDictionary[@"key"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ProvocateurBlock block = [self.keyToBlockMap objectForKey:key];
        block(rxDictionary[@"value"]);
    });
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
    
}



@end