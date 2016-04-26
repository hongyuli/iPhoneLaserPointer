//
//  IMUDataManager.m
//  GyroAccel
//
//  Created by LiHongyu on 4/25/16.
//  Copyright © 2016 Andrew Genualdi. All rights reserved.
//

#import "IMUDataManager.h"
#import "GyroAccel-Swift.h"

@interface IMUDataManager ()
{
    CMMotionManager * motionManager;
}

@end

@implementation IMUDataManager
@synthesize accVal_x;
@synthesize accVal_y;
@synthesize accVal_z;

+ (instancetype) sharedIMUDataManager {
    static IMUDataManager * sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype) init {
    self.position_x = 0;
    self.position_y = 0;
    self.speed_x=0;
    self.speed_y=0;
    self.position_x=0;
    self.position_y=0;
    if (self = [super init]) {
        motionManager = [[CMMotionManager alloc] init];
        //MotionManager
        if([motionManager isDeviceMotionAvailable]) {
            /* Start the DeviceMotion if it is not active already */
            if([motionManager isDeviceMotionActive] == NO) {
                
                /* Update us 2 times a second */
                [motionManager setDeviceMotionUpdateInterval:1.0f / 2.0f];
                
                /* Add on a handler block object */
                
                /* Receive the DeviceMotion data on this block */
                [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                   withHandler:^(CMDeviceMotion *devicemotion, NSError *error)
                 {
                     self.accVal_x = [NSString stringWithFormat:@"%.02f", devicemotion.userAcceleration.x];
                     self.accVal_y = [NSString stringWithFormat:@"%.02f", devicemotion.userAcceleration.y];
                     self.accVal_z = [NSString stringWithFormat:@"%.02f", devicemotion.userAcceleration.z];
                     
                     self.speed_x = self.speed_x + devicemotion.userAcceleration.y;
                     self.speed_y = self.speed_y + devicemotion.userAcceleration.z;
                     
                     self.position_x = self.position_x+self.speed_x;
                     self.position_y = self.position_y+self.speed_y;
                     
                 }];
            }
        }
        else
        {
            NSLog(@"MotionManager not Available!");
        }
        return self;
    }
    return nil;
}

@end