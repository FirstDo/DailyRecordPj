//
//  ViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/28.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController{
    //notification
    var token: NSObjectProtocol?
    //dailyInfo
    var temp = [DailyInfoEntity]()
    var listDict  = [Int: DailyInfoEntity]()
    
    var globalEntity: DailyInfoEntity?
    
    //scrollView
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    //stackView
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }()
    
    //FSCalendar
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 40
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let contentView: ContentView = {
        let v = ContentView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tapButton.addTarget(self, action: #selector(tapUserWrite), for: .touchUpInside)
        return v
    }()
    
    @objc func tapUserWrite() {
        let ac = UIAlertController(title: "무엇을 할까요?", message: nil, preferredStyle: .actionSheet)
        
        guard let target = globalEntity else {
            return
        }
        
        print(target)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            DataManager.shared.deleteTask(entity: target) {
                NotificationCenter.default.post(name: .dataChanged, object: nil)
            }
        }
        
        let edit = UIAlertAction(title: "수정", style: .default) { _ in
            let editVC = InputViewController()
            InputViewController.entity = target
            UserInputData.shared.setData(date: target.date, mood: target.mood, good: target.good, bad: target.bad, thanks: target.thanks, highlight: target.highlight, month: target.month, year: target.year)
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        
        ac.addAction(edit)
        ac.addAction(delete)
        ac.addAction(cancel)
        
        self.present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //초기화 코드: 현재 페이지의 년 월 로 fetch
        let currentPageData = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageData)
        let year = Calendar.current.component(.year, from: currentPageData)
        //temp에 data fetch
        temp = DataManager.shared.fetchTask(Int16(month), Int16(year))
        //listDict에 일: entity 로 정렬
        temp.forEach { entity in
            let date = entity.date
            if let idx = date?.lastIndex(of: "."), let day = Int((date?[idx...].dropFirst())!) {
                listDict[day] = entity
            }
        }
        
        //옵져버
        token = NotificationCenter.default.addObserver(forName: .dataChanged, object: nil, queue: .main, using: { _ in
            let currentPageData = self.calendar.currentPage
            let month = Calendar.current.component(.month, from: currentPageData)
            let year = Calendar.current.component(.year, from: currentPageData)
            //temp에 data fetch
            self.temp = DataManager.shared.fetchTask(Int16(month), Int16(year))
            //listDict에 일: entity 로 정렬
            self.listDict.removeAll()
            self.temp.forEach { entity in
                let date = entity.date
                if let idx = date?.lastIndex(of: "."), let day = Int((date?[idx...].dropFirst())!) {
                    self.listDict[day] = entity
                }
            }
            self.contentView.isHidden = true
        })
        view.backgroundColor = .systemBackground
        
        let backBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarBtn
        
        stackViewSetting()
        scrollViewSetting()
        calendarSetting()
        contentViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.isNavigationBarHidden = true
        print(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.navigationController?.isNavigationBarHidden = false
        print(#function)
    }
}

//MARK: - scrollView, contentView, calendar
extension CalendarViewController {
    func stackViewSetting() {
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func scrollViewSetting() {
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        scrollView.addSubview(calendar)
    }
    
    func calendarSetting() {
        calendar.delegate = self
        calendar.dataSource = self
        let calendarHeight = view.frame.size.height / 3.0 * 2.0
        calendar.heightAnchor.constraint(equalToConstant: calendarHeight).isActive = true
        stackView.addArrangedSubview(calendar)
    }
    
    func contentViewSetting() {
        contentView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(contentView)
        contentView.isHidden = true
    }
}


extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko-kr")
        let selectedDate = formatter.string(from: date)
        
        let day = Calendar.current.component(.day, from: date)
        
        //내용이 있으면 해당 내용을 보여주고
        if let entity = listDict[day]{
            contentView.setData(entity)
            globalEntity = entity
            contentView.isHidden = false
        } else {
            //내용이 없으면 새 내용을 만들자.
            contentView.isHidden = true
            
            //초기화
            UserInputData.shared.cleanData()
            InputViewController.entity = nil
            
            //날짜와 달 설정
            UserInputData.shared.date = selectedDate
            
            let curDate = Calendar.current.dateComponents([.month, .year], from: date)
            let (month, year) = (Int16(curDate.month!), Int16(curDate.year!))

            UserInputData.shared.month = month
            UserInputData.shared.year = year
            //push
            navigationController?.pushViewController(InputViewController(), animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("deselect")
    }
}

