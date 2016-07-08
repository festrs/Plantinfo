//
//  BridgingObject.m
//  PlantInfo
//
//  Created by Felipe Dias Pereira on 2016-07-07.
//  Copyright © 2016 Felipe Dias Pereira. All rights reserved.
//

#import "BridgingObject.h"
#import "Classifier.h"

@implementation BridgingObject
- (NSString*)predictWithImage: (UIImage*)image;
{
    NSString* model_file = [NSBundle.mainBundle pathForResource:@"deploy" ofType:@"prototxt" inDirectory:@"model"];
    NSString* label_file = [NSBundle.mainBundle pathForResource:@"labels" ofType:@"txt" inDirectory:@"model"];
    NSString* mean_file = [NSBundle.mainBundle pathForResource:@"mean" ofType:@"binaryproto" inDirectory:@"model"];
    NSString* trained_file = [NSBundle.mainBundle pathForResource:@"bvlc_reference_caffenet" ofType:@"caffemodel" inDirectory:@"model"];
    string model_file_str = std::string([model_file UTF8String]);
    string label_file_str = std::string([label_file UTF8String]);
    string trained_file_str = std::string([trained_file UTF8String]);
    string mean_file_str = std::string([mean_file UTF8String]);
    
    cv::Mat src_img, bgra_img;
    UIImageToMat(image, src_img);
    // needs to convert to BGRA because the image loaded from UIImage is in RGBA
    cv::cvtColor(src_img, bgra_img, CV_RGBA2BGRA);
    
    Classifier classifier = Classifier(model_file_str, trained_file_str, mean_file_str, label_file_str);
    std::vector<Prediction> result = classifier.Classify(bgra_img);
    
    NSString* ret = nil;
    
    for (std::vector<Prediction>::iterator it = result.begin(); it != result.end(); ++it) {
        NSString* label = [NSString stringWithUTF8String:it->first.c_str()];
        NSNumber* probability = [NSNumber numberWithFloat:it->second];
        NSLog(@"label: %@, prob: %@", label, probability);
        if (it == result.begin()) {
            ret = label;
        }
    }
    
    return ret;
}
@end
