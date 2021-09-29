//
//  InputViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/29.
//

import UIKit

class InputViewController: UIViewController {
    
    var viewTitle: String?
    
    lazy var inputField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 30)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var evaluateView: UIView = {
        let ev = UIView()
        ev.backgroundColor = .systemBlue
        ev.translatesAutoresizingMaskIntoConstraints = false
        return ev
    }()
    
    lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("다음", for: .normal)
        btn.backgroundColor = .systemYellow
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonSetting()
        
        if viewTitle != nil {
            textInputSetting()
            targetSetting()
        } else {
            evaluateSetting()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputField.becomeFirstResponder()
    }
    
    func evaluateSetting() {
        //evaluateView
        view.addSubview(evaluateView)
        evaluateView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        evaluateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        evaluateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        evaluateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(nextButton), for: .touchUpInside)
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func nextButton() {
        let nextVC = InputViewController()
        nextVC.viewTitle = "good"
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func textInputSetting() {
        //textField
        inputField.delegate = self
        inputField.returnKeyType = .next
        inputField.enablesReturnKeyAutomatically = true
        
        //keyboardNotification
        keyboardNotification()
        setInputField()
    }
    
    func commonSetting() {
        //view
        view.backgroundColor = .systemBackground
        
        //title
        navigationController!.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 20)]
        title = "말조각 작성중 📝"
    }
    
    func targetSetting() {
        if let viewTitle = viewTitle {
            switch viewTitle {
            case "good":
                inputField.placeholder = "잘한일 ✌️"
            case "bad":
                inputField.placeholder = "못한일 😵"
            case "thanks":
                inputField.placeholder = "감사한일 🥰"
            case "highlight":
                inputField.placeholder = "내일의 하이라이트 🤔"
                inputField.returnKeyType = .done
            default:
                break
            }
        } else {
            
        }
    }
    
    func keyboardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { noti in
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRect = frame.cgRectValue
                let height = keyboardRect.height

            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in

        }
    }

    
    func setInputField() {
        //textField
        view.addSubview(inputField)
        inputField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        inputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        inputField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        inputField.becomeFirstResponder()
    }

}

extension InputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextVC = InputViewController()
        switch viewTitle {
        case "good":
            nextVC.viewTitle = "bad"
        case "bad":
            nextVC.viewTitle = "thanks"
        case "thanks":
            nextVC.viewTitle = "highlight"
        case "evaluate":
            nextVC.viewTitle = "good"
        case "highlight":
            print("하루가 기록되었습니다")
            navigationController?.popToRootViewController(animated: true)
            return true
        default:
            break
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
        return true
    }
    
}

