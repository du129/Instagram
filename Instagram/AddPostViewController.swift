//
//  AddPostViewController.swift
//  Instagram
//
//  Created by Jonathan Du on 2/5/18.
//  Copyright © 2018 Jonathan Du. All rights reserved.
//

import UIKit
import Firebase
class AddPostViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var db = Firestore.firestore().collection("posts")
    
    let vc = UIImagePickerController()
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionText: UITextField!
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        print("sdsd")
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        postImage.image = editedImage
        //let imageurl =
        
        // Dismiss UIImagePickerController to go back to your original view controller
        picker.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func postButton(_ sender: Any) {
        let data:Data = UIImageJPEGRepresentation((postImage.image!), 0.2)!
        let strBase64 = data.base64EncodedString()
        //print(strBase64 ?? "no")
        
        //var ref: DocumentReference? = nil
        
        db.addDocument(data: [
            "caption": captionText.text!,
            "image":strBase64,
            "time": Date()
            ], completion: { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
        })
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(vc, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
