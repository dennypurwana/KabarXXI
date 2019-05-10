import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfirmPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        signUp(txfUsername.text!, txfEmail.text!, txfPhone.text!, txfPassword.text!)
       // showLoginViewController()
    
    }
    @IBAction func toLoginButtonTapped(_ sender: UIButton) {
        showLoginViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.cornerRadius = 6
        btnSignUp.layer.masksToBounds = true
        txfUsername.delegate = self
        txfEmail.delegate = self
        txfPhone.delegate = self
        txfPassword.delegate = self
        txfConfirmPassword.delegate = self
        self.navigationItem.title = "Sign Up"
        // Do any additional setup after loading the view.
    }

    
    func signUp(_ username: String,_ email: String,_ phone: String,_ password: String) {
        
        
        providerUserService.request(UserServices.createUser(username: username, email: email, phone: phone, password: password)) { (result) in
            switch result {
            case .success(let response):
                do {
    
                    let decoder = JSONDecoder()
                    let responseRegister = try decoder.decode(RegisterResponse.self, from:
                        response.data) //Decode JSON Response Data
                    print(responseRegister)

                    if (responseRegister.status == 200){
                      
                        let  alert = UIAlertController(title: "Info", message:                 responseRegister.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                            self.showLoginViewController()
                        }))
                        self.present(alert, animated: true, completion: nil)

                    }else{

                        let alert = UIAlertController(title: "Info", message: responseRegister.message, preferredStyle: .alert)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}




// MARK: - UIViewController
extension UIViewController {
    
    func showSignUpViewController() {
        
        let storyboard = UIStoryboard(name: "RootSign", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: "register") as! SignUpViewController
        navigationController?.pushViewController(nc, animated: true)
    }
}
