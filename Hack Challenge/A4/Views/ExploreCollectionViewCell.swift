//
//  ExploreCollectionViewCell.swift
//  A4
//
//  Created by Paul Ng on 11/16/25.
//

import UIKit
import SnapKit
import SDWebImage

class ExploreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    private let name = UILabel()
    private let comp = UILabel()
    private let desc = UILabel()
    private let category = UILabel()
    private let reviews = UILabel()
    private let hours = UILabel()
        
    static let reuse = "ExploreCollectionViewCellReuse"
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupName()
        setupComp()
//        setupDesc()
//        setupCategory()
//        setupReviews()
//        setupHours()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure

    func configure(team: Team) {
        name.text = team.name
        comp.text = team.comp
        desc.text = team.description
        category.text = team.category        
        reviews.text = "\(team.reviews.count) reviews"
        hours.text = "\(team.hours) hours/week"
        
        // Check UserDefaults
//        let bookmarked = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
//        if bookmarked.contains(recipe.name) {
//            bookmark.image = UIImage(named: "orangeBookmark")
//            bookmark.isHidden = false
//        }
//        else {
//            bookmark.isHidden = true
//        }
    }
    
    // MARK: - Set Up Views
    
//    func setupImage() {
//        image.contentMode = .scaleAspectFill
//        image.clipsToBounds = true
//            
//        contentView.addSubview(image)
//        image.translatesAutoresizingMaskIntoConstraints = false
//        
//        image.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//            make.height.width.equalTo(148)
//        }
//    }
    
    func setupName() {
        name.textColor = UIColor.black
        name.font = .systemFont(ofSize: 16, weight: .semibold)
        
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
        }
    }
    
    func setupComp() {
        comp.textColor = UIColor.white
        comp.backgroundColor = .systemRed
        comp.layer.cornerRadius = 8
        comp.layer.masksToBounds = true
        comp.font = .systemFont(ofSize: 12, weight: .bold)
        
        comp.numberOfLines = 0
        comp.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(comp)
        comp.translatesAutoresizingMaskIntoConstraints = false
        
        comp.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(name.snp.trailing).offset(8)
        }
    }
    /*
    func setupRating() {
        rating.textColor = UIColor.a4.silver
        rating.font = .systemFont(ofSize: 12, weight: .regular)
        
        contentView.addSubview(rating)
        rating.translatesAutoresizingMaskIntoConstraints = false
        
        rating.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.leading)
            make.top.equalTo(name.snp.bottom)
        }
    }
    
    func setupDifficulty() {
        difficulty.textColor = UIColor.a4.silver
        difficulty.font = .systemFont(ofSize: 12, weight: .regular)
        
        contentView.addSubview(difficulty)
        difficulty.translatesAutoresizingMaskIntoConstraints = false
        
        difficulty.snp.makeConstraints { make in
            make.leading.equalTo(rating.snp.trailing)
            make.top.equalTo(name.snp.bottom)
        }
    }
    
    private func setupBookmarkIcon() {
        contentView.addSubview(bookmark)
        bookmark.translatesAutoresizingMaskIntoConstraints = false
        
        bookmark.snp.makeConstraints {make in
            make.trailing.equalTo(image.snp.trailing)
            make.top.equalTo(image.snp.bottom).offset(8)
            make.width.height.equalTo(20)
        }
    }
     */
}


