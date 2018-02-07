//
//  DetailViewController.swift
//  Instagram
//
//  Created by Jonathan Du on 2/6/18.
//  Copyright © 2018 Jonathan Du. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var post: [String: Any]?
    @IBOutlet weak var detailDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let image64 = post!["image"] as? String {
            let imageDecoded:NSData = NSData(base64Encoded: image64, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let image:UIImage = UIImage(data: imageDecoded as Data)!
            detailImage.image = image
        }
        var date = post!["time"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let todaysDate = dateFormatter.string(from: date as! Date)
        detailDescriptionLabel.text = post?["caption"] as? String
        detailDateLabel.text = todaysDate
        

    }
    

}
