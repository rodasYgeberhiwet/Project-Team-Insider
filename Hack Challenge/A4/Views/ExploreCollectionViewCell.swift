//
//  ExploreCollectionViewCell.swift
//  A4
//
//  Created by Paul Ng on 11/16/25.
//

import UIKit
import SnapKit
import SDWebImage

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}

class ExploreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    private let name = UILabel() // done
    private let comp = PaddedLabel() // done
    private let category = PaddedLabel()
    private let desc = UILabel()
    private let reviews = UILabel()
    private let hours = UILabel()
        
    static let reuse = "ExploreCollectionViewCellReuse"
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 12
        setupName()
        setupComp()
        setupCategory()
        setupDesc()
        setupReviews()
        setupHours()
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
        name.font = .systemFont(ofSize: 18, weight: .semibold)
        
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    func setupComp() {
        comp.textColor = UIColor.white
        comp.backgroundColor = .systemRed
        comp.layer.cornerRadius = 8
        comp.layer.masksToBounds = true
        comp.font = .systemFont(ofSize: 10, weight: .bold)
        comp.textAlignment = .center
        
        comp.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        contentView.addSubview(comp)
        comp.translatesAutoresizingMaskIntoConstraints = false
        
        comp.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(4)
        }
    }
    
    func setupCategory() {
        category.textColor = UIColor.black
        category.backgroundColor = UIColor.white
        category.layer.borderWidth = 1
        category.layer.borderColor = UIColor.darkGray.cgColor
        category.layer.cornerRadius = 8
        category.layer.masksToBounds = true
        category.font = .systemFont(ofSize: 10, weight: .bold)
        category.textAlignment = .center
        
        category.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
//        16
        contentView.addSubview(category)
        category.translatesAutoresizingMaskIntoConstraints = false
        
        category.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(8)
            make.leading.equalTo(comp.snp.trailing).offset(4)
        }
    }
    
    func setupDesc() {
        desc.textColor = UIColor.black
        desc.font = .systemFont(ofSize: 12, weight: .regular)
        
        desc.numberOfLines = 0
        desc.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(desc)
        desc.translatesAutoresizingMaskIntoConstraints = false
        
        desc.snp.makeConstraints { make in
            make.top.equalTo(comp.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    func setupReviews() {
        reviews.textColor = UIColor.black
        reviews.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(reviews)
        reviews.translatesAutoresizingMaskIntoConstraints = false
        
        reviews.snp.makeConstraints { make in
            make.top.equalTo(desc.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(4)
        }
    }
    
    func setupHours() {
        hours.textColor = UIColor.black
        hours.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(hours)
        hours.translatesAutoresizingMaskIntoConstraints = false
        
        hours.snp.makeConstraints { make in
            make.top.equalTo(desc.snp.bottom).offset(8)
            make.leading.equalTo(reviews.snp.trailing).offset(8)
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


