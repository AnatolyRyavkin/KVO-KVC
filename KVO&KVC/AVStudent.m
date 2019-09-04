//
//  AVStudent.m
//  KVO&KVC
//
//  Created by Anatoly Ryavkin on 27/06/2019.
//  Copyright © 2019 AnatolyRyavkin. All rights reserved.
//

#import "AVStudent.h"

@implementation AVStudent

#pragma mark - Observer

- (BOOL)validateValue:(inout id _Nullable * _Nonnull)ioValue forKey:(NSString *)inKey error:(out NSError **)outError{
    NSLog(@"validate at key");
    return YES;
}

- (BOOL)validateValue:(inout id _Nullable * _Nonnull)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError **)outError{
    NSLog(@"validate keyPath");
    return YES;
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key{
    NSLog(@"dont validate");
}

- (nullable id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"dont validate");
    return  nil;
}

/*
@synthesize firstName=_firstName,lastName=_lastName,dateBirth=_dateBirth,gender=_gender,grade=_grade;

-(NSString*)firstName{
    NSLog(@"firstName=%@",_firstName);
    return _firstName;
}
-(NSString*)lastName{
    NSLog(@"lastName=%@",_lastName);
    return _lastName;
}
-(NSDate*)dateBirth{
    NSLog(@"dateBirth=%@",[self.formatter stringFromDate:_dateBirth]);
    return _dateBirth;
}
-(Gender)gender{
    NSLog(@"gender=%@",((_gender==GenderMan)?@"man":@"women"));
    return _gender;
}
-(CGFloat)grade{
    NSLog(@"grade=%.2f",_grade);
    return _grade;
}

-(void)setFirstName:(NSString*)string{
    NSLog(@"firstNameOld=%@",_firstName);
    NSLog(@"firstNameNew=%@",string);
    _firstName=string;
}
-(void)setLastName:(NSString*)string{
    NSLog(@"lastNameOld=%@",_lastName);
    NSLog(@"lastNameNew=%@",string);
    _lastName=string;
}
-(void)setDateBirth:(NSDate*)date{
    NSLog(@"dateBirthOld=%@",[self.formatter stringFromDate:_dateBirth]);
    NSLog(@"dateBirthNew=%@",[self.formatter stringFromDate:date]);
    _dateBirth=date;
}
-(void)setGender:(Gender)gender{
    NSLog(@"genderOld=%@",((_gender==GenderMan)?@"man":@"women"));
    NSLog(@"genderNew=%@",((gender==GenderMan)?@"man":@"women"));
    _gender=gender;
}
-(void)setGrade:(CGFloat)grade{
    NSLog(@"gradeOld=%.2f",_grade);
    NSLog(@"gradeOld=%.2f",grade);
    _grade=grade;
}
*/
-(void)cleanIVar{
    _firstName=@"AAAAAAAAA";
    _lastName=@"BBBBBBBBBBB ";
    _dateBirth=NULL;
    _gender= GenderNil;
    _grade=0;
}

-(NSString*)dataBirthChangeFromDateInString:(NSDate*)date{
    return [self.formatter stringFromDate:date];
}

-(NSDate*)randomDateBirth{

    NSDate*dateBirthBegin =[self.formatter dateFromString:@"01.Jan.1970"];
    NSDate*dateBirthEnd =[self.formatter dateFromString:@"01.Jan.2003"];
    NSTimeInterval intervalDateBirth = [dateBirthEnd timeIntervalSinceDate:dateBirthBegin];
    NSTimeInterval randomCountSecAtDatsBirthBegin = (NSTimeInterval)((arc4random()*10000) % (NSUInteger)intervalDateBirth);
    NSDate*dateBirth = [[NSDate alloc]initWithTimeInterval:randomCountSecAtDatsBirthBegin sinceDate:dateBirthBegin];
    return dateBirth;
}

-(Gender)randomGender{
    return (arc4random()%2) ? GenderMan : GenderWomen;
}

-(CGFloat)randomGrade{
    return ((CGFloat)(arc4random()%500))/100;
}

-(id)init{
    self = [super init];
    if(self){
        self.formatter = [[NSDateFormatter alloc]init];
        self.formatter.dateFormat = @"dd/MMM/yyyy";
        self.gender = [self randomGender];
        self.dateBirth = [self randomDateBirth];

        NSArray*arrayGlasChar = [[NSArray alloc]initWithObjects:@"y",@"u",@"a",@"o",@"i",@"a",@"u",@"o",@"i",@"j",nil];

        NSArray*arraySoglasChar = [[NSArray alloc]initWithObjects:     @"q",@"w",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"w",
                                   @"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"x",@"c",@"v",@"b",@"n",@"m",@"q",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",
                                   @"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",@"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"r",@"t",
                                   @"p",@"s",@"d",@"f",@"g",@"h",@"k",@"l",@"c",@"v",@"b",@"n",@"m",nil];

        NSMutableString*firstName = [[NSMutableString alloc]init];
        int lit = arc4random();
        for(int i=0;i<(arc4random()%6+4);i++){
            NSString*strChar = (lit%2==0) ? [arrayGlasChar objectAtIndex:arc4random()% (arrayGlasChar.count-1)] :
            [arraySoglasChar objectAtIndex:(arc4random()% (arraySoglasChar.count-1))];
            lit++;
            if(i==0)
                [firstName appendString:[strChar uppercaseString]];
            else
                [firstName appendString:strChar];
        }
        if (self.gender == GenderWomen)
            [firstName appendString:@"a"];

        NSMutableString*lastName = [[NSMutableString alloc]init];
        for(int i=0;i<(arc4random()%6+4);i++){
            NSString*strChar = (arc4random()%2==0) ? [arrayGlasChar objectAtIndex:(arc4random()%(arrayGlasChar.count-1))] :  [arraySoglasChar objectAtIndex:(arc4random()%(arraySoglasChar.count-1))];
            if(i==0)
                [lastName appendString:[strChar uppercaseString]];
            else
                [lastName appendString:strChar];
        }

        if(self.gender == GenderMan){
            [lastName appendString: (arc4random()%2==0) ? @"in" : @"of"];
        }else{
            [lastName appendString: (arc4random()%2==0) ? @"ina" : @"ofa"];
        }
        self.lastName = lastName;
        self.firstName = firstName;
        self.grade = [self randomGrade];
        
    }
    return self;
}

@end
