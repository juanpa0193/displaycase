//
//  FeedVC.swift
//  displaycase
//
//  Created by JuanPa Villa on 3/3/17.
//  Copyright © 2017 JuanPa Villa. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtField: MaterialTextField!
    @IBOutlet weak var imgSelectorImage: UIImageView!
    var posts = [Post]()
    var imageSelected = false
    
    var imagePicker: UIImagePickerController!
    
    static var imageCache = NSCache<AnyObject, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        tableView.estimatedRowHeight = 358
        
        DataService.ds.ref.child(REF_POSTS).observe(.value, with: { (snapshot) in
            
            //Since everytime there is a change to a vlue we receive a complete update of all the posts, we just want to clear the posts array and repopulate it
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String,Any> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                    
                }
                
            }
            
            
            print(snapshot.value ?? [:])
            self.tableView.reloadData()
            
        })
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = post.imageUrl {
                img = FeedVC.imageCache.object(forKey: url as AnyObject) as? UIImage
                print("\(img)")   //< ------- DELETE
            }
            
            cell.configureCell(post: post, img: img)  //<------- Revisit
            return cell
            
        } else {
        
        return PostCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            
            return tableView.estimatedRowHeight
        }
    }

    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let imgPicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgSelectorImage.image = imgPicked
            imageSelected = true
        }
        
        
        
        
        
    }
    
    
    @IBAction func selectImg(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func makePost(_ sender: Any) {
        
        
        if let post = txtField.text, post != "" {
            
            if let img = imgSelectorImage.image, imageSelected == true {
                
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = URL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)! // This may return an optional, you may want to add more error handling.
                let keyData = "2568GOST02cba79038e3a5ce0109133cc9a0be6a".data(using: .utf8)!
                let keyJSON = "json".data(using: .utf8)!
                
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    //
                    multipartFormData.append(imgData, withName: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.append(keyData, withName: "key")
                    multipartFormData.append(keyJSON, withName: "format")
                    
                    
                    
                    
                }, to: url, encodingCompletion: { (encodingResult) in
                    //
                    switch encodingResult {
                        
                    case .success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (response) in
                            
                            if let info = response.value as? Dictionary<String,Any> {
                                
                                if let links = info["links"] as? Dictionary<String, Any> {
                                    
                                    if let imgLink = links["image_link"] as? String {
                                        print("LINK: \(imgLink)")
                                        self.postToFirebase(imgUrl: imgLink)
                                        
                                    }
                                }
                            }
                            
                            
                        })
                        break
                    case .failure(let error):
                        print(error)
                    }
                    
                })
                
                
            } else {
                self.postToFirebase(imgUrl: nil)
            }
            
        }
        
        
    }
    
    
    
    func postToFirebase(imgUrl: String?) {
        
        var post : Dictionary<String, Any> =
        [
        "description": txtField.text!,
        "likes": 0
        ]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        let firebasePost = DataService.ds.ref.child(REF_POSTS).childByAutoId()
        firebasePost.setValue(post)
        
        txtField.text = ""
        imgSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
        
    }

}
