//
//  ContentView.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/10/11.
//

import UIKit

class ContentView: UIView {
    
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
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [editButton, deleteButton, floatingButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    }()
    
    var isShow = false
    lazy var buttons : [UIButton] = [deleteButton, editButton]
    

    let innerView: UIView = {
        var v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
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
        self.backgroundColor = .systemGray
        setConstraint()
    }
    
    private func setConstraint() {
        
        //stackView layout
        self.addSubview(stackView)
        
        stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        //innerView layout
        self.addSubview(innerView)
        
        innerView.backgroundColor = .systemGray6
        
        innerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        innerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        innerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        innerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        

        innerView.addSubview(goodTitle)
        innerView.addSubview(goodText)
        
        innerView.addSubview(badTitle)
        innerView.addSubview(badText)
        
        innerView.addSubview(thanksTitle)
        innerView.addSubview(thanksText)
        
        innerView.addSubview(highlightTitle)
        innerView.addSubview(highlightText)

    }
    
    func setData(_ entity: DailyInfoEntity) {
        print("데이터 세팅을하자!")
    }
    
}
