//
//  ViewController.swift
//  A4
//
//  Created by Vin Bui on 10/31/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties (view)
    
    private let titleLabel = UILabel()
    private let subtextLabel = UILabel()
    private var exploreCollectionView: UICollectionView!
    private var filterCollectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties (data)
    
    private var teams : [Team] = [
        Team(
            id: "1",
            name: "Cornell AppDev",
            description: "Student-run team building mobile apps for the Cornell community. Developers learn iOS, Android, full-stack, and design.",
            comp: "Competitive",
            reviews: ["Great learning experience!", "Intense but rewarding", "Best community on campus"],
            hours: "15-20",
            category: "Software"
        ),
        Team(
            id: "2",
            name: "Cornell Data Science",
            description: "Work on real-world data science projects with industry partners. Focus on ML, analytics, and data visualization.",
            comp: "Moderate",
            reviews: ["Awesome mentors", "Great for ML beginners", "Flexible hours"],
            hours: "8-12",
            category: "Data Science"
        ),
        Team(
            id: "3",
            name: "Cornell Design & Tech Initiative",
            description: "Create digital products that solve campus problems. Roles include product management, design, and engineering.",
            comp: "Moderate",
            reviews: ["Impactful projects", "Strong design focus", "Collaborative environment"],
            hours: "10-15",
            category: "Product"
        ),
        Team(
            id: "4",
            name: "CUAir - Autonomous Air Vehicle",
            description: "Design, build, and compete with autonomous UAVs. Work on computer vision, controls, and aerodynamics.",
            comp: "Competitive",
            reviews: ["Hardcore engineering", "Competition focused", "Great for aerospace"],
            hours: "20-25",
            category: "Engineering"
        ),
        Team(
            id: "5",
            name: "Cornell FinTech",
            description: "Explore blockchain, trading algorithms, and financial technology. Both technical and business roles available.",
            comp: "Competitive",
            reviews: ["Wall Street connections", "Cutting-edge tech", "Intense recruitment"],
            hours: "12-18",
            category: "Finance"
        ),
        Team(
            id: "6",
            name: "Cornell WebDev",
            description: "Build and maintain web applications for student organizations. Focus on React, Node.js, and modern web tech.",
            comp: "Open",
            reviews: ["Beginner friendly", "Supportive community", "Good work-life balance"],
            hours: "6-10",
            category: "Web Development"
        ),
        Team(
            id: "7",
            name: "Cornell VR/AR Club",
            description: "Create immersive virtual and augmented reality experiences. Projects range from games to educational tools.",
            comp: "Open",
            reviews: ["Cutting-edge tech", "Creative freedom", "Growing community"],
            hours: "8-12",
            category: "XR/Gaming"
        ),
        Team(
            id: "8",
            name: "Cornell Autonomous Underwater Vehicle",
            description: "Design and build autonomous submarines for international competition. Focus on robotics and marine engineering.",
            comp: "Competitive",
            reviews: ["Travel opportunities", "Hands-on robotics", "Team travels to compete"],
            hours: "15-20",
            category: "Robotics"
        )
    ]
    
//    private let filters = ["All", "Beginner", "Intermediate", "Advanced"]
    
//    private var currFilter: String = "All" //~needed?
//    private var filteredRecipes: [Recipe] = []
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //filteredRecipes = recipes
        view.backgroundColor = UIColor.a4.darkBlue
        setupTitleLabel()
        setupSubtextLabel()
//        setupFilterCollectionView()
        setupExploreCollectionView()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileButtonImg, style: .plain, target: self, action: #selector(pushProfileVC))
        exploreCollectionView.alwaysBounceVertical = true
//        getRecipes()
        
    }
    
    // MARK: - Networking
    
    /*
    @objc private func getRecipes() {
        print("getRecipes call")
        NetworkManager.shared.fetchRecipes { [weak self] recipes in guard let self = self else {
            print("Self is null")
            return }
            self.recipes = recipes
            self.filteredRecipes = recipes
            print("Successfully fetched recipes")
            
            // Perform UI update on main queue
            DispatchQueue.main.async {
                self.recipeCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
     */
    
    // MARK: - Set Up Views
    
    private func setupTitleLabel() {
        titleLabel.text = "Explore Project Teams"
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
    
    private func setupExploreCollectionView() {

        // TODO: Set Up CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 16
        
        // Initialize collectionView using the layout
        exploreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        exploreCollectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: ExploreCollectionViewCell.reuse)
        exploreCollectionView.backgroundColor = UIColor.a4.lightPurple
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        exploreCollectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        
//        refreshControl.addTarget(self, action: #selector(getRecipes), for: .valueChanged)
        exploreCollectionView.refreshControl = refreshControl
        
        view.addSubview(exploreCollectionView)
        exploreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        exploreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtextLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    /*
    private func setupFilterCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 24
        layout.minimumLineSpacing = 0
        
        // Initialize collectionView using the layout
        print("initialized filtercollectionview")
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.reuse)
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
        view.addSubview(filterCollectionView)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        print("done initializing filtercollectionview")
        }
    }
    
    private func filterRecipe(){
        if (currFilter == "All"){
            filteredRecipes = recipes
        } else {
            filteredRecipes = []
            for recipe in recipes {
                if (recipe.difficulty == currFilter){
                    filteredRecipes.append(recipe)
                }
            }
        }
        exploreCollectionView.reloadData()
    }
     */

}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    // update later for user defaults
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if (collectionView == filterCollectionView) {
            currFilter = filters[indexPath.item]
            filterRecipe()
            filterCollectionView.reloadData()
        } else if (collectionView == recipeCollectionView) {
            let selectedRecipe = filteredRecipes[indexPath.item]
            let detailVC = DetailViewController(recipe: selectedRecipe)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
     */
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == exploreCollectionView {
//            return filteredRecipes.count
//        } else if collectionView == filterCollectionView {
//            return filters.count
//        }
//        return 0
        return teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.reuse, for: indexPath) as? ExploreCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(team: teams[indexPath.row])
        return cell
        /*
        if collectionView == exploreCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.reuse, for: indexPath) as? ExploreCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(team: teams[indexPath.row])
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuse, for: indexPath) as? FilterCollectionViewCell else {
                print("filtercollectionview guard didnt pass")
                return UICollectionViewCell() }
            print("filtercollectionview guard passed")
            let isSelected = filters[indexPath.item] == currFilter
            cell.configure(levelName: filters[indexPath.item], isSelected: isSelected)
            return cell
        }
         */
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - (16 * 2) - 24 // minimuminteritemspacing = 24 ; padding on the side = 32
        let size = width / 2
        
        return CGSize(width: width, height: size + 43)
        /*
        if collectionView == recipeCollectionView {
            let width = collectionView.frame.width - (32 * 2) - 33 // minimuminteritemspacing = 33 ; padding on the side = 32
            let size = width / 2
            
            return CGSize(width: size, height: size + 43)
        }
        else {
            return CGSize(width: 116, height: 32)
        }
        */
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 32, right: 16)
        /*
        if collectionView == recipeCollectionView {
            return UIEdgeInsets(top: 0, left: 32, bottom: 32, right: 32)
        } else {
            return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)

        }
        */
        
    }
    
}
/*
extension ViewController: BookmarkDelegate {
    func didUpdateBookmarks() {
        exploreCollectionView.reloadData()
    }
}
*/
