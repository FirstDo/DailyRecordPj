//
//  ContentView.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/11.
//

import UIKit

class ContentView: UIView {
    //elements
    let goodTitle: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let goodText: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let badTitle: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let badText: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let thanksTitle: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let thanksText: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let highlightTitle: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let highlightText: UILabel = {
        var lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    //weatherView
    let emotionLabel: UILabel = {
        let lb =  UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    //InnerView
    let innerView: UIView = {
        var v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy var leftStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [goodTitle, badTitle, thanksTitle, highlightTitle])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    lazy var rightStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [goodText, badText, thanksText, highlightText])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    let lineView: UIView = {
        var v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemBlue
        v.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }()
    
    //Button
    let floatingButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.add, for: .normal)
        btn.addTarget(self, action: #selector(floating(_:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func floating(_ sender: UIButton) {
        //현재 펼쳐있을경우
        if isShow {
            buttons.reversed().forEach { btn in
                UIView.animate(withDuration: 0.3) {
                    btn.isHidden = true
                    self.layoutIfNeeded()
                }
            }
            
        } else {
            buttons.forEach { btn in
                btn.isHidden = false
                btn.alpha = 0
                
                UIView.animate(withDuration: 0.3) {
                    btn.alpha = 1
                    self.layoutIfNeeded()
                }
            }
        }
        isShow.toggle()
    }
    
    let editButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.checkmark, for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.remove, for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    lazy var buttonsView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [editButton, deleteButton, floatingButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    
    var isShow = false
    lazy var buttons : [UIButton] = [deleteButton, editButton]
    



    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetting()
    }
    
    private func initSetting() {
        self.backgroundColor = .systemBackground
        setConstraint()
    }
    

    
    private func setConstraint() {
        
        //buttonsView layout
        innerView.addSubview(buttonsView)
        buttonsView.trailingAnchor.constraint(equalTo: innerView.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        buttonsView.bottomAnchor.constraint(equalTo: innerView.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        
        //emotionLabel
        
        self.addSubview(emotionLabel)
        emotionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        emotionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        
        
        //innerView layout
        self.addSubview(innerView)
        
        innerView.backgroundColor = .systemGray6
        innerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        innerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        innerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        innerView.topAnchor.constraint(equalTo: emotionLabel.bottomAnchor, constant: 10).isActive = true
        //innerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
      
        innerView.addSubview(leftStackView)
        innerView.addSubview(rightStackView)
        innerView.addSubview(lineView)
        
        leftStackView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 10).isActive = true
        leftStackView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 10).isActive = true
        leftStackView.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -10).isActive = true
        leftStackView.trailingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: -10).isActive = true
        
        lineView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 10).isActive = true
        lineView.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -10).isActive = true
        
        
        rightStackView.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 10).isActive = true
        rightStackView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 10).isActive = true
        rightStackView.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -10).isActive = true
        rightStackView.trailingAnchor.constraint(lessThanOrEqualTo: innerView.trailingAnchor, constant: -10).isActive = true

    }
    
    func setData(_ entity: DailyInfoEntity) {
        self.goodText.text = entity.good
        self.goodTitle.text = "😀"
        
        self.badText.text = entity.bad
        self.badTitle.text = "🙁"
        
        self.thanksText.text = entity.thanks
        self.thanksTitle.text = "🥰"
        
        self.highlightText.text = entity.highlight
        self.highlightTitle.text = "🧐"
        

        switch entity.mood {
        case "happy":
            emotionLabel.text = "☀️"
        case "sad":
            emotionLabel.text = "🌧"
        case "soso":
            emotionLabel.text = "🌤"
        case "angry":
            emotionLabel.text = "⚡️"
        default:
            emotionLabel.text = "🌀"
        }
    }
    
}
