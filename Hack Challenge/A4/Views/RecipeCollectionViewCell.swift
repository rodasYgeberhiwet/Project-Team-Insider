//
//  RecipeCollectionViewCell.swift
//  A4
//
//  Created by Paul Ng on 11/16/25.
//

import UIKit
import SnapKit
import SDWebImage

class RecipeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    private let name = UILabel()
    private let image = UIImageView()
    private let rating = UILabel()
    private let difficulty = UILabel()
    private let bookmark = UIImageView()
    
    static let reuse = "RecipeCollectionViewCellReuse"
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        setupName()
        setupRating()
        setupDifficulty()
        setupBookmarkIcon()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure

    func configure(recipe: Recipe) {
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.sd_setImage(with: URL(string: recipe.image_url))
        name.text = recipe.name
        rating.text = String(recipe.rating) + " ∙ "
        difficulty.text = recipe.difficulty
        
        // Check UserDefaults
        let bookmarked = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        if bookmarked.contains(recipe.name) {
            bookmark.image = UIImage(named: "orangeBookmark")
            bookmark.isHidden = false
        }
        else {
            bookmark.isHidden = true
        }
    }
    
    // MARK: - Set Up Views
    
    func setupImage() {
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
            
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(148)
        }
    }
    
    func setupName() {
        name.textColor = UIColor.a4.black
        name.font = .systemFont(ofSize: 16, weight: .semibold)
        
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.snp.makeConstraints { make in
            make.leading.equalTo(image)
            make.trailing.equalTo(image).offset(-12)
            make.top.equalTo(image.snp.bottom).offset(8)
        }
    }
    
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
}


