//
//  PostCollectionViewCell.swift
//  A4
//
//  Created by Amy Yang on 12/3/25.
//
/*
import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    
    private let logo = UIImageView()
    private let name = UILabel()
    private var time = UILabel()
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
        
        backgroundColor = UIColor.a3.white
        layer.cornerRadius = 16
        
        setupLogo()
        setupName()
        setupDate()
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
        logo.image = UIImage(named: "appdev-logo") // can be moved to setupLogo()
        name.text = "Anonymous"
        time.text = post.time.convertToAgo()
        message.text = post.message
        likes.text = "\(post.likes.count) likes"
        
        let postIsLiked = post.likes.contains(netId)
        heart.setTitle(postIsLiked ? "♥︎" : "♡", for: .normal)
        heart.setTitleColor(postIsLiked ? UIColor.a3.ruby : UIColor.a3.silver, for: .normal)
    }
    
    // MARK: - Set Up Views
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
    
    private func setupName(){
        name.textColor = UIColor.a3.black
        name.font = .systemFont(ofSize: 14, weight: .semibold)
        
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: sidePadding),
            name.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 8)
        ])
    }
    
    private func setupDate(){
        time.textColor = UIColor.a3.silver
        time.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(time)
        time.translatesAutoresizingMaskIntoConstraints = false
        
        // let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            time.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0.5),
            time.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 8)
        ])
        
    }
    
    private func setupMessage(){
        message.textColor = UIColor.a3.black
        message.font = .systemFont(ofSize: 14, weight: .medium)
        
        contentView.addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            message.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 16),
            message.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding)
        ])
    }
    
    private func setupHeartButton(){
        heart.setTitle("♡", for: .normal)
        heart.setTitleColor(UIColor.a3.silver, for: .normal)
        heart.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        heart.addTarget(self, action: #selector(updateLiking), for: .touchUpInside)

        contentView.addSubview(heart)
        heart.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            heart.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 16),
            heart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            heart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -sidePadding)
        ])
    }
    
    @objc private func updateLiking(){
        guard var post = post else { return }
        var postIsLiked = post.likes.contains(netId)
        
        heart.setTitle("♥︎", for: .normal)
        heart.setTitleColor(UIColor.a3.ruby, for: .normal)
        post.likes.append(netId)
        NetworkManager.shared.updateRosterLikes(netId: netId, postId: post.id) { updatedPost in
            self.post = updatedPost
            self.likes.text = "\(updatedPost.likes.count) likes"
        }
    }
    
    private func setupLikeCount(){
        likes.textColor = UIColor.a3.black
        likes.font = .systemFont(ofSize: 12, weight: .semibold)
        
        contentView.addSubview(likes)
        likes.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding: CGFloat = 24
        NSLayoutConstraint.activate([
            likes.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 16),
            likes.leadingAnchor.constraint(equalTo: heart.trailingAnchor, constant: 4),
            likes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -sidePadding)
        ])
    }
    
    
}
*/
