//
//  CreatePostViewController.swift
//  A4
//
//  Created by Amy Yang on 12/3/25.
//

import UIKit
import SnapKit

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
    private let majorLabel = UILabel()
    private let majorTextField = TextField()
    private let memberLabel = UILabel()
    private let memberTextField = TextField()
    private let yearsAppLabel = UILabel()
    private let yearsAppTextField = TextField()
    private let hoursLabel = UILabel()
    private let hoursTextField = TextField()
    private let messageLabel = UILabel()
    private let messageTextField = TextField()
    
    private let cancelButton = UIButton()
    private let postButton = UIButton()

    // MARK: - Properties (data)
    private let team: Team
    private var overallRatingText: String
    private var diffRatingText: String
    private var majorText: String
    private var memberText: String
    private var yearsAppText: String
    private var hoursText: String
    private var messageText: String
    private weak var delegate: UpdateTextDelegate?
    
    private let sidePadding: CGFloat = 24
    private var lastView: UIView!
    
    // MARK: - init
    
    init(team: Team, overallRatingText: String, diffRatingText: String, majorText: String, memberText: String, yearsAppText: String, hoursText: String, messageText: String, delegate: UpdateTextDelegate){
        self.team = team
        self.overallRatingText = overallRatingText
        self.diffRatingText = diffRatingText
        self.majorText = majorText
        self.memberText = memberText
        self.yearsAppText = yearsAppText
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
        view.backgroundColor = UIColor.a4.white
        
        configureView()
        setupTitleLabel()
        
        lastView = titleLabel // Start vertical stacking below the title
        
        // Setup all 7 input field pairs sequentially
        setupInputPair(label: overallRatingLabel, textField: overallRatingTextField, labelText: "Overall Rating (1-5)", placeholder: "e.g., 4.5", initialText: overallRatingText)
        setupInputPair(label: diffRatingLabel, textField: diffRatingTextField, labelText: "Difficulty Rating (1-5)", placeholder: "e.g., 3.0", initialText: diffRatingText)
        setupInputPair(label: majorLabel, textField: majorTextField, labelText: "Major", placeholder: "e.g., Computer Science", initialText: majorText)
        setupInputPair(label: memberLabel, textField: memberTextField, labelText: "Member Status", placeholder: "e.g., Yes/No", initialText: memberText)
        setupInputPair(label: yearsAppLabel, textField: yearsAppTextField, labelText: "Years Applied", placeholder: "e.g., 1", initialText: yearsAppText)
        setupInputPair(label: hoursLabel, textField: hoursTextField, labelText: "Time Commitment (hours/week)", placeholder: "e.g., 15", initialText: hoursText)
        
        setupMessageField(label: messageLabel, textField: messageTextField, labelText: "Your Message/Review", placeholder: "Share your experience...", initialText: messageText)
        
        setupButtons()
    }
    /*
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
        /*
        setupMajor()
        setupMembershipLabel()
        setupYears()
        setupHours()
        setupMessageField()
        setupOverallRating()
        setupDiffRating()
        setupCancelButton()
        setupPostButton()
        */
    }
    */

    // MARK: - Set Up Views
    //~im confused bc why are we initializing blank fields?? whats being passed in anyhow?
    private func configureView() {
        titleLabel.text = "Rate \(team.name)"
        overallRatingLabel.text = overallRatingText
        diffRatingLabel.text = diffRatingText
        majorLabel.text = majorText
        memberLabel.text = memberText
        yearsAppLabel.text = yearsAppText
        hoursLabel.text = hoursText
        messageLabel.text = messageText
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(sidePadding)
            make.trailing.equalToSuperview().offset(-sidePadding) //~how does this work if not spanning the entire thing tho
        }
    }
    
    private func setupInputPair(label: UILabel, textField: TextField, labelText: String, placeholder: String, initialText: String) {
        
        // 1. Configure Label
        label.text = labelText
        label.textColor = UIColor.a4.offBlack
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        view.addSubview(label)
        
        // 2. Configure TextField
        textField.placeholder = placeholder
        textField.text = initialText
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = UIColor.a4.lilac.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        view.addSubview(textField)
        
        // 3. Apply Constraints
        
        // Label constraints (start below the previous element)
        label.snp.makeConstraints { make in
            make.top.equalTo(lastView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(sidePadding)
            make.trailing.equalToSuperview().offset(-sidePadding)
        }
        
        // TextField constraints (below the label)
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(sidePadding)
            make.trailing.equalToSuperview().offset(-sidePadding)
            make.height.equalTo(44)
        }
        
        // Update the last constrained view for the next stack
        lastView = textField
    }
    
    private func setupMessageField(label: UILabel, textField: TextField, labelText: String, placeholder: String, initialText: String) {
        
        // 1. Configure Label
        label.text = labelText
        label.textColor = UIColor.a4.offBlack
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        view.addSubview(label)
        
        // 2. Configure TextField (using large text area appearance)
        textField.placeholder = placeholder
        textField.text = initialText
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = UIColor.a4.lilac.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        view.addSubview(textField)
        
        // 3. Apply Constraints
        label.snp.makeConstraints { make in
            make.top.equalTo(lastView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(sidePadding)
            make.trailing.equalToSuperview().offset(-sidePadding)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(sidePadding)
            make.trailing.equalToSuperview().offset(-sidePadding)
            make.height.equalTo(120) // Provide adequate height for the message field
        }
        
        lastView = textField
    }
    
    private func setupButtons() {
        // Setup Post Button (Save/Submit action)
        postButton.backgroundColor = UIColor.a4.darkBlue // Changed color from source [11] for clarity/consistency
        postButton.layer.cornerRadius = 4
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.a4.white, for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        postButton.addTarget(self, action: #selector(popVC), for: .touchUpInside) // Target for posting and popping [12]
        view.addSubview(postButton)
        
        // Setup Cancel Button
        cancelButton.backgroundColor = UIColor.a4.pinkRed
        cancelButton.layer.cornerRadius = 4
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.a4.white, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        cancelButton.addTarget(self, action: #selector(tapBack), for: .touchUpInside) // Target for popping [14]
        view.addSubview(cancelButton)

        // Constraints for buttons (place below the message field)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(lastView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(sidePadding)
            make.width.equalTo(96) // Using width from example constraints [15]
            make.height.equalTo(40)
        }

        postButton.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.top)
            make.trailing.equalToSuperview().offset(-sidePadding)
            make.width.equalTo(96)
            make.height.equalTo(40)
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
    /*
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
     */
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
    
    // MARK: - Button Helpers (Delegate/Navigation)

    @objc private func popVC() {
        print("popVC() called")
        navigationController?.popViewController(animated: true)

        // Delegate call to pass back all collected text fields [12]
        delegate?.updateText(
            newOverallRatingText: overallRatingTextField.text ?? "",
            newDiffRatingText: diffRatingTextField.text ?? "",
            newMajorText: majorTextField.text ?? "",
            newMemberText: memberTextField.text ?? "",
            newYearsAppText: yearsAppTextField.text ?? "",
            newHoursText: hoursTextField.text ?? "",
            newMessageText: messageTextField.text ?? ""
        )
    }

    @objc private func tapBack() {
        print("tapBack() called")
        navigationController?.popViewController(animated: true)
    }

}
