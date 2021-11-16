//
//  IndexView.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/11/17.
//

import UIKit

class IndexView: UIView {
    
    let happyColor: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        v.backgroundColor = .systemYellow
        return v
    }()
    
    let sadColor: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        return v
    }()
    
    let sosoColor: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGreen
        return v
    }()
    
    let angryColor: UIView = {
        let v = UIView()
        v.backgroundColor = .systemRed
        return v
    }()
    
        
    let happyLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "😀"
        return lb
    }()
    
    let sadLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "😢"
        return lb
    }()
    
    let sosoLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "😑"
        return lb
    }()
    
    let angryLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "😡"
        return lb
    }()
    
    lazy var colorStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [happyColor, sadColor, sosoColor, angryColor])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [happyLabel,sadLabel, sosoLabel, angryLabel])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetting()
    }
    
    private func initSetting() {
        backgroundColor = .clear
        
        self.addSubview(colorStackView)
        self.addSubview(labelStackView)
        
        colorStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        colorStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        colorStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        colorStackView.bottomAnchor.constraint(equalTo: labelStackView.topAnchor, constant: -5).isActive = true
    
        labelStackView.leadingAnchor.constraint(equalTo: colorStackView.leadingAnchor).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: colorStackView.trailingAnchor).isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        labelStackView.topAnchor.constraint(equalTo: colorStackView.bottomAnchor).isActive = true

        labelStackView.heightAnchor.constraint(equalTo: colorStackView.heightAnchor, constant: 10).isActive = true
    }
}
