//
//  editingViewController.h
//  DaysInLine
//
//  Created by 张力 on 13-10-22.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <AudioToolbox/AudioToolbox.h>
#import "sqlite3.h"
#import "redrawButtonDelegate.h"
#import "remindDataDelegate.h"
#import "drawTagDelegate.h"
#import "reloadTableDelegate.h"
#import "CustomIOS7AlertView.h"
#import "checkPhotoController.h"
#import "setMainTextDelegate.h"
//#import "addTagDelegate.h"


@interface editingViewController : UIViewController
    <UIAlertViewDelegate,
    remindDataDelegate,
    drawTagDelegate,
    UIActionSheetDelegate,
    UITextViewDelegate,
    UITextFieldDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    AVAudioRecorderDelegate,
    AVAudioPlayerDelegate> {
    sqlite3 *dataBase;
    
    NSNumber *startTimeNum;
    NSNumber *endTimeNum;
    
    
}
@property (weak, nonatomic) IBOutlet UIImageView *editBackground;
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteTagButton;
@property (weak, nonatomic) IBOutlet UIButton *addNewTagButton;
@property (weak, nonatomic) IBOutlet UIButton *finishDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *okInTag;
@property (weak, nonatomic) IBOutlet UIButton *cancelInTag;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;//虚拟键盘回收键

@property (weak, nonatomic) IBOutlet UIButton *addAchieveButton;
@property (weak, nonatomic) IBOutlet UIButton *addCollectionButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) UILabel *startLabel;
@property (weak, nonatomic) UILabel *endLabel;

@property (weak, nonatomic) UILabel *toLabel;
@property (weak, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *timeSelectView;

@property (strong, nonatomic)NSString *databasePath;

//@property (strong, nonatomic) IBOutlet NSMutableArray *imageView;
@property (strong, nonatomic) IBOutlet NSMutableArray *imageViewButton;
@property (strong, nonatomic) CustomIOS7AlertView *moneyAlert;
@property (strong, nonatomic) CustomIOS7AlertView *tagAlert;
@property (strong, nonatomic) CustomIOS7AlertView *checkAlert;
@property (weak, nonatomic)  UITableView *tagTable;
@property (strong, nonatomic)   UITextView *mainText;
@property (strong, nonatomic)   UILabel *mainTextExtend;
@property (weak, nonatomic) IBOutlet UITextField *theme;
@property (weak, nonatomic) IBOutlet NSNumber *eventType;
@property double incomeFinal;
@property double expendFinal;
@property NSMutableArray *tags;
@property NSString *selectedTags;
@property NSString *imageName;
@property (strong, nonatomic) NSString *remindData;

@property NSMutableArray *HasEvtDates;

//录音
@property (strong, nonatomic) UIButton *recorderBtn;
@property (strong, nonatomic) UIButton *playerBtn;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) AVAudioPlayer *player;




//统计时长

@property NSDate *justInEdit;

@property (weak, nonatomic) NSObject <redrawButtonDelegate> *drawBtnDelegate;
@property (weak, nonatomic) NSObject <reloadTableDelegate> *reloadDelegate;
@property (weak, nonatomic) NSObject <setMainTextDelegate> *setTextDelegate;


//@property (weak, nonatomic) NSObject <addTagDelegate> *addTagDataDelegate;
- (IBAction)endEditing:(id)sender;
-(void)pictureTapped:(UIButton *)sender;
@end
