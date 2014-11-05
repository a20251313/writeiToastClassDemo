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
        
        var buttonDemo = UIButton(frame: CGRectMake(0, 200, 100, 30));
        buttonDemo.setTitle("DemoShow", forState: UIControlState.Normal);
        buttonDemo.backgroundColor = UIColor.purpleColor();
        buttonDemo.setTitleColor(UIColor.blackColor(), forState:UIControlState.Normal);
        buttonDemo.addTarget(self, action: "clickDemo:", forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(buttonDemo);
        self.view.backgroundColor = UIColor.purpleColor();
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func clickDemo(sender:UIButton!)
    {
        var toast = iToast(text: "哈哈这是DEMO");
        toast.setGravity(iToastGravity.iToastGravityBottom);
        toast.show();
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

