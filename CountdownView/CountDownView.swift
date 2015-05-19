//
//  CountDownView.swift
//  CountdownView
//
//  Created by suzuki_kiwamu on 2015/05/18.
//  Copyright (c) 2015年 suzuki_kiwamu. All rights reserved.
//

import UIKit

protocol CountDownViewDelegate {
    func endCount()
}


private var animationForKey = "circleAnimation"
private var animationLayer = "animationLayer"
private var firstLayerKey = "firstLayerKey"
private var secondLayerKey = "secondLayerKey"

class CountDownView: UIView {
    
    var mainView: UIView?
    var delegate: CountDownViewDelegate?
    var countMax: Int = 5
    var countMin: Int = 1
    var countNum: Int = 5
    
    var circleViewBackgroundColor = UIColor.clearColor()
    var circleLayerColor = UIColor.whiteColor()
    var circleFirstLayerAlpha: CGFloat = 0.2
    var circleSecondLayerAlpha: CGFloat = 1.0
    var circleLineWidth: CGFloat = 20
    var circleDrawAnimationDuration = 1.0
    var circleDrawAnimationRepeatCount: Float = 1.0
    
    
    var countLabelTextColor = UIColor.whiteColor()
    var countLabelFont = UIFont.systemFontOfSize(40)
    
    var isCountDown = false
    var firstLayer: CALayer?
    var secondLayer: CALayer?
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    
    
    override func awakeFromNib() {
        // mainとなるviewを決定
        self.mainView = NSBundle.mainBundle().loadNibNamed("CountDownView", owner: self, options: nil).first as? UIView
        addSubview(self.mainView!)
    }
    
    
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.customizeView()
    }
    
    
    
   
    
    
    
    
    // MARK: Method
    func countDown() {
        
        self.isCountDown = true
        
        self.countNum = self.countMax
        self.countLabel.text = String(self.countNum)
        self.setupCircleLayer()
        
        // アニメーション開始
        self.circleAnimation(self.circleView.layer.valueForKey(secondLayerKey) as! CAShapeLayer)
    }
    
    func countUp() {
        
        self.isCountDown = false
        
        self.countNum = countMin
        self.countLabel.text = String(self.countNum)
        self.setupCircleLayer()
        
        // アニメーション開始
        self.circleAnimation(self.circleView.layer.valueForKey(secondLayerKey) as! CAShapeLayer)
    }
    
    func dismissLayer() {
        self.firstLayer?.removeFromSuperlayer()
        self.secondLayer?.removeFromSuperlayer()
    }
    
    func removeAnimation() {
        self.circleView.layer.removeAnimationForKey(animationForKey)
    }
    
    
    


    // MARK: Private Method
    private func customizeView() {
        //---- circleView backgroundColor = default (clearColor)
        self.circleView.backgroundColor = circleViewBackgroundColor
        
        //---- countDownLabel textColor = default (whiteColor)
        self.countLabel.textColor = countLabelTextColor
        //--- countDownLabel font = default (systemFontOfSize(40))
        self.countLabel.font = countLabelFont
    }
    
    private func setupCircleLayer() {
        firstLayer = drawCircle(circleView.frame.width, strokeColor: circleLayerColor.colorWithAlphaComponent(circleFirstLayerAlpha))
        secondLayer = drawCircle(circleView.frame.width, strokeColor: circleLayerColor.colorWithAlphaComponent(circleSecondLayerAlpha))
        
        self.circleView.layer.addSublayer(firstLayer)
        self.circleView.layer.addSublayer(secondLayer)
        
        self.circleView.layer.setValue(firstLayer, forKey: firstLayerKey)
        self.circleView.layer.setValue(secondLayer, forKey: secondLayerKey)
    }
    
    private func drawCircle(viewWidth:CGFloat, strokeColor:UIColor) -> CAShapeLayer {
        var circle:CAShapeLayer = CAShapeLayer()
        let lineWidth: CGFloat = circleLineWidth
        let viewScale: CGFloat = viewWidth
        let radius: CGFloat = viewScale - lineWidth
        circle.path = UIBezierPath(roundedRect: CGRectMake(0, 0, radius, radius), cornerRadius: radius / 2).CGPath
        circle.position = CGPointMake(lineWidth / 2, lineWidth / 2)
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = strokeColor.CGColor
        circle.lineWidth = lineWidth
        return circle
    }
    
    private func circleAnimation(layer:CAShapeLayer) {
        var drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.setValue(layer, forKey:animationLayer)
        drawAnimation!.delegate = self
        drawAnimation!.duration = circleDrawAnimationDuration
        drawAnimation!.repeatCount = circleDrawAnimationRepeatCount
        drawAnimation!.fromValue = 0.0
        drawAnimation!.toValue = 1.0
        drawAnimation!.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        layer.addAnimation(drawAnimation, forKey: animationForKey)
    }
    
    private func endAnimation() {
//        self.countLabel.hidden = true
//        self.circleView.hidden = true
        self.dismissLayer()
        self.delegate?.endCount()
    }
    
    
    
    
    
    // MARK: CAAnimation Delegate Method
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if !flag { return }
        let layer:CAShapeLayer = anim.valueForKey(animationLayer) as! CAShapeLayer
        
        if isCountDown {
            countNum--
            self.countLabel.text = String(countNum)
            if countNum <= 0 {
                self.endAnimation()
            } else {
                circleAnimation(layer)
            }
        } else {
            countNum++
            self.countLabel.text = String(countNum)
            if countNum > countMax {
                self.endAnimation()
            } else {
                circleAnimation(layer)
            }
        }
    }
}
