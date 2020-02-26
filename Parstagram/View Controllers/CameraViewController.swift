//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Owner on 2/18/20.
//  Copyright © 2020 Brandon Hsu @ CodePath. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var  commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender : Any) {
        // creating custom PFObject class
        let post = PFObject(className: "Posts")
        post["caption"] = commentField.text
        post["user"] = PFUser.current()!
        
        // save tapped resized image as .png
        let imageData = imageView.image?.pngData()
        
        // create a new parse file (binary object)
        let file = PFFileObject(data: imageData!)
        
        // column image has url to the file contents
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print ("saved!")
            } else {
                print("error!")
            }
        }
    }
    
    // tapping on photo image
    @IBAction func onCameraButton(_ sender: Any) {
        // create controller
        let picker = UIImagePickerController()
        // callback after user takes a photo
        picker.delegate = self
        // allows a user to edit photo after photo is captured
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // returns a dictionary which contains an image
        let image = info[.editedImage] as! UIImage
        // resize image due to cloud upload speed
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
