//
//  ColumnTaskCell.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit

class ColumnTaskCell: UICollectionViewCell, ConfiguringCell {
    static var identifier = "ColumnTaskCell"
    
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
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 3.0
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.shadowOffset = CGSize(width: 4, height: 4)

        date.font = UIFont(name: "Verdana", size: 10)
        priority.font = UIFont(name: "Verdana", size: 10)
        title.font = UIFont(name: "Verdana-Bold", size: 14)
        descr.font = UIFont(name: "Verdana", size: 13)
        title.numberOfLines = 2
        title.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descr.numberOfLines = 0
        
        let innerStackView = UIStackView(arrangedSubviews: [date, priority])
        innerStackView.axis = .horizontal
        innerStackView.distribution = .equalSpacing
        
        let outerStackView = UIStackView(arrangedSubviews: [title, descr, innerStackView])
        outerStackView.axis = .vertical
        outerStackView.spacing = 8
        outerStackView.isLayoutMarginsRelativeArrangement = true
        outerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        contentView.addSubview(outerStackView)
        outerStackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
