//
//  CalendarCustomCell.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/19.
//

import UIKit
import FSCalendar

class CalendarCustomCell: FSCalendarCell {
    public var lbl: UILabel!

    override init!(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        
        contentView.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        lbl = UILabel()
        lbl.textColor = .blue
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
    }
}
