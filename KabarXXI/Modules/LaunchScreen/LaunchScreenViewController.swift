import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet var loadingBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startHomepage()

    }
    
    func startHomepage(){
        loadingBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        
            print("stop timeout")
            self.loadingBar.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showMainViewController()
            
        }
    }
}
