//
//  PulseLayer.swift
//  iTranslateSample01
//
//  Created by Anuradh Caldera on 10/19/19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

class PulseLayer: CALayer {

    private let blueColor: UIColor = UIColor.init(red: 26/255, green: 152/255, blue: 255/255, alpha: 1)
    private var animationGroup: CAAnimationGroup!
    var animationDuration: TimeInterval = 2.0
    private var radius: CGFloat = 200
    private var numberofPulses: Float = .infinity
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_numberofPulses: Float = .infinity, _radius: CGFloat, _position: CGPoint) {
        super.init()
        
        self.backgroundColor = blueColor.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.numberofPulses = _numberofPulses
        self.radius = _radius
        self.position = _position
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        
        DispatchQueue.global(qos: .default).async {
            self.setupAnimationGroup()
            
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulseGroup")
            }
        }
    }
}

//MARK: - Create Scale Animation
extension PulseLayer {
    private func createScaleAnimation() -> CABasicAnimation {
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 1
        scaleAnimation.duration = animationDuration
        
        return scaleAnimation
    }
}

//MARK: - Crate Opacity Animation
extension PulseLayer {
    private func createOpacityAnimation() -> CAKeyframeAnimation {
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.9, 0.0]
        opacityAnimation.keyTimes = [0, 0.2, 1.0]
        
        return opacityAnimation
    }
}

//MARK: - Setup Animation Group
extension PulseLayer {
    private func setupAnimationGroup() {
        animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = numberofPulses
        animationGroup.timingFunction = CAMediaTimingFunction(name: .default)
        animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
}
