//
//  AnalysisViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/28.
//

import UIKit

class AnalysisViewController: UIViewController {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "이번달의 기록 📑"
        lb.font = UIFont.boldSystemFont(ofSize: 30)
        return lb
    }()
    
    func setConstraint() {
        let lb = titleLabel
        view.addSubview(lb)
        lb.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        lb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        let idxView = IndexView()
        view.addSubview(idxView)
        idxView.translatesAutoresizingMaskIntoConstraints = false
        idxView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        idxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        idxView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.4).isActive = true
        idxView.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.10).isActive = true
    }
    
    func drawPieChart(_ percent: [CGFloat], _ color: [UIColor]) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var percentList: [CGFloat] = [0,0,0,0]
        var colorList: [UIColor] = [.systemYellow, .systemBlue, .systemGreen, .systemRed]
        
        let month = Date().month
        let year = Date().year
        
        let list = DataManager.shared.fetchTask(Int16(month), Int16(year))
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraint()
    }
}
