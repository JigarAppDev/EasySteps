//
//  HomeViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit

class HomeRewardCell: UICollectionViewCell {
    @IBOutlet var iconView: UIView!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPoints: UILabel!
    @IBOutlet var lblSteps: UILabel!
}

class HomeViewController: UIViewController {

    @IBOutlet var rewardCollectionView: UICollectionView!
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.rewardCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeRewardCell", for: indexPath) as! HomeRewardCell
        
        //Cell Animation
        DispatchQueue.main.async {
            cell.iconView.pulse(nil)
        }
        
        if indexPath.row == 0 {
            cell.lblPoints.text = "4"
            cell.imgIcon.image = #imageLiteral(resourceName: "ic_play").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Daily Reward"
            cell.lblSteps.text = ""
        } else if indexPath.row == 1 {
            cell.lblPoints.text = "12"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Invite Friends").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Invite Friends"
            cell.lblSteps.text = ""
        } else if indexPath.row == 2 {
            cell.lblPoints.text = "1"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Bonus"
            cell.lblSteps.text = "1000"
        } else if indexPath.row == 3 {
            cell.lblPoints.text = "3"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Bonus"
            cell.lblSteps.text = "3000"
        } else if indexPath.row == 4 {
            cell.lblPoints.text = "4"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Bonus"
            cell.lblSteps.text = "9000"
        } else if indexPath.row == 5 {
            cell.lblPoints.text = "5"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Bonus"
            cell.lblSteps.text = "14000"
        } else if indexPath.row == 6 {
            cell.lblPoints.text = "10"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Bonus"
            cell.lblSteps.text = "20000"
        }
        cell.imgIcon.tintColor = #colorLiteral(red: 0.1294117647, green: 0.5607843137, blue: 0.768627451, alpha: 1)
        cell.iconView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if self.selectedIndex == indexPath.row {
            cell.iconView.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.5607843137, blue: 0.768627451, alpha: 1)
            cell.imgIcon.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.rewardCollectionView.reloadData()
    }
    
}
