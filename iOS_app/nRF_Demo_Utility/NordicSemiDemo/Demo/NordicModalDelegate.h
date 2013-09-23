// Copyright (c) 2011 Nordic Semiconductor. All Rights Reserved.
//
// The information contained herein is property of Nordic Semiconductor ASA.
// Terms and conditions of usage are described in detail in // NORDIC SEMICONDUCTOR SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT.
//
// Licensees are granted free, non-transferable use of the information.
// NO WARRANTY of ANY KIND is provided.
// This heading must NOT be removed from the file.
//
//
//  NordicModalDelegate.h
//  NordicSemiDemo
//
//  Created by Ransom Weaver on 12/18/11.
//

#import <Foundation/Foundation.h>

@protocol NordicModalDelegate <NSObject>

- (void)dismissModal;

@end
