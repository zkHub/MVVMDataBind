//
//  TestView.m
//  mvvmTest
//
//  Created by zk on 2021/9/2.
//

#import "TestView.h"

@implementation TestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

@end
