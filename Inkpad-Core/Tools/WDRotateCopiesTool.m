//
//  WDRotateCopiesTool.m
//  Inkpad
//
//  Created by Sam Green on 11/4/13.
//  Copyright (c) 2013 Taptrix, Inc. All rights reserved.
//

#import "WDRotateCopiesTool.h"
#import "WDUtilities.h"

#define kOptionsViewCornerRadius    9

@implementation WDRotateCopiesTool

- (NSString *) iconName
{
    return @"rotate.png";
}

- (BOOL) createsObject
{
    return YES;
}

- (void) activated
{
    [self createCopies];
}

- (CGAffineTransform) computeTransform:(CGPoint)pt pivot:(CGPoint)pivot constrain:(WDToolFlags)flags
{
    CGPoint delta = WDSubtractPoints(self.initialEvent.location, pivot);
    double offsetAngle = atan2(delta.y, delta.x);
    
    delta = WDSubtractPoints(pt, pivot);
    double angle = atan2(delta.y, delta.x);
    double diff = angle - offsetAngle;
    
    if ((flags & WDToolShiftKey) || (flags & WDToolSecondaryTouch)) {
        float degrees = diff * 180 / M_PI;
        degrees = round(degrees / 45) * 45;
        diff = degrees * M_PI / 180.0f;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(pivot.x, pivot.y);
    transform = CGAffineTransformRotate(transform, diff);
    transform = CGAffineTransformTranslate(transform, -pivot.x, -pivot.y);
    
    return transform;
}

- (void) createCopies
{
    // 1 Create copies of the selected object
    // 2 Transform the created copies
    // 3 Group the original and the copies
}

- (void) deleteCopies
{
    
}

- (void) resetCopies {
    
}

#if TARGET_OS_IPHONE

#pragma mark - Touch Handling
- (void) beginWithEvent:(WDEvent *)event inCanvas:(WDCanvas *)canvas
{
    canvas_ = canvas;
}

#pragma mark - IBActions
- (void) updateOptionsSettings
{
    optionsValue_.text = [NSString stringWithFormat:@"%lu", (unsigned long)numCopies_];
    optionsSlider_.value = numCopies_;
}

- (void) takeFinalSliderValueFrom:(id)sender
{
    numCopies_ = optionsSlider_.value;
    [self updateOptionsSettings];
}

- (void) takeSliderValueFrom:(id)sender
{
    numCopies_ = optionsSlider_.value;
    [self updateOptionsSettings];
}

- (IBAction)increment:(id)sender
{
    optionsSlider_.value = optionsSlider_.value + 1;
    [optionsSlider_ sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)decrement:(id)sender
{
    optionsSlider_.value = optionsSlider_.value - 1;
    [optionsSlider_ sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (UIView *) optionsView
{
    if (!optionsView_) {
        [[NSBundle mainBundle] loadNibNamed:@"ShapeOptions" owner:self options:nil];
        
        optionsSlider_.minimumValue = 1;
        optionsSlider_.maximumValue = 30;
        optionsSlider_.backgroundColor = nil;
        optionsSlider_.exclusiveTouch = YES;
        
        optionsView_.layer.cornerRadius = kOptionsViewCornerRadius;
        
        UIBezierPath *shadowPath = [UIBezierPath
                                    bezierPathWithRoundedRect:optionsView_.bounds
                                    cornerRadius:kOptionsViewCornerRadius];
        
        CALayer *layer = optionsView_.layer;
        layer.shadowPath = shadowPath.CGPath;
        layer.shadowOpacity = 0.33f;
        layer.shadowRadius = 10;
        layer.shadowOffset = CGSizeZero;
        
        optionsTitle_.text = NSLocalizedString(@"Number of Copies", @"Number of Copies");
        
        numCopies_ = 5;
    }
    
    [self updateOptionsSettings];
    
    return optionsView_;
}

#endif

@end
