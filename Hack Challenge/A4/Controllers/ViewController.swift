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
//    private var teams : [Team] = []
    
    
    private var teams : [Team] = [
        Team(
            id: "1", name: "AguaClara",
            description: "Designs sustainable water treatment plants using gravity-powered systems for communities without reliable electricity in Honduras and other developing regions worldwide.",
            comp: "Moderate", reviews: ["Clean water impact", "Civil engineering"], hours: "10-15",
            category: "Civil/Environmental", website: "https://aguaclara.cornell.edu",
            overallRating: "4.7", diffRating: "3.4"
        ),
        Team(
            id: "2", name: "Combat Robotics",
            description: "Designs and builds remote-controlled combat robots that compete in televised robot fighting competitions with destructive weapons and armored chassis for protection.",
            comp: "Competitive", reviews: ["Battle bots", "Destructive testing"], hours: "15-20",
            category: "Robotics", website: "https://combatrobotics.engineering.cornell.edu/",
            overallRating: "4.8", diffRating: "4.2"
        ),
        Team(
            id: "3", name: "AppDev",
            description: "Student-run software development team that creates mobile apps used by thousands of Cornell students including CampusGuide and Eatery for iOS and Android platforms.",
            comp: "Competitive", reviews: ["iOS/Android dev", "Real apps"], hours: "15-20",
            category: "Software", website: "https://cornellappdev.com",
            overallRating: "5.0", diffRating: "4.9"
        ),
        Team(
            id: "4", name: "Assistive Technologies",
            description: "Develops innovative technology solutions to help people with disabilities including communication devices, mobility aids, and accessibility tools for daily living challenges.",
            comp: "Moderate", reviews: ["Meaningful work", "Human-centered design"], hours: "10-15",
            category: "Biomedical", website: "https://www.cornellassist.com/",
            overallRating: "4.6", diffRating: "3.3"
        ),
        Team(
            id: "5", name: "Autonomous Sailboat",
            description: "Designs fully autonomous sailing vessels that navigate using wind power alone, competing in international robotic sailing regattas with AI-based navigation systems.",
            comp: "Moderate", reviews: ["Sailing + robotics", "Marine autonomy"], hours: "12-16",
            category: "Robotics", website: "https://cusail.com/",
            overallRating: "4.5", diffRating: "3.8"
        ),
        Team(
            id: "6", name: "Baja Racing",
            description: "Engineers and builds single-seat off-road vehicles from scratch to compete in SAE Baja competitions involving endurance, acceleration, and maneuverability challenges.",
            comp: "Competitive", reviews: ["Dirt racing", "Mechanical design"], hours: "18-22",
            category: "Mechanical", website: "https://baja.mae.cornell.edu/",
            overallRating: "4.7", diffRating: "4.1"
        ),
        Team(
            id: "7", name: "Biomedical Device",
            description: "Creates medical devices and diagnostic tools from concept to prototype, focusing on solving clinical problems through engineering innovation and regulatory compliance.",
            comp: "Competitive", reviews: ["Healthcare innovation", "FDA regulations"], hours: "14-18",
            category: "Biomedical", website: "https://www.cubmd.org/",
            overallRating: "4.7", diffRating: "4.0"
        ),
        Team(
            id: "8", name: "ChemE Car",
            description: "Designs chemically-powered miniature cars that must stop precisely using only chemical reactions, competing in national AIChE competitions with creative engineering solutions.",
            comp: "Moderate", reviews: ["Chemical engineering", "Precision vehicles"], hours: "12-16",
            category: "Chemical", website: "https://cornellchemecar.com/",
            overallRating: "4.4", diffRating: "3.7"
        ),
        Team(
            id: "9", name: "Concrete Canoe",
            description: "Designs, builds, and races concrete canoes that must float and be raced in national ASCE competitions, focusing on innovative concrete mix designs.",
            comp: "Moderate", reviews: ["Civil engineering", "Mix design"], hours: "12-16",
            category: "Civil", website: "https://cornellconcretecanoe.com/",
            overallRating: "4.3", diffRating: "3.5"
        ),
        Team(
            id: "10", name: "Custom Silicon Systems",
            description: "Designs custom integrated circuits and microchips from transistor-level layout to full system integration, creating specialized hardware for computational applications.",
            comp: "Competitive", reviews: ["Chip design", "Hardware engineering"], hours: "16-20",
            category: "Electrical", website: "https://c2s2.engineering.cornell.edu/",
            overallRating: "4.9", diffRating: "4.5"
        ),
        Team(
            id: "11", name: "Data Science",
            description: "Works on real-world data analysis projects with industry partners, applying machine learning, statistical modeling, and data visualization to solve complex problems.",
            comp: "Moderate", reviews: ["ML models", "Industry projects"], hours: "10-15",
            category: "Data Science", website: "https://cornelldata.science/",
            overallRating: "4.5", diffRating: "3.6"
        ),
        Team(
            id: "12", name: "Debut",
            description: "Biomedical engineering team that researches and creates groundbreaking technology in the medical field to forge advancements in healthcare.",
            comp: "Competitive", reviews: ["Public speaking", "Critical thinking"], hours: "12-18",
            category: "Humanities", website: "https://cornelldebut.org/",
            overallRating: "4.4", diffRating: "3.2"
        ),
        Team(
            id: "13", name: "Digital Tech & Innovation",
            description: "Explores emerging digital technologies like blockchain, AI, and IoT while developing innovative projects that bridge technology with real-world applications.",
            comp: "Moderate", reviews: ["Tech trends", "Startup mindset"], hours: "10-14",
            category: "Technology", website: "https://new.cornelldti.org/",
            overallRating: "4.5", diffRating: "3.4"
        ),
        Team(
            id: "14", name: "Design Build Fly",
            description: "Designs, builds, and tests radio-controlled aircraft for AIAA competition, optimizing for flight performance, payload capacity, and mission-specific requirements.",
            comp: "Moderate", reviews: ["Aircraft design", "Flight testing"], hours: "12-18",
            category: "Aerospace", website: "https://dbf.engineering.cornell.edu/",
            overallRating: "4.5", diffRating: "3.8"
        ),
        Team(
            id: "15", name: "Electric Vehicles",
            description: "Develops electric vehicle technology including battery management systems, motor controllers, and charging infrastructure for sustainable transportation solutions.",
            comp: "Competitive", reviews: ["EV technology", "Battery systems"], hours: "15-20",
            category: "Mechanical/Electrical", website: "https://www.cornellelectricvehicles.org/",
            overallRating: "4.6", diffRating: "4.0"
        ),
        Team(
            id: "16", name: "Engineering World Health",
            description: "Creates low-cost medical devices for developing countries, focusing on diagnostic tools, treatment devices, and healthcare infrastructure for resource-limited settings.",
            comp: "Moderate", reviews: ["Global health", "Medical devices"], hours: "10-15",
            category: "Biomedical", website: "https://www.cornellewh.org/",
            overallRating: "4.7", diffRating: "3.5"
        ),
        Team(
            id: "17", name: "Extended Reality (CUXR)",
            description: "Develops virtual and augmented reality applications for education, training, and entertainment using Unity, Unreal Engine, and custom XR hardware setups.",
            comp: "Open", reviews: ["Immersive tech", "Creative projects"], hours: "8-12",
            category: "XR", website: "https://cuxr.github.io/",
            overallRating: "4.4", diffRating: "3.1"
        ),
        Team(
            id: "18", name: "Hack4Impact",
            description: "Builds custom software solutions for non-profit organizations, creating web applications, databases, and digital tools that address social challenges directly.",
            comp: "Moderate", reviews: ["Social impact", "Web development"], hours: "10-14",
            category: "Software", website: "https://www.cornellh4i.org/",
            overallRating: "4.6", diffRating: "3.3"
        ),
        Team(
            id: "19", name: "Hyperloop",
            description: "Designs high-speed vacuum tube transportation pods that levitate using magnetic systems, competing in SpaceX competitions for futuristic transit solutions.",
            comp: "Competitive", reviews: ["Futuristic transport", "High-speed systems"], hours: "18-24",
            category: "Mechanical", website: "https://cornellhyperloop.com/",
            overallRating: "4.9", diffRating: "4.6"
        ),
        Team(
            id: "20", name: "iGEM",
            description: "Synthetic biology team that engineers biological systems using genetic circuits, competing in international iGEM with innovative biotechnology applications.",
            comp: "Competitive", reviews: ["Genetic engineering", "Lab research"], hours: "15-20",
            category: "Biology", website: "https://igem.engineering.cornell.edu/",
            overallRating: "4.8", diffRating: "4.1"
        ),
        Team(
            id: "21", name: "Mars Rover",
            description: "Builds semi-autonomous Mars rovers that compete in University Rover Challenge, performing geology tasks and navigation in simulated Martian terrain.",
            comp: "Competitive", reviews: ["Space robotics", "Rover systems"], hours: "16-20",
            category: "Robotics", website: "https://marsrover.engineering.cornell.edu/",
            overallRating: "4.7", diffRating: "4.3"
        ),
        Team(
            id: "22", name: "Nexus",
            description: "Interdisciplinary innovation team that tackles complex problems at the intersection of technology, business, and design through collaborative project development.",
            comp: "Moderate", reviews: ["Cross-disciplinary", "Innovation projects"], hours: "10-15",
            category: "Interdisciplinary", website: "https://www.cornellnexus.com/",
            overallRating: "4.4", diffRating: "3.4"
        ),
        Team(
            id: "23", name: "FSAE Racing",
            description: "Designs, builds, and races Formula-style open-wheel race cars from the ground up for international SAE Collegiate Design Series competitions.",
            comp: "Competitive", reviews: ["Race car engineering", "Performance tuning"], hours: "20-25",
            category: "Mechanical", website: "https://cornellracing.org/",
            overallRating: "4.8", diffRating: "4.4"
        ),
        Team(
            id: "24", name: "Rocketry",
            description: "Designs and launches high-power rockets reaching altitudes over 10,000 feet, competing in intercollegiate rocketry competitions with complex payload missions.",
            comp: "Competitive", reviews: ["Rocket science", "Launch events"], hours: "15-20",
            category: "Aerospace", website: "https://cornellrocketryteam.com/",
            overallRating: "4.7", diffRating: "4.2"
        ),
        Team(
            id: "25", name: "Seismic Design",
            description: "Engineers earthquake-resistant building structures using innovative damping systems and materials, competing in seismic design challenges with scaled models.",
            comp: "Moderate", reviews: ["Earthquake engineering", "Structural design"], hours: "12-16",
            category: "Civil", website: "http://cornellseismicdesign.com/",
            overallRating: "4.5", diffRating: "3.9"
        ),
        Team(
            id: "26", name: "Steel Bridge",
            description: "Designs, fabricates, and assembles steel bridges under time constraints for ASCE competition, focusing on structural efficiency and construction speed.",
            comp: "Moderate", reviews: ["Bridge engineering", "Steel fabrication"], hours: "10-15",
            category: "Civil", website: "https://steelbridge.engineering.cornell.edu/",
            overallRating: "4.3", diffRating: "3.7"
        ),
        Team(
            id: "27", name: "Solar Boat",
            description: "Designs and races solar-powered boats that convert sunlight to propulsion energy, competing in solar boat regattas with efficient energy systems.",
            comp: "Moderate", reviews: ["Solar power", "Marine design"], hours: "12-16",
            category: "Mechanical/Electrical", website: "https://cusb.engineering.cornell.edu/",
            overallRating: "4.4", diffRating: "3.6"
        ),
        Team(
            id: "28", name: "Autonomous Underwater Vehicle",
            description: "Builds autonomous submarines that perform underwater tasks like navigation, object retrieval, and mapping in international robotics competitions.",
            comp: "Competitive", reviews: ["Underwater robotics", "Marine engineering"], hours: "15-20",
            category: "Robotics", website: "https://cuauv.org/",
            overallRating: "4.7", diffRating: "4.3"
        ),
        Team(
            id: "29", name: "Unmanned Air Systems",
            description: "Develops unmanned aerial systems including fixed-wing drones and quadcopters for applications in mapping, surveillance, and payload delivery missions.",
            comp: "Competitive", reviews: ["Drone technology", "Aerial systems"], hours: "14-18",
            category: "Aerospace", website: "https://cuair.org/",
            overallRating: "4.6", diffRating: "4.0"
        ),
        Team(
            id: "30", name: "Autoboat",
            description: "Creates autonomous surface vehicles that navigate waterways using computer vision and sensor fusion for environmental monitoring and research applications.",
            comp: "Moderate", reviews: ["Surface autonomy", "Marine robotics"], hours: "12-16",
            category: "Robotics", website: "https://www.cornellautoboat.com/",
            overallRating: "4.5", diffRating: "3.8"
        ),
        Team(
            id: "31", name: "Autonomous Drone",
            description: "Develops fully autonomous drone systems capable of complex missions including search and rescue, inspection, and autonomous swarm coordination.",
            comp: "Moderate", reviews: ["Drone autonomy", "Aerial applications"], hours: "12-16",
            category: "Robotics/Aerospace", website: "https://cuad.info/",
            overallRating: "4.6", diffRating: "3.9"
        ),
        Team(
            id: "32", name: "Geodata",
            description: "Works with geographic information systems, satellite imagery, and spatial data analysis to solve environmental, urban, and resource management problems.",
            comp: "Moderate", reviews: ["GIS mapping", "Spatial analysis"], hours: "10-14",
            category: "Data Science", website: "https://www.cugeodata.com/",
            overallRating: "4.4", diffRating: "3.3"
        ),
        Team(
            id: "33", name: "Engineers for a Sustainable World",
            description: "Implements sustainability projects on campus and in the local community focusing on renewable energy, waste reduction, and sustainable design solutions.",
            comp: "Open", reviews: ["Environmental projects", "Sustainability"], hours: "8-12",
            category: "Environmental", website: "https://esw.engineering.cornell.edu/index.html",
            overallRating: "5.0", diffRating: "3.0"
        ),
        Team(
            id: "34", name: "Engineers in Action",
            description: "Builds pedestrian footbridges in rural communities worldwide, providing safe river crossings and transportation infrastructure for isolated populations.",
            comp: "Moderate", reviews: ["Global development", "Bridge building"], hours: "10-15",
            category: "Civil", website: "https://eia.engineering.cornell.edu/",
            overallRating: "4.5", diffRating: "3.4"
        ),
        Team(
            id: "35", name: "Engineers Without Borders",
            description: "Completes international engineering projects including water supply systems, sanitation facilities, and renewable energy installations in developing communities.",
            comp: "Moderate", reviews: ["Global service", "Community projects"], hours: "10-15",
            category: "Civil/Environmental", website: "https://www.engineering.cornell.edu/student-project-teams/active-project-teams/#",
            overallRating: "4.6", diffRating: "3.5"
        ),
        Team(
            id: "36", name: "Senstech",
            description: "Develops advanced sensor technologies and Internet of Things systems for environmental monitoring, industrial applications, and smart city infrastructure.",
            comp: "Moderate", reviews: ["Sensor design", "IoT networks"], hours: "12-16",
            category: "Electrical", website: "https://www.cornellsenstech.com/",
            overallRating: "4.5", diffRating: "3.7"
        )
    ]
    
//    private let filters = ["All", "Beginner", "Intermediate", "Advanced"]
    
//    private var currFilter: String = "All" //~needed?
//    private var filteredRecipes: [Recipe] = []
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.text = "Cup of Teams"
        titleLabel.textColor = UIColor.a4.lightPurple
        titleLabel.font = UIFont.rounded(ofSize: 32, weight: .bold)

        let attributedString = NSMutableAttributedString(string: "Cup of Teams")
        attributedString.addAttribute(.kern, value: 1.2, range: NSRange(location: 0, length: attributedString.length))
        titleLabel.attributedText = attributedString

        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        // Do any additional setup after loading the view.
        //filteredRecipes = recipes
        view.backgroundColor = UIColor.a4.darkBlue
        setupTitleLabel()
        setupSubtextLabel()
//        setupFilterCollectionView()
        setupExploreCollectionView()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: "profile-icon", style: .plain, target: self, action: #selector(pushProfileVC))
        exploreCollectionView.alwaysBounceVertical = true
        getTeams()
        
    }
    
    // MARK: - Networking
    
    
    @objc private func getTeams() {
        print("getTeams call")
        NetworkManager.shared.fetchTeams { [weak self] recipes in guard let self = self else {
            print("Self is null")
            return }
            self.teams = teams
            print("Successfully fetched recipes")
            
            // Perform UI update on main queue
            DispatchQueue.main.async {
                self.exploreCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Set Up Views
    
    private func setupTitleLabel() {
        titleLabel.text = "Explore Project Teams"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
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
        
        refreshControl.addTarget(self, action: #selector(getTeams), for: .valueChanged)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let selectedTeam = teams[indexPath.item]
        let detailVC = DetailViewController(team: selectedTeam)
        navigationController?.pushViewController(detailVC, animated: true)
        detailVC.delegate = self
     /*
        if (collectionView == filterCollectionView) {
            currFilter = filters[indexPath.item]
            filterRecipe()
            filterCollectionView.reloadData()
        } else if (collectionView == recipeCollectionView) {
            let selectedRecipe = filteredRecipes[indexPath.item]
            let detailVC = DetailViewController(recipe: selectedRecipe)
            navigationController?.pushViewController(detailVC, animated: true)
        }
      */
    }
     
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

extension ViewController: BookmarkDelegate {
    func didUpdateBookmarks() {
        exploreCollectionView.reloadData()
    }
}


