//
//  SelectColorSegmentedControl.swift
//  TaskTracker
//
//  Created by Владимир on 16.08.2023.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

protocol SelectColorSegmentedControlViewModelProtocol {
    var colors: [ColorForTask] { get }
    var selectedColorIndex: BehaviorRelay<Int> { get set }
    var selectedColor: BehaviorRelay<ColorForTask> { get set }
}

class SelectColorSegmentedControlViewModel: SelectColorSegmentedControlViewModelProtocol {
    let colors = TaskColors.colors
    
    var selectedColorIndex = BehaviorRelay(value: 0)
    
    var selectedColor = BehaviorRelay(value: TaskColors.colors[0])
}

class SelectColorSegmentedControl: UIView {
    
    var buttons = [UIColorButton]()
    
    let disposeBag = DisposeBag()
    
    let viewModel = SelectColorSegmentedControlViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        viewModel.selectedColorIndex.subscribe { event in
            print(event)
            guard let index = event.element else { return }
            let button = self.buttons[index]
            for b in self.buttons {
                UIView.animate(withDuration: 0.3) {
                    b.transform = .identity
                    b.layer.borderWidth = 0
                }
            }
            UIView.animate(withDuration: 0.3) {
                button.layer.borderColor = UIColor(named: Colors.borderColor.rawValue)?.cgColor
                button.layer.borderWidth = 3
                button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }
        }.disposed(by: disposeBag)
    }
    
    func setup () {
        for color in viewModel.colors {
            let button = UIColorButton(frame: CGRect(x: 0, y: 0, width: self.frame.width / 6, height: self.frame.width / 5))
            button.backgroundColor = color.backgroundColor
            button.setTitleColor(color.textColor, for: .normal)
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = false
            button.color = color
            if color.name == "Голубой" {
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 3
                button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }
            button.addTarget(self, action: #selector(buttonDidPress(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
    
    @objc func buttonDidPress (sender: UIColorButton) {
        guard let color = sender.color else { return }
        let index = viewModel.colors.firstIndex { $0.name == sender.color?.name }
        if index == nil { return }
        viewModel.selectedColorIndex.accept(index!)
        viewModel.selectedColor.accept(color)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
