//
//  IMUDataManager.h
//  GyroAccel
//
//  Created by LiHongyu on 4/25/16.
//  Copyright © 2016 Andrew Genualdi. All rights reserved.
//

#ifndef IMUDataManager_h
#define IMUDataManager_h

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface IMUDataManager : NSObject

@property NSString * accVal_x;
@property NSString * accVal_y;
@property NSString * accVal_z;
@property double speed_x;
@property double speed_y;
@property double position_x;
@property double position_y;

+ (instancetype) sharedIMUDataManager;



@end

#endif /* IMUDataManager_h */
