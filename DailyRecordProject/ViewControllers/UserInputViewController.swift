//
//  UserInputViewController.swift
//  DailyRecordProject
//
//  Created by dudu on 2021/06/21.
//

import UIKit
import SnapKit

enum CurrentRecord: String {
    case mood
    case goodWork = "잘한일"
    case badWork = "못한일"
    case thanksWork = "감사한일"
    case highlight = "내일의 하이라이트"
    
    var next: Self? {
        switch self {
        case .mood:
            return .goodWork
        case .goodWork:
            return .badWork
        case .badWork:
            return .thanksWork
        case .thanksWork:
            return .highlight
        case .highlight:
            return nil
        }
    }
}

class UserInputViewController: UIViewController {
    private let workTextField: UITextField = {
        let textField = UITextField()
        textField.isHidden = true
        
        return textField
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.isHidden = true
        
        return button
    }()
    
    private let moodSegmentView: MoodSegmentView = {
        let view = MoodSegmentView()
        view.isHidden = true
        
        return view
    }()
    
    private let recordState: CurrentRecord
    private let isEdit: Bool
    
    init(state: CurrentRecord, isEdit: Bool) {
        self.recordState = state
        self.isEdit = isEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        addSubViews()
        layout()
        setUp()
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        view.addSubviews(workTextField, nextButton, moodSegmentView)
    }
    
    private func layout() {
        workTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
        }
        
        moodSegmentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview().offset(-100)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
    
    private func setUp() {
        if recordState == .mood {
            setUpMoodInputView()
        } else {
            setUpTextInputView()
        }
    }
        
    private func setUpMoodInputView() {
        moodSegmentView.isHidden = false
        nextButton.isHidden = false
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func nextButtonDidTap() {
        let userInputVC = UserInputViewController(state: .goodWork, isEdit: isEdit)
        navigationController?.pushViewController(userInputVC, animated: true)
    }
    
    private func setUpTextInputView() {
        workTextField.isHidden = false
        workTextField.delegate = self
        workTextField.returnKeyType = .next
        workTextField.placeholder = recordState.rawValue
        workTextField.becomeFirstResponder()
        workTextField.enablesReturnKeyAutomatically = true
    }
}

extension UserInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextState = recordState.next else {
            navigationController?.popToRootViewController(animated: true)
            
            // 데이터 저장
            return true
        }
        
        let userInputVC = UserInputViewController(state: nextState, isEdit: isEdit)
        navigationController?.pushViewController(userInputVC, animated: true)
        
        return true
    }
}
