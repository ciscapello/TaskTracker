//
//  SectionHeader.swift
//  TaskTracker
//
//  Created by Владимир on 13.08.2023.
//

import UIKit
import SnapKit

class SectionHeader: UICollectionReusableView {
    static let identifier = "SectionHeader"
    
    let divider = UIView()
    let title = UILabel()
    let subtitle = UILabel()
    let button = UIHeaderButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup () {
        title.font = UIFont(name: "Verdana-Bold", size: 14)
        subtitle.font = UIFont(name: "Verdana", size: 12)
        
        let innerStackView = UIStackView(arrangedSubviews: [title, subtitle])
        innerStackView.axis = .vertical
        innerStackView.spacing = 6
        
        button.setImage(UIImage.init(systemName: "plus"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let outerStackView = UIStackView(arrangedSubviews: [innerStackView, button])
        addSubview(outerStackView)
        outerStackView.axis = .horizontal
        outerStackView.distribution = .fill
        outerStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.bottom.equalToSuperview()
        }
        outerStackView.backgroundColor = UIColor(named: Colors.sectionHeader.rawValue)
        outerStackView.layer.cornerRadius = 6
        outerStackView.isLayoutMarginsRelativeArrangement = true
        outerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5)
        
        divider.backgroundColor = .lightGray
        divider.setContentHuggingPriority(.defaultHigh, for: .vertical)
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
