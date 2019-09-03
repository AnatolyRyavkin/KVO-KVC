//
//  AVViewController.h
//  KVO&KVC
//
//  Created by Anatoly Ryavkin on 27/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVStudent.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property NSArray*arrayStudents;
@property IBOutlet UITableView*table;
@property UITableViewController*tvc;
@property NSDateFormatter*formatter;

@property UITextField* textFieldFirstName;
@property UITextField* textFieldLastName;
@property UITextField* textFieldDateBirth;
@property UITextField* textFieldGender;
@property UITextField* textFieldGrade;

@property AVStudent*curentStudent;

- (IBAction)actionInfo:(UIButton *)sender;
- (IBAction)actionClean:(UIButton *)sender;
- (IBAction)actionCleanIVar:(UIButton *)sender;
- (IBAction)actionIVar:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
