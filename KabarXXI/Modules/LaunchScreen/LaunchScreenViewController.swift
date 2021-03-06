import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet var loadingBar: UIView!
    
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    var appSettingArray : [ApplicationSetting] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startHomepage()
       
        
    }
    
    func startHomepage(){
        loadingBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.getApplicationSetting()
        }
    }
    
    
    func openUrlApp(){
        if let url = URL(string: Constant.AppURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func getApplicationSetting(){
        
        applicationSettingProviderServices.request(.getApplicationSetting()) { [weak self] result in
            guard case self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let responses = try decoder.decode(ApplicationSettingResponse.self, from:
                        response.data)
                    
                    self?.appSettingArray = responses.data ?? []
                    
                    
                    if(responses.data?.count ?? 0 > 0){
                        
                        let iosVersionCode = self?.appSettingArray[0].iosVersionCode ?? 0
                        let appVersionConvert = Int((self?.appVersion)!)
                        print(appVersionConvert ?? "0")
                        print(iosVersionCode ?? "0")
                        
                        if iosVersionCode > appVersionConvert! {
                            
                            self?.loadingBar.isHidden = true
                            let  alert = UIAlertController(title: "Info", message:                 "Silahkan update aplikasi anda.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
                                alert.dismiss(animated: true, completion: nil)
                                self?.openUrlApp()
                            }))
                            self?.present(alert, animated: true, completion: nil)
                            
                        }
                        else {
                            
                            self?.loadingBar.isHidden = true
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.showMainViewController()
                            
                        }
                    }
                        
                    else {
                        
                        self?.loadingBar.isHidden = true
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.showMainViewController()
                        
                    }
                    
                    
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
        }
        
    }
}
