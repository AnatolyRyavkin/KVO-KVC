//
//  AVViewController.m
//  KVO&KVC
//
//  Created by Anatoly Ryavkin on 27/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVViewController.h"
#import "AVStudent.h"
#import "AVTableViewCell.m"
#import "AVCell.h"
#import <Foundation/Foundation.h>

@interface AVViewController ()

@end

@implementation AVViewController

#pragma mark - Did load and accessory function

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray*array = [[NSMutableArray alloc]init];
    int count =5;//arc4random()%100+20;
    int numberStudentCheck =arc4random_uniform(count);
    for(int i=0;i<count;i++){
        AVStudent*student = [[AVStudent alloc]init];
                            /* [student addObserver:self forKeyPath:@"firstName" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
                             [student addObserver:self forKeyPath:@"lastName" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
                             [student addObserver:self forKeyPath:@"dataBirth" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
                             [student addObserver:self forKeyPath:@"gender" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
                             [student addObserver:self forKeyPath:@"grade" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
                             */
        if(i!=0)
            student.frend =[array lastObject];
        if(i==count-1){
            ((AVStudent*)[array firstObject]).frend = student;
        }
        if(i==numberStudentCheck)
            [student addObserver:self forKeyPath:@"check" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
        student.check = arc4random()%2;
        [array addObject:student];
    }
    self.arrayStudents = [NSArray arrayWithArray:array];
    UIStoryboard*storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.tvc = [storyboard instantiateViewControllerWithIdentifier:@"identifierTVC"];
    [self.tvc.tableView reloadData];
    self.formatter = [[NSDateFormatter alloc]init];
    self.formatter.dateFormat = @"dd/MMM/yyyy";
}

- (void)viewWillAppear:(BOOL)animated{
    [self.table reloadData];
}

-(AVCell*)makeCellForView:(UIView*)view{
    if([view isMemberOfClass:[AVCell class]])
        return (AVCell*)view;
    if(view.superview==nil)
        return nil;
    else
        return [self makeCellForView:view.superview];
}

-(AVStudent*)studentAtIndexPath:(NSIndexPath*)indexPath{
    return [self.arrayStudents objectAtIndex:indexPath.row];
}

#pragma mark - Observer

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"");
    NSLog(@"-----------------Observer-------------------");
    NSLog(@"student Observing : %@ %@",((AVStudent*)object).firstName,((AVStudent*)object).lastName);
    NSLog(@"keyPath=%@ \n object = %@ \n change = %@ \n context = %@",keyPath,object,change,context);
    NSLog(@"change.NSKeyValueChangeOldKey=%@",[change objectForKey:NSKeyValueChangeOldKey]);
    NSLog(@"change.NSKeyValueChangeNewKey=%@",[change objectForKey:NSKeyValueChangeNewKey]);
    NSLog(@"");
}

#pragma mark - DataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayStudents.count;
}

- (AVCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVStudent*student = [self studentAtIndexPath:indexPath];
    AVCell*cell = [tableView dequeueReusableCellWithIdentifier:@"identifierCell"];
    UIView*contentView = [cell.subviews objectAtIndex:0];
    [(UILabel*)[contentView.subviews objectAtIndex:0] setText:[NSString stringWithFormat:@"%@ %@",student.firstName,student.lastName]];
    cell.student = student;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - Action


- (IBAction)actionSearch:(UIButton *)sender {

    AVCell*cell = [self makeCellForView:sender];
    AVStudent*student = cell.student;
    NSLog(@"------Generale student: %@ %@",student.firstName,student.lastName);
    NSMutableString*pathCheck = [[NSMutableString alloc]initWithString:@"check"];
    NSMutableString*pathStudent = [[NSMutableString alloc]init];
    NSInteger countStudents = self.arrayStudents.count;
    for(int i=0;i<countStudents;i++){
        if(![pathStudent isEqual:@""]){
            AVStudent* studentCheck =(AVStudent*)[student valueForKeyPath:pathStudent];
            NSLog(@"------ check student: %@ %@",studentCheck.firstName,studentCheck.lastName);
        }
        NSNumber*value = [student valueForKeyPath:pathCheck];
        BOOL check = value.boolValue;
        NSLog(@"old check = %@",(check)?@"YES":@"NO");
        check = (check)?NO:YES;
        NSLog(@"new check = %@",(check)?@"YES":@"NO");

        NSError*error;

        NSNumber*checkNum = [NSNumber numberWithBool:check];
        [student validateValue:&checkNum forKey:pathCheck error:&error];
        [error debugDescription];
        
        [student validateValue:&checkNum forKeyPath:pathStudent error:&error];
        [error debugDescription];
        
        [student setValue:[NSNumber numberWithBool:check] forKeyPath:pathCheck];
        
        [student setValue:[NSNumber numberWithBool:check] forKey:@"error"]; //undefined

        [student valueForKeyPath:@"error"]; //undefined

        [pathCheck insertString:@"frend." atIndex:0];
        if(i==0)
            [pathStudent insertString:@"frend" atIndex:0];
        else
            [pathStudent insertString:@"frend." atIndex:0];
    }


#pragma mark - ADDOptions
        //11. Используя операторы KVC создайте массив имен всех студентов
        //12. Определите саммый поздний и саммый ранний годы рождения
        //13. Определите сумму всех баллов студентов и средний бал всех студентов


    NSNumber *c = [self.arrayStudents valueForKeyPath:@"@count"];
    NSLog(@"c = %i ",c.intValue);
    NSArray *arrayFirstName = [self.arrayStudents valueForKeyPath:@"@distinctUnionOfObjects.firstName"];
    NSArray *arrayLastName = [self.arrayStudents valueForKeyPath:@"@unionOfObjects.lastName"];
    NSLog(@"arrayFirstName=%@",[arrayFirstName description]);
    NSLog(@"arrayLastName=%@",[arrayLastName description]);

    NSDate *earlierDate = [self.arrayStudents valueForKeyPath:@"@min.dateBirth"];
    NSLog(@"earlier dataBirth = %@",[self.formatter stringFromDate:earlierDate]);

    NSDate *lastDate = [self.arrayStudents valueForKeyPath:@"@max.dateBirth"];
    NSLog(@"last dataBirth = %@",[self.formatter stringFromDate:lastDate]);

    NSNumber *sum = [self.arrayStudents valueForKeyPath:@"@sum.grade"];
    NSLog(@"sum = %f",[sum floatValue]);

    NSNumber*avg = [self.arrayStudents valueForKeyPath:@"@avg.grade"];
    NSLog(@"avg = %f",[avg floatValue]);
}



- (IBAction)actionClean:(UIButton *)sender {
    AVCell*cell = [self makeCellForView:sender];
    AVStudent*student = cell.student;
    [student setValue:@" " forKey:@"firstName"];
    [student setValue:@" " forKey:@"lastName"];
    [student setValue:@" " forKey:@"dateBirth"];
    [student setValue:[NSNumber numberWithInt:2] forKey:@"gender"];
    [student setValue:[NSNumber numberWithFloat:0] forKey:@"grade"];
    [self.table reloadData];
}

- (IBAction)actionCleanIVar:(UIButton *)sender {
    AVCell*cell = [self makeCellForView:sender];
    AVStudent*student = cell.student;
    student.firstName=@"";
    student.lastName=@" ";
    student.dateBirth=NULL;
    student.gender= GenderNil;
    student.grade=0;
    [self.table reloadData];
}

- (IBAction)actionIVar:(UIButton *)sender {

    AVCell*cell = [self makeCellForView:sender];
    AVStudent*student = cell.student;
    [student willChangeValueForKey:@"firstName"];
    [student cleanIVar];
    [student didChangeValueForKey:@"firstName"];
    [self.table reloadData];

}


- (IBAction)actionInfo:(UIButton *)sender {

    AVCell*cell = [self makeCellForView:sender];
    AVStudent*student = cell.student;
/*
    [student addObserver:self forKeyPath:@"firstName" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
    [student addObserver:self forKeyPath:@"lastName" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
    [student addObserver:self forKeyPath:@"dataBirth" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
    [student addObserver:self forKeyPath:@"gender" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
    [student addObserver:self forKeyPath:@"grade" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
*/
    self.curentStudent = student;
    UITableView*table = self.tvc.tableView;
    for(NSInteger i=0;i<5;i++){
        UITableViewCell*cellInfo = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIView*contentView = cellInfo.contentView;
        UITextField*textField = [contentView.subviews objectAtIndex:0];
        //[textField addObserver:self forKeyPath:@"text" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(void*)student];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        switch (i) {
            case 0:
                self.textFieldFirstName = textField;
                self.textFieldFirstName.delegate = self;
                textField.text = student.firstName;
                break;
            case 1:
                textField.text = student.lastName;
                self.textFieldLastName = textField;
                self.textFieldLastName.delegate = self;
                break;
            case 2:
                textField.text = [student.formatter stringFromDate:student.dateBirth];
                self.textFieldDateBirth = textField;
                self.textFieldDateBirth.delegate =self;
                break;
            case 3:
                textField.text = (student.gender == GenderMan) ? @"man" : @"women";
                if(student.gender==GenderNil)
                    textField.text = @"nil";
                self.textFieldGender = textField;
                self.textFieldGender.delegate =self;
                break;
            case 4:
                textField.text = [NSString stringWithFormat:@"%.2f", student.grade];
                self.textFieldGrade = textField;
                self.textFieldGrade.delegate = self;
                break;

            default:
                break;
        }
    }
    [self showViewController:self.tvc sender:nil];
}

#pragma mark - TextFieldDelegat

- (void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            self.curentStudent.firstName = textField.text;
            break;
        case 2:
            self.curentStudent.lastName = textField.text;
            break;
        case 3:
            if(![self.formatter dateFromString:textField.text])
                textField.text=@"repeat input at format dd/MMM/yyyy";
            else
                self.curentStudent.dateBirth = [self.formatter dateFromString:textField.text];
            break;
        case 4:
            if(!([textField.text isEqualToString:@"man"]||[textField.text isEqualToString:@"women"]))
                textField.text = @"input man or woman";
            else
                self.curentStudent.gender = ([textField.text isEqualToString:@"man"])?GenderMan:GenderWomen;
            break;
        case 5:
            if(!(textField.text.floatValue && textField.text.floatValue>0 && textField.text.floatValue<=5)){
                textField.text = @"input number at 0 to 5";
            }
            else
                self.curentStudent.grade = textField.text.floatValue;
            break;
        default:
            break;
    }
}

-(NSString*)stringOldName: (NSString*)textFieldString stringNewName: (NSString*)string rangeInput: (NSRange)range{

    NSMutableString*stringTemp=[[NSMutableString alloc]initWithString:textFieldString];

    NSMutableCharacterSet *setControl = [NSMutableCharacterSet letterCharacterSet];
    [setControl invert];

    NSArray*arrayCheckAtNumber=[string componentsSeparatedByCharactersInSet:setControl];

    if(arrayCheckAtNumber.count==1){
        [stringTemp replaceCharactersInRange:range withString:string];
        return stringTemp;
    }else{
        return textFieldString;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    switch (textField.tag) {
        case 1:
            if(textField.text.length+string.length<20 && ![string isEqualToString:@""]){
                textField.text = [self stringOldName:textField.text stringNewName:string rangeInput:range];
                return NO;
            }else if([string isEqualToString:@""]){
                return YES;
            }
            break;
        case 2:
            if(textField.text.length+string.length<20 && ![string isEqualToString:@""]){
                textField.text = [self stringOldName:textField.text stringNewName:string rangeInput:range];
                return NO;
            }else if([string isEqualToString:@""]){
                return YES;
            }
            break;
        case 3:
            return YES;
            break;
        case 4:
            return YES;
            break;
        case 5:
            return YES;
            break;
        default:
            return NO;
            break;
    }
    return NO;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            [self.textFieldLastName becomeFirstResponder];
            break;
        case 2:
            [self.textFieldDateBirth becomeFirstResponder];
            break;
        case 3:
            [self.textFieldGender becomeFirstResponder];
            break;
        case 4:
            [self.textFieldGrade becomeFirstResponder];
            break;
        case 5:
            [self.textFieldGrade resignFirstResponder];
            break;
        default:
            break;
    }
    return NO;
}

@end
