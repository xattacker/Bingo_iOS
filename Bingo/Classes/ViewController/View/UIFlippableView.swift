//
//  UIFlippableView.swift
//  Bingo
//
//  Created by JmoVxia on 2019/12/26.
//  Modified by xattacker on 2020/12/10.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

import UIKit


public protocol UIFlippableViewDelegate: class
{
    func onFlipStarted(flipped: UIFlippableView)
    func onFlipEnded(flipped: UIFlippableView)
}


public class UIFlippableView: UIView
{
    public weak var delegate: UIFlippableViewDelegate?
    
    ///是否翻面
    private(set) public var isFlipped: Bool = false
    
    ///动画时间
    private var duration: Double = 0.5
    
    ///动画次数
    private var repeatCount = Int64.max
    
    ///动画执行次数
    private var animatedCount: Int = 0
    ///是否停止
    private var isStop: Bool = true
    
    ///是否暂停
    private var isPause: Bool = false
    
    private var positiveView: UIView?
    private var negativeView: UIView?
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.positiveView?.frame = self.bounds
        self.negativeView?.frame = self.bounds
    }

    public func setupFlipView(_ positive: UIView, opposite: UIView)
    {
        self.positiveView = positive
        self.negativeView = opposite
        
        self.addSubview(positive)
        self.layoutSubviews()
    }
    
    public func flip(_ animated: Bool = true, _ duration: Double = 1)
    {
        if animated
        {
            self.duration = duration
            self.repeatCount = 1
            self.startAnimation()
        }
        else
        {
            self.replaceView()
        }
    }
    
    ///开始动画
    public func startAnimation(_ duration: Double = 1)
    {
        if !self.isStop
        {
            return
        }
        
        self.isStop = false
        self.duration = duration
        self.startFlipAnimation()
    }
    
    ///停止动画
    public func stopAnimation()
    {
        if self.isStop
        {
            return
        }
        
        self.isStop = true
        self.layer.removeAllAnimations()
        self.resumeAnimation()
    }
    
    ///暂停动画
    public func pauseAnimation()
    {
        if self.isPause
        {
            return
        }
        
        
        self.isPause = true
        
        //取出当前时间,转成动画暂停的时间
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        self.layer.speed = 0
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        self.layer.timeOffset = pausedTime
    }
    
    ///恢复动画
    public func resumeAnimation()
    {
        if !self.isPause
        {
            return
        }
        
        self.isPause = false
        //获取暂停的时间差
        let pausedTime = self.layer.timeOffset
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let offset = self.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = offset
    }

    deinit
    {
        self.positiveView = nil
        self.negativeView = nil
        
        self.delegate = nil
    }
}


extension UIFlippableView: CAAnimationDelegate
{
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        if self.isStop
        {
            return
        }
        
        self.animatedCount += 1
        self.delegate?.onFlipEnded(flipped: self)
        
        if self.animatedCount < self.repeatCount
        {
            self.startFlipAnimation()
        }
        else
        {
            self.stopAnimation()
        }
    }
    
    private func startFlipAnimation()
    {
        let animation = CAKeyframeAnimation()
        animation.values = [NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 1, 0)),
                            NSValue(caTransform3D: CATransform3DMakeRotation(.pi / 2, 0, 1, 0)),
                            NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 1, 0))]
        animation.isCumulative = false
        animation.duration = CFTimeInterval(self.duration)
        animation.repeatCount = 1
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "transform")
        self.perform(#selector(replaceView), with: nil, afterDelay: duration * 0.5)
        
        self.delegate?.onFlipStarted(flipped: self)
    }
    
    @objc private func replaceView()
    {
//        if self.isStop || self.isPause
//        {
//            return
//        }
        
        
        self.isFlipped = !self.isFlipped
        
        if self.isFlipped
        {
            if let view = self.negativeView
            {
                self.addSubview(view)
            }
            
            self.positiveView?.removeFromSuperview()
        }
        else
        {
            if let view = self.positiveView
            {
                self.addSubview(view)
            }
            
            self.negativeView?.removeFromSuperview()
        }
    }
}
