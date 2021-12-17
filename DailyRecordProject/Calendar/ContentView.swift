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
    private let dateLabel = UILabel()
    
    let editButton: UIButton = {
        var btn = UIButton()
        btn.tintColor = .CustomBlack
        btn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        return btn
    }()
    
    let deleteButton: UIButton = {
        var btn = UIButton()
        btn.tintColor = .systemRed
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        return btn
    }()
    
    private let goodText = UILabel()
    private let badText = UILabel()
    private let thanksText = UILabel()
    private let highlightText = UILabel()
    
    private let lineView = UIView()
    
    private lazy var labelStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [goodText, badText, thanksText, highlightText])
        sv.axis = .vertical
        sv.spacing = 20
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [editButton, deleteButton])
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetting()
        setConstraint()
    }
    
    private func setConstraint() {
        addSubview(labelStack)
        addSubview(dateLabel)
        addSubview(lineView)
        addSubview(buttonStackView)
        
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.top.equalTo(dateLabel.snp.top)
        }
        
        lineView.backgroundColor = colorDict["angry"]!
        lineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.top.equalTo(dateLabel.snp.bottom).offset(3)
            make.leading.trailing.equalTo(dateLabel)
        }
        
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(10)
            make.trailing.equalTo(self.snp.trailing).offset(-10)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    
    private func initSetting() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
    }
    
    func setData(_ entity: DailyInfoEntity) {
        globalEntity = entity
        badText.textAlignment = .left
        deleteButton.isHidden = false
        lineView.isHidden = false

        self.dateLabel.text = entity.date! + " 기록"
        self.goodText.text = "😀 "+entity.good!
        self.badText.text = "😵 "+entity.bad!
        self.thanksText.text = "🥰 "+entity.thanks!
        self.highlightText.text = "🧐 "+entity.highlight!
    }
    
    func setEmpty() {
        globalEntity = nil
        deleteButton.isHidden = true
        lineView.isHidden = true
        
        self.dateLabel.text = " "
        self.goodText.text = " "
        self.badText.text = "기록이 없어요 :("
        badText.textAlignment = .center
        self.thanksText.text = " "
        self.highlightText.text = " "
    }
}



