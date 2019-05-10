import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
         login(txfUsername.text!, txfPassword.text!)
    }
    @IBAction func toRegisterButtonTapped(_ sender: UIButton) {
        showSignUpViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 6
        loginButton.layer.masksToBounds = true
        txfUsername.delegate = self
        txfPassword.delegate = self
        self.navigationItem.title = "Login"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func login(_ username: String,_ password: String) {
        
        providerUserService.request(UserServices.loginUser(username: username, password: password)) { (result) in
            
            switch result {
            case .success(let response):
                do {
                    
                    print(response.statusCode)
                    let decoder = JSONDecoder()
                    let responseLogin = try decoder.decode(LoginResponse.self, from:
                        response.data) //Decode JSON Response Data
                    
                    print(responseLogin)
                    
                    if(response.statusCode == 200){
                        
                        print(responseLogin.access_token ?? "")
                    UserDefaults.standard.setValue(responseLogin.access_token ?? "", forKey: "accessToken")
                        
                        UserDefaults.standard.setValue(username , forKey: "username")
                        
                        UserDefaults.standard.setValue(true, forKey: "isLogin")
                        UserDefaults.standard.synchronize()
                        self.showProfileViewController()
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Error", message: responseLogin.error_description, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                   
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            case .failure(let error):
                print("error : \(error)")
                
            }
        }
        
    }
}

// MARK: - UIViewController
extension UIViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
       // present(nc, animated: true, completion: nil)
         navigationController?.pushViewController(nc, animated: true)
    }
}
