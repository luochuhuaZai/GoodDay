//
//  ViewController.h
//  GoodDay
//
//  Created by huazai on 14-9-1.
//  Copyright (c) 2014年 litterDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZWeatherCell.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *citylabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UIImageView *choiceImage1;
@property (weak, nonatomic) IBOutlet UIImageView *choiceImage2;

@property (strong, nonatomic) NSDictionary *data;

- (IBAction)changeTheCity:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *cityName;

@property (weak, nonatomic) IBOutlet UIImageView *backimage;

@end
