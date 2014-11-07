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
        
        fypoint += 30;
        var labeltraceDemo = UIButton(frame: CGRectMake(30, 96, 200, 30));
        labeltraceDemo.setTitle("labeltraceDemo", forState: UIControlState.Normal);
        labeltraceDemo.backgroundColor = UIColor.purpleColor();
        labeltraceDemo.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal);
        labeltraceDemo.addTarget(self, action: "labeltraceDemo:", forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(labeltraceDemo);
    
        
        fypoint += 30;
        var buttontraceDemo = UIButton(frame: CGRectMake(30, fypoint, 200, 30));
        buttontraceDemo.setTitle("buttontraceDemo", forState: UIControlState.Normal);
        buttontraceDemo.backgroundColor = UIColor.purpleColor();
        buttontraceDemo.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal);
        buttontraceDemo.addTarget(self, action: "buttontraceDemo:", forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(buttontraceDemo);
        
        fypoint += 30;
        var MBtraceDemo = UIButton(frame: CGRectMake(30, fypoint, 200, 30));
        MBtraceDemo.setTitle("MBtraceDemo", forState: UIControlState.Normal);
        MBtraceDemo.backgroundColor = UIColor.purpleColor();
        MBtraceDemo.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal);
        MBtraceDemo.addTarget(self, action: "MBtraceDemo:", forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(MBtraceDemo);
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func MBtraceDemo(sender:UIButton!)
    {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true);
    /*
        var hud = MBProgressHUD(view: self.view);
        hud.labelText = "正在加载中";
        self.view.addSubview(hud);
        hud.show(true);*/
        
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
    
    func buttontraceDemo(sender:UIButton!)
    {
        var buttonTrace = JFButtonTrace(frame: CGRectMake(0, 500, 150, 35), shadowColor: UIColor.purpleColor(), textColor: UIColor.greenColor(), title: "我魔怔了嘛");
        self.view.addSubview(buttonTrace);
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

