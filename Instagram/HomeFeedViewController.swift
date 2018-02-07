//
//  HomeFeedViewController.swift
//  Instagram
//
//  Created by Jonathan Du on 2/5/18.
//  Copyright © 2018 Jonathan Du. All rights reserved.
//

import UIKit
import Firebase
class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var refreshControl :UIRefreshControl!

    
    @IBOutlet weak var tableView: UITableView!
    var db = Firestore.firestore().collection("posts")
    var posts : [DocumentSnapshot] = []


    @IBAction func logoutButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginScreen")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func parseFire(){
        db.getDocuments{ (data,error) in
            if data != nil {
                var array : [DocumentSnapshot] = []
                for document in data!.documents{
                    array.append(document)
                }
                self.posts = array
                self.tableView.reloadData()
            }else{
                print("ERROR")
            }
        }
        self.refreshControl.endRefreshing()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row].data()
        cell.selectionStyle = .none
        
        if let image64 = post["image"] as? String {
            let imageDecoded:NSData = NSData(base64Encoded: image64, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let image:UIImage = UIImage(data: imageDecoded as Data)!
            cell.postImage.image = image
        }
        cell.captionLabel.text = post["caption"] as? String
        return cell
    }
    @IBAction func postButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeFeedViewController.didPullToRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)


        tableView.delegate = self
        tableView.dataSource = self
        parseFire()
        // Do any additional setup after loading the view.
        
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        parseFire()
    }
    
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "detailSegue"{
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let post = posts[indexPath.row].data()
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.post = post
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
