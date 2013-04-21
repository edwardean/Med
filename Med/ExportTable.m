//
//  ExportTable.m
//  Med
//
//  Created by Edward on 13-3-26.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "ExportTable.h"
#import "dataBaseManager.h"
#import "Medicine.h"
#import "Record.h"
#import "UIView+clearBackground.h"
static CHCSVWriter *sharedWriter = nil;
@interface ExportTable ()

@end

@implementation ExportTable
@synthesize navBar = _navBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_navBar setBackImage];
    [self.view clear];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(0, 0, 198, 60)];
    [btn setCenter:self.view.center];
    [btn setBackgroundImage:ImageNamed(@"btn_normal") forState:UIControlStateNormal];
    [btn setBackgroundImage:ImageNamed(@"btn_down") forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(Export) forControlEvents:UIControlEventTouchUpInside];
    _textView.font = MyFont(14.0f);
}
- (void)Export {
    [self performSelector:@selector(ExportTable) withObject:nil afterDelay:0.005f];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
+ (CHCSVWriter *)sharedWriter{
    @synchronized (self) {
        if (sharedWriter == nil) {
            sharedWriter = [[CHCSVWriter alloc] initWithCSVFile:[DOCUMENT stringByAppendingPathComponent:@"所有记录.csv"] atomic:NO];
        }
        return sharedWriter;
    }
}
- (NSMutableArray *)countAllMed{
    NSMutableArray *array = [NSMutableArray array];
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    if ([dataBase open]) {
        FMResultSet *medSet = [dataBase executeQuery:@"SELECT * FROM Medicine"];
        while ([medSet next]) {
//            NSDictionary *recordDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [medSet stringForColumn:@"Name"],@"Name",
//                                       [medSet stringForColumn:@"PYM"],@"PYM",nil];
            NSDictionary *dic = @{@"Name": [medSet stringForColumn:@"Name"],@"PYM": [medSet stringForColumn:@"PYM"]};
            [array addObject:dic];
        }
        [dataBase close];
    }
    
    
    return array;
}

- (void)writeDetailByID:(NSString *)_ID {
    CHCSVWriter *csvWriter = [ExportTable sharedWriter];
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSArray *medArray = [self countAllMed];
    if ([dataBase open]) {
        FMResultSet *resultSet2 = [dataBase executeQuery:@"SELECT * FROM Detail WHERE Number = ?",_ID];
        while ([resultSet2 next]) {
            //NSString *Name = [resultSet2 stringForColumn:@"Name"];
            NSString *Count = [resultSet2 stringForColumn:@"Count"];
            NSString *PYM = [resultSet2 stringForColumn:@"PYM"];
            debugLog(@"PYM:%@",PYM);
            for (NSDictionary *dic in medArray) {
                if ([PYM isEqualToString:[dic objectForKey:@"PYM"]]) {
                    [csvWriter writeField:Count];
                } else {
                    [csvWriter writeField:nil];
                }
            }
        }
        [csvWriter writeLine];
        [dataBase close];
}

}
- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(7000);
    }
}

- (void)showHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    
	HUD.delegate = self;
    HUD.labelText = @"正在努力导出呢...";
	
	// myProgressTask uses the HUD instance to update progress
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}
- (void)ExportTable{
    [self showHUD];
    CHCSVWriter *csvWriter = [ExportTable sharedWriter];
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    [csvWriter writeField:@"日期"];
    [csvWriter writeField:@"病区"];
    [csvWriter writeField:@"姓名"];
    NSArray *medArray = [self countAllMed];
    for (int i=0; i<[medArray count]; i++) {
        NSDictionary *medDic = [medArray objectAtIndex:i];
        [csvWriter writeField:[medDic objectForKey:@"Name"]];
    }
    [csvWriter writeLine];
    NSArray *resultArray = [Record findAllRecordsInRecordTableToArray];
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dictionary = [resultArray objectAtIndex:idx];
        NSString *PatientName = [dictionary objectForKey:@"PatientName"];
        NSString *Office = [dictionary objectForKey:@"Office"];
        NSString *Date = [dictionary objectForKey:@"Date"];
        [csvWriter writeField:Date];
        [csvWriter writeField:Office];
        [csvWriter writeField:PatientName];
        NSMutableArray *_mutableArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *detailArray = [dictionary objectForKey:@"Detail"];
        [detailArray enumerateObjectsUsingBlock:^(id _obj, NSUInteger _idx, BOOL *_stop) {
            NSDictionary *retailDic = [detailArray objectAtIndex:_idx];
            NSString *Name = [retailDic objectForKey:@"Name"];
            NSString *Count = [retailDic objectForKey:@"Count"];
            NSString *Pym = [retailDic objectForKey:@"PYM"];
            //NSDictionary *medDic = [NSDictionary dictionaryWithObjectsAndKeys:Name,@"Name",Count,@"Count",Pym,@"PYM", nil];
            NSDictionary *medDic = @{@"Name": Name,@"Count":Count,@"PYM":Pym};
            [_mutableArray addObject:medDic];
        }];
        __block BOOL flag = NO;
        __block int count = 0;
        [medArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *medPYM = [[medArray objectAtIndex:idx] objectForKey:@"PYM"];
            [_mutableArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *_medPYM = [[_mutableArray objectAtIndex:idx]objectForKey:@"PYM"];
                if ([medPYM isEqualToString:_medPYM]) {
                    flag = YES;
                    count ++;
                    [csvWriter writeField:[[_mutableArray objectAtIndex:idx]objectForKey:@"Count"]];
                    *stop = YES;
                } else {
                    flag = NO;
                }
            }];
            if (!flag) {
                [csvWriter writeField:nil];
            }
        }];
        [csvWriter writeLine];
    }];
    [dataBase close];
    [csvWriter closeFile];
    sharedWriter = nil;
    
    [Help doSomething:^{
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
        FMDatabase *dataBase = [dataBaseManager createDataBase];
        if ([dataBase open]) {
            FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Medicine"];
            while ([rs next]) {
                NSString *pym = [rs stringForColumn:@"PYM"];
                NSString *name = [rs stringForColumn:@"Name"];
                //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pym,@"PYM",name,@"Name", nil];
                NSDictionary *dic = @{@"PYM":pym,@"Name":name};
                [mutableArray addObject:dic];
                
            }
            [dataBase close];
        }
        [mutableArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = [mutableArray objectAtIndex:idx];
            NSString *PYM = [dic objectForKey:@"PYM"];
            NSString *Name = [dic objectForKey:@"Name"];
            NSArray *array = [Record searchAllRecordsByPYM:PYM];
            [self exportSearchResult:array andFileName:Name andseg:0 inMainDir:0];
        }];
    } afterDelay:0.5f];
}
- (BOOL)exportSearchResult:(NSArray *)array andFileName:(NSString *)fileName andseg:(NSInteger)segIndex inMainDir:(NSInteger)mainDir{
    BOOL isOK = NO;
    NSString *file = [fileName stringByAppendingString:@".csv"];
    CHCSVWriter *csvWriter = nil;
    if (array) {
        if (segIndex==1) {
        csvWriter = [[CHCSVWriter alloc] initWithCSVFile:[[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:file] atomic:NO];
       [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = [array objectAtIndex:idx];
        NSString *Date = [dic objectForKey:@"Date"];
        NSString *PatientName = [dic objectForKey:@"PatientName"];
        NSString *Office = [dic objectForKey:@"Office"];
        [csvWriter writeField:Date];
        [csvWriter writeField:PatientName];
        [csvWriter writeField:Office];
        NSArray *detailArray = [dic objectForKey:@"Detail"];
        [detailArray enumerateObjectsUsingBlock:^(id obj, NSUInteger _idx, BOOL *stop) {
            NSDictionary *detailDic = [detailArray objectAtIndex:_idx];
            NSString *Name = [detailDic objectForKey:@"Name"];
            NSString *Count = [detailDic objectForKey:@"Count"];
            NSString *NameandCount = [Name stringByAppendingString:Count];
            [csvWriter writeField:NameandCount];
        }];
        [csvWriter writeLine];
    }];
        isOK = YES;
        } else if (segIndex==0) {
            NSError *error = nil;
            NSFileManager *manager = [NSFileManager defaultManager];
            NSString *home = DOCUMENT;
            NSString *name = DirectoryName;
            NSString *path;// = [home stringByAppendingPathComponent:name];
            if (mainDir == 2) {
                path = DOCUMENT;
            } else {
                path = [home stringByAppendingPathComponent:name];
            }
            
            if ([manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
                csvWriter = [[CHCSVWriter alloc] initWithCSVFile:[path stringByAppendingPathComponent:file] atomic:NO];
            } else {
                debugLog(@"Error:%@",error);
            }
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *dic = [array objectAtIndex:idx];
                [csvWriter writeField:[dic objectForKey:@"Date"]];
                [csvWriter writeField:[dic objectForKey:@"Office"]];
                [csvWriter writeField:[dic objectForKey:@"PatientName"]];
                [csvWriter writeField:[dic objectForKey:@"Name"]];
                [csvWriter writeField:[dic objectForKey:@"Count"]];
                [csvWriter writeLine];
            }];
            isOK = YES;
        }
    }
    [csvWriter closeFile];
    return isOK;
}
- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
    [self setNavBar:nil];
}
@end
