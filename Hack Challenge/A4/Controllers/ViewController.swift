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
    private var recipeCollectionView: UICollectionView!
    private var filterCollectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Properties (data)
    
    /*
    private var recipes: [Recipe] = [
        Recipe(
            id: "801343ed-fc1b-4ed0-a226-2381f0ec4186",
            description: "This ropa vieja is great served on tortillas or over rice. Add sour cream, cheese, and fresh cilantro on the side.",
            difficulty: "Intermediate",
            image_url: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F8368708.jpg&q=60&c=sc&orient=true&poi=auto&h=512",
            name: "Cuban Ropa Vieja",
            rating: 4.4
        ),
        Recipe(
            id: "9d40a3f8-a40f-48c0-9aa6-28031fddde81",
            description: "You only need 3 ingredients for this crockpot Italian chicken with Italian dressing and Parmesan cheese. Nothing could be easier than this for a weekday meal that's ready when you get home.",
            difficulty: "Beginner",
            image_url: "https://www.allrecipes.com/thmb/cLLmeWO7j9YYI66vL3eZzUL_NKQ=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/7501402crockpot-italian-chicken-recipe-fabeveryday4x3-223051c7188841cb8fd7189958c62f3d.jpg",
            name: "Crockpot Italian Chicken",
            rating: 4.5
        ),
        Recipe(
            id: "0c28ab59-e99d-4ec1-be2f-359a92537560",
            description: "This crockpot mac and cheese recipe is creamy, comforting, and takes just moments to assemble in a slow cooker. Great for large family gatherings and to take to potluck dinners. It's always a big hit!",
            difficulty: "Beginner",
            image_url: "https://www.allrecipes.com/thmb/wRSDpUgu8VR2PpQtjGq97cuk8Fo=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/237311-slow-cooker-mac-and-cheese-DDMFS-4x3-9b4a15f2c3344c1da22b034bc3b35683.jpg",
            name: "Slow Cooker Mac and Cheese",
            rating: 4.3
        ),
        Recipe(
            id: "ef10e605-65d0-4a85-9fd8-8e3294939473",
            description: "My mother was one of the best cooks I ever knew. Whenever she made stews we mostly found homemade dumplings in them. We never ate things from packages or microwaves and you sure could taste what food was. That's the only way I cook today - I don't use any electronic gadgets to cook with except an electric stove.",
            difficulty: "Beginner",
            image_url: "https://www.allrecipes.com/thmb/neJT4JLJz7ks8D0Rkvzf8fRufWY=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/6900-dumplings-DDMFS-4x3-c03fe714205d4f24bd74b99768142864.jpg",
            name: "Homemade Dumplings",
            rating: 4.7
        ),
        Recipe(
            id: "a69bdffc-c9ba-428b-8f06-24cef356a611",
            description: "Succulent pork loin with fragrant garlic, rosemary, and wine.",
            difficulty: "Advanced",
            image_url: "https://www.allrecipes.com/thmb/llWmU-j1PO7kCPvKkzQnfmeBf0M=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/21766-roasted-pork-loin-DDMFS-4x3-42648a2d6acf4ef3a05124ef5010c4fb.jpg",
            name: "Roasted Pork Loin",
            rating: 4.5
        ),
        Recipe(
            id: "85745755-11dd-4e68-8953-15f5194971bc",
            description: "My version of chicken Parmesan is a little different than what they do in the restaurants, with less sauce and a crispier crust.",
            difficulty: "Intermediate",
            image_url: "https://www.allrecipes.com/thmb/0NW5WeQpXaotyZHJnK1e1mFWcCk=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/223042-Chicken-Parmesan-mfs_001-7ab952346edc4b2da36f3c0259b78543.jpg",
            name: "Chicken Parmesan",
            rating: 4.8
        )
    ]
    */
    
    private var recipes : [Recipe] = []
    
    private let filters = ["All", "Beginner", "Intermediate", "Advanced"]
    
    private var currFilter: String = "All" //~needed?
    private var filteredRecipes: [Recipe] = []
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //filteredRecipes = recipes
        view.backgroundColor = UIColor.white
        setupTitleLabel()
        setupFilterCollectionView()
        setupRecipeCollectionView()
        recipeCollectionView.alwaysBounceVertical = true
        getRecipes()
        print("getRecipes called")
        
    }
    
    // MARK: - Networking
    
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
    
    // MARK: - Set Up Views
    
    private func setupTitleLabel() {
        titleLabel.text = "ChefOS"
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
    
    private func setupRecipeCollectionView() {

        // TODO: Set Up CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 43
        layout.minimumInteritemSpacing = 33
        
        // Initialize collectionView using the layout
        recipeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        recipeCollectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.reuse)
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(getRecipes), for: .valueChanged)
        recipeCollectionView.refreshControl = refreshControl
        
        view.addSubview(recipeCollectionView)
        recipeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        recipeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
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
        recipeCollectionView.reloadData()
    }

}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    // update later for user defaults
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
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recipeCollectionView {
            return filteredRecipes.count
        } else if collectionView == filterCollectionView {
            return filters.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recipeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.reuse, for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell() }
            print("recipecollectionview guard passed")
            cell.configure(recipe: filteredRecipes[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuse, for: indexPath) as? FilterCollectionViewCell else {
                print("filtercollectionview guard didnt pass")
                return UICollectionViewCell() }
            print("filtercollectionview guard passed")
            let isSelected = filters[indexPath.item] == currFilter
            cell.configure(levelName: filters[indexPath.item], isSelected: isSelected)
            return cell
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recipeCollectionView {
            let width = collectionView.frame.width - (32 * 2) - 33 // minimuminteritemspacing = 33 ; padding on the side = 32
            let size = width / 2
            
            return CGSize(width: size, height: size + 43)
        }
        else {
            return CGSize(width: 116, height: 32)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == recipeCollectionView {
            return UIEdgeInsets(top: 0, left: 32, bottom: 32, right: 32)
        } else {
            return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)

        }
        
    }
    
}

extension ViewController: BookmarkDelegate {
    func didUpdateBookmarks() {
        recipeCollectionView.reloadData()
    }
}
