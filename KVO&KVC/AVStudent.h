//
//  AVStudent.h
//  KVO&KVC
//
//  Created by Anatoly Ryavkin on 27/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    GenderMan = 0,
    GenderWomen,
    GenderNil
}Gender;

@interface AVStudent : NSObject

@property (nonatomic)NSString*firstName;
@property (nonatomic)NSString*lastName;
@property (nonatomic,nullable)NSDate*dateBirth;
@property (nonatomic)Gender gender;
@property (nonatomic)CGFloat grade;
@property NSDateFormatter*formatter;

@property (nonatomic,weak)AVStudent*frend;

@property BOOL check;

-(void)cleanIVar;



@end

NS_ASSUME_NONNULL_END
