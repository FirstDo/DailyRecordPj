//
//  InputViewController.swift
//  DailyRecordProject
//
//  Created by 김도연 on 2021/09/29.
//

import UIKit

class InputViewController: UIViewController {
    
    static var isEdit : Bool = false
    
    var viewTitle: String?
    // 잘한일, 못한일, 감사한일, 하이라이트를 입력받을 텍스트 필드
    lazy var inputField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 30)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //evaluateView에 쓰일 nextButton
    lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("다음", for: .normal)
        btn.backgroundColor = .systemGray
        btn.isEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func singleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag, let selectedView = view.viewWithTag(tag) as? UIImageView else {
            fatalError("tap tag Error")
        }
        
        for i in 0..<4 {
            emotionButtons[i].tintColor = .systemBlue
        }
        
        selectedView.tintColor = .systemRed
        
        switch tag {
        case 1:
            UserInputData.shared.mood = "happy"
        case 2:
            UserInputData.shared.mood = "sad"
        case 3:
            UserInputData.shared.mood = "soso"
        case 4:
            UserInputData.shared.mood = "angry"
        default:
            break
        }
        nextButton.backgroundColor = .systemYellow
        nextButton.isEnabled = true
        
    }
    
    lazy var emotionButtons : [UIImageView] = {
        let happyImg = UIImageView(image: UIImage(systemName: "sun.max"))
        let sadImg = UIImageView(image: UIImage(systemName: "cloud.drizzle"))
        let sosoImg = UIImageView(image: UIImage(systemName: "moon"))
        let angryImg = UIImageView(image: UIImage(systemName: "cloud.bolt.rain"))
        let imageViewList = [happyImg,sadImg,sosoImg,angryImg]
        for i in 0..<4 {
            imageViewList[i].contentMode = .scaleAspectFit
            imageViewList[i].tag = i+1
            imageViewList[i].isUserInteractionEnabled = true
            
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture(_:)))
            singleTap.numberOfTouchesRequired = 1
            imageViewList[i].addGestureRecognizer(singleTap)
        }
        
        return imageViewList
    }()
    
    lazy var stackView: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: emotionButtons)
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.isLayoutMarginsRelativeArrangement = true
        stackV.layoutMargins.left = 10
        stackV.layoutMargins.right = 10
        stackV.axis = .horizontal
        stackV.spacing = 20
        stackV.distribution = .fillEqually
        stackV.backgroundColor = .systemGroupedBackground
       
        return stackV
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
        if let vt =  viewTitle {
            switch vt {
            case "good":
                inputField.text = UserInputData.shared.goodThing
            case "bad":
                inputField.text = UserInputData.shared.badThing
            case "thanks":
                inputField.text = UserInputData.shared.thanksThing
            case "highlight":
                inputField.text = UserInputData.shared.highlightThing
            default:
                break
            }
            
            
            inputField.becomeFirstResponder()
        }
    }
    
    func evaluateSetting() {
        view.addSubview(stackView)
        stackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(gotoGoodViewAction), for: .touchUpInside)
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

    }
    
    @objc func gotoGoodViewAction() {
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
        //keyboardNotification()
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
    
//    func keyboardNotification() {
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { noti in
//            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                let keyboardRect = frame.cgRectValue
//                let height = keyboardRect.height
//
//            }
//        }
//
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
//
//        }
//    }

    
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
        //데이터 저장을 위한 싱클톤 클래스
        let data = UserInputData.shared
        
        let nextVC = InputViewController()
        switch viewTitle {
        case "good":
            data.goodThing = inputField.text
            nextVC.viewTitle = "bad"
        case "bad":
            data.badThing = inputField.text
            nextVC.viewTitle = "thanks"
        case "thanks":
            data.thanksThing = inputField.text
            nextVC.viewTitle = "highlight"
        //여기서 데이터를 저장하자!
        case "highlight":
            data.highlightThing = inputField.text
            if let (date, mood, good, bad, thanks, highlight) = UserInputData.shared.getAllData() {
                
                DataManager.shared.createDailyInfo(date: date, mood: mood, good: good, bad: bad, thanks: thanks, highlight: highlight) {
                    NotificationCenter.default.post(name: CalendarViewController.taskChanged, object: nil)
                }
                navigationController?.popToRootViewController(animated: true)
                return true
            } else {
                print("저장실패!!!!")
                return false
            }
        default:
            break
        }
        navigationController?.pushViewController(nextVC, animated: true)
        return true
    }
}

