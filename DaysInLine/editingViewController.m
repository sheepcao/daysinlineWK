//
//  editingViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-10-22.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "editingViewController.h"
#import "remindViewController.h"
#import "globalVars.h"


@interface editingViewController (){
    NSMutableArray *selected;
    NSMutableArray *tagLabels;
    NSMutableArray *tagImages;

    NSMutableArray *textInlabel;
    NSMutableArray *beSelected;//判断打开标签后，某cell是否已选

    NSMutableArray *loadCellOnce;//判断某cell是否已load
    NSUInteger sourceType ;

}
@end

@implementation editingViewController
@synthesize timeSelectView;


bool didRecord; //for control record and play
bool flag;
NSString *oldRemindDate;
bool firstInmoney;
bool haveSaved;
bool firstInTag;//判断打开标签后，某cell是否已选
SystemSoundID soundObject;

int recorderID;

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
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *docsPath = [storeURL path];
    
    self.databasePath = [[NSString alloc] initWithString:[docsPath stringByAppendingPathComponent:@"infoNew.sqlite"]];
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        //NSLog(@"aloha!");
    }
    [super viewDidLoad];
    
    
    timeSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2+40)];
    timeSelectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timeSelectView];
    timeSelectView.alpha = 0.9;
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {

        [self.editBackground setImage:[UIImage imageNamed:@"editView586.png"]];
        
        
    }else{

        [self.editBackground setImage:[UIImage imageNamed:@"editView.png"]];
        
    }

    
    //self.incomeFinal=0.0f;
    haveSaved = NO;
    firstInmoney = NO;
    recorderID = 0;
    

    //self.remindData = nil;
    //NSLog(@"<<<<<%@>>>>>",self.remindData);
    tagLabels = [[NSMutableArray alloc] init];
    tagImages = [[NSMutableArray alloc] init];
    textInlabel = [[NSMutableArray alloc] init];
    beSelected = [[NSMutableArray alloc] init];
    loadCellOnce = [[NSMutableArray alloc] init];


    
    self.selectedTags = [[NSMutableString alloc] init];


    
    self.startTimeButton =(UIButton *)[self.view viewWithTag:101];
    self.endTimeButton =(UIButton *)[self.view viewWithTag:102];
    self.startTimeButton.layer.borderWidth = 1.0;
    self.startTimeButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.endTimeButton.layer.borderWidth = 1.0;
    self.endTimeButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    //self.startTimeButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.startTimeButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.endTimeButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.startLabel = (UILabel *)[self.view viewWithTag:103];
  
    //self.startLabel.layer.borderWidth = 1;
    
    self.endLabel = (UILabel *)[self.view viewWithTag:104];
    self.theme = (UITextField *)[self.view viewWithTag:105];
    
    self.toLabel =(UILabel *)[self.view viewWithTag:121];
    self.titleLabel =(UILabel *)[self.view viewWithTag:120];

    [self.toLabel setText:NSLocalizedString(@"到",nil)];
    [self.titleLabel setText:NSLocalizedString(@"主题",nil)];
    //self.toLabel.font = [UIFont systemFontOfSize:16.0];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    int mainText_Height = mainHeight;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        //NSLog(@"ios7!!!!");
        mainText_Height += 20;
    }
    
    /* fit for 4-inch screen */
   // CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        mainText_Height += 80;
    }

    
    self.mainText = [[UITextView alloc] initWithFrame:CGRectMake(40, 155, 220, mainText_Height)];
    self.mainTextExtend = [[UILabel alloc] initWithFrame:CGRectMake(260, 155, 23, mainText_Height)];
    self.mainTextExtend.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTextExtend];
    [self.view addSubview:self.mainText];
    
    //录音按钮
    self.recorderBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.mainText.center.x-55, self.mainText.frame.origin.y + self.mainText.frame.size.height-25, 50, 50)];
    [self.recorderBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    
    self.playerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.mainText.center.x+30, self.mainText.frame.origin.y + self.mainText.frame.size.height-25, 50, 50)];
    [self.playerBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];

    [self.recorderBtn addTarget:self action:@selector(recordSound) forControlEvents:UIControlEventTouchUpInside];
    [self.playerBtn addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];

    

    [self.view addSubview:self.playerBtn];
    [self.view addSubview:self.recorderBtn];
    
    [self.recorderBtn setHidden:YES];
    [self.playerBtn setHidden:YES];
    
    
    //eric:for setup recorder with event id.
    didRecord = NO;
    if (modifying == 0) {
        self.remindData = @"";
        recorderID = [self searchEventID];
    }else
    {
        recorderID = modifyEventId;
    }
    [self setupRecorder:recorderID];


    self.mainText.tag = 106;
    [self.setTextDelegate setMainText:self.mainText];
    self.mainText.delegate = self;
    self.mainText.font = [UIFont systemFontOfSize:16.0];
    
    if ([self.mainText.text isEqualToString:NSLocalizedString(@"点击输入......",nil)]) {
        self.mainText.textColor = [UIColor lightGrayColor];
    }else
    {
        self.mainText.textColor = [UIColor blackColor];
   
    }

    self.imageViewButton = [[NSMutableArray alloc] initWithCapacity:NR_IMAGEVIEW];
    for (int j = 0; j<NR_IMAGEVIEW; j++) {
        int x = 15+60*j;
        int y = 350;
        int width = 50;
        int height = 50;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            //NSLog(@"ios7!!!!");
            y += 20;
        }
        
        /* fit for 4-inch screen */
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) {
            y += 80;
        }
        
        self.imageViewButton[j] = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
       
        [(UIButton *)[self.imageViewButton objectAtIndex:j] setTag:IMAGEVIEW_TAG_BASE+j];
        [self.view addSubview:self.imageViewButton[j]];
  
        //NSLog(@"frame: x:%f , y:%f , width: %f , hei: %f",[[self.imageViewButton objectAtIndex:j] frame].origin.x,[[self.imageViewButton objectAtIndex:j] frame].origin.y,[[self.imageViewButton objectAtIndex:j] frame].size.width,[[self.imageViewButton objectAtIndex:j] frame].size.height);
    }
    
    
    self.moneyButton = (UIButton *)[self.view viewWithTag:1004];
    self.remindButton =(UIButton *)[self.view viewWithTag:1002];
   
	// Do any additional setup after loading the view.
    [self.startTimeButton addTarget:self action:@selector(startTimeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.endTimeButton addTarget:self action:@selector(endTimeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setImage:[UIImage imageNamed:@"saveBtn2.png"] forState:UIControlStateHighlighted];
    [self.returnButton addTarget:self action:@selector(returnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.moneyButton addTarget:self action:@selector(moneyTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.remindButton addTarget:self action:@selector(remindTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.addTagButton addTarget:self action:@selector(addTagTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.addCollectionButton addTarget:self action:@selector(addCollectTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.photoButton addTarget:self action:@selector(photoTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.startTimeButton.layer.borderWidth = 3.0;
    self.startTimeButton.layer.borderColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:235/255.0f alpha:1.0f].CGColor;
    self.endTimeButton.layer.borderWidth = 3.0;
    self.endTimeButton.layer.borderColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:235/255.0f alpha:1.0f].CGColor;

    
    //NSLog(@"type is:%@ ~~~~~",self.eventType);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    //为虚拟键盘添加收回按钮

    
    int y = self.view.frame.size.height ;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        //NSLog(@"ios7!!!!");
        y += 20;
    }
    
    /* fit for 4-inch screen */
   // CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        y += 80;
    }
    
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitButton setImage:[UIImage imageNamed:@"键盘返回键.png"] forState:UIControlStateNormal];
    self.exitButton.backgroundColor = [UIColor clearColor];
    CGRect exitBtFrame = CGRectMake(self.view.frame.size.width-48, y, 48.0f, 30.0f);
    
    [self.exitButton setFrame:exitBtFrame];
    
    
    [self.view addSubview:self.exitButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
      
    
    CFBundleRef mainbundle=CFBundleGetMainBundle();

    //获得声音文件URL
    CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("editSound"),CFSTR("wav"),NULL);
    //创建system sound 对象
    AudioServicesCreateSystemSoundID(soundfileurl, &soundObject);
 

        //[self.adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    

}

-(void) viewDidAppear:(BOOL)animated
{
    static int times = 0;
    times++;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    //  NSString* cName = [NSString stringWithFormat:@"%@",  self.navigationItem.title, nil];
    //  NSLog(@"current appear tab title %@", cName);
    //[[Frontia getStatistics] pageviewStartWithName:@"editView"];
}

-(void)keyboardWillShow
{
   if (self.timeSelectView.frame.origin.y < [UIScreen mainScreen].bounds.size.height)
   {
       [self cancelTime];
   }
}

-(void) viewDidDisappear:(BOOL)animated
{
    // NSString* cName = [NSString stringWithFormat:@"%@", self.navigationItem.title, nil];
    // NSLog(@"current disappear tab title %@", cName);
    //[[Frontia getStatistics] pageviewEndWithName:@"editView"];
}

#pragma mark select eventID for rerocd
-(int)searchEventID
{
    int maxID = 0;
    
    sqlite3_stmt *statement;
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEvent = [NSString stringWithFormat:@"SELECT max(eventID) from EVENT"];
        
        const char *queryEventstatment = [queryEvent UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                //找到要修改的事件，取出数据。
           
                maxID = sqlite3_column_int(statement, 0);
                
            }
            
        }else
            NSLog(@"Error while max:%s",sqlite3_errmsg(dataBase));
            
        sqlite3_finalize(statement);
    }
    else {
        //NSLog(@"数据库打开失败");
        
    }
    sqlite3_close(dataBase);
    
    return maxID+1;
}


-(void)addTagTapped
{
    [MobClick event:@"addTag"];
    
    if (soundSwitch) {
           AudioServicesPlaySystemSound(soundObject);
    }
    
    //[[Frontia getStatistics] logEvent:@"10007" eventLabel:@"tagTap"];

    
    
    
    selected = [[NSMutableArray alloc] init];
    firstInTag = YES;
    
    
    NSNumber *haveload = [[NSNumber alloc] initWithBool:NO];
    for (int i = 0; i<self.tags.count; i++) {
        
        [loadCellOnce insertObject:haveload atIndex:i];
        
    }

   
    [self dismissKeyboard];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"tagView" owner:self options:nil];
    
    UIView *tmpCustomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 300, 211)];
    
    tmpCustomView = [nib objectAtIndex:0];
    
    UIImageView *imageInTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 211)];
    
    [tmpCustomView addSubview:imageInTag];
    [tmpCustomView sendSubviewToBack:imageInTag];
    
    
    imageInTag.image = [UIImage imageNamed:@"tagAlert.png"];
    

    
    

   // tabletest.layer.borderColor = [UIColor clearColor].CGColor;
 //   //NSLog(@"row:%f",tabletest.rowHeight);
   // //NSLog(@"tag 3 is: %@",self.tags[3]);
    
   // UITableView *tagTable = (UITableView *)[tmpCustomView viewWithTag:601];
    
    UITableView *tagTable = [[UITableView alloc] initWithFrame:CGRectMake(16, 0, 264, 142)];
    tagTable.backgroundColor = [UIColor clearColor];
    tagTable.rowHeight = 36;
    [tmpCustomView addSubview:tagTable];

    self.tagTable = tagTable;
    
    
    UIButton *okButton =(UIButton *)[tmpCustomView viewWithTag:602];
    [okButton addTarget:self action:@selector(okTagTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelButton =(UIButton *)[tmpCustomView viewWithTag:603];
    [cancelButton addTarget:self action:@selector(cancelTagTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *addButton =(UIButton *)[tmpCustomView viewWithTag:604];
    [addButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *deleteButton =(UIButton *)[tmpCustomView viewWithTag:605];
    [deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *finishButton =(UIButton *)[tmpCustomView viewWithTag:606];
    [finishButton addTarget:self action:@selector(finishButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.okInTag = okButton;
    self.cancelInTag = cancelButton;
    self.deleteTagButton = deleteButton;
    self.addNewTagButton = addButton;
    self.finishDeleteButton = finishButton;
    [self.finishDeleteButton setHidden:YES];
    
    self.tagTable.delegate = self;
    self.tagTable.dataSource = self;
    self.tagTable.allowsMultipleSelection = YES;
    
  //  [selected removeAllObjects];
    
    
    
    for (int i = 0; i<self.tags.count; i++) {
        

        
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        [self tableView: self.tagTable cellForRowAtIndexPath: index];
        



    }

    
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    alert.tag = 1;
    
    [alert setContainerView:tmpCustomView];
   
    self.tagAlert = alert;
     
    
    [alert show];

    
    

}
-(void)addButtonTapped
{
     //[[Frontia getStatistics] logEvent:@"10024" eventLabel:@"addTag"];
    
   // [selected removeAllObjects];
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_add;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("addSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_add);
        AudioServicesPlaySystemSound(soundObject_add);
    }

    
    
    UIAlertView* addSelection;
    
    addSelection = [[UIAlertView alloc]
                    initWithTitle:NSLocalizedString(@"请输入标签",nil)
                    message:nil
                    delegate:self
                    cancelButtonTitle:NSLocalizedString(@"取消",nil)
                    otherButtonTitles:NSLocalizedString(@"确定",nil),nil];
    
    [addSelection setAlertViewStyle:UIAlertViewStylePlainTextInput];
    addSelection.tag = 3;
    
    [addSelection show];
    
}
-(void)deleteButtonTapped
{
    [MobClick event:@"delete"];

    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_delete;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("cancelSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_delete);
        AudioServicesPlaySystemSound(soundObject_delete);
    }

    
    
    
    [self.tagTable setEditing:YES animated:YES];
    [self.addNewTagButton setHidden:YES];
    [self.deleteTagButton setHidden:YES];
    [self.okInTag setHidden:YES];
    [self.cancelInTag setHidden:YES];
    [self.finishDeleteButton setHidden:NO];
    
}

-(void)okTagTapped
{
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_ok;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("okSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_ok);
        AudioServicesPlaySystemSound(soundObject_ok);
    }
    
    [beSelected removeAllObjects];
    
    NSMutableString *choices = [[NSMutableString alloc] init];
    //NSLog(@"count is %lu",(unsigned long)tagLabels.count);
    for (int i = 0 ; i< tagLabels.count ; i++) {
        UILabel * oldTag = [tagLabels objectAtIndex:i];
        UIImageView *oldImage = [tagImages objectAtIndex:i];
    
        [oldImage removeFromSuperview];
        [oldTag removeFromSuperview];
      
    }
    [textInlabel removeAllObjects];
    [tagLabels removeAllObjects];
    [tagImages removeAllObjects];
    if (selected.count > 0) {
        for (int i = 0; i < selected.count; i++) {
            [choices appendFormat:@"%@,",selected[i]];
            UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(260, 5+160+30*i, 60, 20)];
            tag.backgroundColor = [UIColor clearColor];
            tag.textColor = [UIColor whiteColor];

            tag.text = selected[i];
            tag.font = [UIFont systemFontOfSize:11.0];
            
            UIImageView *tagImage = [[UIImageView alloc] initWithFrame:CGRectMake(255, 160+30*i,70, 30)];
            tagImage.image = [UIImage imageNamed:@"标签.png"];
            
            [self.view bringSubviewToFront:tag];
            
            [tagLabels addObject:tag];
            [tagImages addObject:tagImage];
            [textInlabel addObject:tag.text];
            [self.view addSubview:tagImage];
            [self.view addSubview:tag];
            
        }
        
        self.selectedTags = [choices substringToIndex:(choices.length-1)];
        //NSLog(@"OK   tapped---->:%@",self.selectedTags);

    }
    else
    {
        self.selectedTags = @"";
    }
  
    [self.tagAlert close];
}
-(void)cancelTagTapped
{
    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_cancel;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("cancelSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_cancel);
        AudioServicesPlaySystemSound(soundObject_cancel);
    }
    
    
   [self.tagAlert close];
}

-(void)finishButtonTapped
{
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_ok;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("okSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_ok);
        AudioServicesPlaySystemSound(soundObject_ok);
    }
    
    
    [self.tagTable setEditing:NO animated:YES];
    [self.addNewTagButton setHidden:NO];
    [self.deleteTagButton setHidden:NO];
    [self.okInTag setHidden:NO];
    [self.cancelInTag setHidden:NO];
    [self.finishDeleteButton setHidden:YES];
    
}

-(void)remindTapped
{
    
    [MobClick event:@"reminder"];

    
    if (soundSwitch) {
        AudioServicesPlaySystemSound(soundObject);
    }
    
    remindViewController *my_remind ;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        my_remind = [[remindViewController alloc] initWithNibName:@"remindViewController586" bundle:nil];
    }else{
       my_remind = [[remindViewController alloc] initWithNibName:@"remindViewController" bundle:nil];
        
    }
    my_remind.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    my_remind.setRemindDelegate = self;
    
    //[my_remind.remindMode setTitle:@"按日期提醒" forSegmentAtIndex:0];//设置指定索引的题目
    //[my_remind.remindMode setTitle:@"按间隔提醒" forSegmentAtIndex:1];//设置指定索引的题目
    //NSLog(@"<<<<<%@>>>>>2",self.remindData);
    oldRemindDate = self.remindData;
    if (![oldRemindDate isEqualToString:@""]) {
        
        NSArray *remindDate = [oldRemindDate componentsSeparatedByString:@","];
        my_remind.remindDate = remindDate[0];
        my_remind.remindTime = remindDate[1];
        
    }

    [self presentViewController:my_remind animated:YES completion:Nil ];
    
}
-(void) photoTapped
{
    [MobClick event:@"photo"];
    
    if (soundSwitch) {
        AudioServicesPlaySystemSound(soundObject);
    }
    
    UIActionSheet *sheet;
    
    if (((UIButton *)self.imageViewButton[4]).imageView.image ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"照片数量达到上限！",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                              otherButtonTitles:nil];
      
        
        [ alert  show];

    }
    else {
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择",nil)
                                                 delegate:self
                                        cancelButtonTitle:nil
                                   destructiveButtonTitle:NSLocalizedString(@"取消",nil)
                                        otherButtonTitles:NSLocalizedString(@"拍照",nil), NSLocalizedString(@"从相册选择",nil), nil];
        } else {
            sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"请选择",nil)
                                                delegate:self
                                       cancelButtonTitle:nil
                                  destructiveButtonTitle:NSLocalizedString(@"取消",nil)
                                       otherButtonTitles:NSLocalizedString(@"从相册选择",nil), nil];
        }
        sheet.tag = 255;
        [sheet showInView:self.view];
    }
}

#pragma mark - 保存图片至沙盒 和 系统相册
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                          stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    //保存到相册
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil,nil);

    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    NSString *name = [NSString stringWithFormat:@"%@.png", UUID];
    
    [self saveImage:image withName: name];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    int index = 0;
    if ([self.imageName isEqualToString:@""] || self.imageName == nil) {
        self.imageName = name;
    } else {
        self.imageName = [NSString stringWithFormat:@"%@;%@", self.imageName, name];
        index = (int)[[self.imageName componentsSeparatedByString:@";"] count] - 1;
    }
   // [[self.imageView objectAtIndex:index] setImage:savedImage];
    //button for every imageView
    
    //[[self.imageViewButton objectAtIndex:index] setFrame:[[self.imageView objectAtIndex:index] frame]];
   // [self.view addSubview:[self.imageViewButton objectAtIndex:index]];
   // [[self.imageViewButton objectAtIndex:index] setTag:index+IMAGEBUTTON_TAG_BASE];
  //  //NSLog(@"button tag is :%d",((UIButton *)self.imageViewButton[index]).tag );
    [[self.imageViewButton objectAtIndex:index] setImage:savedImage forState:UIControlStateNormal];
    [[self.imageViewButton objectAtIndex:index] addTarget:self action:@selector(pictureTapped:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)pictureTapped:(UIButton *)sender
{

    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_photo;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_photo);
        AudioServicesPlaySystemSound(soundObject_photo);
    }
    

    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"photoView" owner:self options:nil];
    
    UIView *tmpCustomView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100,self.view.frame.size.height/2-50,200, 100)];
    
    tmpCustomView = [nib objectAtIndex:0];
    
    UIImageView *checkPhotoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tmpCustomView.frame.size.width, tmpCustomView.frame.size.height)];
    
    checkPhotoImage.image = [UIImage imageNamed:@"photoAlert.png"];
    checkPhotoImage.layer.borderWidth = 3.0f;
    checkPhotoImage.layer.borderColor = [UIColor clearColor].CGColor;
    tmpCustomView.layer.borderWidth = 3.0f;
    tmpCustomView.layer.borderColor = [UIColor clearColor].CGColor;
    [tmpCustomView addSubview:checkPhotoImage];
    [tmpCustomView sendSubviewToBack:checkPhotoImage];
    // //NSLog(@"tag 3 is: %@",self.tags[3]);
    
    // UITableView *tagTable = (UITableView *)[tmpCustomView viewWithTag:601];
    UIButton *checkButton =(UIButton *)[tmpCustomView viewWithTag:1];
    checkButton.tag = sender.tag;
    [checkButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *removeButton =(UIButton *)[tmpCustomView viewWithTag:2];
    removeButton.tag = sender.tag;
    [removeButton addTarget:self action:@selector(removeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *returnInPhotoCheckButton =(UIButton *)[tmpCustomView viewWithTag:3];
    returnInPhotoCheckButton.tag = sender.tag;
    [returnInPhotoCheckButton addTarget:self action:@selector(returnInPhotoCheck:) forControlEvents:UIControlEventTouchUpInside];
  
    
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    alert.layer.borderWidth = 0.0f;
    alert.layer.borderColor = [UIColor clearColor].CGColor;
    alert.tag = 10;
    
    [alert setContainerView:tmpCustomView];
    
    self.checkAlert = alert;
    
    [alert show];

}

-(void)checkButtonTapped:(UIButton *)sender
{
     //[[Frontia getStatistics] logEvent:@"10011" eventLabel:@"viewPic"];
    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_InPhoto;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_InPhoto);
        AudioServicesPlaySystemSound(soundObject_InPhoto);
    }
    
    //NSLog(@"查看图片");
    [self.checkAlert close];
    
    checkPhotoController *my_bigPhoto = [[checkPhotoController alloc] initWithNibName:@"checkPhotoController" bundle:nil];
    my_bigPhoto.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UIButton *bigView = self.imageViewButton[sender.tag-IMAGEVIEW_TAG_BASE];
    
    my_bigPhoto.fullPhoto.image = bigView.imageView.image;
    
    
    
    [(UIImageView *)[my_bigPhoto.view viewWithTag:1] setImage:bigView.imageView.image ];
    

    
    [self presentViewController:my_bigPhoto animated:YES completion:Nil ];

    
    
}

-(void)removeButtonTapped:(UIButton *)sender
{
    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_photo;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("cancelSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_photo);
        AudioServicesPlaySystemSound(soundObject_photo);
    }
    
    //NSLog(@"移除图片");
    [self.checkAlert close];
   
    
   
    NSMutableArray *imageNames = [NSMutableArray arrayWithArray:[self.imageName componentsSeparatedByString:@";"]];
    
     self.imageName =@"";
    
   
    NSLog(@"imaggeNames:%@",imageNames);

    UIButton *toBeRemoved = self.imageViewButton[sender.tag-IMAGEVIEW_TAG_BASE];
    [self.imageViewButton removeObjectAtIndex:(sender.tag-IMAGEVIEW_TAG_BASE) ];
    [toBeRemoved removeFromSuperview];
    
    
    int y = 350;
    int width = 50;
    int height = 50;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        //NSLog(@"ios7!!!!");
        y += 20;
    }
    
    /* fit for 4-inch screen */
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        y += 80;
    }
    

    

    
    for (int j = ((int)sender.tag)-IMAGEVIEW_TAG_BASE; j<NR_IMAGEVIEW-1; j++) {
        int x = 15+60*j;
        
        UIButton *moveButton = self.imageViewButton[j];
        
        [moveButton setFrame:CGRectMake(x, y, width, height)];
        [(UIButton *)self.imageViewButton[j] setTag:IMAGEVIEW_TAG_BASE+j];
        
    }

    
        self.imageViewButton[4] = [[UIButton alloc] initWithFrame:CGRectMake(15+60*4, y, width, height)];
        
        [(UIButton *)[self.imageViewButton objectAtIndex:4] setTag:IMAGEVIEW_TAG_BASE+4];
        [self.view addSubview:self.imageViewButton[4]];
 


    [imageNames removeObjectAtIndex:(sender.tag-IMAGEVIEW_TAG_BASE)];
    if (imageNames.count > 0 ) {
        self.imageName = imageNames[0];
        for (int k = 1; k<imageNames.count; k++) {
            self.imageName = [NSString stringWithFormat:@"%@;%@", self.imageName, imageNames[k]];

        }
    }
 
    
    
}

-(void)returnInPhotoCheck:(UIButton *)sender
{
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_cancel;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("cancelSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_cancel);
        AudioServicesPlaySystemSound(soundObject_cancel);
    }
  
    [self.checkAlert close];
    
}

-(void)moneyTapped
{
    
    [MobClick event:@"money"];
    
    if (soundSwitch) {
        AudioServicesPlaySystemSound(soundObject);
    }
    
    NSNumber *income_mdfy;
    NSNumber *expend_mdfy;
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"moneyView" owner:self options:nil];
    
    UIView *tmpCustomView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height/3)];

    tmpCustomView = [nib objectAtIndex:0];
    
    UIImageView *imageInMoney = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 211)];
    
    [tmpCustomView addSubview:imageInMoney];
    [tmpCustomView sendSubviewToBack:imageInMoney];
    
    
    imageInMoney.image = [UIImage imageNamed:@"tagAlert.png"];
    //NSLog(@"enable is : %d",tmpCustomView.userInteractionEnabled);
    [tmpCustomView setUserInteractionEnabled:YES];
    UITextField * income = (UITextField *)[tmpCustomView viewWithTag:501];
    UITextField * outcome = (UITextField *)[tmpCustomView viewWithTag:502];
    UILabel * incomeLabel = (UILabel *)[tmpCustomView viewWithTag:510];
    UILabel * outcomeLabel = (UILabel *)[tmpCustomView viewWithTag:511];
    UILabel * money1 = (UILabel *)[tmpCustomView viewWithTag:512];
    UILabel * money2 = (UILabel *)[tmpCustomView viewWithTag:513];
    
    [incomeLabel setText:NSLocalizedString(@"收入",nil)];
    [outcomeLabel setText:NSLocalizedString(@"支出",nil)];
    [money1 setText:NSLocalizedString(@"元",nil)];
    [money2 setText:NSLocalizedString(@"元",nil)];

    
    income.delegate =self;
    outcome.delegate = self;


    [income setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [outcome setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    
    if ((modifying == 1)&&(!firstInmoney)){
        sqlite3_stmt *statement;
        const char *dbpath = [self.databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            NSString *queryEvent = [NSString stringWithFormat:@"SELECT income,expend from event where eventID=\"%d\"",modifyEventId];
            const char *queryEventstatment = [queryEvent UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    //找到要修改的事件，取出数据。
                    
                    
                    income_mdfy = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement, 0)];
                    expend_mdfy = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement, 1)];
                    //NSLog(@"AAAAAAA%@",income_mdfy);
                    
                    
                }
                
            }
            sqlite3_finalize(statement);
        }
        else {
            //NSLog(@"数据库打开失败");
            
        }
        sqlite3_close(dataBase);
        self.incomeFinal = [income_mdfy doubleValue];
        self.expendFinal = [expend_mdfy doubleValue];
        firstInmoney = YES;
        
        [income setText:[NSString stringWithFormat:@"%.2f",[income_mdfy doubleValue]]];
        [outcome setText:[NSString stringWithFormat:@"%.2f",[expend_mdfy doubleValue]]];
    }
    
    [income setText:[NSString stringWithFormat:@"%.2f",self.incomeFinal]];
    [outcome setText:[NSString stringWithFormat:@"%.2f",self.expendFinal]];

    
    UIButton *okButton =(UIButton *)[tmpCustomView viewWithTag:503];
    [okButton addTarget:self action:@selector(okTapped) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelButton =(UIButton *)[tmpCustomView viewWithTag:504];
    [cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    alert.tag = 0;
    
    [alert setContainerView:tmpCustomView];
    
    self.moneyAlert = alert;
    
    [alert show];
}


//tag＝1的actionsheet
-(void)startTimeTapped
{

    [self dismissKeyboard];

    
    
    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_time;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_time);
        AudioServicesPlaySystemSound(soundObject_time);
    }
    

    
	UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;

	datePicker.tag = 201;
	datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker setMinuteInterval:15];
    
    /* set to 24h format */
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [datePicker setLocale:locale];
    
    [timeSelectView addSubview:datePicker];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y+datePicker.frame.size.height+2, [UIScreen mainScreen].bounds.size.width, 35)];
    [okBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(selectStartTime) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okBtn setTintColor:[UIColor blueColor]];
    
    okBtn.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:0.95f];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y+datePicker.frame.size.height+45, [UIScreen mainScreen].bounds.size.width, 35)];
    [cancelBtn setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelTime) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor blueColor]];


    
    cancelBtn.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:0.95f];

    
    [timeSelectView addSubview:okBtn];
    [timeSelectView addSubview:cancelBtn];

    
    [self.view bringSubviewToFront:timeSelectView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    CGRect frame = [timeSelectView frame];
    
    /*------------CHANGECODE: custom action sheet---------*/

    
    //new code
    frame.origin.y -= frame.size.height;
    [timeSelectView setFrame:frame];
    [UIView commitAnimations];
    /*--------------------------------------------------------------*/

    [self.startTimeButton setEnabled:NO];
    [self.endTimeButton setEnabled:NO];



}

-(void)selectStartTime
{
        UIDatePicker *datePicker = (UIDatePicker *)[timeSelectView viewWithTag:201];
        [datePicker setMinuteInterval:15];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        formatter.dateFormat = @"H:mm";
        NSString *timestart = [formatter stringFromDate:datePicker.date];
        
        [(UILabel *)[self.view viewWithTag:103] setText:timestart];
        [self.startTimeButton setTitle:@"" forState:UIControlStateNormal];
        
        NSArray *startTime = [self.startLabel.text componentsSeparatedByString:@":"];
        double hour_0 = [startTime[0] doubleValue];
        double minite_0 = [startTime[1] doubleValue];
        double startNum = hour_0*60 + minite_0;
        startTimeNum = [[NSNumber alloc] initWithDouble:(startNum)];
    
    [self cancelTime];
}

-(void)cancelTime
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    CGRect frame = [timeSelectView frame];
    
    /*------------CHANGECODE: custom action sheet---------*/
    
    
    //new code
    frame.origin.y += frame.size.height;
    [timeSelectView setFrame:frame];
    [UIView commitAnimations];
    for (UIView *subs in [timeSelectView subviews]) {
        [subs removeFromSuperview];
    }
    
    [self.startTimeButton setEnabled:YES];
    [self.endTimeButton setEnabled:YES];


}


-(void)selectEndTime
{
    UIDatePicker *datePicker = (UIDatePicker *)[timeSelectView viewWithTag:202];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"H:mm";
    NSString *timestart = [formatter stringFromDate:datePicker.date];
    
    [(UILabel *)[self.view viewWithTag:104] setText:timestart];
    [self.endTimeButton setTitle:@"" forState:UIControlStateNormal];
    
    NSArray *endTime = [self.endLabel.text componentsSeparatedByString:@":"];
    
    
    double hour_1 = [endTime[0] doubleValue];
    double minite_1 = [endTime[1] doubleValue];
    double endNum = hour_1*60 + minite_1;
    
    endTimeNum = [[NSNumber alloc] initWithDouble:(endNum)];
    if (self.startLabel.text) {
        if ([endTimeNum doubleValue]<=[startTimeNum doubleValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                            message:NSLocalizedString(@"结束时间应该比开始时间更大哦！",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }

    [self cancelTime];

}

//tag＝2的actionsheet
-(void)endTimeTapped
{

    [self dismissKeyboard];

    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_time;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("goEdit"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_time);
        AudioServicesPlaySystemSound(soundObject_time);
    }
    
//    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n" ;
//    
//	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定",nil), NSLocalizedString(@"取消",nil),nil];
//    actionSheet.tag = 2;
//	[actionSheet showInView:self.view];
    UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;
    datePicker.tag = 202;
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker setMinuteInterval:15];
    
    /* set to 24h format */
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [datePicker setLocale:locale];

    
    [timeSelectView addSubview:datePicker];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y+datePicker.frame.size.height+2, [UIScreen mainScreen].bounds.size.width, 35)];
    [okBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(selectEndTime) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okBtn setTintColor:[UIColor blueColor]];
    okBtn.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:0.95f];;

    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y+datePicker.frame.size.height+45, [UIScreen mainScreen].bounds.size.width, 35)];
    [cancelBtn setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelTime) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor blueColor]];
    cancelBtn.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:0.95f];;
    
    [timeSelectView addSubview:okBtn];
    [timeSelectView addSubview:cancelBtn];

    [self.view bringSubviewToFront:timeSelectView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    CGRect frame = [timeSelectView frame];
    
    /*------------CHANGECODE: custom action sheet---------*/
    
    
    //new code
    frame.origin.y -= frame.size.height;
    [timeSelectView setFrame:frame];
    [UIView commitAnimations];
    /*--------------------------------------------------------------*/

    [self.endTimeButton setEnabled:NO];
    [self.startTimeButton setEnabled:NO];


}

-(void)addCollectTapped
{
    
    [MobClick event:@"addFavorite"];

    //[[Frontia getStatistics] logEvent:@"10013" eventLabel:@"addCollect"];

    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_collect;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("okSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_collect);
        AudioServicesPlaySystemSound(soundObject_collect);
    }

    
    //先判断当前事件是否已经保存过，如果时新增事件，先保存再加入收藏夹。
    int eventIdNow=-1;
    
    // modifying＝1时候，先查询收藏表中是否已经存在，若有，提示存在，若无，添加只收藏并提示成功。
    if (modifying == 1)
    {
        const char *dbpath = [self.databasePath UTF8String];
        sqlite3_stmt *stmtIfcollect = nil;
        sqlite3_stmt *stmtInsertCollect = nil;
        
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            
            NSString *queryCollectID = [NSString stringWithFormat:@"SELECT * from collection where eventID=\"%d\"",modifyEventId];
            const char *queryCollectIDstatement = [queryCollectID UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryCollectIDstatement, -1, &stmtIfcollect, NULL)==SQLITE_OK) {
                if (sqlite3_step(stmtIfcollect)==SQLITE_ROW) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示",nil)
                                                                    message:NSLocalizedString(@"收藏夹中已收录此事",nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                          otherButtonTitles:nil];
                    
                    [ alert  show];
                }else{
                    
                    NSString *insertCollct = [NSString stringWithFormat:@"INSERT INTO collection(eventID) VALUES(?)"];
                    
                    const char *collectstmt = [insertCollct UTF8String];
                    sqlite3_prepare_v2(dataBase, collectstmt, -1, &stmtInsertCollect, NULL);
                    sqlite3_bind_int(stmtInsertCollect,1, modifyEventId);
                    
                    if (sqlite3_step(stmtInsertCollect)==SQLITE_DONE) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示",nil)
                                                                        message:NSLocalizedString(@"成功添加至收藏夹",nil)
                                                                       delegate:nil
                                                              cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                              otherButtonTitles:nil];
                        
                        [ alert  show];
                        
                    }
                    else {
                    }
                    
                    
                    
                }
                
                
            }else{
                //NSLog(@"wwwwwwwwwwww!!!!!!!!!~~");
            }
            sqlite3_finalize(stmtIfcollect);
            sqlite3_finalize(stmtInsertCollect);
            
        } else {
            //NSLog(@"数据库打开失败");
            
        }
        
        
        sqlite3_close(dataBase);
        
    }else if (modifying == 0) {
        
        flag=NO;
        if (([self.startLabel.text isEqualToString:@""]) || ([self.endLabel.text isEqualToString:@""])) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                            message:NSLocalizedString(@"请输入事件起始和结束时间",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        
        else  {
            
            
            NSNumber *oldStartNum;
            NSArray *startTime = [self.startLabel.text componentsSeparatedByString:@":"];
            NSArray *endTime = [self.endLabel.text componentsSeparatedByString:@":"];
            
            double hour_0 = [startTime[0] doubleValue];
            double minite_0 = [startTime[1] doubleValue];
            double hour_1 = [endTime[0] doubleValue];
            double minite_1 = [endTime[1] doubleValue];
            
            
            
            double startNum = hour_0*60 + minite_0;
            double endNum = hour_1*60 + minite_1;
            
            if (startNum >= endNum) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                                message:NSLocalizedString(@"结束应该在开始之后哦",nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                      otherButtonTitles:nil];
                alert.tag = 100;
                [alert show];
                return;
            }
            else{
                
                startTimeNum = [[NSNumber alloc] initWithDouble:(startNum)];
                endTimeNum = [[NSNumber alloc] initWithDouble:(endNum)];
                
                for (int i = [startTimeNum intValue]/15; i < [endTimeNum intValue]/15; i++) {
                    if([self.eventType intValue]==0 && workArea[i] == 1)
                    {
                        flag=YES;
                        break;
                    }
                    if([self.eventType intValue]==1 && lifeArea[i] == 1)
                    {
                        flag=YES;
                        break;
                    }
                }
                
                
                if (flag) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                                    message:NSLocalizedString(@"该时段已有事件存在，请修改起止时间或选择相应事件进行补充",nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                          otherButtonTitles:nil];
                    alert.tag = 101;
                    [alert show];
                    
                    return;
                    
                    
                }
                else{
                    //NSLog(@"the old start is :%d",[oldStartNum intValue]);
                    
                    NSLog(@"text!!!!:%@",self.theme.text);
                    if (!self.theme.text||[self.theme.text isEqualToString:@""]) {
                        self.theme.text = NSLocalizedString(@"无主题",nil);
                    }
                    
                    [self.drawBtnDelegate redrawButton:startTimeNum:endTimeNum:self.theme.text:self.eventType:oldStartNum];
                    if ([self.eventType intValue]==0) {
                        for (int i = [startTimeNum intValue]/15; i < [endTimeNum intValue]/15; i++) {
                            workArea[i] = 1;
                            //NSLog(@"seized work area is :%d",i);
                        }
                    }else if([self.eventType intValue]==1){
                        for (int i = [startTimeNum intValue]/15; i < [endTimeNum intValue]/15; i++) {
                            lifeArea[i] = 1;
                            //NSLog(@"seized life area is :%d",i);
                        }
                    }else{
                        //NSLog(@"事件类型有误！");
                    }
                    
                    //在数据库中存储该事件
                    
                    const char *dbpath = [self.databasePath UTF8String];
                    sqlite3_stmt *statementInsert;
                    sqlite3_stmt *statementSelect;
                    sqlite3_stmt *statementCollect;
                    
                    
                    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                        
                        // 插入当天的数据
                        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO EVENT(TYPE,TITLE,mainText,income,expend,date,startTime,endTime,distance,label,remind,startArea,photoDir,eventID) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                        
                        const char *insertsatement = [insertSql UTF8String];
                        sqlite3_prepare_v2(dataBase, insertsatement, -1, &statementInsert, NULL);
                        sqlite3_bind_int(statementInsert,1, [self.eventType intValue]);
                        sqlite3_bind_text(statementInsert,2, [self.theme.text UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statementInsert,3, [self.mainText.text UTF8String], -1, SQLITE_TRANSIENT);
                        //未添加功能的数据
                        sqlite3_bind_double(statementInsert,4, self.incomeFinal);
                        sqlite3_bind_double(statementInsert,5, self.expendFinal);
                        
                        
                        sqlite3_bind_text(statementInsert,6, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_double(statementInsert,7, [startTimeNum doubleValue]);
                        sqlite3_bind_double(statementInsert,8, [endTimeNum doubleValue]);
                        sqlite3_bind_double(statementInsert,9, [endTimeNum doubleValue]-[startTimeNum doubleValue]);
                        
                        sqlite3_bind_text(statementInsert,10, [self.selectedTags UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statementInsert,11, [self.remindData UTF8String], -1, SQLITE_TRANSIENT);
                        //  sqlite3_bind_int(statement,11, 0);
                        sqlite3_bind_int(statementInsert,12, [self.eventType intValue]*1000+[startTimeNum intValue]/15);
                        sqlite3_bind_text(statementInsert,13, [self.imageName UTF8String], -1, SQLITE_TRANSIENT);
                        
                        sqlite3_bind_int(statementInsert,14, [self searchEventID]);
                        
                        if (sqlite3_step(statementInsert)==SQLITE_DONE) {
                        }
                        else {
                        }
                        
                        sqlite3_finalize(statementInsert);
                        
                        //此处添加插入收藏的数据库语句，并alert已自动保存并添加至收藏夹。
                        //先找到本次事件的eventID。
                        
                        
                        
                        NSString *queryEventID = [NSString stringWithFormat:@"SELECT eventID from event where DATE=\"%@\" and startArea=\"%d\"",modifyDate,[self.eventType intValue]*1000+[startTimeNum intValue]/15];
                        const char *queryEventIDstatement = [queryEventID UTF8String];
                        if (sqlite3_prepare_v2(dataBase, queryEventIDstatement, -1, &statementSelect, NULL)==SQLITE_OK) {
                            if (sqlite3_step(statementSelect)==SQLITE_ROW) {
                                eventIdNow = sqlite3_column_int(statementSelect, 0);
                                
                                modifying = 1;
                                modifyEventId = eventIdNow;
                                haveSaved = YES;
                            }
                        }
                        
                        else{
                            //NSLog(@"wwwwwwwwwwww!!!!!1");
                        }
                        sqlite3_finalize(statementSelect);
                        
                        if (eventIdNow>0) {
                            
                            NSString *insertCollctSql = [NSString stringWithFormat:@"INSERT INTO collection(eventID) VALUES(?)"];
                            
                            const char *collectsatement = [insertCollctSql UTF8String];
                            sqlite3_prepare_v2(dataBase, collectsatement, -1, &statementCollect, NULL);
                            sqlite3_bind_int(statementCollect,1, eventIdNow);
                            
                            if (sqlite3_step(statementCollect)==SQLITE_DONE) {
                                //NSLog(@"innsert collect okssssssssssscollect");
                            }
                            else {
                                //NSLog(@"Error while insert collect:%s",sqlite3_errmsg(dataBase));
                            }
                            
                            sqlite3_finalize(statementCollect);
                            
                            
                        }
                        else
                        {
                            //NSLog(@"未能正确录入该事件，时间ID没有正确填充！！！！！！！");
                        }
                        
                    }
                    
                    else {
                        //NSLog(@"数据库打开失败");
                        
                    }
                    
                    
                    sqlite3_close(dataBase);
                }
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"该事项已自动保存并存入收藏夹",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                  otherButtonTitles:nil];
            
            [ alert  show];
            const char *dbpath = [self.databasePath UTF8String];
            
            
            if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                sqlite3_stmt *findStatement;
                sqlite3_stmt *dayStatement;
                NSString *queryDay = [NSString stringWithFormat:@"SELECT DATE from DAYTABLE where DATE=\"%@\"",modifyDate];
                const char *queryDayStatement = [queryDay UTF8String];
                if (sqlite3_prepare_v2(dataBase, queryDayStatement, -1, &findStatement, NULL)==SQLITE_OK) {
                    
                    if(sqlite3_step(findStatement)==SQLITE_ROW)
                    {
                    }else {
                        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE,mood,growth) VALUES(?,?,?)"];
                        
                        //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
                        const char *insertsatement = [insertSql UTF8String];
                        sqlite3_prepare_v2(dataBase, insertsatement, -1, &dayStatement, NULL);
                        sqlite3_bind_text(dayStatement, 1, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_int(dayStatement, 2, 0);
                        sqlite3_bind_int(dayStatement, 3, 0);
                        
                        
                        if (sqlite3_step(dayStatement)==SQLITE_DONE) {
                            //NSLog(@"innsert today ok");
                            
                            NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                            
                            NSDate *dateUnconvert = [dateFormatter dateFromString:modifyDate];
                            [self.HasEvtDates addObject:dateUnconvert];
                        }
                        else {
                            //NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
                        }
                        
                        sqlite3_finalize(dayStatement);
                        
                    }
                    
                    
                    
                }
                
                
                sqlite3_finalize(findStatement);
            }
            else{
                //NSLog(@"数据库打开失败");
                
            }
            
            sqlite3_close(dataBase);
            

            
        }
    }
    
}


-(void)deleteTapped
{
    
     //[[Frontia getStatistics] logEvent:@"10012" eventLabel:@"deleteEvent"];
    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_dlt;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("cancelSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_dlt);
        AudioServicesPlaySystemSound(soundObject_dlt);
    }
    
   
    //NSLog(@"delete！！！！！！！！");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"确定删除该事项吗",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"取消",nil)
                                          otherButtonTitles:NSLocalizedString(@"确定",nil),nil];
    alert.tag = 4;
    
    [ alert  show];

    
}

-(void)saveTapped
{
    
    [MobClick event:@"save"];

    
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_save;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("okSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_save);
        AudioServicesPlaySystemSound(soundObject_save);
    }
    
    NSNumber *oldStartNum;
    //NSLog(@"<<<<<%@>>>>>3",self.remindData);
    

    
    if (modifying == 1) {
        sqlite3_stmt *statement;
        const char *dbpath = [self.databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            //NSLog(@"before select event ID");
            NSString *queryEvent = [NSString stringWithFormat:@"SELECT startTime,endTime from event where eventID=\"%d\"",modifyEventId];
            
            const char *queryEventstatment = [queryEvent UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                if (sqlite3_step(statement)==SQLITE_ROW) {
                    //找到当前修改的事件，取出数据，并清零对应的Area。
                    //NSLog(@"After select event ID");
                   // double testStart =sqlite3_column_double(statement,0);
                    NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,0)];
                    oldStartNum = startTm;
                    NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,1)];
                    
                    if ([self.eventType intValue] == 0) {
                        for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                            workArea[i] = 0;
                            //NSLog(@"release work area is :%d",i);
                        }
                    }else if([self.eventType intValue] == 1){
                        for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                            lifeArea[i] = 0;
                            //NSLog(@"release life area is :%d",i);
                        }
                    }
                    
                }
                
            }
            sqlite3_finalize(statement);
        }
        else {
            //NSLog(@"数据库打开失败");
            
        }
        sqlite3_close(dataBase);
        
    }

    
    flag=NO;

    //NSLog(@"hello!");
    if (([self.startLabel.text isEqualToString:@""]) || ([self.endLabel.text isEqualToString:@""])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                        message:NSLocalizedString(@"请输入事件起始和结束时间",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    else  {
        NSArray *startTime = [self.startLabel.text componentsSeparatedByString:@":"];
        NSArray *endTime = [self.endLabel.text componentsSeparatedByString:@":"];
        
        double hour_0 = [startTime[0] doubleValue];
        double minite_0 = [startTime[1] doubleValue];
        double hour_1 = [endTime[0] doubleValue];
        double minite_1 = [endTime[1] doubleValue];
        
        
        
        double startNum = hour_0*60 + minite_0;
        double endNum = hour_1*60 + minite_1;
        
        if (startNum >= endNum) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                            message:NSLocalizedString(@"结束应该在开始之后哦",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                  otherButtonTitles:nil];
            alert.tag = 100;
            [alert show];
            
            return;
        }
        else{
            
            startTimeNum = [[NSNumber alloc] initWithDouble:(startNum)];
            endTimeNum = [[NSNumber alloc] initWithDouble:(endNum)];
            
            for (int i = [startTimeNum intValue]/15; i < [endTimeNum intValue]/15; i++) {
                if([self.eventType intValue]==0 && workArea[i] == 1)
                {
                    flag=YES;
                    break;
                }
                if([self.eventType intValue]==1 && lifeArea[i] == 1)
                {
                    flag=YES;
                    break;
                }
            }
            
            
            if (flag) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                                message:NSLocalizedString(@"该时段已有事件存在，请修改起止时间或选择相应事件进行补充",nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                      otherButtonTitles:nil];
                alert.tag = 101;
                [alert show];
               
                
                
                
                //未能成功保存，所选时间内有其他事件冲突。所以先恢复当前修改中事件的占位，防止占位清零后点击返回，造成Area错误释放。
                sqlite3_stmt *statement;
                const char *dbpath = [self.databasePath UTF8String];
                if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                    //NSLog(@"before select event ID");
                    NSString *queryEvent = [NSString stringWithFormat:@"SELECT startTime,endTime from event where eventID=\"%d\"",modifyEventId];
                    
                    const char *queryEventstatment = [queryEvent UTF8String];
                    if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                        if (sqlite3_step(statement)==SQLITE_ROW) {
                            //找到当前修改的事件，取出数据，将对应的Area设置为1。
                            //NSLog(@"After select event ID");
                            NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,0)];
                            oldStartNum = startTm;
                            NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,1)];
                            
                            //NSLog(@"end:%d",[endTm intValue]);
                            if ([self.eventType intValue] == 0) {
                                for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                                    workArea[i] = 1;
                                    //NSLog(@"seize work area is :%d",i);
                                }
                            }else if([self.eventType intValue] == 1){
                                for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                                    lifeArea[i] = 1;
                                    //NSLog(@"seize life area is :%d",i);
                                }
                            }
                            
                        }
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                

                
                
                    return;
                
                
            }
            else{

                NSLog(@"text!!!!:%@",self.theme.text);
                if (!self.theme.text||[self.theme.text isEqualToString:@""]) {
                    self.theme.text = NSLocalizedString(@"无主题",nil);
                }
                
                
  
                [self.drawBtnDelegate redrawButton:startTimeNum:endTimeNum:self.theme.text:self.eventType:oldStartNum];
                if ([self.eventType intValue]==0) {
                    for (int i = [startTimeNum intValue]/15; i < [endTimeNum intValue]/15; i++) {
                        workArea[i] = 1;
                        //NSLog(@"seized work area is :%d",i);
                    }
                }else if([self.eventType intValue]==1){
                    for (int i = [startTimeNum intValue]/15; i < [endTimeNum intValue]/15; i++) {
                        lifeArea[i] = 1;
                        //NSLog(@"seized life area is :%d",i);
                    }
                }else{
                    //NSLog(@"事件类型有误！");
                }
                
          
                
                if (modifying == 0) {
                    
                    //在数据库中存储该事件
                   
                    const char *dbpath = [self.databasePath UTF8String];
                    sqlite3_stmt *statement;
                    
                    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                        
                        // 插入当天的数据
                        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO EVENT(TYPE,TITLE,mainText,income,expend,date,startTime,endTime,distance,label,remind,startArea,photoDir,eventID) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
                        
                        const char *insertsatement = [insertSql UTF8String];
                        sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
                        sqlite3_bind_int(statement,1, [self.eventType intValue]);
                        sqlite3_bind_text(statement,2, [self.theme.text UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statement,3, [self.mainText.text UTF8String], -1, SQLITE_TRANSIENT);
                        //未添加功能的数据
                        sqlite3_bind_double(statement,4, self.incomeFinal);
                        sqlite3_bind_double(statement,5, self.expendFinal);
                        
                        
                        sqlite3_bind_text(statement,6, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_double(statement,7, [startTimeNum doubleValue]);
                        sqlite3_bind_double(statement,8, [endTimeNum doubleValue]);
                        sqlite3_bind_double(statement,9, [endTimeNum doubleValue]-[startTimeNum doubleValue]);
                        
                        sqlite3_bind_text(statement,10, [self.selectedTags UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(statement,11, [self.remindData UTF8String], -1, SQLITE_TRANSIENT);
                        //  sqlite3_bind_int(statement,11, 0);
                        sqlite3_bind_int(statement,12, [self.eventType intValue]*1000+[startTimeNum intValue]/15);
                        sqlite3_bind_text(statement,13, [self.imageName UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_int(statement,14, [self searchEventID]);
                        
                            if (sqlite3_step(statement)==SQLITE_DONE) {
                            //NSLog(@"innsert event okqqqqqq");
                            }
                            else {
                            //NSLog(@"Error while insert event:%s",sqlite3_errmsg(dataBase));
                            }
                       
                        sqlite3_finalize(statement);
                    }
                    
                    else {
                        //NSLog(@"数据库打开失败");
                        
                    }
                    sqlite3_close(dataBase);
                    
                }
                else{
                    
                    const char *dbpath = [self.databasePath UTF8String];
                    sqlite3_stmt *statement;
                    
                    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                        
                        // 更新当天的数据
                        NSString *insertSql = [NSString stringWithFormat:@"UPDATE EVENT SET TITLE=?,mainText=?,income=?,expend=?,startTime=?,endTime=?,distance=?,label=?,remind=?,startArea=?,photoDir=? where eventID=?"];
                        
                        const char *updatesatement = [insertSql UTF8String];
                        if(sqlite3_prepare_v2(dataBase, updatesatement, -1, &statement, NULL)==SQLITE_OK){
                            
                            sqlite3_bind_text(statement,1, [self.theme.text UTF8String], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_text(statement,2, [self.mainText.text UTF8String], -1, SQLITE_TRANSIENT);
                            //未添加功能的数据
                            sqlite3_bind_double(statement,3, self.incomeFinal);
                            sqlite3_bind_double(statement,4, self.expendFinal);
                            
                            sqlite3_bind_double(statement,5, [startTimeNum doubleValue]);
                            sqlite3_bind_double(statement,6, [endTimeNum doubleValue]);
                            sqlite3_bind_double(statement,7, [endTimeNum doubleValue]-[startTimeNum doubleValue]);
                            
                            sqlite3_bind_text(statement,8, [self.selectedTags UTF8String], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_text(statement,9, [self.remindData UTF8String], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_int(statement,10, [self.eventType intValue]*1000+[startTimeNum intValue]/15);
                            sqlite3_bind_text(statement,11, [self.imageName UTF8String], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_int(statement,12, modifyEventId);
                            
                            if (sqlite3_step(statement)==SQLITE_DONE) {
                                //NSLog(@"innsert event okwwwwwwww");
                            }
                            else {
                                //NSLog(@"Error while insert event:%s",sqlite3_errmsg(dataBase));
                            }
                        }
                        else {
                            
                             //NSLog(@"modified event44");
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    
                    else {
                        //NSLog(@"数据库打开失败");
                        
                    }
                    sqlite3_close(dataBase);

                    
                }
                
            }
        

            
        }
    }
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    if (modifying == 0) {
        if (![self.remindData isEqualToString:@""]) {
            NSArray *remindDate = [self.remindData componentsSeparatedByString:@","];
            NSString *date = remindDate[0];
            NSString *time = remindDate[1];

            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *time1 = [formatter stringFromDate:now];
            NSDate *dateNow = [formatter dateFromString:time1];

            NSDate *daysRemind = [formatter dateFromString:date];
            formatter.dateFormat = @"H:mm";
            NSDate *timeRemind = [formatter dateFromString:time];
            NSString *time2 = [formatter stringFromDate:now];
            NSDate *timeNow = [formatter dateFromString:time2];
            
            NSTimeInterval daysInterval=[daysRemind timeIntervalSinceDate:dateNow];
            NSTimeInterval timeInterval=[timeRemind timeIntervalSinceDate:timeNow];
            
            int interval = (int)(daysInterval + timeInterval);
            
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil)
            {
                
                //NSDate *now=[NSDate new];
                notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:interval];
                //NSLog(@"%d",interval);
                notification.timeZone=[NSTimeZone defaultTimeZone];
             
                //notification.alertBody=@"TIME！";
                
                notification.alertAction = NSLocalizedString(@"打开",nil);  //提示框按钮
                notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
                
                notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
                
                notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),self.theme.text];
                notification.soundName = UILocalNotificationDefaultSoundName;

                notification.userInfo=[[NSDictionary alloc] initWithObjectsAndKeys:@"value1",@"key1",nil];
 
                [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
                
                
            }

         
        }else{
            
        }
    }
    else if(modifying == 1)
    {
        //NSLog(@"~~~~~~~~%@",self.remindData);
        if (![self.remindData isEqualToString:@""]) {
            
            
            NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
            
            for (UILocalNotification * localNotification in allLocalNotification) {
                //NSLog(@"%@",localNotification.userInfo);
                NSString * alarmValue=[localNotification.userInfo objectForKey:oldRemindDate];
                if ([oldRemindDate isEqualToString:alarmValue]) {
                    //NSLog(@"666666666666");
                    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                }
            }

            
            NSArray *remindDate = [self.remindData componentsSeparatedByString:@","];
            NSString *date = remindDate[0];
            NSString *time = remindDate[1];
            
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *time1 = [formatter stringFromDate:now];
            NSDate *dateNow = [formatter dateFromString:time1];
            
            NSDate *daysRemind = [formatter dateFromString:date];
            formatter.dateFormat = @"H:mm";
            NSDate *timeRemind = [formatter dateFromString:time];
            NSString *time2 = [formatter stringFromDate:now];
            NSDate *timeNow = [formatter dateFromString:time2];
            
            NSTimeInterval daysInterval=[daysRemind timeIntervalSinceDate:dateNow];
            NSTimeInterval timeInterval=[timeRemind timeIntervalSinceDate:timeNow];
            
            int interval = (int)(daysInterval + timeInterval);
            
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil)
            {
                
                //NSDate *now=[NSDate new];
                notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:interval];
                //NSLog(@"%d",interval);
                notification.timeZone=[NSTimeZone defaultTimeZone];
                
                //notification.alertBody=@"TIME！";
                
                notification.alertAction = NSLocalizedString(@"打开",nil);  //提示框按钮
                notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
                
                notification.applicationIconBadgeNumber = 1; //设置app图标右上角的数字
                
                notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),self.theme.text];
                notification.soundName = UILocalNotificationDefaultSoundName;

                notification.userInfo=[[NSDictionary alloc] initWithObjectsAndKeys:@"value1",@"key1",nil];
                
                [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
             
            }
        }
        
        
    }
    
    [self.reloadDelegate reloadTable];
    
    if (modifying == 0) {
        
        
        const char *dbpath = [self.databasePath UTF8String];
        
        
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            sqlite3_stmt *findStatement;
            sqlite3_stmt *dayStatement;
            NSString *queryDay = [NSString stringWithFormat:@"SELECT DATE from DAYTABLE where DATE=\"%@\"",modifyDate];
            const char *queryDayStatement = [queryDay UTF8String];
            if (sqlite3_prepare_v2(dataBase, queryDayStatement, -1, &findStatement, NULL)==SQLITE_OK) {
                
                if(sqlite3_step(findStatement)==SQLITE_ROW)
                {
                }else {
                    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE,mood,growth) VALUES(?,?,?)"];
                    
                    //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
                    const char *insertsatement = [insertSql UTF8String];
                    sqlite3_prepare_v2(dataBase, insertsatement, -1, &dayStatement, NULL);
                    sqlite3_bind_text(dayStatement, 1, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(dayStatement, 2, 0);
                    sqlite3_bind_int(dayStatement, 3, 0);
                    
                    
                    if (sqlite3_step(dayStatement)==SQLITE_DONE) {
                        //NSLog(@"innsert today ok");
                        
                        NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        
                        NSDate *dateUnconvert = [dateFormatter dateFromString:modifyDate];
                        [self.HasEvtDates addObject:dateUnconvert];
                    }
                    else {
                        //NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
                    }
                    
                    sqlite3_finalize(dayStatement);
                    
                }
                
                
                
            }
            
            
            sqlite3_finalize(findStatement);
        }
        else{
            //NSLog(@"数据库打开失败");
            
        }
        
        sqlite3_close(dataBase);
    }
    
    NSTimeInterval inEdit=[self.justInEdit timeIntervalSince1970];
  
    NSDate* finishEdit = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval endEidt=[finishEdit timeIntervalSince1970];
    
    NSTimeInterval editInterval=endEidt-inEdit;
     NSLog(@"editInterval is :%f",editInterval);
    NSLog(@"editInterval is :%ld",(unsigned long)editInterval);
  
    
    if ([self.eventType intValue]==0) {
        
        //[[Frontia getStatistics] logEventWithDurationTime:@"10005" eventLabel:@"saveWork" durationTime:(unsigned long)editInterval];
        
    }else if([self.eventType intValue]==1){
        
        //[[Frontia getStatistics] logEventWithDurationTime:@"10006" eventLabel:@"saveLife" durationTime:(unsigned long)editInterval];
        
    }

    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)okTapped
{
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_ok;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("okSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_ok);
        AudioServicesPlaySystemSound(soundObject_ok);
    }
    
    
    UITextField * income = (UITextField *)[self.moneyAlert viewWithTag:501];
    UITextField * outcome = (UITextField *)[self.moneyAlert viewWithTag:502];
    NSString *incomeText = income.text;
    self.incomeFinal=[incomeText doubleValue];
    NSString *outcomeText = outcome.text;
    self.expendFinal=[outcomeText doubleValue];
    //NSLog(@"BBBBBBBBB%f",self.incomeFinal);
    
    if (self.incomeFinal>0.001 ||self.expendFinal>0.001) {
        [self.moneyButton setImage:[UIImage imageNamed: @"收入高亮.png"] forState:UIControlStateNormal];
    }else
    {
        [self.moneyButton setImage:[UIImage imageNamed: @"moneyBtn.png"] forState:UIControlStateNormal];

    }
   
    [self.moneyAlert close];
    //[income resignFirstResponder];

}

-(void)cancelTapped
{
    if (soundSwitch) {
        
        CFBundleRef mainbundle=CFBundleGetMainBundle();
        SystemSoundID soundObject_cancel;
        //获得声音文件URL
        CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("cancelSound"),CFSTR("wav"),NULL);
        //创建system sound 对象
        AudioServicesCreateSystemSoundID(soundfileurl, &soundObject_cancel);
        AudioServicesPlaySystemSound(soundObject_cancel);
    }
    
    [self.moneyAlert close];
}

-(void)returnTapped
{
    if (soundSwitch) {
        AudioServicesPlaySystemSound(soundObject);
    }
    
    if (haveSaved) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"本次编辑内容尚未保存，确定离开吗",nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"取消",nil)
                                              otherButtonTitles:NSLocalizedString(@"确定",nil),nil];
        alert.tag = 5;
        
        [ alert  show];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:201];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            formatter.dateFormat = @"H:mm";
            NSString *timestart = [formatter stringFromDate:datePicker.date];
            
            [(UILabel *)[self.view viewWithTag:103] setText:timestart];
            [self.startTimeButton setTitle:@"" forState:UIControlStateNormal];
            
            NSArray *startTime = [self.startLabel.text componentsSeparatedByString:@":"];
            double hour_0 = [startTime[0] doubleValue];
            double minite_0 = [startTime[1] doubleValue];
            double startNum = hour_0*60 + minite_0;
            startTimeNum = [[NSNumber alloc] initWithDouble:(startNum)];
        }else if(buttonIndex == 1)
        {
            return;
        }
        
    }
    
	    
    if (actionSheet.tag == 2) {
        
        if (buttonIndex == 0) {
            
            UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:202];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            formatter.dateFormat = @"H:mm";
            NSString *timestart = [formatter stringFromDate:datePicker.date];
            
            [(UILabel *)[self.view viewWithTag:104] setText:timestart];
            [self.endTimeButton setTitle:@"" forState:UIControlStateNormal];
            
            NSArray *endTime = [self.endLabel.text componentsSeparatedByString:@":"];
            
            
            double hour_1 = [endTime[0] doubleValue];
            double minite_1 = [endTime[1] doubleValue];
            double endNum = hour_1*60 + minite_1;
            
            endTimeNum = [[NSNumber alloc] initWithDouble:(endNum)];
            if (self.startLabel.text) {
                if ([endTimeNum doubleValue]<=[startTimeNum doubleValue]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                                    message:NSLocalizedString(@"结束时间应该比开始时间更大哦！",nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }

        }else if(buttonIndex == 1)
        {
            return;
        }
        
        
        
    }

    if (actionSheet.tag == 255) {
 
        sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        } else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
       // self.wantsFullScreenLayout = YES;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

- (IBAction)endEditing:(id)sender {
    [self resignFirstResponder];
}

-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]||[objInput isKindOfClass:[UITextView class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
        
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
    if (textField.tag == 501 || textField.tag == 502) {
        
        
        if ([textField.text isEqualToString:@"0.00"]) {
            textField.text = @"";
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
    return YES;
}



- (void)willPresentAlertView:(UIAlertView *)myAlertView {
    if (myAlertView.tag == 0) {
        //NSLog(@"Alert0000000000");
        myAlertView.frame = CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height/3);

    }
    else if(myAlertView.tag == 1){
        
        //NSLog(@"Alert111111111");
        myAlertView.frame = CGRectMake(0, 65, self.view.bounds.size.width/2, 372);
        
    }
 
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 3) {
        if (buttonIndex == 1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            
            if (![tf.text isEqualToString:@""]) {
                //NSLog(@"new tag is : %@",tf.text);
                const char *dbpath = [self.databasePath UTF8String];
                sqlite3_stmt *statement;
                
                if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                    
                    // 插入当天的数据
                    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO TAG(tagName) VALUES(?)"];
                    
                    const char *insertsatement = [insertSql UTF8String];
                    sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
                    sqlite3_bind_text(statement,1, [tf.text UTF8String], -1, SQLITE_TRANSIENT);
                    
                    if (sqlite3_step(statement)==SQLITE_DONE) {
                        //NSLog(@"innsert tag ok");
                        [self.tags addObject:tf.text];
                        // [self.addTagDataDelegate addTagData:tf.text];
                    }
                    else {
                        //NSLog(@"Error while insert event:%s",sqlite3_errmsg(dataBase));
                        UIAlertView *tagNotUnique = [[UIAlertView alloc]
                                                     initWithTitle:NSLocalizedString(@"Attention",nil)
                                                     message:NSLocalizedString(@"This tag is already exist!",nil)
                                                     delegate:nil
                                                     cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                     otherButtonTitles:nil];
                        
                        
                        [tagNotUnique show];
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                else {
                    //NSLog(@"数据库打开失败");
                    
                }
                sqlite3_close(dataBase);
                
                [self.tagTable reloadData];
                
                [beSelected addObject: [[NSNumber alloc] initWithBool:NO]];
                

            }
            
            
            //NSLog(@"点击了确定按钮");
        }
        else {
            //NSLog(@"点击了取消按钮");
        }
    }
    if (alertView.tag == 4) {
        
        NSNumber *oldStartNum;
        if (buttonIndex == 1) {
            
            if(modifying == 1){
                
                const char *dbpath = [self.databasePath UTF8String];
                sqlite3_stmt *statement;
                sqlite3_stmt *statement_1;
                sqlite3_stmt *statement_2;
                
                if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
                    
                    NSString *queryEvent = [NSString stringWithFormat:@"SELECT startTime,endTime from event where eventID=\"%d\"",modifyEventId];
                    
                    const char *queryEventstatment = [queryEvent UTF8String];
                    if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
                        if (sqlite3_step(statement)==SQLITE_ROW) {
                            //找到当前修改的事件，取出数据，并清零对应的Area。
                            //NSLog(@"After select event ID");
                            NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,0)];
                            oldStartNum = startTm;
                            NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,1)];
                            
                            if ([self.eventType intValue] == 0) {
                                for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                                    workArea[i] = 0;
                                    //NSLog(@"release work area is :%d",i);
                                }
                            }else if([self.eventType intValue] == 1){
                                for (int i = [startTm intValue]/15; i < [endTm intValue]/15; i++) {
                                    lifeArea[i] = 0;
                                    //NSLog(@"release life area is :%d",i);
                                }
                            }
                            
                        }
                        
                    }
                    //NSLog(@"the old start is :%d",[oldStartNum intValue]);
                    [self.drawBtnDelegate redrawButton:nil:nil:nil:self.eventType:oldStartNum];
                    
                    //删除收藏表中的数据，如果没有，也执行，只是没有删除任何行。
                    
                    NSString *deleteCollect = [NSString stringWithFormat:@"DELETE FROM collection WHERE eventID=?"];
                    
                    const char *deleteCollectStement = [deleteCollect UTF8String];
                    sqlite3_prepare_v2(dataBase, deleteCollectStement, -1, &statement_2, NULL);
                    sqlite3_bind_int(statement_2, 1, modifyEventId);
                    
                    if (sqlite3_step(statement_2)==SQLITE_DONE) {
                        //NSLog(@"delete event from collection ok");
                        
                    }
                    else {
                        //NSLog(@"Error while delete tag:%s",sqlite3_errmsg(dataBase));
                        
                    }
                    
                    
                    // 删除当天的数据
                    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM EVENT WHERE eventID=?"];
                    
                    const char *deletestement = [deleteSql UTF8String];
                    sqlite3_prepare_v2(dataBase, deletestement, -1, &statement_1, NULL);
                    sqlite3_bind_int(statement_1, 1, modifyEventId);
                    
                    if (sqlite3_step(statement_1)==SQLITE_DONE) {
                        //NSLog(@"delete event ok");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                                        message:NSLocalizedString(@"成功删除该事项",nil)
                                                                       delegate:nil
                                                              cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        //刷新所有列表，因为删除了事件，列表内容应该有相应的改变
                        [self.reloadDelegate reloadTable];
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        
                    }
                    else {
                        //NSLog(@"Error while delete tag:%s",sqlite3_errmsg(dataBase));
                        
                    }
                    


                    
                    sqlite3_finalize(statement);
                    sqlite3_finalize(statement_1);
                    sqlite3_finalize(statement_2);
                }
                
                else {
                    //NSLog(@"数据库打开失败");
                    
                }
                sqlite3_close(dataBase);
                //NSLog(@"事项删除完毕！！！！！！") ;
                
                [self deleteRecorderVoice];//eric: delete recording voice...
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                                message:NSLocalizedString(@"该事件尚未保存，无须删除",nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                      otherButtonTitles:nil];
                [alert show];

            }
            
        }
    }
    if (alertView.tag == 5) {
        if (buttonIndex == 1) {
            
            if (modifying == 0)
            {
                [self deleteRecorderVoice];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    if(alertView.tag == 10)//eirc: for recording alert.
    {
        if (buttonIndex == 1) {
            [self deleteRecorderVoice];
            
            [self startRecording];
        }
        
    }
    
}


#pragma mark remindData Delegate
-(void)setRemindData:(NSString *)date :(NSString *)time
{
    self.remindData = [NSString stringWithFormat:@"%@,%@",date,time];
    if (self.remindData.length >3) {
        [self.remindButton setImage:[UIImage imageNamed: @"提醒高亮.png"] forState:UIControlStateNormal];
    }else
    {
        [self.remindButton setImage:[UIImage imageNamed: @"remindBtn.png"] forState:UIControlStateNormal];
        
    }
    
}
//NSLog(@"%@",self.remindData);
    
    


#pragma mark drawTag delegation

-(void) drawTag:(NSString *)oldTags
{
    
    if (![oldTags isEqualToString:@"" ] ) {
        
        
        //NSLog(@"old label is :%@",oldTags);
        self.selectedTags = oldTags;
        
        NSArray *tagToDraw = [oldTags componentsSeparatedByString:@","];

        if (tagToDraw.count > 0) {
            for (int i = 0; i < tagToDraw.count; i++) {
                UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(260, 5+160+30*i, 60, 20)];
                tag.text = tagToDraw[i];
                tag.textColor = [UIColor whiteColor];
                tag.font = [UIFont systemFontOfSize:11.0];
                tag.backgroundColor = [UIColor clearColor];
                
                UIImageView *tagImage = [[UIImageView alloc] initWithFrame:CGRectMake(255, 160+30*i, 70, 30)];
                tagImage.image = [UIImage imageNamed:@"标签.png"];

                [self.view bringSubviewToFront:tag];
               
                [tagLabels addObject:tag];
                [tagImages addObject:tagImage];
                [textInlabel addObject:tag.text];
                [self.view addSubview:tagImage];
                [self.view addSubview:tag];
                
            }
            
        }
        
    }
    
}


#pragma mark tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //  //NSLog(@"count:%d",[currentAlbumData[@"titles"] count]);
    
    return self.tags.count;
}

// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   if ([(NSNumber *)[loadCellOnce objectAtIndex:indexPath.row] boolValue] == YES ) {

  
     NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
       NSUInteger row=[indexPath row];
   //r cell.backgroundColor = [UIColor clearColor];
/*
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell1-1.png"]];
    UIImageView *clivkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell2-1.png"]];
    cell.backgroundView = bgImageView;
    cell.selectedBackgroundView = clivkImageView;
  */
    //设置文本
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text =[self.tags objectAtIndex :row];
    cell.backgroundColor = [UIColor clearColor];
    
  //  NSUInteger row=[indexPath row];
    
    
    
    NSNumber *haveSelected = [[NSNumber alloc] initWithBool:NO];
    
    if ([textInlabel containsObject:cell.textLabel.text]) {
        
        haveSelected = [[NSNumber alloc] initWithBool:YES];
        
        if ([(NSNumber *)[loadCellOnce objectAtIndex:[indexPath row]] boolValue] == NO ) {
            [selected addObject:[self.tags objectAtIndex:row]];

        }
        
      
    }
    if (loadCellOnce.count>0 && [(NSNumber *)[loadCellOnce objectAtIndex:[indexPath row]] boolValue] == NO ) {
        [beSelected insertObject:haveSelected atIndex:row];
        
    }
    

    
    NSNumber *haveload = [[NSNumber alloc] initWithBool:YES];
    [loadCellOnce insertObject:haveload atIndex:indexPath.row];

    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row=[indexPath row];

 //   NSNumber *haveSelected = [[NSNumber alloc] initWithBool:NO];
    
    if ([(NSNumber *)[beSelected objectAtIndex:row] boolValue] == YES ) {
        
        
        cell.highlighted = YES;
        NSLog(@"selected:%d", cell.selected);
        
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  

    
    NSUInteger row=[indexPath row];
    
    if ([(NSNumber *)[beSelected objectAtIndex:row] boolValue] == YES /*&& firstInTag ==YES*/) {
       // [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        [selected removeObject:[self.tags objectAtIndex:indexPath.row]];
       // firstInTag = NO;
        [beSelected insertObject:[[NSNumber alloc] initWithBool:NO] atIndex:row];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
      
        //theUITableViewCell.highlighted = NO;
        //theUITableViewCell.selected = NO;
        
    }else{
       // theUITableViewCell.highlighted = YES;
        [selected addObject:[self.tags objectAtIndex:row]];
        //NSLog(@"select---->:%@",selected);
    }
 


    

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete ;
}




- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

   
  //  NSUInteger row=[indexPath row];
 /*
    if ([(NSNumber *)[beSelected objectAtIndex:row] boolValue] == YES) {
        
      //  cell.highlighted = YES;
        [selected addObject:[self.tags objectAtIndex:row]];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];


        // [self tableView:tableView didDeselectRowAtIndexPath:indexPath];

        
    }else{
  */
        [selected removeObject:[self.tags objectAtIndex:indexPath.row]];
      //  cell.highlighted = NO;
        //NSLog(@"Deselect---->:%@",selected);

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"here!!!!!!!!!");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
      
            
        [beSelected removeObjectAtIndex:indexPath.row];

        [selected removeObject:[self.tags objectAtIndex:indexPath.row]];
        
        
        const char *dbpath = [self.databasePath UTF8String];
        sqlite3_stmt *statement;
        
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            
            // 插入当天的数据
            NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM TAG WHERE tagName=?"];
            
            const char *deletestement = [deleteSql UTF8String];
            sqlite3_prepare_v2(dataBase, deletestement, -1, &statement, NULL);
            sqlite3_bind_text(statement,1, [[self.tags objectAtIndex:indexPath.row] UTF8String], -1, SQLITE_TRANSIENT);
            
            
            if (sqlite3_step(statement)==SQLITE_DONE) {
                //NSLog(@"delete tag ok");
                [self.tags removeObject:[self.tags objectAtIndex:indexPath.row]];
               
            }
            else {
                //NSLog(@"Error while delete tag:%s",sqlite3_errmsg(dataBase));
                
            }
            sqlite3_finalize(statement);
        }
        
        else {
            //NSLog(@"数据库打开失败");
            
        }
        sqlite3_close(dataBase);
        

        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tagTable setEditing:NO animated:YES];
        
        
    }
   
}

#pragma mark TextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:NSLocalizedString(@"点击输入......",nil)]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor]; //optional

    
    NSLog(@"mainText frame3:%.2f",textView.frame.size.height);
   // self.mainText.contentInset=UIEdgeInsetsMake(0, 0,kbSize.height, 0);

    
    int mainText_Height = mainHeight;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        //NSLog(@"ios7!!!!");
        mainText_Height += 20;
    }
    
    /* fit for 4-inch screen */
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        mainText_Height += 80;
    }
    
    textView.frame=CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, (mainText_Height-100));
    self.mainTextExtend.frame = CGRectMake(self.mainTextExtend.frame.origin.x, self.mainTextExtend.frame.origin.y, self.mainTextExtend.frame.size.width, (mainText_Height-100));
    
    NSLog(@"mainText frame4:%.2f",textView.frame.size.height);
    
    [textView becomeFirstResponder];
    
     NSLog(@"mainText frame5:%.2f",textView.frame.size.height);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"点击输入......",nil);
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    
          NSLog(@"mainText frame3:%.2f",textView.frame.size.height);
    
    int mainText_Height = mainHeight;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        //NSLog(@"ios7!!!!");
        mainText_Height += 20;
    }
    
    /* fit for 4-inch screen */
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        mainText_Height += 80;
    }
    
    
    [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, mainText_Height)];
    
    self.mainTextExtend.frame = CGRectMake(self.mainTextExtend.frame.origin.x, self.mainTextExtend.frame.origin.y, self.mainTextExtend.frame.size.width, mainText_Height);
    
      NSLog(@"mainText frame4:%.2f",textView.frame.size.height);
    
    [textView resignFirstResponder];
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    
    
    NSDictionary *info = [notification userInfo];
    NSLog(@"-->info:%@",info);
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSValue *animationDurValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    //    copy value
    [animationDurValue getValue:&animationDuration];
    
    // self.mainText.frame = CGRectMake(self.mainText.frame.origin.x, self.mainText.frame.origin.y, self.mainText.frame.size.width/2, self.mainText.frame.size.height/2);
    
    //    让键盘弹起的时候添加一个动画
    [UIView beginAnimations:@"animal" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGFloat distanceToMove = kbSize.height;
    NSLog(@"---->动态键盘高度:%f",distanceToMove);
    [self adjustPanelsWithKeyBordHeight:distanceToMove];
    [UIView commitAnimations];
    self.exitButton.hidden=NO;
    [self.exitButton addTarget:self action:@selector(cancelBackKeyboard) forControlEvents:UIControlEventTouchDown];
    

 
    
    
}


- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
        NSLog(@"mainText frame2:%.2f",self.mainText.frame.size.height);
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    NSValue *animationDurValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    //   把animationDurvalue 值拷贝到animationDuration中
    [animationDurValue getValue:&animationDuration];
    
    [UIView beginAnimations:@"animal" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    
    if (self.exitButton) {
        
        CGRect exitBtFrame = CGRectMake(self.view.frame.size.width - 48, self.view.frame.size.height, 48.0f, 30.0f);
        self.exitButton.frame = exitBtFrame;
        [self.view addSubview:self.exitButton];
        
    }
    [UIView commitAnimations];
    
}

-(void)adjustPanelsWithKeyBordHeight:(float) height
{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (self.exitButton) {
        
        CGRect exitBtFrame = CGRectMake(self.view.frame.size.width - 48, self.view.frame.size.height - height-30, 48.0f, 30.0f);
        self.exitButton.frame = exitBtFrame;
        
        [self.view addSubview:self.exitButton];
        
        
    }
    
}

-(void)cancelBackKeyboard
{
    [self.mainText resignFirstResponder];
    [self.theme resignFirstResponder];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0.00";
       
    }
    [textField resignFirstResponder];
    
}



#pragma recorder and player
-(void)setupRecorder:(int)level
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
   
    // Set the audio file
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.DaysInLine"];
    NSString *voicePath = [[storeURL path] stringByAppendingPathComponent:[NSString stringWithFormat:@"message%d.caf",level]];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
//    NSString *voicePath =[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"message%d.caf",level]];
    
    if([fileManager fileExistsAtPath:voicePath] == YES)
    {
        //find an voice already exist..
         didRecord = YES;

        //set recorder and play button appearence
        
        [self.recorderBtn setHidden:NO];
        [self.playerBtn setHidden:NO];

    }else
    {
        CGRect recorderBtnFrame = self.recorderBtn.frame;
        recorderBtnFrame.origin.x += 40;
        [self.recorderBtn setFrame:recorderBtnFrame];
        [self.recorderBtn setHidden:NO];
        
        CGRect playerBtnFrame = self.playerBtn.frame;
        playerBtnFrame.origin.x += 180; //set out of the right bound.
        [self.playerBtn setFrame:playerBtnFrame];
        [self.playerBtn setHidden:YES];
    }

    
    

    NSURL *outputFileURL = [NSURL fileURLWithPath:voicePath];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    

    
    
}

-(void)recordSound
{

    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *voicePath =[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"message%d.caf",recorderID]];
    
    if (![self.recorder isRecording]) {
        
        if([fileManager fileExistsAtPath:voicePath] == YES)
        {
            //find an voice already exist..
            UIAlertView *recordExistAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请谨慎操作",nil) message:NSLocalizedString(@"重新录音将删除该事件的原有录音,确定继续?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
            recordExistAlert.tag = 10;
            [recordExistAlert show];
            

            
        }else
        {
        
            [self startRecording];
            [MobClick event:@"record"];

        }
        
    } else {
        
        [self.recorder stop];
        [self.recorderBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
        [self.playerBtn setEnabled:YES];
        if ([self.playerBtn isHidden]) {
            [self.playerBtn setHidden:NO];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            
            CGRect recorderBtnFrame = self.recorderBtn.frame;
            recorderBtnFrame.origin.x -= 40;
            [self.recorderBtn setFrame:recorderBtnFrame];
            [self.recorderBtn setHidden:NO];
            
            CGRect playerBtnFrame = self.playerBtn.frame;
            playerBtnFrame.origin.x -= 180; //set out of the right bound.
            [self.playerBtn setFrame:playerBtnFrame];
            [self.playerBtn setHidden:NO];
            
            [UIView commitAnimations];
            
        }
        
    }
    
    
}

-(void)startRecording
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    [self.recorder record];
    didRecord =YES;
    [self.recorderBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [self.playerBtn setEnabled:NO];
}

-(void)playRecord
{

    

    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
    NSLog(@"URL1:%@",self.recorder.url);
    
    [self.recorderBtn setEnabled:NO];
    [self.player setDelegate:self];
    self.player.volume = 1;
    [self.player prepareToPlay];
    
    [self.player play];
    double duration = self.player.duration;
    
    [self performSelector:@selector(playOver) withObject:nil afterDelay:duration];
    
    

}
-(void)playOver
{
    [self.recorderBtn setEnabled:YES];
    
}

-(void)deleteRecorderVoice
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *voicePath =[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"message%d.caf",recorderID]];
    
    NSError *error;
    [fileManager removeItemAtPath:voicePath error:&error];
    NSLog(@"error:%@",[error description]);
}

#pragma mark - recorder delegate
//add new message to home page
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self.playerBtn setEnabled:YES];

}



@end


