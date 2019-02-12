//
//  GYKit.h
//  Ying2018
//
//  Created by qiugaoying on 2019/2/12.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#ifndef GYKit_h
#define GYKit_h

#import <Masonry.h>
#import "NSDate+Category.h"
#import "UIColor+Extension.h"
#import "GYDateSimpleSheetView.h"

#define GYSCREEN_W   [UIScreen mainScreen].bounds.size.width
#define GYSCREEN_H  [UIScreen mainScreen].bounds.size.height

#define GYFontWidthScale   ((CGFloat)((GYSCREEN_W < GYSCREEN_H ? GYSCREEN_W :GYSCREEN_H) / 375.0))  // 375
#define GYFontRegularText(fsize)  [UIFont fontWithName:@"PingFangSC-Regular" size:(fsize * GYFontWidthScale)]

#endif /* GYKit_h */
