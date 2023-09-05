//
//  CreateTaskViewController.swift
//  TaskTracker
//
//  Created by Владимир on 14.08.2023.
//

import UIKit
import RxRelay
import RxCocoa
import RxSwift

class CreateTaskViewController: UIViewController {
    
    var viewModel: CreateTaskViewModelProtocol?
    let disposeBag = DisposeBag()
    
    let headerTitle = UILabel()
    let titleFieldLabel = UILabel()
    let titleField = UITextField()
    let descriptionFieldLabel = UILabel()
    let descriptionField = UITextView()
    let controlLabel = UILabel()
    let control = SelectColorSegmentedControl()
    let button = UIButton(type: .system)
    
    let placeholderLabel: UILabel = {
       let label = UILabel()
        label.text = "Описание задачи"
        label.font = UIFont(name: "Verdana", size: 16)
        label.sizeToFit()
        label.textColor = UIColor(named: Colors.placeholder.rawValue)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = UIColor(named: Colors.background.rawValue)
        self.hideKeyboardWhenTappedAround()
        descriptionField.delegate = self
        
        titleField.rx.text.orEmpty.bind(to: viewModel!.title).disposed(by: disposeBag)
        descriptionField.rx.text.orEmpty.bind(to: viewModel!.descr).disposed(by: disposeBag)
        control.viewModel.selectedColor.bind(to: viewModel!.color).disposed(by: disposeBag)
    }
    
    func setup () {
        guard let category = viewModel?.category else { return }
        headerTitle.text = "Создать задачу в '\(category)'"
        view.addSubview(headerTitle)
        headerTitle.font = UIFont(name: "Verdana", size: 15)
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(titleFieldLabel)
        titleFieldLabel.text = "Заголовок задачи"
        titleFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
        }
        titleFieldLabel.font = UIFont(name: "Verdana", size: 12)
        titleFieldLabel.textColor = UIColor(named: Colors.mainText.rawValue)
        
        view.addSubview(titleField)
        titleField.backgroundColor = .red
        titleField.layer.cornerRadius = 8
        titleField.snp.makeConstraints { make in
            make.top.equalTo(titleFieldLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(40)
        }
        titleField.setLeftPaddingPoints(5)
        titleField.attributedPlaceholder = NSAttributedString(
            string: Placeholder.randomCategoryTitle(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: Colors.placeholder.rawValue)!]
        )
        titleField.backgroundColor = UIColor(named: Colors.fieldBackground.rawValue)
        titleField.textColor = UIColor(named: Colors.fieldText.rawValue)

        
        view.addSubview(descriptionFieldLabel)
        descriptionFieldLabel.text = "Описание задачи"
        descriptionFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
        }
        descriptionFieldLabel.font = UIFont(name: "Verdana", size: 12)
        descriptionFieldLabel.textColor = UIColor(named: Colors.mainText.rawValue)

        view.addSubview(descriptionField)
        descriptionField.backgroundColor = .red
        descriptionField.layer.cornerRadius = 8
        descriptionField.snp.makeConstraints { make in
            make.top.equalTo(descriptionFieldLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(150)
        }
        descriptionField.backgroundColor = UIColor(named: Colors.fieldBackground.rawValue)
        descriptionField.textColor = UIColor(named: Colors.fieldText.rawValue)
        descriptionField.font = UIFont.systemFont(ofSize: 15)
        
        placeholderLabel.isHidden = !descriptionField.text.isEmpty
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionField.font?.pointSize)! / 2)
        descriptionField.addSubview(placeholderLabel)

        
        view.addSubview(controlLabel)
        controlLabel.text = "Выберите цвет карточки"
        controlLabel.font = UIFont(name: "Verdana", size: 12)
        controlLabel.textColor = UIColor(named: Colors.mainText.rawValue)
        controlLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionField.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
        }
        
        view.addSubview(control)
        control.snp.makeConstraints { make in
            make.top.equalTo(controlLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(view.snp.width).multipliedBy(0.15)
        }
        
        view.addSubview(button)
        button.setTitle("Создать", for: .normal)
        button.snp.makeConstraints { make in
            make.top.equalTo(control.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        button.backgroundColor = UIColor(named: Colors.buttonBackground.rawValue)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(named: Colors.buttonText.rawValue), for: .normal)
        button.addTarget(self, action: #selector(buttonDidPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Verdana", size: 16)
        button.setTitleColor(.red, for: .highlighted)
    }
    
    @objc func buttonDidPressed () {
        if titleField.text!.isEmpty {
            self.titleField.shake()
        }
        if descriptionField.text.isEmpty {
            self.descriptionField.shake()
        }
        if viewModel!.isValid {
            viewModel?.buttonPressed()
            dismiss(animated: true)
        }
    }
}

extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
}
