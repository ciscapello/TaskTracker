//
//  ColumnTaskCell.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit

class TableTaskCell: UICollectionViewCell, ConfiguringCell {
    static var identifier = "TableTaskCell"
    
    var title = UILabel()
    var descr = UILabel()
    var date = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        contentView.backgroundColor = .yellow
    }

    func configure(with task: Task) {
        title.text = task.title
        title.textColor = UIColor(hexString: task.textColor)
        descr.text = task.descr
        descr.textColor = UIColor(hexString: task.textColor)
        date.text = task.updatedAt.format()
        date.textColor = UIColor(hexString: task.textColor)
        contentView.applyGradient(isVertical: false, colorArray: [UIColor(hexString: task.backgroundColor).darker(componentDelta: 0.1), UIColor(hexString: task.backgroundColor).lighter(componentDelta: 0.1)])
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        date.font = UIFont(name: "Verdana", size: 10)
        title.numberOfLines = 1
        descr.numberOfLines = 0
        title.font = UIFont(name: "Verdana-Bold", size: 13)
        descr.font = UIFont(name: "Verdana", size: 12)
        
        let innerStackView = UIStackView(arrangedSubviews: [title, date])
        innerStackView.axis = .horizontal
        innerStackView.distribution = .equalSpacing
        
        let outerStackView = UIStackView(arrangedSubviews: [innerStackView, descr])
        outerStackView.axis = .vertical
        outerStackView.isLayoutMarginsRelativeArrangement = true
        outerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        outerStackView.spacing = 3
        contentView.addSubview(outerStackView)
        outerStackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

