//
//  TabViewController.swift
//  EasySteps
//
//  Created by Jigar on 17/10/21.
//

import UIKit

class TabViewController: UIViewController {

    @IBOutlet var tabView: UIView!
    @IBOutlet var btnHome: UIButton!
    @IBOutlet var btnSteps: UIButton!
    @IBOutlet var btnDeals: UIButton!
    @IBOutlet var btnSetting: UIButton!
    
    private lazy var homeVC: HomeViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var stepsVC: YourDailyStepsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "YourDailyStepsViewController") as! YourDailyStepsViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var dealsVC: DealsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "DealsViewController") as! DealsViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var settingsVC: SettingsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    //MARK: Tab Button Selection
    @IBAction func tabButtonAction(sender: UIButton) {
        if sender == self.btnHome {
            remove(asChildViewController: stepsVC)
            remove(asChildViewController: settingsVC)
            remove(asChildViewController: dealsVC)
            add(asChildViewController: homeVC)
        } else if sender == self.btnSteps {
            remove(asChildViewController: homeVC)
            remove(asChildViewController: settingsVC)
            remove(asChildViewController: dealsVC)
            add(asChildViewController: stepsVC)
        } else if sender == self.btnDeals {
            remove(asChildViewController: stepsVC)
            remove(asChildViewController: settingsVC)
            remove(asChildViewController: homeVC)
            add(asChildViewController: dealsVC)
        } else if sender == self.btnSetting {
            remove(asChildViewController: stepsVC)
            remove(asChildViewController: dealsVC)
            remove(asChildViewController: homeVC)
            add(asChildViewController: settingsVC)
        }
        self.view.bringSubviewToFront(self.tabView)
    }
    
    // MARK: - View Methods
    private func setupView() {
        remove(asChildViewController: stepsVC)
        remove(asChildViewController: settingsVC)
        remove(asChildViewController: dealsVC)
        add(asChildViewController: homeVC)
        self.view.bringSubviewToFront(self.tabView)
    }
    
    // MARK: - Helper Methods
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }

}
