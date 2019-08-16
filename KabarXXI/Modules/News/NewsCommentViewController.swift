
import UIKit

class NewsCommentViewController: UIViewController
  , UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
  {
    
    @IBOutlet var newsCommentTableView: UITableView!
  
    @IBOutlet var commentButton: UIButton!
    
    @IBOutlet var commentInput: UITextField!
    
    @IBAction func commentButtonTapped(_ sender: Any) {
       
        if(UserDefaults.standard.bool(forKey: "isLogin")){
            
            if(commentInput.text == ""){
                
                let alert = UIAlertController(title: "Info", message: "Mohon isi komentar terlebih dahulu.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                sendComment(commentInput.text!)
            }
            
        }
        
        else{
            
            let  alert = UIAlertController(title: "Info", message: "Anda harus login terlebih dahulu.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.showLoginViewController()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    var idNews_:Int = 0
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentInput.delegate = self
        self.navigationItem.title = "Komentar"
        loadAllComment()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAllComment()
        
    }
    
    
    func sendComment(_ description: String) {
    
        commentProviderServices.request(CommentServices.createComment(description: description, newsId: idNews_)) { (result) in
            switch result {
            case .success(let response):
                
                self.commentInput.text = ""
                self.loadAllComment()
                print(response)
//                do {
//
//                    print(response)
//
//
//                } catch let parsingError {
//                    print("Error", parsingError)
//                }
            case .failure(let error):
                print("error : \(error)")
                
            }
        }
        
        
    }
    
    
    func loadAllComment() {
    
        commentProviderServices.request(.getAllCommented(idNews_)) { [weak self] result in
            guard case self = self else { return }
            
            // 3
            switch result {
            case .success(let response):
                do {
                    
                    print("data comment : \(response.data)")
                    
                    let decoder = JSONDecoder()
                    let responses = try decoder.decode(CommentResponse.self, from:
                        response.data)
                    print(responses)
                    self?.comments = responses.data ?? []
                    self?.newsCommentTableView.reloadData()
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
            case .failure: break
            }
            
            //self?.refreshControl_?.endRefreshing()
            self?.newsCommentTableView.finishInfiniteScroll()
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.newsCommentTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        let cell = Bundle.main.loadNibNamed("NewsCommentViewCell", owner: self, options: nil)?.first as! NewsCommentViewCell
        
        let comment = comments[indexPath.row]
//        cell.image =  UIImage(named: "user_round")
        cell.imageProfile.image = UIImage(named: "user_male_round")
        cell.username.text = comment.users?.username ?? ""
        cell.descComment.text = comment.description  ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

// MARK: - UIViewController
extension UIViewController {
    
    func showCommentViewController(with idNews: Int) {
        
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "newsComment") as! NewsCommentViewController
        vc.idNews_ = idNews
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
