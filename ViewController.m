//
//  ViewController.m
//  GoodDay
//
//  Created by huazai on 14-9-1.
//  Copyright (c) 2014年 litterDeveloper. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

/* ****************************************************
 * 该方法是程序的生命周期方法,会在在这个View被加载之后立即执行 *
 * 用来执行数据的初始化等必须得操作,有点想main函数           *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    /* 使用UICollectionView的时候,需要手动来给这个UICollectionView添加数据源
     * 和代理,而CollectionView会根据数据源来读取数据,并且代理会监听collectionView
     * 的一些行为。
     */
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    
    // 设置textview的editable属性,这样就可以让一段文本显示出来,并且不能被修改。
    self.textView.editable = NO;
    
    //执行requestDataInCity方法,获取对应城市的天气数据,默认获取长春的天气数据
    [self requestDataInCity:@"长春"];
    
    //根据获得的天气数据,改变view里面显示的内容
    [self loadDataInDay:1];
}

/* **********************************************
 * 该方法是用来加载数据的方法,没有返回值              *
 * 把加载数据的方法独立出来,这样就可以重复使用了,每当   *
 * 点击下方的collectionViewCell之后,可以通过重复执行 *
 * 该方法来改变当前查看的天气细节                    *
 */
- (void)loadDataInDay:(int)daynum {
    
    //通过设置text来改变上方的城市名。
    self.citylabel.text = [self.data valueForKey:@"city"];
    
    //通过之前获取的字典,来读取到天气数据
    NSString *weather1 = [self.data valueForKey:[NSString stringWithFormat:@"weather_%d", daynum]];
    
    //获取温度数据
    NSString *temp1 = [self.data valueForKey:[NSString stringWithFormat:@"temp_%d", daynum]];
    
    //获取选择的时间
    NSString *day = [self.data valueForKey:[NSString stringWithFormat:@"date_%d", daynum]];
    
    //获取风向细节
    NSString *wind = [self.data valueForKey:[NSString stringWithFormat:@"wind_%d", daynum]];
    
    //改变textView的text来输出数据
    self.textView.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",weather1,temp1,day,wind];
    
    //改变下面的天气图片,默认读取第一天的数据。
    NSString *imageName1 = [self.data valueForKey:[NSString stringWithFormat:@"img_%d", 1]];
    
    NSString *imageName2 = [self.data valueForKey:[NSString stringWithFormat:@"img_%d", 2]];
    
    [self changeImageWithName1:imageName1 andName2:imageName2];
}

/* ************************
 * 该方法是生命周期方法      *
 * 在内存不够的时候会调用    *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* ************************************************
 * 下面的方法是用来请求数据的,没有返回值,应该在一开始执行  *
 * 该方法包括了一些对网络的请求包装、返回解析Json数据等   *
 */
- (void)requestDataInCity:(NSString *)cityName {
    
    //声明一个error,因为跟网络连接就由可能会出错,这些错误要显示出来。
    NSError *error;
    
    //声明请求api的URL地址,用str装载
    NSString *str = [NSString stringWithFormat:@"http://api.36wu.com/Weather/GetMoreWeather?district=%@", [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //把str用NSURLRequest包装好,用来发送请求使用
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
   
    //声明一个NSData来获取请求所返回的内容
    NSData *responer = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    //调用苹果官方的JSON解析类来解析JSON,把返回的结果解析成字典对象
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:responer options:NSJSONReadingMutableLeaves error:&error];
    //测试字典对象
    NSLog(@"%@", weatherDic);
    
    //获得返回结果的状态.(200是正常返回, 301等则是出错)
    NSString *state = [weatherDic objectForKey:@"status"];
    //测试状态
    NSLog(@"%@", state);
    
    //做个保护,只有正常返回结果的时候才去进一步解析数据
    if (state.intValue == 200)
    {
        self.data = [weatherDic objectForKey:@"data"];
    }
    
    //每一次请求完数据,即获得了新城市的天气数据,需要重新载入数据一次
    [self.collectionview reloadData];
}


#pragma mark -- UICollection DataSource method
/* ***********************************************
 * 下面2个是UICollectionViewDataSource数据源协议方法 *
 * 通过实现该协议来为CollectionView提供数据           *
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //提供一共有多少个cell
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //静态id,用来绑定storyboard里面的cell,让每一个cell都是这样子的
    static NSString *cellId = @"weatherCell";
    HZWeatherCell *cell = (HZWeatherCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    //加载将要读取的图片的名字
    NSString *imageName = [NSString stringWithFormat:@"%@.png", [self.data valueForKey:[NSString stringWithFormat:@"img_%ld", 2*(indexPath.row)+1]]];
    
    //改变cell里面的图片
    [UIView animateWithDuration:1.0f animations:^{
        cell.image.alpha = 0;
    }];
    cell.image.image = [UIImage imageNamed:imageName];
    
    [UIView animateWithDuration:1.0f animations:^{
        cell.image.alpha = 1.0f;
    }];
    
    //获得全部温度的string
    NSString *totalStr = [self.data valueForKey:[NSString stringWithFormat:@"temp_%ld", (long)indexPath.row+1]];
    //获得最低温度的位置
    NSRange range = [totalStr rangeOfString:@"~"];
    
    //把最低温度的值输出到cell中去
    cell.temp.text = [[self.data valueForKey:[NSString stringWithFormat:@"temp_%ld", (long)indexPath.row+1]] substringToIndex:range.location];
    
    return cell;
}

/* **************************
 * 这个方法是用来包装加载图片   *
 */
- (void)changeImageWithName1:(NSString *)name1 andName2:(NSString *)name2 {
    
    //通过使用UIView来直接做动画,让图片先消失
    [UIView animateWithDuration:1.0f animations:^{
        self.choiceImage1.alpha = 0;
        self.choiceImage2.alpha = 0;
    }];
    
    //改变加载的图片
    self.choiceImage1.image = [UIImage imageNamed:name1];
    self.choiceImage2.image = [UIImage imageNamed:name2];
    
    //让图片通过动画浮现
    [UIView animateWithDuration:1.0f animations:^{
        self.choiceImage2.alpha = 1.0f;
        self.choiceImage1.alpha = 1.0f;
    }];
}

/* ************************************
 * 监听方法,通过点击check按钮来触发该方法  *
 */
- (IBAction)changeTheCity:(id)sender {
    
    //点击check之后,让键盘下去
    [self.cityName resignFirstResponder];
    
    //获取输入的城市名
    NSString *cityName = self.cityName.text;
    
    //载入城市的天气信息
    [self requestDataInCity:cityName];
    [self loadDataInDay:1];
}

#pragma mark -- UICollectionView - Delegate
/* ****************************************************
 * 下面的方法是实现UICollectionViewDelegate代理协议方法    *
 * 实现该协议方法来实现对collectionView的监听,来监听点击cell *
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HZWeatherCell *cell = (HZWeatherCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.5f animations:^{
        cell.alpha = 0;
    }];
    
    [UIView animateWithDuration:0.5f animations:^{
        cell.alpha = 1.0f;
    }];
    
    //改变显示的天气细节
    [self loadDataInDay:(int)indexPath.row+1];
    
    //改变下面的天气图片
    NSString *imageName1 = [self.data valueForKey:[NSString stringWithFormat:@"img_%ld", 2*(indexPath.row)+1]];
    
    NSString *imageName2 = [self.data valueForKey:[NSString stringWithFormat:@"img_%ld", 2*(indexPath.row)+2]];
            
    [self changeImageWithName1:imageName1 andName2:imageName2];

    return YES;
}



@end
