import UIKit

class ProfileViewController: UIViewController {
  
    
    @IBOutlet var profileView: UIView!
    @IBOutlet var signupStackView: UIStackView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var unameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        logout()
    }
    
    
    let userDefaults = UserDefaults.standard
    
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        
        showSignUpViewController()
        
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
       
        showLoginViewController()
        
    }
    
    

    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        checkLogin()
       
        let btnNotification = UIButton(frame: CGRect(x:0,y:0,width:10,height:10))
        btnNotification.setImage(UIImage(named: "notif"), for: .normal)
        btnNotification.addTarget(self,action: #selector(btnNotificationTapped), for: .touchUpInside)
        let btnBookmark = UIButton(frame: CGRect(x:0,y:0,width:20,height:20))
        btnBookmark.setImage(UIImage(named: "bookmark_white"), for: .normal)
        btnBookmark.addTarget(self,action: #selector(btnBookmarkTapped), for: .touchUpInside)
        let notifButton = UIBarButtonItem(customView: btnNotification)
        let bookmarkButton = UIBarButtonItem(customView: btnBookmark)
    
        self.navigationItem.setRightBarButtonItems([bookmarkButton,notifButton], animated: true)
        
        
        
    }
    
    @objc func btnBookmarkTapped(_ sender: Any) {
        
        showBookmarkViewController()
        print("bookmark event")
       
    }
    
    @objc func btnNotificationTapped(_ sender: Any) {
        
        showNotificationsViewController()
        print("notif event")
        
    }
    
    func checkLogin(){

        let isLogin = userDefaults.bool(forKey: "isLogin")
        let username:String = userDefaults.string(forKey: "username") ?? ""
        loginButton.layer.cornerRadius = 6
        loginButton.layer.masksToBounds = true
        logoutButton.layer.cornerRadius = 6
        logoutButton.layer.masksToBounds = true
        
        if(isLogin && username != ""){

            self.loginButton.isHidden = true
            self.signupStackView.isHidden = true
            getProfile()

        }
        else
        {
            self.loginButton.isHidden = false
            self.profileView.isHidden = true
            self.logoutButton.isHidden = true
            self.signupStackView.isHidden = false
            
        }
    }
    
    
    func logout(){
        
        UserDefaults.standard.setValue("", forKey: "accessToken")
        
        UserDefaults.standard.setValue("" , forKey: "username")
        
        UserDefaults.standard.setValue(false, forKey: "isLogin")
        
        UserDefaults.standard.synchronize()
        
        showLoginViewController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLogin()
    }
    
    func getProfile() {
        
        let username:String = userDefaults.string(forKey: "username") ?? ""
        providerUserService.request(.getUserByUsername(username: username)) { [weak self] result in
            guard case self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                   
                    if(response.statusCode == 200)
                    {
                        
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(UserResponse.self, from:
                        response.data)
            
                        self?.profileView.isHidden = false
                        self?.logoutButton.isHidden = false
                        self?.userDefaults.setValue(userResponse.data?.id, forKey: "userId")
                        self?.emailLabel.text = userResponse.data?.email
                        self?.unameLabel.text = userResponse.data?.username
                        self?.phoneLabel.text = userResponse.data?.phoneNumber
                        
                    }else {
                        
                        self?.showLoginViewController()
                        
                    }
                 
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
    
        }
        
    }
    

}


extension UIViewController {
    func showProfileViewController() {
        let storyboard = UIStoryboard(name: "TabbarMenu", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        // present(nc, animated: true, completion: nil)
        navigationController?.pushViewController(nc, animated: true)
    }
}
