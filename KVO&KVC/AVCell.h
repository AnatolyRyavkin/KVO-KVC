//
//  AVCell.h
//  KVO&KVC
//
//  Created by Anatoly Ryavkin on 27/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVStudent.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVCell : UITableViewCell

@property AVStudent*student;

@end

NS_ASSUME_NONNULL_END
