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
    // private let subtextLabel = UILabel()
    private let nameLabel = UILabel()
    private let image = UIImageView()
    private let overallRatingNumberLabel = UILabel()
    private let overallRatingTextLabel = UILabel()
    private let difficultyRatingNumberLabel = UILabel()
    private let difficultyRatingTextLabel = UILabel()
    private let separatorView = UIView() // The thin vertical line
    private let siteButton = UIButton()
    private let category = PaddedLabel()
    private let comp = PaddedLabel()
    private let reviews = UILabel()
    private let hours = UILabel()
    private let descLabel = UILabel()
    //private let reviews2 = UILabel()
    
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
        
        let titleLabel = UILabel()
        titleLabel.text = "Cup of Teams"
        titleLabel.textColor = UIColor.a4.lightPurple
        titleLabel.font = UIFont.rounded(ofSize: 28, weight: .bold)

        let attributedString = NSMutableAttributedString(string: "Cup of Teams")
        attributedString.addAttribute(.kern, value: 1.2, range: NSRange(location: 0, length: attributedString.length))
        titleLabel.attributedText = attributedString

        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        setupGradientBackground()
        view.backgroundColor = UIColor.a4.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImg, style: .plain, target: self, action: #selector(tapBack))
        setupImage()
        setupNameLabel()
        configureView()
        let dummyOverallRating: Float = 4.7
        let dummyDifficultyRating: Float = 3.5
        setupRatingMetrics(overallRating: dummyOverallRating, difficultyRating: dummyDifficultyRating)
        setupSiteButton()
        setupComp()
        setupCategory()
        setupReviews()
        setupHours()
        setupDescription()
        setupBookmark()
//        setupPostCollectionView()
        
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
            
        let darkdarkBlue = UIColor.a4.darkdarkBlue.cgColor
        let darkBlue = UIColor.a4.darkBlue.cgColor
        let lightBlue = UIColor.a4.lightPurple.cgColor
        let white = UIColor.a4.white.cgColor
        
        gradientLayer.colors = [
            darkdarkBlue,      // Top: Dark blue
            darkBlue,
            lightBlue,     // Quick transition to light blue
            white,         // White starts EARLY
            white          // Rest is white
        ]
        
        // ⭐️ CRITICAL: Adjust these values! Lower numbers = higher up
        // 0 = top of screen, 1 = bottom of screen
        gradientLayer.locations = [0, 0.15, 0.25, 0.33, 1]  // ⭐️ White starts at 25% down!
        
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }

    
    // MARK: - Set Up Views
    private func configureView() {
//        self.image.sd_setImage(with: URL(string: team.image_url))
        self.image.image = UIImage(named: "appdev-logo") //dummy image
        nameLabel.text = team.name
        descLabel.text = team.description
        comp.text = team.comp
        category.text = team.category
        reviews.text = "\(team.reviews.count) reviews"
        hours.text = "\(team.hours) hours/week"
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Big Red Teams"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textAlignment = .left
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview()
        }
    }
    /*
    private func setupSubtextLabel() {
        subtextLabel.text = "Learn more about Cornell's student-led project teams"
        subtextLabel.textColor = .white
        subtextLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        subtextLabel.textAlignment = .left
        subtextLabel.numberOfLines = 0
        
        view.addSubview(subtextLabel)
        subtextLabel.translatesAutoresizingMaskIntoConstraints = false
            
        subtextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview()
        }
    }
    */
    private func setupNameLabel() {
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
        nameLabel.snp.makeConstraints { make in
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
        comp.font = .systemFont(ofSize: 12, weight: .bold)
        comp.textAlignment = .center
        
        comp.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        view.addSubview(comp)
        comp.translatesAutoresizingMaskIntoConstraints = false
        
        comp.snp.makeConstraints { make in
            make.top.equalTo(overallRatingTextLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(32)
        }
    }
    
    func setupCategory() {
        category.textColor = UIColor.a4.offBlack
        category.backgroundColor = UIColor.a4.lilac
        category.layer.borderWidth = 1
        // category.layer.borderColor = UIColor.darkGray.cgColor
        category.layer.cornerRadius = 8
        category.layer.masksToBounds = true
        category.font = .systemFont(ofSize: 12, weight: .bold)
        category.textAlignment = .center
        
        category.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        
        view.addSubview(category)
        category.translatesAutoresizingMaskIntoConstraints = false
        
        category.snp.makeConstraints { make in
            make.centerY.equalTo(comp.snp.centerY)
            make.leading.equalTo(comp.snp.trailing).offset(16)
        }
    }
    
    func setupReviews() {
        reviews.textColor = UIColor.a4.offBlack
        reviews.font = .systemFont(ofSize: 18, weight: .semibold)
        
        view.addSubview(reviews)
        reviews.translatesAutoresizingMaskIntoConstraints = false
        
        reviews.snp.makeConstraints { make in
            make.top.equalTo(comp.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(32)
        }
    }
    
    func setupHours() {
        hours.textColor = UIColor.a4.offBlack
        hours.font = .systemFont(ofSize: 18, weight: .semibold)
        
        view.addSubview(hours)
        hours.translatesAutoresizingMaskIntoConstraints = false
        
        hours.snp.makeConstraints { make in
            make.top.equalTo(comp.snp.bottom).offset(20)
            make.leading.equalTo(reviews.snp.trailing).offset(60)
        }
    }
    
    private func setupDescription() {
        descLabel.textColor = UIColor.black
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 0
        
        view.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
            
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(reviews.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
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
        let bookmarked = UserDefaults.standard.array(forKey: "bookmarked") as? [String] ?? []
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

    
extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}
