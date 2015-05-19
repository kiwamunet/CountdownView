//
//  DemoViewController.swift
//  CountdownView
//
//  Created by suzuki_kiwamu on 2015/05/18.
//  Copyright (c) 2015年 suzuki_kiwamu. All rights reserved.
//

import UIKit

class DeomViewController: UIViewController, CountDownViewDelegate {

    @IBOutlet weak var countDownView: CountDownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countDownView.delegate = self
        self.countDownView.countLabelTextColor = UIColor.blackColor()
        self.countDownView.circleLayerColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    @IBAction func upStart(sender: AnyObject) {
        self.countDownView.countUp()
    }
 
    @IBAction func downStart(sender: AnyObject) {
        self.countDownView.countDown()
    }
    
    
    
    
    // MARK: CountDownViewDelegate
    func endCount() {
        println("おわったよ")
    }
    
}

