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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

+ (CHCSVWriter *)sharedWriter{
    @synchronized (self) {
        if (sharedWriter == nil) {
            sharedWriter = [[CHCSVWriter alloc] initWithCSVFile:[[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:@"所有记录.csv"] atomic:NO];
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
            NSDictionary *recordDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [medSet stringForColumn:@"Name"],@"Name",
                                       [medSet stringForColumn:@"PYM"],@"PYM",nil];
            [array addObject:recordDic];
        }
        [dataBase close];
    }
    
    
    return array;
}

- (void)writeDetailByID:(NSString *)_ID {
    CHCSVWriter *csvWriter = [ExportTable sharedWriter];
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSArray *medArray = [[self countAllMed] copy];
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
    HUD.labelText = @"正在努力导出呢。。";
	
	// myProgressTask uses the HUD instance to update progress
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}
- (IBAction)ExportTable:(id)sender {
    [self showHUD];
    CHCSVWriter *csvWriter = [ExportTable sharedWriter];
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    [csvWriter writeField:@"病区"];
    [csvWriter writeField:@"姓名"];
    NSArray *medArray = [self countAllMed];
    for (int i=0; i<[medArray count]; i++) {
        NSDictionary *medDic = [medArray objectAtIndex:i];
        [csvWriter writeField:[medDic objectForKey:@"Name"]];
    }
    [csvWriter writeLine];
    if ([dataBase open]) {
        FMResultSet *resultSet1 = [dataBase executeQuery:@"SELECT * FROM Record"];
        while ([resultSet1 next]) {
            NSString *ID = [resultSet1 stringForColumn:@"id"];//第一张表的id主键
            NSString *PatientName = [resultSet1 stringForColumn:@"PatientName"];//第一张表的PatientName
            NSString *Office = [resultSet1 stringForColumn:@"Office"];//第一张表的Office
            [csvWriter writeField:Office];
            [csvWriter writeField:PatientName];
            NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
            FMResultSet *resultSet2 = [dataBase executeQuery:@"SELECT * FROM Detail WHERE Number = ?",ID];
            while ([resultSet2 next]) {
                //NSString *Name = [resultSet2 stringForColumn:@"Name"];
                NSString *Count = [resultSet2 stringForColumn:@"Count"];
                NSString *PYM = [resultSet2 stringForColumn:@"PYM"];
                NSDictionary *medDic = [NSDictionary dictionaryWithObjectsAndKeys:Count,@"Count",PYM,@"PYM", nil];
                [mutableArray addObject:medDic];
            }
            __block BOOL flag = NO;
            __block int count = 0;
            [medArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                NSString *medPYM = [[medArray objectAtIndex:idx] objectForKey:@"PYM"];
                [mutableArray enumerateObjectsUsingBlock:^(id obj, NSUInteger _idx, BOOL *stop)
                {
                    NSString *_medPYM = [[mutableArray objectAtIndex:_idx]objectForKey:@"PYM"];
                    if ([medPYM isEqualToString:_medPYM])
                    {
                        flag = YES;
                        count ++;
                        [csvWriter writeField:[[mutableArray objectAtIndex:_idx]objectForKey:@"Count"]];
//                        
//                        if ([mutableArray count]==count) {
//                            debugLog(@"%d",count);
//                            *stop = YES;
//                             [csvWriter writeLine];
//                        }
                        *stop = YES;
                    }
                    else
                    {
                        flag = NO;
                    }
                }];
                if (flag==NO) {
                    [csvWriter writeField:nil];
                }
                
            }];
        [csvWriter writeLine];
        
        }
    }
    [dataBase close];
    [csvWriter closeFile];
}

- (BOOL)exportSearchResult:(NSArray *)array {
    BOOL isOK = NO;
    CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initWithCSVFile:[[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:@"搜索记录.csv"] atomic:NO];
    if (array) {
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = [array objectAtIndex:idx];
        NSString *PatientName = [dic objectForKey:@"PatientName"];
        NSString *Office = [dic objectForKey:@"Office"];
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
    }
    [csvWriter closeFile];
    [csvWriter release];
    return isOK;
}
- (void)dealloc {
    [_navBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNavBar:nil];
    [super viewDidUnload];
    debugMethod();
}
@end
