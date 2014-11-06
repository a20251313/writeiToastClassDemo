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
    case    JFAlertViewClickIndexNone = -1
    case    JFAlertViewClickIndexLeft = 0
    case    JFAlertViewClickIndexRight
    case    JFAlertViewClickIndexRemove
}


@objc(JFAlertViewDeledate)
protocol JFAlertViewDeledate
{
   optional func JFAlertClickView(alertView:JFAlertView,buttonIndex:Int);
   optional func dismissWithClickedButtonIndex(buttonindex:Int,animated:Bool);
}

class JFAlertView: UIView {

    var m_bIsWillRemove = false;
    var _backgroundImageView:UIImageView?;

}
