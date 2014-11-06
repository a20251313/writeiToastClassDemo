//
//  ViewController.swift
//  writeItoastInswift
//
//  Created by jingfuran on 14/11/5.
//  Copyright (c) 2014年 jingfuran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var  fypoint:CGFloat = 66.0;
        var buttonDemo = UIButton(frame: CGRectMake(0, 66, 100, 30));
        buttonDemo.setTitle("DemoShow", forState: UIControlState.Normal);
        buttonDemo.backgroundColor = UIColor.purpleColor();
        buttonDemo.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal);
        buttonDemo.addTarget(self, action: "itoastDemo:", forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(buttonDemo);
        self.view.backgroundColor = UIColor.whiteColor();
        
        
        var labeltraceDemo = UIButton(frame: CGRectMake(30, 96, 200, 30));
        labeltraceDemo.setTitle("labeltraceDemo", forState: UIControlState.Normal);
        labeltraceDemo.backgroundColor = UIColor.purpleColor();
        labeltraceDemo.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal);
        labeltraceDemo.addTarget(self, action: "labeltraceDemo:", forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(labeltraceDemo);
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func itoastDemo(sender:UIButton!)
    {
        var toast = iToast(text: "哈哈这是DEMO");
        toast.setGravity(iToastGravity.iToastGravityBottom);
        toast.show();
        
    }
    func labeltraceDemo(sender:UIButton!)
    {
        var labelTrace = JFLabelTrace(frame: CGRectMake(0, 300, 120, 45), withShadowColor: UIColor.greenColor(), offsetsize: CGSizeMake(1, 1), textColor: UIColor.blackColor());
        labelTrace.text = "我魔怔了嘛";
      //  labelTrace.setTextShadowColor(UIColor.greenColor());
      //  labelTrace.backgroundColor = UIColor.lightGrayColor();
        self.view.addSubview(labelTrace);
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

