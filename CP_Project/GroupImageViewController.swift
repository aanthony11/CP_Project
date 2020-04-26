//
//  GroupImageViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/26/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class GroupImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    var original_image : UIImage?
    var scaled_image : UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nextButton.layer.cornerRadius = 10
    }
    

    @IBAction func onTapped(_ sender: Any) {
        print("I was tapped!")
        
        // open image picker for user
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
       
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // store image data
        original_image = info[.editedImage] as? UIImage
        let size = CGSize(width: 300, height: 300)
        scaled_image = original_image?.af_imageScaled(to: size)
        
        groupImageView.image = scaled_image
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass image data to next view controller
        if segue.identifier == "nextSegue" {
            let destination = segue.destination as! UINavigationController
            let vc = destination.topViewController as! CreateGroupViewController
            vc.image = scaled_image
        }
    }
    
    
    @IBAction func onNext(_ sender: Any) {
        performSegue(withIdentifier: "nextSegue", sender: self) // perform segue
        
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
