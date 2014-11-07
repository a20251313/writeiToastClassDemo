//
//  JFAlertView.swift
//  writeItoastInswift
//
//  Created by jingfuran on 14/11/6.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit

enum JFAlertViewClickIndex:Int
{
    case    None = -1
    case    Left = 0
    case    Right
    case    Remove
}


@objc(JFAlertViewDeledate)
protocol JFAlertViewDeledate
{
   optional func JFAlertClickView(alertView:JFAlertView,buttonIndex:Int);
   optional func dismissWithClickedButtonIndex(buttonindex:Int,animated:Bool);
}

class JFAlertView: UIView {

    var m_bIsWillRemove = false;
    var backgroundImageView:UIImageView?;
    var contentLabel:JFLabelTrace?;
    var rightButton:JFButtonTrace?;
    var leftButton:JFButtonTrace?;
    var overlayView:UIView?;
    var delegate:JFAlertViewDeledate?;
    var leftTitle:String?;
    var rightTitle:String?;
    var propmt:String?;
    var warningMsg:String?;
    var cancelButtonIndex = JFAlertViewClickIndex.Remove;
    var leftButtonIndex = JFAlertViewClickIndex.Left;
    var rightButtonIndex = JFAlertViewClickIndex.Right;
  

    init(title:String? ,message:String?,delegate:JFAlertViewDeledate? ,cancelButtonTitle:String?, otherButtonTitles:String?)
    {
        super.init(frame:UIScreen.mainScreen().bounds);
        m_bIsWillRemove = false;
        if(cancelButtonTitle != nil)
        {
            self.leftButtonIndex = JFAlertViewClickIndex.Left;
            self.cancelButtonIndex = JFAlertViewClickIndex.Remove;
        }else
        {
            self.leftButtonIndex = JFAlertViewClickIndex.None;
            self.cancelButtonIndex = JFAlertViewClickIndex.None;
        }
        
        if(otherButtonTitles != nil)
        {
            self.rightButtonIndex = JFAlertViewClickIndex.Right;
        }else
        {
            self.rightButtonIndex = JFAlertViewClickIndex.None;
        }
        
        self.delegate = delegate;
        self.leftTitle = cancelButtonTitle;
        self.rightTitle = otherButtonTitles;
        self.propmt = title;
        self.warningMsg = message;
        self.defaultInit();
    }
    
    func defaultInit()
    {
        overlayView = UIView(frame: UIScreen.mainScreen().bounds);
        var frame = UIScreen.mainScreen().bounds;
        overlayView?.frame = frame;
        self.frame = frame;
        overlayView?.backgroundColor = UIColor(red: 0.16, green: 0.17, blue: 0.20, alpha: 0.5);
       // backgroundImageView = uiii
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
