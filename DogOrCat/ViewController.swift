//
//  ViewController.swift
//  DogOrCat
//
//  Created by Bruno Portela on 5/30/19.
//  Copyright © 2019 Bruno Portela. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var checkAnimalButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImageSource(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        let imageSourceActions = UIAlertController(title: "Image Source", message: "Choose an image source to continue.", preferredStyle: .actionSheet)
        imageSourceActions.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction)  in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
            
        }))
        
        imageSourceActions.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(imageSourceActions, animated: true)
    }
    
    @IBAction func checkAnimal(_ sender: Any) {
        
        AnimalDetector.startAnimalDetection(imageView: imageView) { (results) in
            guard let animal = results.first else {
                self.classificationLabel.text = "Sorry, couldn't determine."
                print("No detection possible")
                return
                
            }
        
            DispatchQueue.main.async {
                self.classificationLabel.text = "It's a \(animal)"
            }
        }
    }
    
}
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {picker.dismiss(animated: true); print("Could not select image!"); return}
        
        imageView.image = selectedImage
        imageView.contentMode = .scaleAspectFill
        checkAnimalButton.isEnabled = true
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
