//
//  ContentView.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/11.
//

import UIKit

class ContentView: UIView {
    var globalEntity: DailyInfoEntity?
    
    //elements
    private let dateLabel: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let editButton: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        return btn
    }()
    
    let deleteButton: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        return btn
    }()
    
//    let tapButton: UIButton = {
//        var btn = UIButton()
//        btn.setImage(UIImage(systemName: "plus"), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    
    private let goodText: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let badText: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let thanksText: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let highlightText: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private lazy var labelStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [goodText, badText, thanksText, highlightText])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        sv.distribution = .fillEqually
        sv.alignment = .fill
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
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        isUserInteractionEnabled = true
        
        //addSubview(tapButton)
        addSubview(labelStack)
        addSubview(dateLabel)
        addSubview(editButton)
        addSubview(deleteButton)
        
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        editButton.topAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        editButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10).isActive = true
        
        //for 4 report Label
        labelStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        labelStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        labelStack.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        labelStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
//        //for empty View tap
//        tapButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        tapButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        tapButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        tapButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setData(_ entity: DailyInfoEntity) {
        globalEntity = entity
        
        //tapButton.isHidden = true
        goodText.textAlignment = .left
        deleteButton.isHidden = false
        //editButton.isHidden = false
            
        self.dateLabel.text = entity.date! + " 기록"
        self.goodText.text = "😀 "+entity.good!
        self.badText.text = "🙁 "+entity.bad!
        self.thanksText.text = "🥰 "+entity.thanks!
        self.highlightText.text = "🧐 "+entity.highlight!
    }
    
    func setEmpty() {
        globalEntity = nil
        //tapButton.isHidden = false
        deleteButton.isHidden = true
        //editButton.isHidden = true
        
        self.dateLabel.text = nil
        self.goodText.text = "기록이 없어요 :("
        goodText.textAlignment = .center
        self.badText.text = nil
        self.thanksText.text = nil
        self.highlightText.text = nil
    }

}


