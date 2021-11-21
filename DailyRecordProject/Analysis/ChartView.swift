//
//  ChartView.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/16.
//

import UIKit

struct Slice {
    var percent: CGFloat
    var color: UIColor
}

class ChartView: UIView {

    let animationDuration: CGFloat = 2.0
    var slices: [Slice]?
    var sliceIndex = 0
    var currentPercent: CGFloat = 0.0
    
    func animateChart() {
        print(#function)
        sliceIndex = 0
        currentPercent = 0.0
        self.layer.sublayers = nil
        removeAllLabels()
        
        if slices != nil && slices!.count > 0 {
            let firstSlice = slices![0]
            addSlice(firstSlice)
            addLabel(firstSlice)
        }
    }
    
    //pieChart 그리기
    func addSlice(_ slice: Slice) {
        print(#function)
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
    
    //lable 그리기
    func addLabel(_ slice: Slice) {
        print(#function)
        let center = self.center
        let labelCenter = getLabelCenter(currentPercent, currentPercent + slice.percent)
        
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        addSubview(label)
        
        let roundedPercentage = round(slice.percent * 1000) / 10
        
        var temp = ""
        
        switch slice.color {
        case .systemYellow:
            temp = "🌈\n"
        case .systemBlue:
            temp = "💦\n"
        case .systemGreen:
            temp = "🌤\n"
        case .systemRed:
            temp = "🔥\n"
        default:
            break
        }
        label.text = temp + "\(roundedPercentage)%"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: labelCenter.x - center.x).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenter.y - center.y).isActive = true
        self.layoutIfNeeded()
    }
    
    private func getLabelCenter(_ fromPercent: CGFloat, _ toPercent: CGFloat) -> CGPoint {
        let canvasWidth = self.frame.width * 0.7
        let radius = canvasWidth * 3 / 8
        
        let labelAngle = percentToRadian((toPercent - fromPercent) / 2 + fromPercent)
        let path = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: labelAngle, endAngle: labelAngle, clockwise: true)
        path.close()
        
        return path.currentPoint
    }
    
    func removeAllLabels() {
        subviews.filter({$0 is UILabel}).forEach({$0.removeFromSuperview()})
    }
    
    func percentToRadian(_ percent: CGFloat) -> CGFloat {
        var angle = 270 + percent * 360
        if angle >= 360 {
            angle -= 360
        }
        return angle * CGFloat.pi / 180.0
    }
    
    func getDuration(_ slice: Slice) -> CFTimeInterval {
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
                addLabel(nextSlice)
            }
        }
    }
}
