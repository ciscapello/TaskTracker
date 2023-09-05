//
//  CreateCategoryViewController.swift
//  TaskTracker
//
//  Created by Владимир on 14.08.2023.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class CreateCategoryViewController: UIViewController {
    
    var viewModel: CreateCategoryViewModelProtocol?
    
    let disposeBag = DisposeBag()
    
    let headerTitle = UILabel()
    let titleField = UITextField(frame: .zero)
    let subtitleField = UITextField(frame: .zero)
    let control = SelectLayoutSegmentedControl()
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Colors.background.rawValue)
        self.hideKeyboardWhenTappedAround()
        setup()
        
        titleField.rx.text.orEmpty.bind(to: viewModel!.title).disposed(by: disposeBag)
        subtitleField.rx.text.orEmpty.bind(to: viewModel!.subtitle).disposed(by: disposeBag)
        control.selectedType.bind(to: viewModel!.sectionType).disposed(by: disposeBag)
    }
    
    func setup() {
        headerTitle.text = "Новый список"
        headerTitle.font = UIFont(name: "Verdana", size: 15)
        view.addSubview(headerTitle)
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
        
        let divider = UIView()
        divider.backgroundColor = .quaternaryLabel
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
                
        titleField.backgroundColor = UIColor(named: Colors.fieldBackground.rawValue)
        titleField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        titleField.setLeftPaddingPoints(5)
        titleField.textColor = UIColor(named: Colors.fieldText.rawValue)
        titleField.attributedPlaceholder = NSAttributedString(
            string: Placeholder.randomCategoryTitle(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: Colors.placeholder.rawValue)!]
        )
        titleField.layer.cornerRadius = 8

        subtitleField.backgroundColor = UIColor(named: Colors.fieldBackground.rawValue)
        subtitleField.placeholder = Placeholder.randomCategorySubtitle()
        subtitleField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        subtitleField.setLeftPaddingPoints(5)
        subtitleField.textColor = UIColor(named: Colors.fieldText.rawValue)
        subtitleField.attributedPlaceholder = NSAttributedString(
            string: Placeholder.randomCategorySubtitle(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: Colors.placeholder.rawValue)!]
        )
        subtitleField.layer.cornerRadius = 8
        
        let titleFieldLabel = UILabel()
        titleFieldLabel.text = "Введите заголовок для списка"
        titleFieldLabel.font = UIFont(name: "Verdana", size: 12)
        titleFieldLabel.textColor = UIColor(named: Colors.mainText.rawValue)
        
        let titleFieldStack = UIStackView(arrangedSubviews: [titleFieldLabel, titleField])
        titleFieldStack.axis = .vertical
        titleFieldStack.spacing = 4
        titleFieldStack.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
                
        let subtitleFieldLabel = UILabel()
        subtitleFieldLabel.text = "Кратко опишите список"
        subtitleFieldLabel.font = UIFont(name: "Verdana", size: 12)
        subtitleFieldLabel.textColor = UIColor(named: Colors.mainText.rawValue)
        
        let subtitleFieldStack = UIStackView(arrangedSubviews: [subtitleFieldLabel, subtitleField])
        subtitleFieldStack.axis = .vertical
        subtitleFieldStack.spacing = 4
        subtitleFieldStack.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        let outerStackView = UIStackView(arrangedSubviews: [divider, titleFieldStack, subtitleFieldStack])
        outerStackView.axis = .vertical
        outerStackView.spacing = 13
        view.addSubview(outerStackView)
        outerStackView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.right.left.equalToSuperview()
            make.height.equalTo(170)
        }
        outerStackView.isLayoutMarginsRelativeArrangement = true
        outerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13)
        
        view.addSubview(control)
        control.snp.makeConstraints { make in
            make.top.equalTo(outerStackView.snp.bottom).offset(20)
            make.right.left.equalToSuperview()
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
        if let isValid = viewModel?.formIsValid {
            if !isValid {
                self.titleField.shake()
            } else {
                self.viewModel?.buttonDidPressed()
                self.dismiss(animated: true)
            }
        }
    }
}
