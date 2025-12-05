//
//  PostCollectionViewCell.swift
//  A4
//
//  Created by Amy Yang on 12/3/25.
//

import UIKit
import SnapKit

class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    
    private let profileImage = UIImageView()
    private let name = UILabel()
    private var time = UILabel()
    
    private let overallRatingNumberLabel = UILabel()
    private let overallRatingTextLabel = UILabel()
    private let difficultyRatingNumberLabel = UILabel()
    private let difficultyRatingTextLabel = UILabel()
    private let separatorView = UIView()
    
    private let membership = UILabel()
    private let major = UILabel()
    private let timesApplied = UILabel()
    private let timeCommitment = UILabel()
    private let message = UILabel()
    private let heart = UIButton()
    private let likes = UILabel()
    
    // MARK: - Properties (data)
    
    static let reuse: String = "CustomCollectionViewCellReuse"
    private var post: Post?
    private let netId = "aly32"
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.a4.white
        layer.cornerRadius = 16
        
        setupProfileImage()
        setupName()
        setupDate()
        setupRatingMetrics()
        setupDataLabels()
        setupMessage()
//        setupHeart()
        setupHeartButton()
        setupLikeCount()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure
    func configure(post: Post){
        self.post = post
//        logo.image = UIImage(named: "appdev-logo") // can be moved to setupLogo()
        name.text = "Anonymous"
        time.text = post.time.convertToAgo()
        likes.text = "\(post.likes.count) likes"
        overallRatingNumberLabel.text = post.overallRating
        overallRatingTextLabel.text = "Overall"
        difficultyRatingNumberLabel.text = post.difficultyRating
        difficultyRatingTextLabel.text = "Difficulty"
        if(post.isMember){
            membership.text = "Member: \(post.yearsMember)"
        } else {
            membership.text = "Member: No"
        }
        major.text = "Major: \(post.major)"
        timesApplied.text = "Times applied: \(post.timesApplied)"
        timeCommitment.text = "Time commitment: \(post.timeCommitment) hours/week"
        message.text = post.message
        
        let postIsLiked = post.likes.contains(netId)
        heart.setTitle(postIsLiked ? "♥︎" : "♡", for: .normal)
        heart.setTitleColor(postIsLiked ? UIColor.a4.pinkRed : UIColor.a4.silver, for: .normal)
    }
    
    // MARK: - Set Up Views
    /*
    private func setupLogo(){
        logo.contentMode = .scaleAspectFit
        
        contentView.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: sidePadding),
            logo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            logo.widthAnchor.constraint(equalToConstant: 32),
            logo.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    */
    
    private let sidePadding: CGFloat = 24
    private let imageSize: CGFloat = 32
    
    private func setupProfileImage(){
        profileImage.image = UIImage(named: "appdev-logo") // dummy image
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = imageSize
        contentView.addSubview(profileImage)
                
        contentView.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(sidePadding)
            make.leading.equalToSuperview().offset(sidePadding)
            make.width.height.equalTo(imageSize)
        }
    }
    
    private func setupName(){
        name.textColor = UIColor.a4.black
        name.font = .systemFont(ofSize: 14, weight: .semibold)
        
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
    }
    
    private func setupDate(){
        time.textColor = UIColor.a4.silver
        time.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(time)
        time.translatesAutoresizingMaskIntoConstraints = false
        
        time.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(0.5)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
    }
    
    private func setupRatingMetrics() {
        overallRatingNumberLabel.textColor = UIColor.a4.offBlack
        overallRatingNumberLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        overallRatingTextLabel.text = "Overall"
        overallRatingTextLabel.textColor = UIColor.a4.silver
        overallRatingTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        contentView.addSubview(overallRatingNumberLabel)
        contentView.addSubview(overallRatingTextLabel)
                
        difficultyRatingNumberLabel.textColor = UIColor.a4.offBlack
        difficultyRatingNumberLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        difficultyRatingTextLabel.text = "Difficulty"
        difficultyRatingTextLabel.textColor = UIColor.a4.silver
        difficultyRatingTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        contentView.addSubview(difficultyRatingNumberLabel)
        contentView.addSubview(difficultyRatingTextLabel)
        
        separatorView.backgroundColor = UIColor.a4.silver // Thin line color
        contentView.addSubview(separatorView)
                
        // Constraints for Overall Rating (LHS)
        overallRatingNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
        }
        
        overallRatingTextLabel.snp.makeConstraints { make in
            make.top.equalTo(overallRatingNumberLabel.snp.bottom).offset(4)
            make.centerX.equalTo(overallRatingNumberLabel.snp.centerX)
        }
                
        // Constraint for Separator (Center component)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(overallRatingNumberLabel.snp.top).offset(8)
            make.leading.equalTo(overallRatingNumberLabel.snp.trailing).offset(32)
            make.width.equalTo(1)
            make.height.equalTo(50)
        }

        // Constraints for Difficulty Rating (RHS)
        difficultyRatingNumberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(overallRatingNumberLabel.snp.centerY)
            make.leading.equalTo(separatorView.snp.trailing).offset(32)
        }
        
        difficultyRatingTextLabel.snp.makeConstraints { make in
            make.centerY.equalTo(overallRatingTextLabel.snp.centerY)
            make.centerX.equalTo(difficultyRatingNumberLabel.snp.centerX)
//            make.bottom.lessThanOrEqualToSuperview().offset(-32) // Ensure the bottom anchor is constrained
        }
    }
    
    private func setupDataLabels() {
            let labels = [membership, major, timesApplied, timeCommitment]
            
            labels.forEach { label in
                label.textColor = UIColor.a4.offBlack
                label.font = .systemFont(ofSize: 14, weight: .regular)
                contentView.addSubview(label)
            }
            
            let dataGap: CGFloat = 16 // Gap below ratings
            let smallStackGap: CGFloat = 4
            
            membership.snp.makeConstraints { make in
                make.top.equalTo(overallRatingTextLabel.snp.bottom).offset(dataGap)
                make.leading.equalToSuperview().offset(sidePadding)
            }

            major.snp.makeConstraints { make in
                make.top.equalTo(membership.snp.bottom).offset(smallStackGap)
                make.leading.equalTo(membership.snp.leading)
            }

            timesApplied.snp.makeConstraints { make in
                make.top.equalTo(major.snp.bottom).offset(smallStackGap)
                make.leading.equalTo(major.snp.leading)
            }

            timeCommitment.snp.makeConstraints { make in
                make.top.equalTo(timesApplied.snp.bottom).offset(smallStackGap)
                make.leading.equalTo(timesApplied.snp.leading)
            }
        }
    
    private func setupMessage(){
        message.textColor = UIColor.a4.black
        message.font = .systemFont(ofSize: 14, weight: .medium)
        message.numberOfLines = 10
        contentView.addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        
        message.snp.makeConstraints { make in
            make.top.equalTo(timeCommitment.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(sidePadding)
            make.trailing.equalToSuperview().offset(-sidePadding)
        }
    }
    
    private func setupHeartButton(){
        heart.setTitle("♡", for: .normal)
        heart.setTitleColor(UIColor.a4.silver, for: .normal)
        heart.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        heart.addTarget(self, action: #selector(updateLiking), for: .touchUpInside)

        contentView.addSubview(heart)
        heart.translatesAutoresizingMaskIntoConstraints = false
        
        heart.snp.makeConstraints { make in
            make.top.equalTo(message.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(sidePadding)
            make.bottom.equalToSuperview().offset(-sidePadding)
        }
    }
    
    @objc private func updateLiking(){
        guard var post = post else { return }
        var postIsLiked = post.likes.contains(netId)
        
        heart.setTitle("♥︎", for: .normal)
        heart.setTitleColor(UIColor.a4.pinkRed, for: .normal)
        post.likes.append(netId)
//        NetworkManager.shared.updateRosterLikes(netId: netId, postId: post.id) { updatedPost in
//            self.post = updatedPost
//            self.likes.text = "\(updatedPost.likes.count) likes"
//        }
    }
    
    private func setupLikeCount(){
        likes.textColor = UIColor.a4.black
        likes.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(likes)
        likes.translatesAutoresizingMaskIntoConstraints = false
        
        likes.snp.makeConstraints { make in
            make.centerY.equalTo(heart.snp.centerY)
            make.leading.equalTo(heart.snp.trailing).offset(4)
            make.bottom.equalToSuperview().offset(-sidePadding)
        }
    }
    
    
}

