//
//  CircularProgressBarView.swift
//  Pomodoro
//
//  Created by Sergey Myzin on 26.09.2021.
//

import UIKit

class CircularProgressBarView: UIView {
    
    // MARK: - Properties -
    private var circleLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    // MARK: - Colors -
    var progressColorGreen = UIColor(red: 0.24, green: 0.70, blue: 0.44, alpha: 1.00)
    var circleColorGreen = UIColor(red: 0.56, green: 0.93, blue: 0.56, alpha: 1.00)
    
    var progressColorRed = UIColor(red: 0.70, green: 0.13, blue: 0.13, alpha: 1.00)
    var circleColorRed = UIColor(red: 1.00, green: 0.39, blue: 0.28, alpha: 1.00)
    
    // MARK: - Variables to animate -
    var progressStrokeEnd: CGFloat = 0.0
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    // MARK: - Functions - 
    func changeColors(type: String) {
        if type == "red" {
            progressLayer.strokeColor = progressColorRed.cgColor
            circleLayer.strokeColor = circleColorRed.cgColor
        } else {
            progressLayer.strokeColor = progressColorGreen.cgColor
            circleLayer.strokeColor = circleColorGreen.cgColor
        }
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.height / 2.0), radius: 80, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 4.5
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = circleColorRed.cgColor
        
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 3.0
        progressLayer.strokeEnd = progressStrokeEnd
        progressLayer.strokeColor = progressColorRed.cgColor
        
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.fromValue = 1.0
        circularProgressAnimation.toValue = 0.0
        circularProgressAnimation.fillMode = .backwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
