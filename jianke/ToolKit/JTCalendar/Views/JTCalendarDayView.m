//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCalendarManager.h"

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
//    self.backgroundColor = [UIColor redColor];
    
    self.clipsToBounds = YES;
    
    _circleRatio = .7;
    _dotRatio = 1. / 9.;
    _unserLabelRatio = .5;
    
    {
        _circleView = [UIView new];
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleView.hidden = YES;

        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
    }
    
    {
        _dotView = [UIView new];
        [self addSubview:_dotView];
        
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.hidden = YES;

        _dotView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView.layer.shouldRasterize = YES;
    }
    
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
//        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        _textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    // add
    {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        
        _imageView.hidden = YES;
        _imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _imageView.layer.shouldRasterize = YES;
    }
    
    {
        _underLabel = [UILabel new];
        [self addSubview:_underLabel];
        
        _underLabel.hidden = YES;
        _underLabel.font = [UIFont systemFontOfSize:9];
        _underLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _underLabel.layer.shouldRasterize = YES;
    }
    
}

- (void)layoutSubviews
{
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2. - sizeCircle * 0.2);
    _circleView.layer.cornerRadius = sizeCircle / 2.;
    
    _dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) + sizeDot * 2.5);
    _dotView.layer.cornerRadius = sizeDot / 2.;
    
    _textLabel.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _textLabel.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2. - sizeCircle * 0.2);
    
    // add
    CGFloat sizeUnderLabel = roundf(sizeCircle * _unserLabelRatio);
    
    _imageView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _imageView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2. - sizeCircle * 0.2);
    _imageView.layer.cornerRadius = sizeCircle / 2.;
    
    _underLabel.frame = CGRectMake(0, 0, sizeUnderLabel, sizeUnderLabel);
    _underLabel.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) + sizeUnderLabel);
    
}

- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [self reload];
}

- (void)reload
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
        [dateFormatter setDateFormat:@"dd"];
    }
    
    _textLabel.text = [dateFormatter stringFromDate:_date];
        
    [_manager.delegateManager prepareDayView:self];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

@end
