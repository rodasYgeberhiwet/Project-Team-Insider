//
//  CreatePostViewController.swift
//  A4
//
//  Created by Amy Yang on 12/3/25.
//

import UIKit

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 20)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class CreatePostViewController: UIViewController {

    // MARK: - Properties (view)

    private let titleLabel = UILabel()
    
    private let overallRatingLabel = UILabel()
    private let overallRatingTextField = TextField()
    private let diffRatingLabel = UILabel()
    private let diffRatingTextField = TextField()
    private let memberLabel = UILabel()
    private let memberTextField = TextField()
    private let majorLabel = UILabel()
    private let majorTextField = TextField()
    private let yearsAppLabel = UILabel()
    private let yearsAppTextField = TextField()
    private let hoursLabel = UILabel()
    private let hoursTextField = TextField()
    private let messageLabel = UILabel()
    private let messageTextField = TextField()
    
    private let cancelButton = UIButton()
    private let postButton = UIButton()

    // MARK: - Properties (data)
    private var overallRatingText: String
    private var diffRatingText: String
    private var majorRatingText: String
    private var memberText: String
    private var yearAppText: String
    private var hoursText: String
    private var messageText: String
    private weak var delegate: UpdateTextDelegate?
    
    private let post: Post
    private let team: Team
    
    init(post: Post, team: Team, overallRatingText: String, diffRatingText: String, majorRatingText: String, memberText: String, yearAppText: String, hoursText: String, messageText: String, delegate: UpdateTextDelegate){
        self.post = post
        self.team = team
        self.overallRatingText = overallRatingText
        self.diffRatingText = diffRatingText
        self.majorRatingText = majorRatingText
        self.memberText = memberText
        self.yearAppText = yearAppText
        self.hoursText = hoursText
        self.messageText = messageText
        self.delegate = delegate
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
        
        view.backgroundColor = UIColor.a4.white
        
        
        configureView()
        setupTitleLabel()
        setupMajor()
        setupMembershipLabel()
        setupYears()
        setupHours()
        setupMessageField()
        setupOverallRating()
        setupDiffRating()
        setupCancelButton()
        setupPostButton()
    }

    // MARK: - Set Up Views
    
    private func configureView() {
        titleLabel.text = "Rate \(team.name)"
//        comp.text = team.comp
//        category.text = team.category
//        reviews.text = "\(team.reviews.count) reviews"
//        hours.text = "\(team.hours) hours/week"
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    
    /*
    private func setupMembershipLabel() {
        membershipLabel.textColor = .black
        membershipLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        membershipLabel.textAlignment = .left
        membershipLabel.numberOfLines = 0
        
        view.addSubview(membershipLabel)
        membershipLabel.translatesAutoresizingMaskIntoConstraints = false
            
        membershipLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
    }
     */

    private func setupTextField() {
        textField.placeholder = "✏️ What's on your mind?"
        textField.font = .systemFont(ofSize: 16)

        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: sidePadding)
        ])
    }

    /*
    private func setupPostButton() {
        postButton.backgroundColor = UIColor.a4.pinkRed
        postButton.layer.cornerRadius = 4
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.a4.white, for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        postButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)

        contentView.addSubview(postButton)
        postButton.translatesAutoresizingMaskIntoConstraints = false

        let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -sidePadding),
            postButton.widthAnchor.constraint(equalToConstant: 96),
            postButton.heightAnchor.constraint(equalToConstant: 32),
            postButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 32)
        ])
    }
    */
    /*
    private func setupCancelButton() {
        cancelButton.backgroundColor = UIColor.a4.pinkRed
        cancelButton.layer.cornerRadius = 4
        cancelButton.setTitle("Post", for: .normal)
        cancelButton.setTitleColor(UIColor.a4.white, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        cancelButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)

        contentView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        //snapkit constraints
    }
    */

    // MARK: - Button Helpers
/*
    @objc private func createPost() {
        // TODO: Send a POST request to create a post
        if let textFieldText = textField.text, !textFieldText.isEmpty {
            NetworkManager.shared.addToRoster(message: textFieldText) {[weak self] post in guard let self = self else {return} }
        }
    }
    */

}
