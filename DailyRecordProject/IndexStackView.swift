//
//  IndexStackView.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/12/02.
//

import UIKit

class IndexStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        axis = .horizontal
        
        let nameList = ["happy", "sad", "soso", "angry"]
        let korName = ["행복 ","슬픔 ","보통 ","화남 "]

        for (idx,name) in nameList.enumerated() {
            let v = UIView()
            v.heightAnchor.constraint(equalToConstant: 16).isActive = true
            v.widthAnchor.constraint(equalToConstant: 16).isActive = true
            v.layer.cornerRadius = 8
            v.backgroundColor = colorDict[name]!
            self.addArrangedSubview(v)

            let lb = UILabel()
            lb.text = korName[idx]
            self.addArrangedSubview(lb)
        }
        self.distribution = .fillProportionally
        self.spacing = 5
        self.clipsToBounds = false
    }
}
