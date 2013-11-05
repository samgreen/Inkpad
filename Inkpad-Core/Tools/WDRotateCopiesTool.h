//
//  WDRotateCopiesTool.h
//  Inkpad
//
//  Created by Sam Green on 11/4/13.
//  Copyright (c) 2013 Taptrix, Inc. All rights reserved.
//

#import "WDTransformTool.h"

@interface WDRotateCopiesTool : WDTransformTool {
    NSUInteger          numCopies_;
    NSMutableArray      *copies_;
    WDCanvas            *canvas_;
    
#if TARGET_OS_IPHONE
    IBOutlet UIView     *optionsView_;
    IBOutlet UILabel    *optionsTitle_;
    IBOutlet UILabel    *optionsValue_;
    IBOutlet UISlider   *optionsSlider_;
#endif
}

@end
