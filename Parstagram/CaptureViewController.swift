//
//  CaptureViewController.swift
//  Parstagram
//
//  Created by David Yip on 2/17/19.
//  Copyright © 2019 David Yip. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSumbit(_ sender: Any){
        let post = PFObject(className: "Posts")
        
        //every PFobject is like a dictionary
        post["author"] = PFUser.current()!
        post["caption"] = commentLabel.text
        
        let imageDate = imageView.image!.pngData()
        let file = PFFileObject(data: imageDate!)
        
        post["image"] = file
        
        post.saveInBackground { ( success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print("Error \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onTapCamera(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }
        else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to:  size)
        
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
