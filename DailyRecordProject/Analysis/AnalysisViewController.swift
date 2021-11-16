//
//  AnalysisViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/28.
//

import UIKit

class AnalysisViewController: UIViewController {
    //연속일수를 저장할 레이블 두개
    let maxLenLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 20)
        return lb
    }()
    
    let currentLenLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 30)
        return lb
    }()
    
    
    func setConstraint() {
        view.addSubview(currentLenLabel)
        currentLenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        currentLenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        view.addSubview(maxLenLabel)
        maxLenLabel.leadingAnchor.constraint(equalTo: currentLenLabel.leadingAnchor).isActive = true
        maxLenLabel.topAnchor.constraint(equalTo: currentLenLabel.bottomAnchor, constant: 10).isActive = true
        
        let idxView = IndexView()
        view.addSubview(idxView)
        idxView.translatesAutoresizingMaskIntoConstraints = false
        idxView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        idxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        idxView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.4).isActive = true
        idxView.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.10).isActive = true
        
        
    }
    
    func calculateLen() {
        let curInt = 10
        let curStr = String(curInt)
        
        let maxInt = 10
        let maxStr = String(maxInt)
        
        currentLenLabel.text = "현재 "+curStr+"일 기록중"
        maxLenLabel.text = "최고 "+maxStr+"일 연속 기록"
        
        let currentText = currentLenLabel.text!
        let maxText = maxLenLabel.text!
        
        let curRange = (currentText as NSString).range(of: curStr)
        let maxRange = (maxText as NSString).range(of: maxStr)
        changeFontSize(currentText, size: 40, range: curRange, type: 0)
        changeFontSize(maxText, size: 30, range: maxRange, type: 1)
    }
    
    func drawPieChart() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let pieChartView = ChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        pieChartView.center = self.view.center
        pieChartView.slices = [Slice(percent: 0.2, color: .systemYellow),
                               Slice(percent: 0.3, color: .systemBlue),
                               Slice(percent: 0.4, color: .systemGreen),
                               Slice(percent: 0.1, color: .systemRed)]
        
        view.addSubview(pieChartView)
        pieChartView.animateChart()
        
        print(pieChartView.frame)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraint()
        calculateLen()
        drawPieChart()
    }
    
    func changeFontSize(_ text: String, size: CGFloat, range: NSRange, type: Int) {
        let attributedStr = NSMutableAttributedString(string: text)
        let fontSize = UIFont.boldSystemFont(ofSize: size)
        
        attributedStr.addAttribute(.font, value: fontSize, range: range)
        
        if type == 0 {
            currentLenLabel.attributedText = attributedStr
            currentLenLabel.sizeToFit()
        } else {
            maxLenLabel.attributedText = attributedStr
            maxLenLabel.sizeToFit()
        }
    }
}
