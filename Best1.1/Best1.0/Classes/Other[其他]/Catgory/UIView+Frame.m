

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setWxh_height:(CGFloat)wxh_height
{
    CGRect rect = self.frame;
    rect.size.height = wxh_height;
    self.frame = rect;
}

- (CGFloat)wxh_height
{
    return self.frame.size.height;
}

- (CGFloat)wxh_width
{
    return self.frame.size.width;
}
- (void)setWxh_width:(CGFloat)wxh_width
{
    CGRect rect = self.frame;
    rect.size.width = wxh_width;
    self.frame = rect;
}

- (CGFloat)wxh_x
{
    return self.frame.origin.x;
    
}

- (void)setWxh_x:(CGFloat)wxh_x
{
    CGRect rect = self.frame;
    rect.origin.x = wxh_x;
    self.frame = rect;
}

- (void)setWxh_y:(CGFloat)wxh_y
{
    CGRect rect = self.frame;
    rect.origin.y = wxh_y;
    self.frame = rect;
}

- (CGFloat)wxh_y
{

    return self.frame.origin.y;
}

-(void)setWxh_centerX:(CGFloat)wxh_centerX{
    CGPoint center = self.center;
    center.x = wxh_centerX;
    self.center = center;
}
-(CGFloat)wxh_centerX{
    return self.center.x;
}

-(void)setWxh_centerY:(CGFloat)wxh_centerY{

    CGPoint center = self.center;
    center.y = wxh_centerY;
    self.center = center;
}
-(CGFloat)wxh_centerY{
    return self.center.y;
}

#pragma mark - 快速从xib中创建view
+(instancetype)viewFromXib{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}
@end
