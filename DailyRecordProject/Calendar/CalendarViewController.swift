//
//  ViewController.swift
//  DailyRecordProject
//
//  Created by DuDu on 2021/09/28.
//

import UIKit
import FSCalendar
import StoreKit
import SnapKit

final class CalendarViewController: UIViewController {
    private var dataChangedObserver: NSObjectProtocol?
    private var weekChangedObserver: NSObjectProtocol?
    
    private var tempList = [DailyInfoEntity]()
    private var listDict  = [Int: DailyInfoEntity]()
    
    private var globalEntity: DailyInfoEntity?
    
    private lazy var formatter :DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko-kr")
        return formatter
    }()
    
    private let indexView: IndexStackView = {
        let view = IndexStackView()
        return view
    }()
    
    private let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.headerHeight = 40
        calendar.placeholderType = .none
        
        calendar.appearance.weekdayTextColor = .CustomBlack
        calendar.appearance.headerTitleColor = .CustomBlack
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        return calendar
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.setImage(UIImage(systemName: "greaterthan.circle"), for: .normal)
        btn.tintColor = UIColor.CustomBlack
        
        return btn
    }()
    
    private lazy var prevButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.setImage(UIImage(systemName: "lessthan.circle"), for: .normal)
        btn.tintColor = UIColor.CustomBlack
        
        return btn
    }()
    
    @objc private func nextTapped() {
        let date = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)!
        calendar.setCurrentPage(date, animated: true)
    }
    
    @objc private func previousTapped() {
        let date = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage)!
        calendar.setCurrentPage(date, animated: true)
    }
    
    private lazy var contentView: ContentView = {
        let contentView = ContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.editButton.addTarget(self, action: #selector(editReport), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(deleteReport), for: .touchUpInside)
        
        return contentView
    }()
    
    @objc private func editReport() {
        if let target = globalEntity {
            let editVC = InputViewController()
            
            InputViewController.entity = target
            UserInputData.shared.setData(date: target.date,
                                         mood: target.mood,
                                         good: target.good,
                                         bad: target.bad,
                                         thanks: target.thanks,
                                         highlight: target.highlight,
                                         month: target.month,
                                         year: target.year)
            
            navigationController?.pushViewController(editVC, animated: true)
        }
        else {
            navigationController?.pushViewController(InputViewController(), animated: true)
        }
    }
    @objc private func deleteReport() {
        guard let target = globalEntity else {
            return
        }
        
        let alertController = UIAlertController(title: "정말 삭제할까요?", message: nil, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            DataManager.shared.deleteTask(entity: target) {
                NotificationCenter.default.post(name: .dataChanged, object: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        setUpData()
        
        addWeekChangedObserver()
        addDataChangedObserver()

        setUpCalender()
        setUpContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.navigationController?.isNavigationBarHidden = false
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
        let backBarBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarBtn
    }
    
    private func setUpData() {
        let currentPageData = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageData)
        let year = Calendar.current.component(.year, from: currentPageData)

        tempList = DataManager.shared.fetchTask(Int16(month), Int16(year))

        listDict.removeAll()
        tempList.forEach { entity in
            let date = entity.date
            if let idx = date?.lastIndex(of: "."), let day = Int((date?[idx...].dropFirst())!) {
                listDict[day] = entity
            }
        }
    }
    
    private func addWeekChangedObserver() {
        weekChangedObserver = NotificationCenter.default.addObserver(forName: .weekChanged, object: nil, queue: .main, using: { [weak self] noti in
            if let noti = noti.userInfo?["week"] as? Int {
                self?.calendar.firstWeekday = UInt(noti)
            }
        })
    }
    
    private func addDataChangedObserver() {
        dataChangedObserver = NotificationCenter.default.addObserver(forName: .dataChanged, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else {return}
            let currentPageData = self.calendar.currentPage
            let month = currentPageData.month
            let year = currentPageData.year

            //temp에 data fetch
            self.tempList = DataManager.shared.fetchTask(month, year)
            //listDict에 일: entity 로 정렬
            self.listDict.removeAll()
            self.tempList.forEach { entity in
                let date = entity.date
                if let idx = date?.lastIndex(of: "."), let day = Int((date?[idx...].dropFirst())!) {
                    self.listDict[day] = entity
                }
            }
            let date = self.calendar.selectedDate!
            let day = Int(date.day)
            
            if let entity = self.listDict[day]{
                self.contentView.setData(entity)
                self.globalEntity = entity
                
            } else {
                self.contentView.setEmpty()
                let selectedDate = self.formatter.string(from: date)
                //초기화
                UserInputData.shared.cleanData()
                InputViewController.entity = nil
                //날짜와 달 설정
                UserInputData.shared.date = selectedDate
                
                let month = date.month, year = date.year
                
                UserInputData.shared.month = month
                UserInputData.shared.year = year
            }
            self.calendar.reloadData()
            //review Code
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        })
    }
    
    private func setUpCalender() {
        calendar.delegate = self
        calendar.dataSource = self
        
        view.addSubview(calendar)
        let calendarHeight = view.frame.size.height / 3.0 * 1.5
        calendar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(calendarHeight)
        }
        
        view.addSubview(prevButton)
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        
        view.addSubview(indexView)
        indexView.translatesAutoresizingMaskIntoConstraints = false
        indexView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottomMargin).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpContentView() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        let day = Calendar.current.component(.day, from: Date())
        calendar.select(calendar.today)
        if let entity = listDict[day] {
            globalEntity = entity
            contentView.setData(entity)
        } else {
            contentView.setEmpty()
            
            let date = Date()
            let selectedDate = formatter.string(from: date)

            UserInputData.shared.cleanData()
            InputViewController.entity = nil

            UserInputData.shared.date = selectedDate
            let month = date.month, year = date.year
            
            UserInputData.shared.month = month
            UserInputData.shared.year = year
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        calendar.reloadData()
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return .systemBackground
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        guard let entity = listDict[Int(date.day)], let mood = entity.mood else {
            return .black
        }
        
        return colorDict[mood]
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        guard let entity = listDict[Int(date.day)], let mood = entity.mood else {
            return .systemBackground
        }
        
        return colorDict[mood]
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        guard let entity = listDict[Int(date.day)], let mood = entity.mood else {
            return .systemBackground
        }
        
        return colorDict[mood]
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .CustomBlack
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        guard let _ = listDict[Int(date.day)] else {
            return .systemGray3
        }
        
        return .CustomBlack
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let difference = Calendar.current.dateComponents([.second], from: Date(), to: date).second!
        
        return difference <= 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = formatter.string(from: date)
        let day = Int(date.day)

        if let entity = listDict[day]{
            contentView.setData(entity)
            globalEntity = entity
        }
        else {
            globalEntity = nil
            contentView.setEmpty()

            UserInputData.shared.cleanData()
            InputViewController.entity = nil

            UserInputData.shared.date = selectedDate
            
            let month = date.month, year = date.year
            
            UserInputData.shared.month = month
            UserInputData.shared.year = year
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        UserDefaults.standard.set(calendar.currentPage.month, forKey: UserDefaultKey.listMonth)
        UserDefaults.standard.set(calendar.currentPage.year, forKey: UserDefaultKey.listYear)
        NotificationCenter.default.post(name: .dataChanged, object: nil)
    }
}

