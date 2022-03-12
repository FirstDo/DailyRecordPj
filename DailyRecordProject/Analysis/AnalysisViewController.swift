//
//  AnalysisViewController.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/09/28.
//

import UIKit
import SnapKit

final class AnalysisViewController: UIViewController {
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "\(Date.month)월달의 기록 🧐"
        lb.font = UIFont.boldSystemFont(ofSize: 35)
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showMoodChart()
    }
    
    private func setConstraint() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        let indexView = IndexStackView()
        view.addSubview(indexView)
        indexView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
    }
    
    private func showMoodChart() {
        var percentList: [CGFloat] = [0,0,0,0]
        var colorList: [UIColor] = [colorDict["happy"], colorDict["sad"], colorDict["soso"],colorDict["angry"]].compactMap{$0}
        
        let month = UserDefaults.standard.value(forKey: UserDefaultKey.listMonth) as? Int16 ?? Date().month
        let year = UserDefaults.standard.value(forKey: UserDefaultKey.listYear) as? Int16 ?? Date().year
        
        titleLabel.text = "\(month)월달의 기록 🧐"
        
        let list = DataManager.shared.fetchTask(month, year)
        
        if list.count == 0 {
            drawPieChart([],[])
            return
        }
        
        list.forEach{ value in
            let mood = value.mood!
            
            switch mood {
            case "happy":
                percentList[0] += 1
            case "sad":
                percentList[1] += 1
            case "soso":
                percentList[2] += 1
            case "angry":
                percentList[3] += 1
            default:
                break
            }
        }
        
        for i in stride(from: 3, through: 0, by: -1) {
            if percentList[i] == 0 {
                percentList.remove(at: i)
                colorList.remove(at: i)
            }
        }
        
        let total = CGFloat(list.count)
        percentList = percentList.map{$0/total}
        
        drawPieChart(percentList,colorList)
    }
    
    private func drawPieChart(_ percent: [CGFloat], _ color: [UIColor]) {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        if let existView = self.view.viewWithTag(100) {
            existView.removeFromSuperview()
        }
        
        let pieChartView = ChartView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        pieChartView.tag = 100
        pieChartView.center = self.view.center
        
        var sliceArr = [Slice]()
        
        for i in 0..<percent.count {
            sliceArr.append(Slice(percent: percent[i], color: color[i]))
        }
        
        pieChartView.slices = sliceArr
        
        view.addSubview(pieChartView)
        pieChartView.animateChart()
    }
}
