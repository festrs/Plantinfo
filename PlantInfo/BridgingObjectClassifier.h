//
//  BridgingObject.h
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-07.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BridgingObjectClassifier : NSObject

- (NSArray*)predictWithImage: (UIImage*)image;

+ (id)sharedManager;
@end

