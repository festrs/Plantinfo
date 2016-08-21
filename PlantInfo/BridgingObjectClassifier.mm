//
//  BridgingObject.m
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-07.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

#import "BridgingObjectClassifier.h"
#import "Classifier.h"
#import <Foundation/Foundation.h>

@implementation BridgingObjectClassifier

Classifier *classifier = NULL;

+ (id)sharedManager {
    static BridgingObjectClassifier *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        //Load model
        NSString* model_file = [NSBundle.mainBundle pathForResource:@"deploy" ofType:@"prototxt" inDirectory:@"models"];
        NSString* label_file = [NSBundle.mainBundle pathForResource:@"labelt4" ofType:@"txt" inDirectory:@"models"];
        NSString* mean_file = [NSBundle.mainBundle pathForResource:@"image_mean_t4_treainset" ofType:@"binaryproto" inDirectory:@"models"];
        NSString* trained_file = [NSBundle.mainBundle pathForResource:@"bvlc_4training_googlenet_iter_80000" ofType:@"caffemodel" inDirectory:@"models"];
        string model_file_str = std::string([model_file UTF8String]);
        string label_file_str = std::string([label_file UTF8String]);
        string trained_file_str = std::string([trained_file UTF8String]);
        string mean_file_str = std::string([mean_file UTF8String]);
        classifier = new Classifier(model_file_str, trained_file_str, mean_file_str, label_file_str);
    }
    return self;
}

- (NSArray*)predictWithImage: (UIImage*)image
{
    cv::Mat src_img, bgra_img;
    UIImageToMat(image, src_img);
    // needs to convert to BGRA because the image loaded from UIImage is in RGBA
    cv::cvtColor(src_img, bgra_img, CV_RGBA2BGRA);
    
    std::vector<Prediction> result = classifier->Classify(bgra_img);
    
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    for (std::vector<Prediction>::iterator it = result.begin(); it != result.end(); ++it) {
        NSString* label = [NSString stringWithUTF8String:it->first.c_str()];
        NSString* nid = [label componentsSeparatedByString:@" "].lastObject;
        NSNumber* probability = [NSNumber numberWithFloat:it->second];
        NSString* result = [NSString stringWithFormat:@"%@;%@", nid, probability];
        [ret addObject:result];
    }
    
    return [ret copy];
}
@end
