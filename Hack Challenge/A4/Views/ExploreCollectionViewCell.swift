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
    private let learnMore = UIButton()
    private let bookmark = UIImageView()
        
    static let reuse = "ExploreCollectionViewCellReuse"
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12        // nice subtle shadow
        layer.shadowRadius = 6            // how blurry
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.masksToBounds = false       // IMPORTANT
        setupName()
        setupComp()
        setupCategory()
        setupDesc()
        setupReviews()
        setupHours()
        setupLearnMoreButton()
        setupBookmarkIcon()
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
        let bookmarked = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        if bookmarked.contains(team.name) {
            bookmark.image = UIImage(named: "orangeBookmark")
            bookmark.isHidden = false
        }
        else {
            bookmark.isHidden = true
        }
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
        name.textColor = UIColor.a4.offBlack
        name.font = .systemFont(ofSize: 18, weight: .semibold)
        
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    func setupComp() {
        comp.textColor = UIColor.white
        comp.backgroundColor = UIColor.a4.pinkRed
        comp.layer.cornerRadius = 8
        comp.layer.masksToBounds = true
        comp.font = .systemFont(ofSize: 10, weight: .bold)
        comp.textAlignment = .center
        
        comp.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        contentView.addSubview(comp)
        comp.translatesAutoresizingMaskIntoConstraints = false
        
        comp.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func setupCategory() {
        category.textColor = UIColor.a4.offBlack
        category.backgroundColor = UIColor.a4.lilac
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
            make.leading.equalToSuperview().offset(8)
        }
    }
    
    func setupDesc() {
        desc.textColor = UIColor.a4.offBlack
        desc.font = .systemFont(ofSize: 12, weight: .regular)
        
        desc.numberOfLines = 0
        desc.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(desc)
        desc.translatesAutoresizingMaskIntoConstraints = false
        
        desc.snp.makeConstraints { make in
            make.top.equalTo(category.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    func setupReviews() {
        reviews.textColor = UIColor.a4.offBlack
        reviews.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(reviews)
        reviews.translatesAutoresizingMaskIntoConstraints = false
        
        reviews.snp.makeConstraints { make in
            make.top.equalTo(desc.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
        }
    }
    
    func setupHours() {
        hours.textColor = UIColor.a4.offBlack
        hours.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(hours)
        hours.translatesAutoresizingMaskIntoConstraints = false
        
        hours.snp.makeConstraints { make in
            make.top.equalTo(desc.snp.bottom).offset(8)
            make.leading.equalTo(reviews.snp.trailing).offset(32)
        }
    }
    
    func setupLearnMoreButton() {
        learnMore.setTitle("View", for: .normal)
        learnMore.setTitleColor(UIColor.a4.offBlack, for: .normal)
        learnMore.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        learnMore.backgroundColor = UIColor.a4.beige
        learnMore.layer.cornerRadius = 12
//        learnMore.addTarget(self, action: #selector(pushVC, for: .touchUpInside)
        learnMore.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        contentView.addSubview(learnMore)
        learnMore.translatesAutoresizingMaskIntoConstraints = false
        
        learnMore.snp.makeConstraints { make in
//            make.top.equalTo(hours.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
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
     */
    private func setupBookmarkIcon() {
        contentView.addSubview(bookmark)
        bookmark.translatesAutoresizingMaskIntoConstraints = false
        
        bookmark.snp.makeConstraints {make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(20)
        }
    }
     
}


