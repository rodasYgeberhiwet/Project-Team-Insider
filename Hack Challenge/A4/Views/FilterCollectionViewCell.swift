//
//  FilterCollectionViewCell.swift
//  A4
//
//  Created by Paul Ng on 11/17/25.
//

import UIKit
import SnapKit
import SDWebImage

class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    private let level = UIButton()
    
    static let reuse = "FilterCollectionViewCellReuse"
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLevel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure

    func configure(levelName: String, isSelected: Bool) {
        level.setTitle(levelName, for: .normal)
        if (isSelected){
            level.backgroundColor = UIColor.a4.yellowOrange
            level.setTitleColor(UIColor.a4.white, for: .normal)
        } else {
            level.backgroundColor = UIColor.a4.offWhite
            level.setTitleColor(UIColor.a4.black, for: .normal)
        }
    }
    
    // MARK: - Set Up Views
    
    func setupLevel() {
        level.setTitle("All", for: .normal)
        level.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        level.layer.cornerRadius = 16
        level.isUserInteractionEnabled = false //~
        contentView.addSubview(level)
        level.translatesAutoresizingMaskIntoConstraints = false
        
        level.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
        }
    }
}


