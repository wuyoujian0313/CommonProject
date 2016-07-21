//
//  SignatureView.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/16.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "SignatureView.h"

@interface SignatureView ()

// 签名图片
@property (nonatomic, strong) UIImage           *image;
@property (nonatomic, strong) NSMutableArray    *arrayStrokes;
@property (nonatomic, strong) NSMutableArray    *arrayAbandonedStrokes;

@property (nonatomic, copy) SignatureStautsCallback       callback;
@end

@implementation SignatureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.backgroundColor = [UIColor whiteColor];
        
        self.penSize = 4.0;
        self.penColor = [UIColor blackColor];
        self.arrayStrokes = [NSMutableArray array];
        self.arrayAbandonedStrokes = [NSMutableArray array];
        self.callback = nil;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame status:(SignatureStautsCallback)callback {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.backgroundColor = [UIColor whiteColor];
        
        self.penSize = 4.0;
        self.penColor = [UIColor blackColor];
        self.arrayStrokes = [NSMutableArray array];
        self.arrayAbandonedStrokes = [NSMutableArray array];
        self.callback = callback;
    }
    return self;
}

// 禁用多触点
- (BOOL)isMultipleTouchEnabled {
    return NO;
}

- (void)saveImage2PNGAtPath:(NSString*)path {
    [self saveImage2FileAtPath:path isPNG:YES];
}

- (void)saveImage2JPEGAtPath:(NSString*)path {
    [self saveImage2FileAtPath:path isPNG:NO];
}

- (BOOL)canUndoSignature {
    return ([_arrayStrokes count] > 0);
}


- (BOOL)canRedoSignature {
    return ([_arrayAbandonedStrokes count] > 0);
}

- (void)undoSignature {
    if ([_arrayStrokes count]>0) {
        NSMutableDictionary* dictAbandonedStroke = [_arrayStrokes lastObject];
        [_arrayAbandonedStrokes addObject:dictAbandonedStroke];
        [_arrayStrokes removeLastObject];
        [self setNeedsDisplay];
    }
}

- (void)redoSignature {
    if ([_arrayAbandonedStrokes count]>0) {
        NSMutableDictionary* dictReusedStroke = [_arrayAbandonedStrokes lastObject];
        [_arrayStrokes addObject:dictReusedStroke];
        [_arrayAbandonedStrokes removeLastObject];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    
    if (_arrayStrokes) {
        
        for (NSDictionary *dictStroke in _arrayStrokes) {
            
            NSArray *arrayPointsInstroke = [dictStroke objectForKey:@"points"];
            UIColor *color = [dictStroke objectForKey:@"color"];
            float size = [[dictStroke objectForKey:@"size"] floatValue];
            [color set];
            
            UIBezierPath* pathLines = [UIBezierPath bezierPath];
            CGPoint pointStart = CGPointFromString([arrayPointsInstroke objectAtIndex:0]);
            [pathLines moveToPoint:pointStart];
#if 1
            for (int i = 0; i < (arrayPointsInstroke.count - 1); i++) {
                
                CGPoint pointNext = CGPointFromString([arrayPointsInstroke objectAtIndex:i+1]);
                CGPoint midPoint = [self midPoint:pointStart p1:pointNext];
                CGPoint midPoint1 = [self midPoint:pointStart p1:midPoint];
                CGPoint midPoint2 = [self midPoint:midPoint p1:pointNext];
                //- (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2
                
                [pathLines addCurveToPoint:pointNext controlPoint1:midPoint1 controlPoint2:midPoint2];
                pointStart = pointNext;
            }
            
#else
            for (int i = 0; i < (arrayPointsInstroke.count - 1); i++) {
                CGPoint pointNext = CGPointFromString([arrayPointsInstroke objectAtIndex:i+1]);
                [pathLines addLineToPoint:pointNext];
            }
            
#endif
            pathLines.lineWidth = size;
            pathLines.lineJoinStyle = kCGLineJoinRound;
            pathLines.lineCapStyle = kCGLineCapRound;
            [pathLines stroke];
        }
    }
}


- (void)clear {
    [_arrayStrokes removeAllObjects];
    [_arrayAbandonedStrokes removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - touche APIs
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSMutableArray *arrayPointsInStroke = [NSMutableArray array];
    NSMutableDictionary *dictStroke = [NSMutableDictionary dictionary];
    [dictStroke setObject:arrayPointsInStroke forKey:@"points"];
    [dictStroke setObject:_penColor forKey:@"color"];
    [dictStroke setObject:[NSNumber numberWithFloat:_penSize] forKey:@"size"];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [arrayPointsInStroke addObject:NSStringFromCGPoint(point)];
    
    [_arrayStrokes addObject:dictStroke];
    
    if (_callback) {
        _callback(SignatureStatusBegin);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self];
    NSMutableArray *arrayPointsInStroke = [[_arrayStrokes lastObject] objectForKey:@"points"];
    [arrayPointsInStroke addObject:NSStringFromCGPoint(point)];
    
    CGRect rectToRedraw = CGRectMake(((prevPoint.x>point.x)?point.x:prevPoint.x)-_penSize,
                                     ((prevPoint.y>point.y)?point.y:prevPoint.y)-_penSize,
                                     fabs(point.x-prevPoint.x)+2*_penSize,\
                                     fabs(point.y-prevPoint.y)+2*_penSize\
                                     );
    [self setNeedsDisplayInRect:rectToRedraw];
    
    if (_callback) {
        _callback(SignatureStatusMoving);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[_arrayAbandonedStrokes removeAllObjects];
    
    if (_callback) {
        _callback(SignatureStatusEnd);
    }
}


#pragma mark - private APIs
- (UIImage*)image {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)saveImage2FileAtPath:(NSString*)path isPNG:(BOOL)isPNG {
    NSData* data = isPNG ? UIImagePNGRepresentation(self.image):UIImageJPEGRepresentation(self.image,0);
    [data writeToFile:path atomically:YES];
}

- (CGPoint)midPoint:(CGPoint)p0 p1:(CGPoint)p1 {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}


@end
