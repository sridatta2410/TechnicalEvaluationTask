//
//  ViewController.swift
//  NewMeetingScreen
//
//  Created by Sridatta Nallamilli on 15/09/21.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

struct onboardingSlides {
    var image: String
    var title: String
    var subtitle: String
}

class ViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var totalView                            : UIView!
    @IBOutlet weak var headerView                           : UIView!
    @IBOutlet weak var contentView                          : UIView!
    @IBOutlet weak var scrollView                           : UIScrollView!
    @IBOutlet weak var scrollableContentView                : UIView!
    @IBOutlet weak var scrollableContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var screenTitleLabel                     : UILabel!
    
    @IBOutlet weak var loginView                            : UIView!
    @IBOutlet weak var orView                               : UIView!
    @IBOutlet weak var divider1View                         : UIView!
    @IBOutlet weak var divider2View                         : UIView!
    @IBOutlet weak var createAcountView                     : UIView!
    @IBOutlet weak var googleLoginView                      : UIView!
    @IBOutlet weak var appleSigninView                      : UIView!
    @IBOutlet weak var loginLabel                           : UILabel!
    @IBOutlet weak var orLabel                              : UILabel!
    @IBOutlet weak var createAccountLabel                   : UILabel!
    @IBOutlet weak var googleSigninLabel                    : UILabel!
    @IBOutlet weak var appleSigninLabel                     : UILabel!
    @IBOutlet weak var googleLogoImage                      : UIImageView!
    @IBOutlet weak var applelogoImage                       : UIImageView!
    @IBOutlet weak var loginButton                          : UIButton!
    @IBOutlet weak var createAccountButton                  : UIButton!
    @IBOutlet weak var googleButton                         : UIButton!
    @IBOutlet weak var appleButton                          : UIButton!
    
    @IBOutlet weak var onboardingPageControl                : UIPageControl!
    @IBOutlet weak var onboardingCollectionView             : UICollectionView!

    //MARK:- Variables
    let ud              = UserDefaults.standard
    var dataArray       = [onboardingSlides]()

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    //MARK:- Userdefined Methods
    func setupUI() {
        
        setViewCornerRadiusToCircle(
            [loginView, createAcountView, googleLoginView, appleSigninView]
        )
        
        setBorderForView(
            [createAcountView, googleLoginView, appleSigninView],
            borderWidth: 0.2,
            borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        )
        
        loginView.backgroundColor = blueColor
        loginLabel.textColor = .white
        
        orView.backgroundColor = .clear
        setBgColorForView([divider1View, divider2View], color: homeViewBgColor)
        setViewCustomCornerRadius([divider1View, divider2View], radius: 4.0)
        
        if #available(iOS 13.0, *) {
            appleSigninView.isHidden = false
        } else {
            // Fallback on earlier versions
            appleSigninView.isHidden = true
        }
        
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        
        setupSlidesData()
        
    }
    
    func setupSlidesData() {
        dataArray.removeAll()
        
        dataArray.append(onboardingSlides(image: "mainBg", title: "StayTouch", subtitle: ""))
        dataArray.append(onboardingSlides(image: "onboarding_1", title: "Welcome to StayTouch!", subtitle: "Discover our StayTouch Share feature: Bring two phones close to each other to share your contact information securely and effortlessly."))
        dataArray.append(onboardingSlides(image: "onboarding_2", title: "Create Multiple Profiles", subtitle: "Decide what information you share based on the context and the occasion."))
        dataArray.append(onboardingSlides(image: "onboarding_3", title: "Automatic Updates", subtitle: "Whenever you update your contact details, we'll update everyone in your network."))
        dataArray.append(onboardingSlides(image: "onboarding_4", title: "Remember Who's Who", subtitle: "Record details of past meetings by adding notes, pictures, and voice memos."))
        dataArray.append(onboardingSlides(image: "onboarding_5", title: "Manage Your Meetings", subtitle: "Use the StayTouch calendar to keep your schedule tidy and organized."))
        
        onboardingCollectionView.showsVerticalScrollIndicator = false
        onboardingCollectionView.showsHorizontalScrollIndicator = false
        onboardingCollectionView.isPagingEnabled = true
        onboardingCollectionView.reloadData()
        
        onboardingPageControl.numberOfPages = dataArray.count
        onboardingPageControl.currentPage = 0
        onboardingPageControl.isUserInteractionEnabled = false
    }
    
    //MARK:- Button Actions
    @IBAction func loginButtonAction(_ sender: Any) {
    }
    
    @IBAction func createAccountButtonAction(_ sender: Any) {
    }
    
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
                
            guard let user = user else { return }

            let emailAddress = user.profile?.email

            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName

            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            print("\n--- Google Sign-In ---\n")
            print("Email       = \(emailAddress!)")
            print("Full name   = \(fullName!)")
            print("Given name  = \(givenName!)")
            print("Family name = \(familyName!)")
            
            self.ud.set(givenName, forKey: "logged_user_name")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
            vc.userName = givenName!
            vc.userEmail = emailAddress!
            vc.isAppleLogin = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func appleButtonAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            appleButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- Extensions

//MARK: CollectionView Delegate Methods
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            onboardingPageControl.currentPageIndicatorTintColor = .white
            onboardingPageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
            setBgColorForView([divider1View, divider2View], color: .white)
            orLabel.textColor = .white
        }
        else {
            onboardingPageControl.currentPageIndicatorTintColor = blueColor
            onboardingPageControl.pageIndicatorTintColor = blueColor.withAlphaComponent(0.1)
            setBgColorForView([divider1View, divider2View], color: homeViewBgColor)
            orLabel.textColor = .black
        }
        onboardingPageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SlidesCollectionCell!
        
        let slide = dataArray[indexPath.row]
        
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "landingCell", for: indexPath) as! SlidesCollectionCell

            cell.appTitle.text = slide.title
            cell.appTitle.textAlignment = .center
            cell.appTitle.font = UIFont(name: "Lato-Bold", size: 34.0)
        }
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slidesCell", for: indexPath) as! SlidesCollectionCell
            cell.onboardingImage.image = UIImage(named: "\(slide.image)")
            
            cell.onboardingTitle.text = slide.title
            cell.onboardingTitle.numberOfLines = 0
            cell.onboardingTitle.textAlignment = .center
            cell.onboardingTitle.font = UIFont(name: "Lato-Regular", size: 24.0)
            
            cell.onboardingSubtitle.text = slide.subtitle
            cell.onboardingSubtitle.numberOfLines = 0
            cell.onboardingSubtitle.textAlignment = .center
            cell.onboardingSubtitle.textColor = .lightGray
            cell.onboardingSubtitle.font = UIFont(name: "Lato-Regular", size: 14.0)
        }
        return cell
        
    }

}

//MARK: Apple SignIn Delegate Methods
extension ViewController: ASAuthorizationControllerDelegate {
    
    func authorizeAction(userIdentifier: String) {
           if #available(iOS 13.0, *) {
               let appleIDProvider = ASAuthorizationAppleIDProvider()
               appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                    switch credentialState {
                       case .authorized:
                           // The Apple ID credential is valid.
                        print("authorized")
                           break
                       case .revoked:
                           // The Apple ID credential is revoked.
                         print("revoked")
                           break
                       case .notFound:
                           // No credential was found, so show the sign-in UI.
                        print("not found")
                       default:
                           break
                    }
               }
           } else {
               // Fallback on earlier versions
           }
           
       }
    
    @available(iOS 13.0, *)
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = (appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? "")
            let givenName = appleIDCredential.fullName?.givenName ?? ""
            let familyName = appleIDCredential.fullName?.familyName ?? ""
            let email = appleIDCredential.email
            
            if givenName != "" {
                self.ud.set(givenName, forKey: "logged_user_name_apple")
                self.ud.set(givenName, forKey: "logged_user_email_apple")
            }
            
            print("\n--- Apple Sign-In ---\n")
            print("User Identifier  = \(userIdentifier)")
            print("Email            = \(email)")
            print("Full name        = \(fullName)")
            print("Given name       = \(givenName)")
            print("Family name      = \(familyName)")
            
            authorizeAction(userIdentifier: userIdentifier)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeView
            vc.userName = givenName ?? ""
            vc.userEmail = email ?? ""
            vc.isAppleLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
