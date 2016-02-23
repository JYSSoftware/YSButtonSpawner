//
//  YSSpawner.m
//  YSButtonSpawner
//
//  Copyright (c) 2016 Yongsuk Jin ( https://github.com/JYS1004 ).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "YSSpawner.h"
#define DG_TO_RAD(angle) ((M_PI * angle) / 180.0)

@interface YSSpawner ()

@property CGPoint centerOfRoot;

@end

@implementation YSSpawner

- (id) init{
  
  self = [super init];
  
  if (self) {
    [self cummonInit];
  }
  return self;
}

- (id) initWithRootButton: (UIButton*) root{
  
  self = [super init];
  
  if (self) {
    [self cummonInit];
    _rootButton = root;
  }
  return self;
}

- (void) cummonInit{
  _rootButton = [[UIButton alloc] init];
  _btnCluster = [[NSMutableArray alloc] init];
}

//return center
- (CGPoint) centerCalculator: (CGRect) frame{
  
  CGFloat center_x, center_y;
  center_x = (frame.origin.x + frame.size.width) / 2;
  center_y = (frame.origin.y + frame.size.height) /2;
  return CGPointMake(center_x, center_y);
}

//returns spawned button cluster (last object is newly added)
- (NSMutableArray*) spawnButton : (CGRect) initPoint : (CGRect) destination
                                : (UIButton *) button : (NSTimeInterval) duration
                                : (CGFloat) alpha : (UIView*) viewTobePresented
{
  [_btnCluster addObject:button];
  if (button.alpha != 0) {
    button.alpha = 0;
    button.frame = initPoint;
    [viewTobePresented addSubview:button];
  }
  
  [UIButton animateWithDuration:duration delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:6 options:UIViewAnimationOptionAllowUserInteraction animations:^{
    button.alpha = alpha;
    button.frame = destination;
  } completion:nil];
  
  return _btnCluster;
}

- (void) spawnBack : (UIButton*) rootBtn : (NSTimeInterval) duration
                   : (UIButton*) buttonTobeDisapper : (UIView*) presentedView
{
  //if button isnt in the presentedView
  if (![buttonTobeDisapper isDescendantOfView:presentedView] || [buttonTobeDisapper superview] == nil) {
    NSLog(@"wrong parent View Or No superView");
    return;
  }
  else{
    [UIButton animateWithDuration:duration animations:^{
      
      buttonTobeDisapper.alpha = 0;
      buttonTobeDisapper.frame = rootBtn.frame;
      
    } completion: ^(BOOL finished){
      [buttonTobeDisapper removeFromSuperview];
    }];
  }
}

- (void) spawnBackAll : (UIButton*) rootBtn : (NSTimeInterval) duration
                   : (NSMutableArray*) buttonsTobeDisapper
{
  for (UIButton *buttonTobeDisapper in buttonsTobeDisapper) {
    
    if ([buttonTobeDisapper isEqual:_rootButton]) {
      //cannot disapper rootButton
      
    }
    else{
      //if button isnt in the presentedView
      if ([buttonTobeDisapper superview] == nil) {
        NSLog(@"No superView");
      }
      else{
        [UIButton animateWithDuration:duration animations:^{
      
          buttonTobeDisapper.alpha = 0;
          buttonTobeDisapper.frame = rootBtn.frame;
      
        } completion: ^(BOOL finished){
          [buttonTobeDisapper removeFromSuperview];
        }];
      }
    }
  }
}

//angle input : counter clockwise (starting from left x-axis below x-axis is negative angle)
- (CGRect) getDestination : (UIButton*) rootBtn : (CGPoint) rootCenter : (float) angle : (float) distance{
 
  float rad = DG_TO_RAD(angle);
  CGPoint destCenter = CGPointMake( rootCenter.x + distance * cosf(rad),
                                   rootCenter.y + distance * sinf(rad));
  CGRect frame = rootBtn.frame;
  float dy, dx;
  dy = frame.size.height/2;
  dx = frame.size.width/2;
  
  CGPoint destXY = CGPointMake(destCenter.x - dx, destCenter.y - dy);
  return CGRectMake(destXY.x, destXY.y, rootBtn.frame.size.width, rootBtn.frame.size.height);
}

- (float) calculateAbsoluteAngle : (float) angle{
  int i = (int)(angle / 360.0);
  if (angle < 0) {
    
    if (i != 0) {
      angle = 360 - fabs((angle - i * 360));
    }
    else{
      angle = 360 - fabs(angle);
    }
  }
  else{
    if (i != 0)
    {
      angle = angle - i * 360;
    }
  }
  return angle;
}


- (void) setPresentingView:(UIView *)presentingView{
  _presentingView = presentingView;
}

- (void) setRootButton:(UIButton *)rootButton{
  _rootButton = rootButton;
}

- (UIView*) getPresentingView{
  return _presentingView;
}

- (UIButton*) getRootButton{
  return _rootButton;
}


@end
