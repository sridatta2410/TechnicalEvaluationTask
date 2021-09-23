//
//  HomeView.swift
//  NewMeetingScreen
//
//  Created by Sridatta Nallamilli on 21/09/21.
//

import UIKit

class HomeView: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var totalView                            : UIView!
    @IBOutlet weak var headerView                           : UIView!
    @IBOutlet weak var contentView                          : UIView!

    @IBOutlet weak var screenTitleLabel                     : UILabel!
    @IBOutlet weak var logoutButton                         : UIButton!
    @IBOutlet weak var welcomeImage                         : UIImageView!
    @IBOutlet weak var welcomeLabel                         : UILabel!
    @IBOutlet weak var emailLabel                           : UILabel!
    @IBOutlet weak var viewMeetingsView                     : UIView!
    @IBOutlet weak var viewMeetingsButton                   : UIButton!

    //MARK:- Variables
    let ud                  = UserDefaults.standard
    var userName            = ""
    var userEmail           = ""
    var isAppleLogin:Bool!  = false
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    //MARK:- User Defined Methods
    func setupUI() {
        view.backgroundColor        = homeViewBgColor
        headerView.backgroundColor = homeViewBgColor
        contentView.backgroundColor = homeViewBgColor
        
        welcomeImage.tintColor = blueColor.withAlphaComponent(0.2)
        if #available(iOS 13.0, *) {
            welcomeImage.image = UIImage(systemName: "person.fill")
        } else {
            // Fallback on earlier versions
        }

        if isAppleLogin == true {
            if userName == "" {
                if ud.value(forKey: "logged_user_name_apple") != nil {
                    userName = ud.value(forKey: "logged_user_name_apple") as! String
                }
            }
            if userEmail == ""{
                if ud.value(forKey: "logged_user_email_apple") != nil {
                    userEmail = ud.value(forKey: "logged_user_email_apple") as! String
                }
            }
        }
        
        welcomeLabel.text           = "Welcome! \(userName)"
        welcomeLabel.font = UIFont(name: "Lato-Bold", size: 22.0)
        
        emailLabel.text             = userEmail
        emailLabel.textColor        = UIColor.lightGray
        emailLabel.font = UIFont(name: "Lato-Regular", size: 18.0)
        
        viewMeetingsView.backgroundColor = blueColor
        viewMeetingsView.layer.cornerRadius = viewMeetingsView.frame.height / 2.0
        viewMeetingsButton.setTitleColor(.white, for: .normal)
    }
    
    //MARK:- Button Actions
    @IBAction func logoutButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (logoutAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    @IBAction func viewMeetingsButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MeetingsListView") as! MeetingsListView
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
