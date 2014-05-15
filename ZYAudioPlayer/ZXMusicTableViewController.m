//
//  ZXMusicTableViewController.m
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-15.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "ZXMusicTableViewController.h"
#import "ZXAudioViewController.h"
#import "ZXAudioPlayView.h"

@interface ZXMusicTableViewController ()
@property (nonatomic,strong)ZXAudioPlayView *audioplay;
@end
static NSString *cellFile=@"cell";
@implementation ZXMusicTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.audioplay=[[ZXAudioPlayView alloc]initWithFrame:self.view.bounds];
    self.audioplay.musicFile=self.tableMusicArray;
    [self.view addSubview:self.audioplay];
    self.audioplay.alpha=0;
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellFile];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.tableMusicArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellFile forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text=self.tableMusicArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZXAudioViewController *audioView=[[ZXAudioViewController alloc]init];
    audioView.musicFile=self.tableMusicArray;
    audioView.countMusic=indexPath.row;
    [self.navigationController pushViewController:audioView animated:YES];
    
//    if (self.audioplay.countMusic!=indexPath.row) {
//        self.audioplay.countMusic=indexPath.row;
//        [self.audioplay playMusicZX];
//    }
//    self.navigationController.navigationBarHidden=YES;
//    self.audioplay.alpha=1;
}


@end
