//
//  IMUDataViewControllerDelegate.swift
//  GyroAccel
//
//  Created by LiHongyu on 5/15/16.
//  Copyright © 2016 Andrew Genualdi. All rights reserved.
//

import Foundation


@objc public protocol IMUDataViewControllerDelegate: class {
    func getIMUdatavalue() -> NSString
}