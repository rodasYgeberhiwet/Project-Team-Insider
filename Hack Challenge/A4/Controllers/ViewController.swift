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
    private var exploreCollectionView: UICollectionView!
    private var filterCollectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties (data)
    
    private var teams : [Team] = []
    
//    private let filters = ["All", "Beginner", "Intermediate", "Advanced"]
    
//    private var currFilter: String = "All" //~needed?
//    private var filteredRecipes: [Recipe] = []
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //filteredRecipes = recipes
        view.backgroundColor = UIColor.white
        setupTitleLabel()
//        setupFilterCollectionView()
        setupExploreCollectionView()
        exploreCollectionView.alwaysBounceVertical = true
//        getRecipes()
        print("getRecipes called")
        
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
        titleLabel.textColor = .black
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
    
    private func setupExploreCollectionView() {

        // TODO: Set Up CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 43
        layout.minimumInteritemSpacing = 33
        
        // Initialize collectionView using the layout
        exploreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        exploreCollectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: ExploreCollectionViewCell.reuse)
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        
//        refreshControl.addTarget(self, action: #selector(getRecipes), for: .valueChanged)
        exploreCollectionView.refreshControl = refreshControl
        
        view.addSubview(exploreCollectionView)
        exploreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        exploreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
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
        let width = collectionView.frame.width - (32 * 2) - 33 // minimuminteritemspacing = 33 ; padding on the side = 32
        let size = width / 2
        
        return CGSize(width: size, height: size + 43)
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
        return UIEdgeInsets(top: 0, left: 32, bottom: 32, right: 32)
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
