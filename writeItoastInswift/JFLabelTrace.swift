//
//  JFLabelTrace.swift
//  writeItoastInswift
//
//  Created by jingfuran on 14/11/6.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit

class JFLabelTrace: UILabel {

    var textShadowColor = UIColor.clearColor();
    init(frame:CGRect,withShadowColor shadowColor:UIColor,offsetsize offset:CGSize,textColor mytextColor:UIColor)
    {
        super.init(frame: frame);
        super.shadowColor = shadowColor;
        super.shadowOffset = offset;
        super.textColor = textColor;
        super.backgroundColor = UIColor.clearColor();
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextShadowColor(textshadowColor:UIColor)
    {
        self.shadowColor = textshadowColor;
    }
    
    override func drawTextInRect(rect: CGRect) {
        var shadowOffet = self.shadowColor;
        var textcolor = self.textColor;
        var c = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(c, 1);
        CGContextSetLineJoin(c, kCGLineJoinRound);
        CGContextSetTextDrawingMode(c, kCGTextFillStroke);
        self.textColor = self.shadowColor;
        super.drawTextInRect(rect);
        
        CGContextSetTextDrawingMode(c, kCGTextFill);
        self.textColor = textColor;
        self.shadowOffset = CGSizeMake(0, 0);
        super.drawTextInRect(rect);
        self.shadowOffset = shadowOffset;
        
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
