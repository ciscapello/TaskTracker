//
//  RowTaskCell.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit

class RowTaskCell: UICollectionViewCell, ConfiguringCell {
    static var identifier = "RowTaskCell"
    
    var title = UILabel()
    var descr = UILabel()
    var date = UILabel()
    var priority = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func configure(with task: Task) {
        contentView.applyGradient(isVertical: false, colorArray: [UIColor(hexString: task.backgroundColor).darker(componentDelta: 0.1), UIColor(hexString: task.backgroundColor).lighter(componentDelta: 0.1)])
        title.text = task.title
        title.textColor = UIColor(hexString: task.textColor)
        descr.text = task.descr
        descr.textColor = UIColor(hexString: task.textColor)
        date.text = task.updatedAt.format()
        date.textColor = UIColor(hexString: task.textColor)
        priority.text = task.title
        priority.textColor = UIColor(hexString: task.textColor)

    }
    
    private func setup() {
        title.numberOfLines = 2
        descr.numberOfLines = 0
        title.setContentHuggingPriority(.defaultHigh, for: .vertical)
        title.font = UIFont(name: "Verdana-Bold", size: 13)
        date.font = UIFont(name: "Verdana", size: 10)
        priority.font = UIFont(name: "Verdana", size: 10)
        descr.font = UIFont(name: "Verdana", size: 12)

        let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.setContentHuggingPriority(.defaultHigh, for: .vertical)
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        let innerStackView = UIStackView(arrangedSubviews: [date, priority])
        innerStackView.axis = .horizontal
        innerStackView.distribution = .equalSpacing
        
        let outerStackView = UIStackView(arrangedSubviews: [title, innerStackView, divider, descr])
        outerStackView.axis = .vertical
        contentView.addSubview(outerStackView)
        outerStackView.isLayoutMarginsRelativeArrangement = true
        outerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        outerStackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        outerStackView.spacing = 3
        outerStackView.setCustomSpacing(6, after: divider)
        outerStackView.setCustomSpacing(6, after: innerStackView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

