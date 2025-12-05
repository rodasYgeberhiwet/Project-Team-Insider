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
    private let createPostButton = UIButton()
    private var postCollectionView: UICollectionView!
    
    private var bookmarkButton: UIBarButtonItem!
    private let backButtonImg = UIImage(systemName: "chevron.left")
    
    private let scrollView = UIScrollView()
    private let contentView = UIView() //scrollable view
//    private var collectionView: UICollectionView!
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
        
        let post1 = Post(
            likes: ["aly32", "user_b", "user_c"], // Includes the current user's netId ("aly32") to test liking logic [3]
            message: "The development workflow is highly structured and professional. Excellent mentorship for new members, but expect the time commitment to be closer to 20 hours/week.",
            time: Date().addingTimeInterval(-3600 * 4), // 4 hours ago
            id: "review_101",
            profileImage: "default_icon.png",
            overallRating: "4.9",
            difficultyRating: "3.1",
            isMember: true,
            yearsMember: "F2024 - S2025",
            major: "Computer Science",
            timesApplied: 1,
            timeCommitment: "15-20" // matches setupDataLabels dummy data [4]
        )
        
        let post2 = Post(
            likes: [],
            message: "The interview process was mostly behavioral and very organized. I was slightly disappointed by the lack of technical feedback provided afterwards.",
            time: Date().addingTimeInterval(-86400 * 5), // 5 days ago
            id: "interview_204",
            profileImage: "default_icon.png",
            overallRating: "4.5",
            difficultyRating: "4.3",
            isMember: false,
            yearsMember: "N/A",
            major: "Electrical Engineering",
            timesApplied: 2,
            timeCommitment: "N/A"
        )

        let post3 = Post(
            likes: ["user_a"],
            message: "I really enjoyed the collaborative environment. Great for beginners looking to learn the basics!",
            time: Date().addingTimeInterval(-60 * 15), // 15 minutes ago
            id: "review_300",
            profileImage: "default_icon.png",
            overallRating: "4.1",
            difficultyRating: "3.9",
            isMember: true,
            yearsMember: "F2023",
            major: "Information Science",
            timesApplied: 1,
            timeCommitment: "10-15"
        )
        
        let post4 = Post(
            likes: ["user_x", "user_y", "user_z"],
            message: "The technical challenges here are graduate-level. You'll work on real engineering problems that push your limits. Not recommended for beginners.",
            time: Date().addingTimeInterval(-60 * 25), // 25 minutes ago
            id: "review_400",
            profileImage: "default_icon.png",
            overallRating: "4.9",
            difficultyRating: "4.7",
            isMember: true,
            yearsMember: "S2023",
            major: "Mechanical Engineering",
            timesApplied: 2,
            timeCommitment: "18-24"
        )

        let post5 = Post(
            likes: ["user_m", "user_n"],
            message: "Best community I've found on campus. Everyone is supportive and you'll ship actual products that get used. Great mix of technical and creative work.",
            time: Date().addingTimeInterval(-60 * 45), // 45 minutes ago
            id: "review_500",
            profileImage: "default_icon.png",
            overallRating: "4.8",
            difficultyRating: "3.8",
            isMember: true,
            yearsMember: "F2022",
            major: "Computer Science",
            timesApplied: 1,
            timeCommitment: "15-20"
        )

        let post6 = Post(
            likes: ["user_p"],
            message: "Seeing your work actually get implemented and help people is incredibly fulfilling. More hands-on building than theoretical design work.",
            time: Date().addingTimeInterval(-60 * 90), // 1.5 hours ago
            id: "review_600",
            profileImage: "default_icon.png",
            overallRating: "4.7",
            difficultyRating: "3.5",
            isMember: true,
            yearsMember: "S2023",
            major: "Civil Engineering",
            timesApplied: 1,
            timeCommitment: "10-15"
        )

        let post7 = Post(
            likes: ["user_q", "user_r", "user_s", "user_t"],
            message: "We spend more time in the workshop than anywhere else. The commitment is intense but the competition experience is absolutely worth it.",
            time: Date().addingTimeInterval(-60 * 120), // 2 hours ago
            id: "review_700",
            profileImage: "default_icon.png",
            overallRating: "4.8",
            difficultyRating: "4.5",
            isMember: true,
            yearsMember: "F2021",
            major: "Mechanical Engineering",
            timesApplied: 3,
            timeCommitment: "20-25"
        )

        let post8 = Post(
            likes: ["user_u"],
            message: "You build software that actually helps communities. Less about fancy tech stacks, more about solving real problems for people in need.",
            time: Date().addingTimeInterval(-60 * 180), // 3 hours ago
            id: "review_800",
            profileImage: "default_icon.png",
            overallRating: "4.6",
            difficultyRating: "3.2",
            isMember: true,
            yearsMember: "S2024",
            major: "Information Science",
            timesApplied: 1,
            timeCommitment: "10-14"
        )

        let post9 = Post(
            likes: ["user_v", "user_w"],
            message: "The AI/ML work we do competes with graduate research. You'll learn cutting-edge algorithms that aren't covered in undergraduate courses.",
            time: Date().addingTimeInterval(-60 * 240), // 4 hours ago
            id: "review_900",
            profileImage: "default_icon.png",
            overallRating: "4.9",
            difficultyRating: "4.4",
            isMember: true,
            yearsMember: "F2023",
            major: "Electrical & Computer Engineering",
            timesApplied: 2,
            timeCommitment: "20-25"
        )

        let post10 = Post(
            likes: ["user_aa", "user_bb", "user_cc"],
            message: "International trips completely changed my engineering perspective. Building infrastructure abroad teaches you more than any classroom ever could.",
            time: Date().addingTimeInterval(-60 * 300), // 5 hours ago
            id: "review_1000",
            profileImage: "default_icon.png",
            overallRating: "4.7",
            difficultyRating: "3.6",
            isMember: true,
            yearsMember: "S2022",
            major: "Environmental Engineering",
            timesApplied: 1,
            timeCommitment: "10-15"
        )
        
        let dummyPosts: [Post] = [
            post1,
            post2,
            post3,
            post4,
            post5,
            post6,
            post7,
            post8,
            post9,
            post10
        ]
        
        self.posts = dummyPosts
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImg, style: .plain, target: self, action: #selector(tapBack))
        setupScroll()
        setupImage()
        setupNameLabel()
        configureView()
        setupRatingMetrics()
        setupSiteButton()
        setupComp()
        setupCategory()
        setupReviews()
        setupHours()
        setupDescription()
        setupCreatePostButton()
        setupPostCollectionView()
        setupBookmark()
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
            
        let darkdarkBlue = UIColor.a4.darkdarkBlue.cgColor
        let darkBlue = UIColor.a4.darkBlue.cgColor
        let lightBlue = UIColor.a4.lightPurple.cgColor
        let white = UIColor.a4.white.cgColor
        
        gradientLayer.colors = [
            darkdarkBlue,
            darkBlue,
            white,
            lightBlue,
            lightBlue
        ]

        gradientLayer.locations = [0, 0.15, 0.25, 0.60, 1]
        
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
        //reviews.text = "\(team.reviews.count) reviews"
        reviews.text = "10 reviews"
        hours.text = "\(team.hours) hours/week"
        overallRatingNumberLabel.text = team.overallRating
        difficultyRatingNumberLabel.text = team.diffRating
    }
    
    private func setupScroll() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // pin ContentView to the ScrollView edges
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width) // vertical scrolling
        }
    }
    
    /*
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
     */
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
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(image.snp.centerY)
            make.leading.equalTo(image.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    private func setupRatingMetrics() {
                
        // Set up the big number (e.g., 4.7)
        overallRatingNumberLabel.textColor = UIColor.a4.offBlack
        overallRatingNumberLabel.font = .systemFont(ofSize: 32, weight: .bold)
        
        // Set up the descriptive text ("Overall")
        overallRatingTextLabel.text = "Overall"
        overallRatingTextLabel.textColor = UIColor.a4.silver
        overallRatingTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        contentView.addSubview(overallRatingNumberLabel)
        contentView.addSubview(overallRatingTextLabel)
                
        // Set up the big number (e.g., 3.5)
        difficultyRatingNumberLabel.textColor = UIColor.a4.offBlack
        difficultyRatingNumberLabel.font = .systemFont(ofSize: 32, weight: .bold) // Bigger font
        
        // Set up the descriptive text ("Difficulty")
        difficultyRatingTextLabel.text = "Difficulty"
        difficultyRatingTextLabel.textColor = UIColor.a4.silver
        difficultyRatingTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        contentView.addSubview(difficultyRatingNumberLabel)
        contentView.addSubview(difficultyRatingTextLabel)
        
        // --- 3. Separator Line ---
        
        separatorView.backgroundColor = UIColor.a4.silver // Thin line color
        contentView.addSubview(separatorView)
        
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
        
        contentView.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false

        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(32)
            make.height.equalTo(80) //329
            make.width.equalTo(80) //340
        }
    }
    
    private func setupSiteButton() {
        siteButton.backgroundColor = UIColor.a4.darkBlue
        siteButton.layer.cornerRadius = 4
        siteButton.layer.shadowColor = UIColor.a4.black.cgColor
        siteButton.layer.shadowOpacity = 0.2
        siteButton.layer.shadowRadius = 4
        siteButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        siteButton.setTitle(" Visit Site", for: .normal)
        siteButton.setTitleColor(UIColor.a4.white, for: .normal)
        let linkImage = UIImage(systemName: "link") //~link, safari
        siteButton.setImage(linkImage, for: .normal)
        siteButton.tintColor = UIColor.a4.white
        siteButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        siteButton.addTarget(self, action: #selector(openSite), for: .touchUpInside)
        siteButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 8)

        contentView.addSubview(siteButton)
        siteButton.translatesAutoresizingMaskIntoConstraints = false
        
        siteButton.snp.makeConstraints { make in
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

        contentView.addSubview(comp)
        comp.translatesAutoresizingMaskIntoConstraints = false
        
        comp.snp.makeConstraints { make in
            make.top.equalTo(overallRatingTextLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(32)
        }
    }
    
    func setupCategory() {
        category.textColor = UIColor.a4.offBlack
        category.backgroundColor = UIColor.a4.lilac
//        category.layer.borderWidth = 1
        // category.layer.borderColor = UIColor.darkGray.cgColor
        category.layer.cornerRadius = 8
        category.layer.masksToBounds = true
        category.font = .systemFont(ofSize: 12, weight: .bold)
        category.textAlignment = .center
        
        category.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        
        contentView.addSubview(category)
        category.translatesAutoresizingMaskIntoConstraints = false
        
        category.snp.makeConstraints { make in
            make.centerY.equalTo(comp.snp.centerY)
            make.leading.equalTo(comp.snp.trailing).offset(16)
        }
    }
    
    func setupReviews() {
        reviews.textColor = UIColor.a4.offBlack
        reviews.font = .systemFont(ofSize: 18, weight: .semibold)
        
        contentView.addSubview(reviews)
        reviews.translatesAutoresizingMaskIntoConstraints = false
        
        reviews.snp.makeConstraints { make in
            make.top.equalTo(comp.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
        }
    }
    
    func setupHours() {
        hours.textColor = UIColor.a4.offBlack
        hours.font = .systemFont(ofSize: 18, weight: .semibold)
        
        contentView.addSubview(hours)
        hours.translatesAutoresizingMaskIntoConstraints = false
        
        hours.snp.makeConstraints { make in
            make.top.equalTo(comp.snp.bottom).offset(16)
            make.leading.equalTo(reviews.snp.trailing).offset(60)
        }
    }
    
    private func setupDescription() {
        descLabel.textColor = UIColor.a4.offBlack
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 0
        
        contentView.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
            
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(reviews.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    func setupCreatePostButton() {
        createPostButton.backgroundColor = UIColor.a4.darkBlue
        createPostButton.layer.cornerRadius = 4
        //inner shadow effect
        createPostButton.layer.shadowColor = UIColor.a4.black.cgColor
        createPostButton.layer.shadowOpacity = 0.2
        createPostButton.layer.shadowRadius = 4
        createPostButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        createPostButton.layer.masksToBounds = false
        createPostButton.setTitle(" Post", for: .normal)
        createPostButton.setTitleColor(UIColor.a4.white, for: .normal)
        createPostButton.tintColor = UIColor.a4.white
        let iconImage = UIImage(systemName: "square.and.pencil")
        createPostButton.setImage(iconImage, for: .normal)
        createPostButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        createPostButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
     
             createPostButton.addTarget(self, action: #selector(pushCreatePost), for: .touchUpInside)

        view.addSubview(createPostButton)
        createPostButton.translatesAutoresizingMaskIntoConstraints = false
        
        createPostButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    private func setupPostCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //~needed?
//        layout.estimatedItemSize = automatic
//        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 16
        
        // Initialize collectionView using the layout
        postCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.reuse)
        postCollectionView.backgroundColor = UIColor.a4.lightPurple
        postCollectionView.alwaysBounceVertical = true
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
//        postCollectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        postCollectionView.isScrollEnabled = false //let parent control scrolling
        
//        refreshControl.addTarget(self, action: #selector(getRecipes), for: .valueChanged)
        postCollectionView.refreshControl = refreshControl
        
        contentView.addSubview(postCollectionView)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(createPostButton.snp.bottom).offset(2)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(calculateCollectionViewHeight()) //height of all posts
            make.bottom.equalToSuperview()
        }
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        let postCount = posts.count
        let estimatedCellHeight: CGFloat = 350
        let sectionTopInset: CGFloat = 16
        let sectionBottomInset: CGFloat = 32
        let contentInsetTop: CGFloat = 32
        let minimumLineSpacing: CGFloat = 0 //~what value?
        let interItemSpacing: CGFloat = 16

        // Total height calculation:
        // (Total height of all cells) + (Spacing between cells) + (Insets/Padding)
        
        let totalCellHeight = estimatedCellHeight * CGFloat(postCount)
        let totalSpacing = interItemSpacing * CGFloat(postCount - 1)
        let totalPadding = sectionTopInset + sectionBottomInset + contentInsetTop

        return totalCellHeight + totalSpacing + totalPadding
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
    
    @objc private func openSite() {
        guard let urlString = team.website,
              let url = URL(string: urlString) else {
            return
        }

        UIApplication.shared.open(url) { success in
            // error handling?
        }
    }
    
    @objc private func pushCreatePost() {
        let createVC = CreatePostViewController(
            team: team,
            overallRatingText: "",
            diffRatingText: "",
            majorText: "",
            memberText: "",
            yearsAppText: "",
            hoursText: "",
            messageText: "",
            delegate: self
        )
    navigationController?.pushViewController(createVC, animated: true)
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

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuse, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }

        let post = posts[indexPath.row]
        cell.configure(post: post)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // define height based on content of PostCollectionViewCell (wraps)
        let width = collectionView.frame.width - (32 * 2) // Total width minus padding
        // estimate a height tall enough to contain all elements, or use self-sizing cells.
        let estimatedHeight: CGFloat = 350 // Placeholder height based on required complexity
        
        return CGSize(width: width, height: estimatedHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle post selection/interaction here
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Add padding around the section
        return UIEdgeInsets(top: 16, left: 32, bottom: 32, right: 32)
    }
    
    @objc private func pushVC() {
        // TODO: Push ViewControllerTwo
        //let editVC = EditProfileVC(hometownText: hometownText, majorText: majorText, delegate: self)
        //navigationController?.pushViewController(editVC, animated: true)
    }
}

extension DetailViewController: UpdateTextDelegate {

    func updateText(
        newOverallRatingText: String,
        newDiffRatingText: String,
        newMajorText: String,
        newMemberText: String,
        newYearsAppText: String,
        newHoursText: String,
        newMessageText: String
    ) {
        print("updateText called")
        // Step A: Data Conversion and Preparation
        
        // Convert status string to Bool for isMember, defaulting to false
        let isMember = newMemberText.lowercased() == "yes"
        
        // Convert years applied string to Int, defaulting to 0
        let timesAppliedInt = Int(newYearsAppText) ?? 0
        
        // Determine yearsMember status based on isMember
        let yearsMemberStatus = isMember ? "F2025 - S2026" : "N/A"
        
        // Step B: Create a New Post Object
        
        // Construct the new Post object using the data collected from CreatePostVC.
        let newPost = Post(
            likes: [], // Initially, the new post has no likes
            message: newMessageText,
            time: Date(), // Set post time to now
            id: UUID().uuidString, // Generate a unique identifier
            profileImage: "default_icon.png", // Use a placeholder profile image
            overallRating: newOverallRatingText,
            difficultyRating: newDiffRatingText,
            isMember: isMember,
            yearsMember: yearsMemberStatus,
            major: newMajorText,
            timesApplied: timesAppliedInt,
            timeCommitment: newHoursText
        )

        // ****************
        // NOTE: In a complete application, NetworkManager.shared.createPost(...)
        // would be called here, sending all seven parameters to the backend
        // (which might involve routes defined for reviews or interviews [4, 5]).
        // The rest of this block would execute upon successful API response.
        // ****************

        // Step C: Update the Data Source
        
        // Append the newly created post to the local data source array [6, 7].
        self.posts.append(newPost)

        // Step D: Display the New Post
        
        // Force the post collection view to reload its data to show the newly added item [8].
        self.postCollectionView.reloadData()
    }
}

protocol UpdateTextDelegate: AnyObject {
    func updateText(newOverallRatingText: String, newDiffRatingText: String, newMajorText: String, newMemberText: String, newYearsAppText: String, newHoursText: String, newMessageText: String)
}

