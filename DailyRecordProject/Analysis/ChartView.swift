//
//  ChartView.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/11/16.
//

import UIKit

struct Slice {
    var percent: CGFloat
    var color: UIColor
}

final class ChartView: UIView {

    private let animationDuration: CGFloat = 2.0
    var slices: [Slice]?
    private var sliceIndex = 0
    private var currentPercent: CGFloat = 0.0
    
    func animateChart() {
        sliceIndex = 0
        currentPercent = 0.0
        self.layer.sublayers = nil
        removeAllLabels()
        
        if slices != nil && slices!.count > 0 {
            let firstSlice = slices![0]
            addSlice(firstSlice)
        }
    }
    
    private func addSlice(_ slice: Slice) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = getDuration(slice)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.delegate = self
        
        let canvasWidth = self.frame.width * 0.7
        let path = UIBezierPath(arcCenter: self.center, radius: canvasWidth * 3 / 8, startAngle: percentToRadian(currentPercent) + 0.0001, endAngle: percentToRadian(currentPercent+slice.percent), clockwise: true)
        
        let sliceLayer = CAShapeLayer()
        sliceLayer.path = path.cgPath
        sliceLayer.fillColor = nil
        sliceLayer.strokeColor = slice.color.cgColor
        sliceLayer.lineWidth = canvasWidth * 2 / 8
        sliceLayer.strokeEnd = 1
        sliceLayer.add(animation, forKey: animation.keyPath)
        
        self.layer.addSublayer(sliceLayer)
    }
    
    private func getLabelCenter(_ fromPercent: CGFloat, _ toPercent: CGFloat) -> CGPoint {
        let canvasWidth = self.frame.width * 0.7
        let radius = canvasWidth * 3 / 8
        
        let labelAngle = percentToRadian((toPercent - fromPercent) / 2 + fromPercent)
        let path = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: labelAngle, endAngle: labelAngle, clockwise: true)
        path.close()
        
        return path.currentPoint
    }
    
    private func removeAllLabels() {
        subviews.filter({$0 is UILabel}).forEach({$0.removeFromSuperview()})
    }
    
    private func percentToRadian(_ percent: CGFloat) -> CGFloat {
        var angle = 270 + percent * 360
        
        if angle >= 360 {
            angle -= 360
        }
        
        return angle * CGFloat.pi / 180.0
    }
    
    private func getDuration(_ slice: Slice) -> CFTimeInterval {
        return CFTimeInterval(slice.percent / 1.0 * animationDuration)
    }
}

extension ChartView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            currentPercent += slices![sliceIndex].percent
            sliceIndex += 1
            
            if sliceIndex < slices!.count {
                let nextSlice = slices![sliceIndex]
                addSlice(nextSlice)
            }
        }
    }
}
