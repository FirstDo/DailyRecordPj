//
//  CalendarViewController.swift
//  DailyRecordProject
//
//  Created by dudu on 2022/06/17.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarViewController: UIViewController {
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar()
        
        calendar.appearance.selectionColor = .clear
        calendar.appearance.borderSelectionColor = .label
        calendar.appearance.titleSelectionColor = .label
        calendar.appearance.subtitleSelectionColor = .label
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        
        calendar.locale = Locale(identifier: "ko_KR")
        
        return calendar
    }()
    
    private let emotionIndexView = EmotionIndexView()
    private let dailyRecordView = DailyRecordView()
    
    private var dailyRecords = [DailyRecord]() {
        didSet {
            calendarView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func configureLayout() {
        view.addSubviews(calendarView, emotionIndexView, dailyRecordView)
        
        calendarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(calendarView.snp.width).offset(50)
        }
        
        emotionIndexView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        dailyRecordView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.top.equalTo(emotionIndexView.snp.bottom).offset(20)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        configureFSCalendar()
    }
    
    private func configureFSCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    func fetchData() {
        guard let results = PersistantManager.shared.fetchAll(target: calendarView.currentPage) else { return }
        
        dailyRecords = results
    }
}

extension CalendarViewController: FSCalendarDataSource {
    // empty
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let dailyRecord = dailyRecords.first(where: { $0.createdDate?.day == date.day }) else { return }
        
        dailyRecordView.configure(
            with: dailyRecord,
            date: date,
            editAction: { [weak self] in
                // empty
            },
            deleteAction: { [weak self] in
                guard let self = self else { return }
                
                PersistantManager.shared.delete(target: dailyRecord)
                
                if let index = self.dailyRecords.firstIndex(where: { $0.createdDate?.day == date.day }) {
                    self.dailyRecords.remove(at: index)
                }
            }
        )
    }
}

extension CalendarViewController: FSCalendarDelegateAppearance {
    // empty
}
