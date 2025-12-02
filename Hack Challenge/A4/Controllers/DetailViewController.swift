//
//  DetailViewController.swift
//  A4
//
//  Created by Amy Yang on 11/20/25.
//
/*
import UIKit
import SDWebImage
import SnapKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties (view)
    
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let image = UIImageView()
    private var bookmarkButton: UIBarButtonItem!
    private let backButtonImg = UIImage(systemName: "chevron.left")
    
    // MARK: - Properties (data)

    private let recipe: Recipe
    weak var delegate: BookmarkDelegate? // creation of delegate
    
    init(recipe: Recipe){
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImg, style: .plain, target: self, action: #selector(tapBack))
        setupImage()
        setupTitleLabel()
        setupDescription()
        configureView()
        setupBookmark()
        
    }
    
    // MARK: - Set Up Views
    
    private func setupTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    private func setupDescription() {
        descLabel.textColor = UIColor.a4.silver
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 0
        
        view.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
            
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    private func setupImage() {
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false

        image.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.height.equalTo(329)
            make.width.equalTo(340)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    private func configureView() {
        self.image.sd_setImage(with: URL(string: recipe.image_url))
        titleLabel.text = recipe.name
        descLabel.text = recipe.description
        
    }
    
    private func setupBookmark() {
        bookmarkButton = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(toggleBookmark)
        )
        
        navigationItem.rightBarButtonItem = bookmarkButton
        // let bookmarked = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        updateBookmark()
    }
    
    private func updateBookmark() {
        let bookmarked = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        if bookmarked.contains(recipe.name) {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        }
        else {
            bookmarkButton.image = UIImage(systemName: "bookmark")
        }
    }
    
    @objc private func toggleBookmark() {
        print("bookmark tapped for recipe: \(recipe.name)")
        
        var bookmarked = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        
        if bookmarked.contains(recipe.name) {
            // bookmarked already
            bookmarked.removeAll { name in
                name == recipe.name
            }
        } else {
            // not bookmarked yet
            bookmarked.append(recipe.name)
        }
        
        UserDefaults.standard.set(bookmarked, forKey: "bookmarked")
        updateBookmark()
        delegate?.didUpdateBookmarks() // assign delegate to complete the action of updating the bookmark
    }
    
    @objc private func tapBack() {
        navigationController?.popViewController(animated: true)
    }
}

protocol BookmarkDelegate: AnyObject { // using protocol to establish loose coupling instead of tight coupling
    func didUpdateBookmarks() // what the delegate must do
}

    
*/
