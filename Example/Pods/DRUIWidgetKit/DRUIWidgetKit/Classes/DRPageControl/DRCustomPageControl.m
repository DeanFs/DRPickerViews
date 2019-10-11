//
//  DRCustomPageControl.m
//  XHPageControl
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 xuanhe. All rights reserved.
//

#import "DRCustomPageControl.h"

@interface DRCustomPageControl ()

/**
 分页符子视图
 */
@property (nonatomic, strong) NSMutableArray *dotViews;

/**
 当前视图尺寸
 */
@property (nonatomic, assign) CGFloat recordWidth;
@end

@implementation DRCustomPageControl

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.backgroundColor = [UIColor clearColor];
      _normalRatio = 1;
      _currentRatio = 2;
      _numberOfPages = 0;
      _currentPage = 0;
      _controlHeight = 6;
      _controlSpacing = 8;
      _normalColor = [UIColor grayColor];
      _currentColor = [UIColor orangeColor];
      _positionType = DRPageControlPositionTypeMiddle;
}

-(void)clearView{
    [self.dotViews removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.recordWidth != self.bounds.size.width) {
        [self createPointView];
    }
}

-(void)createPointView{
    
    self.recordWidth = self.bounds.size.width;  // 保存记录
    
    [self clearView];
    if(_numberOfPages <= 0)
        return;
    
    //居中控件
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat mainWidth = (_numberOfPages - 1)* _controlHeight*_normalRatio+ (_numberOfPages - 1) * _controlSpacing + _controlHeight * _currentRatio;
    if(self.frame.size.width<mainWidth){
        startX = 0;
    }else{
        if (_positionType == DRPageControlPositionTypeLeft) {
            startX = 10;
        }else if (_positionType == DRPageControlPositionTypeMiddle){
            startX = (self.frame.size.width-mainWidth)/2.0;
        }else if (_positionType == DRPageControlPositionTypeRight){
            startX = self.frame.size.width-mainWidth-10;
        }
    }
    if(self.frame.size.height<_controlHeight){
        startY = 0;
    }else{
        startY = (self.frame.size.height-_controlHeight)/2;
    }
    //动态创建点
    for (int page=0; page<_numberOfPages; page++) {
        if(page == _currentPage){
            UIView *currPointView = [[UIView alloc]initWithFrame:CGRectMake(startX, startY, _controlHeight*_currentRatio, _controlHeight)];
            currPointView.layer.cornerRadius = _controlHeight/2;
            currPointView.tag = page+1000;
            currPointView.backgroundColor = _currentColor;
            currPointView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [currPointView addGestureRecognizer:tapGesture];
            [self addSubview:currPointView];
            startX = CGRectGetMaxX(currPointView.frame)+_controlSpacing;
            [self.dotViews addObject:currPointView];
            if(_currentBkImg){
                currPointView.backgroundColor = [UIColor clearColor];
                UIImageView *currBkImg = [[UIImageView alloc]init];
                currBkImg.tag = 2233;
                currBkImg.frame = CGRectMake(0, 0, currPointView.frame.size.width, currPointView.frame.size.height);
                currBkImg.image = _currentBkImg;
                [currPointView addSubview:currBkImg];
            }
            
        }else{
            UIView *otherPointView = [[UIView alloc]initWithFrame:CGRectMake(startX, startY, _controlHeight * _normalRatio, _controlHeight)];
            otherPointView.backgroundColor = _normalColor;
            otherPointView.tag = page+1000;
            otherPointView.layer.cornerRadius = _controlHeight/2.0;
            otherPointView.userInteractionEnabled = YES;
            
            if (_normalBkImg) {
                otherPointView.backgroundColor = [UIColor clearColor];
                UIImageView *normalBkImg = [[UIImageView alloc] init];
                normalBkImg.tag = page+1000+2244;
                normalBkImg.frame = CGRectMake(0, 0, otherPointView.frame.size.width, otherPointView.frame.size.height);
                normalBkImg.image = _normalBkImg;
                [otherPointView addSubview:normalBkImg];
            }
            
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [otherPointView addGestureRecognizer:tapGesture];
            [self addSubview:otherPointView];
            [self.dotViews addObject:otherPointView];
            startX = CGRectGetMaxX(otherPointView.frame)+_controlSpacing;
        }
    }
    
}

//切换当前的点
-(void)exchangeCurrentView:(NSInteger)old new:(NSInteger)new
{
    UIView *oldSelect=[self viewWithTag:1000+old];
    CGRect mpSelect=oldSelect.frame;
    
    UIView *newSeltect=[self viewWithTag:1000+new];
    CGRect newTemp=newSeltect.frame;
    
    if(_currentBkImg){
        UIView *imgview=[oldSelect viewWithTag:2233];
        [imgview removeFromSuperview];
        
        newSeltect.backgroundColor=[UIColor clearColor];
        UIImageView *currBkImg=[UIImageView new];
        currBkImg.tag=2233;
        currBkImg.frame=CGRectMake(0, 0, mpSelect.size.width, mpSelect.size.height);
        currBkImg.image=_currentBkImg;
        [newSeltect addSubview:currBkImg];
    }
    if (_normalBkImg) {
        UIView *imgview=[newSeltect viewWithTag:2244+1000+new];
        [imgview removeFromSuperview];
        
        oldSelect.backgroundColor = [UIColor clearColor];
        UIImageView *normalBkImg = [UIImageView new];
        normalBkImg.tag=2244+1000+new;
        normalBkImg.frame=CGRectMake(0, 0, mpSelect.size.width, mpSelect.size.height);
        normalBkImg.image=_normalBkImg;
        [oldSelect addSubview:normalBkImg];
    }
    oldSelect.backgroundColor=_normalColor;
    newSeltect.backgroundColor=_currentColor;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat lx=mpSelect.origin.x;
        if(new<old)
            lx+=self.controlHeight *(self.currentRatio - self.normalRatio);
        oldSelect.frame=CGRectMake(lx, mpSelect.origin.y, self.controlHeight * self.normalRatio, self.controlHeight);
        
        CGFloat mx=newTemp.origin.x;
        if(new>old)
            mx-=self.controlHeight * (self.currentRatio - self.normalRatio);
        newSeltect.frame=CGRectMake(mx, newTemp.origin.y, self.controlHeight * self.currentRatio, self.controlHeight);
        
        // 左边的时候到右边 越过点击
        if(new-old>1)
        {
            for(NSInteger t=old+1;t<new;t++)
            {
                UIView *ms = [self viewWithTag:1000+t];
                ms.frame=CGRectMake(ms.frame.origin.x-self.controlHeight * (self.currentRatio - self.normalRatio), ms.frame.origin.y, self.controlHeight*self.normalRatio, self.controlHeight);
            }
        }
        // 右边选中到左边的时候 越过点击
        if(new-old<-1)
        {
            for(NSInteger t=new+1;t<old;t++)
            {
                UIView *ms=[self viewWithTag:1000+t];
                ms.frame=CGRectMake(ms.frame.origin.x+self.controlHeight * (self.currentRatio - self.normalRatio), ms.frame.origin.y, self.controlHeight*self.normalRatio, self.controlHeight);
            }
        }
    }];
}


-(void)clickAction:(UITapGestureRecognizer*)recognizer{
    if (!self.actionAble) return;
    
    NSInteger index=recognizer.view.tag-1000;
    [self setCurrentPage:index];
    
}


-(BOOL)isTheSameColor:(UIColor*)color1 annormalColor:(UIColor*)color2{
    return  CGColorEqualToColor(color1.CGColor, color2.CGColor);
}

- (void)updateDotViewsBackgroundColor {
    for (int i = 0; i< self.dotViews.count; i++) {
        UIView *dotView = self.dotViews[i];
        dotView.backgroundColor = i == self.currentPage ? self.currentColor : self.normalColor;
    }
}

#pragma mark - setter & getter

-(void)setNormalColor:(UIColor *)normalColor{
    
    if(![self isTheSameColor:normalColor annormalColor:_normalColor]){
        _normalColor = normalColor;
        [self updateDotViewsBackgroundColor];
    }
}

-(void)setCurrentColor:(UIColor *)currentColor{
    if(![self isTheSameColor:currentColor annormalColor:_currentColor]){
        _currentColor = currentColor;
        [self updateDotViewsBackgroundColor];
    }
}

-(void)setControlHeight:(NSInteger)controlHeight{
    if(_controlHeight != controlHeight){
        _controlHeight = controlHeight;
        [self createPointView];
    }
}
-(void)setNormalRatio:(NSInteger)normalRatio{
    if (normalRatio != _normalRatio) {
        _normalRatio = normalRatio;
        [self createPointView];
    }
}
-(void)setCurrentRatio:(NSInteger)currentRatio{
    if (currentRatio != _currentRatio) {
        _currentRatio = currentRatio;
        [self createPointView];
    }
}

-(void)setControlSpacing:(NSInteger)controlSpacing{
    if(_controlSpacing != controlSpacing){
        
        _controlSpacing = controlSpacing;
        [self createPointView];
        
    }
}

-(void)setCurrentBkImg:(UIImage *)currentBkImg{
    if(_currentBkImg != currentBkImg){
        _currentBkImg = currentBkImg;
        [self createPointView];
    }
}

-(void)setNormalBkImg:(UIImage *)normalBkImg{
    if (_normalBkImg != normalBkImg) {
        _normalBkImg = normalBkImg;
        [self createPointView];
    }
}

- (void)setPositionType:(DRPageControlPositionType)positionType {
    if (_positionType != positionType) {
        _positionType = positionType;
        [self createPointView];
    }
}



-(void)setNumberOfPages:(NSInteger)page{
    if(_numberOfPages == page)
        return;
    _numberOfPages = page;
    [self createPointView];
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    if(_currentPage == currentPage) return;
    
    [self exchangeCurrentView:_currentPage new:currentPage];
    _currentPage = currentPage;
    
    if (self.tapAction) {
        self.tapAction(currentPage);
    }

}

-(NSMutableArray *)dotViews {
    if (!_dotViews) {
        _dotViews = @[].mutableCopy;
    }
    return _dotViews;
}

@end
