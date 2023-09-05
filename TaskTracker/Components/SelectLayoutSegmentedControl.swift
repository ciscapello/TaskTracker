//
//  SelectLayoutControl.swift
//  TaskTracker
//
//  Created by Владимир on 15.08.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class SelectLayoutSegmentedControl: UIView {
    
    let disposeBag = DisposeBag()
    
    let buttonTitles = ["Колонки", "Табличка", "Строка"]
    
    let types = [SectionType.columns, SectionType.table, SectionType.row]
    
    var buttons = [UIButton]()
    
    let selectedIndex = BehaviorRelay(value: 0)
    let selectedType = BehaviorRelay(value: SectionType.columns)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
        selectedIndex.subscribe { event in
            guard let index = event.element else { return }
            self.selectedType.accept(self.types[index])
            for button in self.buttons {
                UIView.animate(withDuration: 0.2) {
                    button.alpha = 0.6
                    button.layer.borderWidth = 1
                    button.transform = .identity
                }
            }
            UIView.animate(withDuration: 0.2) {
                self.buttons[index].alpha = 1
                self.buttons[index].layer.borderWidth = 2
                self.buttons[index].transform = CGAffineTransformScale(self.buttons[index].transform, 1.1, 1.1)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupStack () {
        for title in buttonTitles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor(named: Colors.mainText.rawValue), for: .normal)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.equalTo(70)
            }
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 8
            if title != "Колонки" {
                button.alpha = 0.6
            }
            button.layer.borderColor = UIColor(named: Colors.mainText.rawValue)?.cgColor
            buttons.append(button)
        }
                
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13)
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    @objc func buttonAction (sender: UIButton) {
        let index = buttons.firstIndex(where: { button in
            button.titleLabel?.text == sender.titleLabel?.text
    
        })
        guard let i = index else { print("SDADD"); return }
        selectedIndex.accept(i)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
