//
//  DetailViewController.swift
//  A4
//
//  Created by Amy Yang on 11/20/25.
//

import UIKit
import SDWebImage
import SnapKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties (view)
    
    private let titleLabel = UILabel()
    private let image = UIImageView()
    private let overallRatingNumberLabel = UILabel()
    private let overallRatingTextLabel = UILabel()
    private let difficultyRatingNumberLabel = UILabel()
    private let difficultyRatingTextLabel = UILabel()
    private let separatorView = UIView() // The thin vertical line
    private let siteButton = UIButton()
    private let category = UILabel()
    private let comp = UILabel()
    private let reviews1 = UILabel()
    private let hours = UILabel()
    private let descLabel = UILabel()
    private let reviews2 = UILabel()
    
    private var bookmarkButton: UIBarButtonItem!
    private let backButtonImg = UIImage(systemName: "chevron.left")
    
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties (data)

    private let team: Team
    weak var delegate: BookmarkDelegate? // creation of delegate
    
    private var posts: [Post] = []
    
    init(team: Team){
        self.team = team
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
        configureView()
        let dummyOverallRating: Float = 4.7
        let dummyDifficultyRating: Float = 3.5
        setupRatingMetrics(overallRating: dummyOverallRating, difficultyRating: dummyDifficultyRating)
        setupSiteButton()
        setupComp()
        setupCategory()
        setupDescription()
        setupBookmark()
//        setupPostCollectionView()
        
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
            make.centerY.equalTo(image.snp.centerY)
            make.leading.equalTo(image.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    private func setupRatingMetrics(overallRating: Float, difficultyRating: Float) {
        
        // --- 1. Overall Rating (LHS) ---
        
        // Set up the big number (e.g., 4.7)
        overallRatingNumberLabel.text = String(format: "%.1f", overallRating)
        overallRatingNumberLabel.textColor = UIColor.a4.offBlack
        overallRatingNumberLabel.font = .systemFont(ofSize: 32, weight: .bold)
        
        // Set up the descriptive text ("Overall")
        overallRatingTextLabel.text = "Overall"
        overallRatingTextLabel.textColor = UIColor.a4.silver
        overallRatingTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        view.addSubview(overallRatingNumberLabel)
        view.addSubview(overallRatingTextLabel)
        
        // --- 2. Difficulty Rating (RHS) ---
        
        // Set up the big number (e.g., 3.5)
        difficultyRatingNumberLabel.text = String(format: "%.1f", difficultyRating)
        difficultyRatingNumberLabel.textColor = UIColor.a4.offBlack
        difficultyRatingNumberLabel.font = .systemFont(ofSize: 32, weight: .bold) // Bigger font
        
        // Set up the descriptive text ("Difficulty")
        difficultyRatingTextLabel.text = "Difficulty"
        difficultyRatingTextLabel.textColor = UIColor.a4.silver
        difficultyRatingTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        view.addSubview(difficultyRatingNumberLabel)
        view.addSubview(difficultyRatingTextLabel)
        
        // --- 3. Separator Line ---
        
        separatorView.backgroundColor = UIColor.a4.silver // Thin line color
        view.addSubview(separatorView)
        
        // --- 4. Apply SnapKit Constraints ---
        
        // Constraints for Overall Rating (LHS)
        overallRatingNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(32)
        }
        
        overallRatingTextLabel.snp.makeConstraints { make in
            // Positioned directly below the rating number
            make.top.equalTo(overallRatingNumberLabel.snp.bottom).offset(4)
            make.centerX.equalTo(overallRatingNumberLabel.snp.centerX)
        }
                
        // Constraint for Separator (Center component)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(overallRatingNumberLabel.snp.top).offset(4)
            make.leading.equalTo(overallRatingNumberLabel.snp.trailing).offset(32)
            make.width.equalTo(1) // Thin vertical line
            make.height.equalTo(50)
        }

        // Constraints for Difficulty Rating (RHS)
        difficultyRatingNumberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(overallRatingNumberLabel.snp.centerY)
            make.leading.equalTo(separatorView.snp.trailing).offset(32)
        }
        
        difficultyRatingTextLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyRatingNumberLabel.snp.bottom).offset(4)
            make.centerX.equalTo(difficultyRatingNumberLabel.snp.centerX)
//            make.bottom.lessThanOrEqualToSuperview().offset(-32) // Ensure the bottom anchor is constrained
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
            make.top.equalTo(overallRatingTextLabel.snp.bottom).offset(16)
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
            make.leading.equalToSuperview().offset(32)
            make.height.equalTo(80) //329
            make.width.equalTo(80) //340
        }
    }
    
    private func configureView() {
//        self.image.sd_setImage(with: URL(string: team.image_url))
        self.image.image = UIImage(named: "appdev-logo") //dummy image
        titleLabel.text = team.name
        descLabel.text = team.description
        
    }
    
    private func setupSiteButton() {
        siteButton.backgroundColor = UIColor.a4.darkBlue
        siteButton.layer.cornerRadius = 4
        siteButton.setTitle(" Visit Site", for: .normal)
        siteButton.setTitleColor(UIColor.a4.white, for: .normal)
        let linkImage = UIImage(systemName: "link") //~link, safari
        siteButton.setImage(linkImage, for: .normal)
        siteButton.tintColor = UIColor.a4.white
        siteButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
//        postButton.addTarget(self, action: #selector(openSite), for: .touchUpInside)
        siteButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 8)

        view.addSubview(siteButton)
        siteButton.translatesAutoresizingMaskIntoConstraints = false
        
        siteButton.snp.makeConstraints { make in
            // Vertically align the site button with the top of the ratings numbers
            make.centerY.equalTo(separatorView.snp.centerY)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    func setupComp() {
        comp.textColor = UIColor.white
        comp.backgroundColor = UIColor.a4.pinkRed
        comp.layer.cornerRadius = 8
        comp.layer.masksToBounds = true
        comp.font = .systemFont(ofSize: 10, weight: .bold)
        comp.textAlignment = .center
        
//        comp.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        view.addSubview(comp)
        comp.translatesAutoresizingMaskIntoConstraints = false
        
        comp.snp.makeConstraints { make in
            make.top.equalTo(overallRatingTextLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
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
        
//        category.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
//        16
        view.addSubview(category)
        category.translatesAutoresizingMaskIntoConstraints = false
        
        category.snp.makeConstraints { make in
            make.centerY.equalTo(comp.snp.centerY)
            make.leading.equalTo(comp.snp.trailing).offset(16)
        }
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
        if bookmarked.contains(team.name) {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        }
        else {
            bookmarkButton.image = UIImage(systemName: "bookmark")
        }
    }
    
    @objc private func toggleBookmark() {
        print("bookmark tapped for recipe: \(team.name)")
        
        var bookmarked = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
        
        if bookmarked.contains(team.name) {
            // bookmarked already
            bookmarked.removeAll { name in
                name == team.name
            }
        } else {
            // not bookmarked yet
            bookmarked.append(team.name)
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

    

