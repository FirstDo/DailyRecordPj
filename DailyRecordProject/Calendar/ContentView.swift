//
//  ContentView.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/11.
//

import UIKit

class ContentView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConstraint()
    }
    
    private func setConstraint() {
        self.backgroundColor = .systemBlue
    }

}
