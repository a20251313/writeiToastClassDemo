//
//  MBProgressHUD.swift
//  writeItoastInswift
//
//  Created by jingfuran on 14/11/6.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit


enum MBProgressHUDMode:Int
{
    case Indeterminate = 1
    case Determinate
    case CustomView
}
enum MBProgressHUDAnimation:Int
{
    case Fade = 1
    case Zoom
    
}
var PADDING:CGFloat = 4
@objc(MBProgressHUDDelegate)
protocol MBProgressHUDDelegate
{
    optional func hudWasHidden(hud:MBProgressHUD);
}
class MBProgressHUD: UIView {

    var mode:MBProgressHUDMode = MBProgressHUDMode.Indeterminate{
        didSet
        {
            if NSThread.isMainThread()
            {
                self.updateIndicators();
                self.setNeedsLayout();
                self.setNeedsDisplay();
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateIndicators();
                    self.setNeedsLayout();
                    self.setNeedsDisplay();});
            }
        }
    }
    var animationType = MBProgressHUDAnimation.Fade;
    var methodForExecution:Selector?;
    var targetForExecution:AnyObject?;
    var objectForExecution:AnyObject?;
    var useAnimation = false;
    var xoffset:CGFloat = 0;
    var yoffset:CGFloat = 0;
    var width:CGFloat = 0;
    var height:CGFloat = 0;
    var minSize:CGSize = CGSizeZero;
    var square = false;
    var margin:CGFloat = 0;
    var dimBackground = false;
    var taskInProgress = false;
    var graceTime:NSTimeInterval = 0;
    var minSHowTime:NSTimeInterval = 0;
    var graceTimer:NSTimer?;
    var minSHpwTimer:NSTimer?;
    var showStarted:NSDate?;
    var indicator:UIView?;
    var label:UILabel?
    var detailsLabel:UILabel?
    var progress:Double = 0{
        didSet
        {
            if NSThread.isMainThread()
            {
               // self.updateProgress();
                self.setNeedsLayout();
                self.setNeedsDisplay();
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                 //   self.updateProgress();
                    self.setNeedsLayout();
                    self.setNeedsDisplay();});
            }
        }
    }
    var delegate:MBProgressHUDDelegate?;
    var labelText:NSString?{
        didSet
        {
            if NSThread.isMainThread()
            {
              //  self.updateLabelText(self.labelText);
                self.setNeedsLayout();
                self.setNeedsDisplay();
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                //    self.updateLabelText(self.labelText);
                    self.setNeedsLayout();
                    self.setNeedsDisplay();});
            }
        }
    }
    var detailsLabelText:NSString?{
        didSet
        {
            if NSThread.isMainThread()
            {
              //  self.updateDetailsLabelText(self.detailsLabelText)
                self.setNeedsLayout();
                self.setNeedsDisplay();
            }else
            {
                dispatch_async(dispatch_get_main_queue(), {
                  //  self.updateDetailsLabelText(self.detailsLabelText)
                    self.setNeedsLayout();
                    self.setNeedsDisplay();});
            }
        }
    }
    var opacity:CGFloat = 0;
    var labelFont:UIFont?;
    var detailsFont:UIFont?;
    var isFinished = false;
    var removeFromSuperViewOnHide = false;
    var customView:UIView?;
    var rotationTransform:CGAffineTransform?;
    
    
    
    class func showHUDAddedTo(view:UIView, animated isAnimated:Bool)->MBProgressHUD
    {
        var hud = MBProgressHUD(view: view);
        view.addSubview(hud);
        hud.show(isAnimated);
        return hud;
    }
    class func hideHUDForView(view:UIView,animated isAnimated:Bool)->Bool
    {
        var viewToMove:UIView? = nil;
        
        for subView in view.subviews
        {
            if subView is MBProgressHUD
            {
                viewToMove = subView as? UIView;
            }
        }
        if(viewToMove != nil)
        {
            var removeView:MBProgressHUD = viewToMove as MBProgressHUD;
            removeView.removeFromSuperViewOnHide = true;
            removeView.hide(isAnimated);
        }
        
        return false;
    }
    convenience init(view:UIView)
    {
        self.init(frame: view.bounds)
        
        if view is UIWindow
        {
            self.setTransformForCurrentOrientation(false);
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil);
    }
    convenience init(window:UIWindow)
    {
        self.init(view:window);
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.animationType = MBProgressHUDAnimation.Fade;
        self.mode = MBProgressHUDMode.Indeterminate;
        self.labelText = nil;
        self.detailsLabelText = nil;
        self.opacity = 0.8;
        self.labelFont = UIFont.boldSystemFontOfSize(16);
        self.detailsFont = UIFont.boldSystemFontOfSize(12);
        self.xoffset = 0;
        self.yoffset = 0;
        self.dimBackground = false;
        self.margin = 20;
        self.graceTime = 0;
        self.minSHowTime = 0;
        self.removeFromSuperViewOnHide = false;
        self.minSize = CGSizeZero;
        self.square = false;
        self.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleRightMargin;
        self.opaque = false;
        self.backgroundColor = UIColor.clearColor();
        self.alpha = 0;
        label = UILabel(frame: self.bounds);
        detailsLabel = UILabel(frame: self.bounds);
        taskInProgress = false;
        rotationTransform = CGAffineTransformIdentity;
    }
    
    override func removeFromSuperview() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil);
        super.removeFromSuperview();
    }
    override func layoutSubviews() {
        var frame = self.bounds;
      //  var indFrame = indicator?.bounds;
        var indFrame = indicator!.bounds;
        self.width = (indFrame.size.width)+2*margin;
        self.height = (indFrame.size.height)+2*margin;
        
        indFrame.origin.x = floor((frame.size.width-indFrame.size.width/2)+CGFloat(self.xoffset))
        indFrame.origin.y = floor((frame.size.height-indFrame.size.height/2)+CGFloat(self.yoffset))
        indicator?.frame = indFrame;
        if(self.labelText != nil)
        {
        
            var dic = NSDictionary(objectsAndKeys: self.labelFont!,NSFontAttributeName);
            var dims = self.labelText?.sizeWithAttributes(dic);
            var lHeight = dims?.height;
            var lWidth:CGFloat? = 0;
            if(dims?.width <= (frame.size.width-CGFloat(4*margin)))
            {
                lWidth = dims?.width;
            }else
            {
                lWidth = (frame.size.width-CGFloat(4*margin));
            }
            
            label?.font = self.labelFont;
            label?.adjustsFontSizeToFitWidth = false;
            label?.textAlignment = NSTextAlignment.Center;
            label?.opaque = false;
            label?.backgroundColor = UIColor.clearColor();
            label?.textColor = UIColor.whiteColor();
            label?.text = self.labelText;
            
            if(self.width < (((lWidth!)+2*margin)))
            {
                self.width = ((lWidth!)+2*margin);
            }
            self.height = self.height+lHeight!+PADDING;
            indFrame.origin.y -= floor(lHeight!/2+PADDING/2);
            indicator?.frame = indFrame;
            var lFrame = CGRectMake(floor((frame.size.width - lWidth!) / 2) + xoffset,
                floor(indFrame.origin.y + indFrame.size.height + PADDING),
                lWidth!, lHeight!);
            label?.frame = lFrame;
            self.addSubview(label!);
            
            
            if (nil != self.detailsLabelText) {
                
                // Set label properties
                detailsLabel?.font = self.detailsFont;
                detailsLabel?.adjustsFontSizeToFitWidth = false;
                detailsLabel?.textAlignment = NSTextAlignment.Center;
                detailsLabel?.opaque = false;
                detailsLabel?.backgroundColor = UIColor.clearColor();
                detailsLabel?.textColor = UIColor.whiteColor();
                detailsLabel?.text = self.detailsLabelText;
                detailsLabel?.numberOfLines = 0;
                
                var maxHeight = frame.size.height - self.height - 2*margin;
                var font = UIFont.systemFontOfSize(16);
                
                var dic = NSDictionary(objectsAndKeys: self.detailsFont!,NSFontAttributeName);
            
                var text:NSString = self.detailsLabelText!;
                
                var labelSize = text.boundingRectWithSize(CGSizeMake(frame.size.width - 4*margin, maxHeight), options: NSStringDrawingOptions.UsesFontLeading, attributes: dic, context: nil).size;
                
               
                lHeight = labelSize.height;
                lWidth = labelSize.width;
                
                // Update HUD size
                if (self.width < lWidth!) {
                    self.width = lWidth! + 2 * margin;
                }
                self.height = self.height + lHeight! + PADDING;
                
                // Move indicator to make room for the new label
                indFrame.origin.y -= (floor(lHeight! / 2 + PADDING / 2));
                indicator?.frame = indFrame;
                
                // Move first label to make room for the new label
                lFrame.origin.y -= (floor(lHeight! / 2 + PADDING / 2));
                label?.frame = lFrame;
                
                // Set label position and dimensions
                var lFrameD = CGRectMake(floor((frame.size.width - lWidth!) / 2) + xoffset,
                    lFrame.origin.y + lFrame.size.height + PADDING, lWidth!, lHeight!);
                detailsLabel?.frame = lFrameD;
                
                self.addSubview(detailsLabel!);
            }
        }
        
        if (square) {
            var maxValue = max(self.width,self.height);
            if (maxValue <= frame.size.width - 2*margin) {
                self.width = maxValue;
            }
            if (maxValue <= frame.size.height - 2*margin) {
                self.height = maxValue;
            }
        }
        
        if (self.width < minSize.width) {
            self.width = minSize.width;
        } 
        if (self.height < minSize.height) {
            self.height = minSize.height;
        }
        

            
    }
      //  self.width = indFrame?.size.width;
        
    func show(animated:Bool)
    {
        useAnimation = animated;
        if self.graceTime > 0.0
        {
            var mysel = Selector("handleGraceTimer:");
            self.graceTimer = NSTimer(timeInterval: self.graceTime, target: self, selector: mysel, userInfo: nil, repeats: false);
            NSRunLoop.currentRunLoop().addTimer(self.graceTimer!, forMode: NSDefaultRunLoopMode);
        
        }else
        {
            self.setNeedsDisplay();
            self.showUsingAnimation(useAnimation);
        }
    }
    func hide(animated:Bool)
    {
        useAnimation = animated;
        if(self.minSHowTime > 0.0 && showStarted != nil)
        {
            var intrev = NSDate().timeIntervalSinceDate(showStarted!);
            if(intrev < self.minSHowTime)
            {
                self.minSHpwTimer = NSTimer.scheduledTimerWithTimeInterval((self.minSHowTime-intrev), target: self, selector: "handleMinShowTimer:", userInfo: nil, repeats: false);
                return;
            }
        }
        
        self.hideUsingAnimation(useAnimation);
        
    }
    
    func hide(animated:Bool,afterDelay:NSTimeInterval)
    {
        var timer = NSTimer(timeInterval: afterDelay, target: self, selector: "hideDelayed:", userInfo: NSNumber(bool: animated), repeats: false);
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode);
    }
    func hideDelayed(timer:NSTimer!)
    {
        
        var num = timer.userInfo as NSNumber;
        let ani = num.boolValue;
        self.hide(ani);
    }
    
    func handleMinShowTimer(timer:NSTimer!)
    {
        self.hideUsingAnimation(useAnimation);
    }
    func handleGraceTimer(timer:NSTimer!)
    {
        if(taskInProgress)
        {
            self.setNeedsDisplay();
            self.showUsingAnimation(useAnimation);
        }
    }
    func showWhileExecuting(sel:Selector?,onTarget:AnyObject?,withObject:AnyObject!,animated:Bool)
    {
        methodForExecution = sel;
        targetForExecution = onTarget;
        objectForExecution = withObject;
        taskInProgress = true;
        NSThread.detachNewThreadSelector("launchExecution", toTarget: self, withObject: nil);
        self.show(animated);
        
    }
    func lanuchExecution()
    {
        var timer = NSTimer(timeInterval: 0.1, target: targetForExecution!, selector: methodForExecution!, userInfo: objectForExecution, repeats: false);
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode);
        dispatch_async(dispatch_get_main_queue(), {self.cleanUp()});
    }
    
    func animationFinished(animationID:NSString,finished isfinshed:Bool,context mycontext:AnyObject)
    {
        self.done();
    }
   
    func done()
    {
        isFinished = true;
        self.alpha = 0;
        if(delegate != nil)
        {
            delegate?.hudWasHidden!(self);
        }
        
        if removeFromSuperViewOnHide
        {
            self.removeFromSuperview();
        }
        
    }
    func cleanUp()
    {
        taskInProgress = false;
        self.indicator = nil;
        self.hide(useAnimation);
    }
    func showUsingAnimation(animated:Bool)
    {
        self.alpha = 0;
        if(animated && animationType == MBProgressHUDAnimation.Zoom)
        {
            self.transform = CGAffineTransformConcat(rotationTransform!, CGAffineTransformMakeScale(1.5, 1.5));
        }
        self.showStarted = NSDate();
        if(animated)
        {
            UIView.beginAnimations("1", context: nil);
            UIView.setAnimationDuration(0.3);
            self.alpha = 1;
            if(animationType == MBProgressHUDAnimation.Zoom)
            {
                self.transform = rotationTransform!;
            }
            UIView.commitAnimations();
        }else
        {
            self.alpha = 1;
        }
        
    }
    func hideUsingAnimation(animated:Bool)
    {
        if(animated)
        {
            UIView.beginAnimations("2", context: nil);
            UIView.setAnimationDuration(0.3);
            UIView.setAnimationDelegate(self);
            UIView.setAnimationDidStopSelector("");
            if(animationType == MBProgressHUDAnimation.Zoom)
            {
                self.transform = CGAffineTransformConcat(rotationTransform!, CGAffineTransformMakeScale(0.5, 0.5));
            }
            self.alpha = 0.02;
            UIView.commitAnimations();
        }else
        {
            self.alpha = 0.0;
            self.done();
        }
    }
    
    override func drawRect(rect: CGRect) {
        var contect = UIGraphicsGetCurrentContext();
        if(dimBackground)
        {
            
            var gradLocationsNum:size_t = 2;
            var firstArray:Array<CGFloat> = [0.0,1];
            var secondArray:Array<CGFloat> = [0,0,0,0,0,0,0,0.75];
            var gradLocations:UnsafePointer<CGFloat> = UnsafePointer<CGFloat>(firstArray);
            var gradColors:UnsafePointer<CGFloat> = UnsafePointer<CGFloat>(secondArray);
            
            //var path = withUnsafePointer(&info, {(pointer:UnsafePointer<CGFloat>)->CGFloat});
          //  var gradLocations:UnsafePointer<CGFloat> = <0,0>;
            var colorSpace = CGColorSpaceCreateDeviceRGB();
            var gradient  = CGGradientCreateWithColorComponents(colorSpace, gradLocations, gradColors, gradLocationsNum)
        
            var gradCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            var gradRadius = min(self.bounds.size.width, self.bounds.size.height);
            var option:UInt32 = UInt32(kCGGradientDrawsAfterEndLocation);
            CGContextDrawRadialGradient(contect, gradient, gradCenter, 0, gradCenter, CGFloat(gradRadius),option);
        }
        
        
        var allRe = self.bounds;
        var boxRect = CGRectMake((allRe.size.width/2-self.width)/2+self.xoffset, (allRe.size.height/2-self.height)/2+self.yoffset, self.width, self.height);
        var radius:CGFloat = 10;
        CGContextBeginPath(contect);
        CGContextSetGrayFillColor(contect, 0, self.opacity);
        CGContextMoveToPoint(contect, CGRectGetMinX(boxRect)+radius, CGRectGetMinY(boxRect));
        CGContextAddArc(contect, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, CGFloat(3 * M_PI / 2), 0, 0);
        CGContextAddArc(contect, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, CGFloat(M_PI / 2), 0);
        CGContextAddArc(contect, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, CGFloat(M_PI / 2), CGFloat(M_PI), 0);
        CGContextAddArc(contect, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, CGFloat(M_PI), 3 * CGFloat(M_PI / 2), 0);
        CGContextClosePath(contect);
        CGContextFillPath(contect);
    }
    
    func deviceOrientationDidChange(notifite:NSNotification!)
    {
        if(nil != self.superview)
        {
            return;
        }
        if self.superview is UIWindow
        {
            self.setTransformForCurrentOrientation(true);
        }else
        {
            self.bounds = self.superview!.bounds;
            self.setNeedsDisplay();
        }
    }
    
    func radians(degress:CGFloat)->CGFloat
    {
        return degress*CGFloat(M_PI)/180;
    }
    func  setTransformForCurrentOrientation(animated:Bool)
    {
        var orientitation = UIApplication.sharedApplication().statusBarOrientation;
        var degrees:CGFloat = 0;
        if(self.superview != nil)
        {
            self.bounds = self.superview!.bounds;
            self.setNeedsDisplay();
        }
        
        if(UIInterfaceOrientationIsLandscape(orientitation))
        {
            if orientitation == UIInterfaceOrientation.LandscapeLeft
            {
                 degrees = -90;
            }else
            {
                 degrees = 90;
            }
            self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
           
        }else
        {
            if (orientitation == UIInterfaceOrientation.PortraitUpsideDown)
            { degrees = 180; }
            else
            { degrees = 0; }
            
            rotationTransform = CGAffineTransformMakeRotation(self.radians(degrees));
           
        }
        
        if animated
        {
            UIView.beginAnimations("1", context: nil);
        }
        self.transform = rotationTransform!;
        if animated
        {
            UIView.commitAnimations();
        }
        
    }
    
    func updateLabelText(newText:String?)
    {
        self.labelText = newText;
    }
    func updateDetailsLabelText(newText:String?)
    {
        self.detailsLabelText = newText;
    }
    func updateProgress()
    {
        let ind:MBRoundProgressView? = indicator as? MBRoundProgressView;
        ind?.progress = progress;
    }
    func updateIndicators()
    {
        if(indicator != nil)
        {
            indicator?.removeFromSuperview();
        }
        if(mode == MBProgressHUDMode.Determinate)
        {
            self.indicator = MBRoundProgressView();
        }else if(mode == MBProgressHUDMode.CustomView && self.customView != nil)
        {
            self.indicator = self.customView;
            
        }else
        {
            self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
            let inc = indicator as UIActivityIndicatorView;
            inc.startAnimating();
        }
        
        self.addSubview(indicator!);
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}




class MBRoundProgressView: UIView {
    var progress:Double
        {
        didSet
        {
            self.setNeedsDisplay();
        }
    };
    override init() {
        progress = 0;
        super.init(frame: CGRectMake(0, 0, 37, 37));
    }
    override init(frame: CGRect) {
         self.progress = 0;
         super.init(frame: frame);
         self.backgroundColor = UIColor.clearColor();
         self.opaque = false;
       
    }
    required init(coder aDecoder: NSCoder) {
        self.progress = 0;
        super.init(coder: aDecoder);
    }
    override func drawRect(rect: CGRect) {
        var allRect = self.bounds;
        var circleRect = CGRectInset(allRect, 2, 2);
        var context = UIGraphicsGetCurrentContext();
        //drar background
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);//white
        CGContextSetRGBFillColor(context, 1, 1, 1, 0.1);
        CGContextSetLineWidth(context, 2);
        CGContextFillEllipseInRect(context, circleRect);
        CGContextStrokeEllipseInRect(context, circleRect);
        
        // Drawing progrsss
        
        var center = CGPointMake(allRect.size.width/2, allRect.size.height/2);
        var radius = (allRect.size.width-4)/2;
        var startAngle = -(M_PI_2)/2;
        var endAngle = self.progress*2*M_PI+startAngle;
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);
        CGContextMoveToPoint(context, center.x, center.y);
        CGContextAddArc(context, center.x, center.y, radius, CGFloat(startAngle), CGFloat(endAngle), 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        
    }
    
}