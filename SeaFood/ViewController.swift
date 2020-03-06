//
//  ViewController.swift
//  SeaFood
//
//  Created by Mohammad Athania on 02/03/20.
//  Copyright © 2020 Mohammad Athania. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    let imagePicker1 = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
         imagePicker.sourceType = .camera
        imagePicker1.sourceType = .photoLibrary
        imagePicker1.delegate = self
         imagePicker.allowsEditing = false
        imagePicker1.allowsEditing = true

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       {
         imageView.image = userPickedImage
        guard let ciimage = CIImage(image: userPickedImage) else {
            fatalError("Could Not Convert")
        }
        detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker1.dismiss(animated: true, completion: nil)

        
    }
    
    func detect(image: CIImage){
       guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Failed to Build Model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Unsuccesful Request")
         
            }

            self.navigationItem.title = results.first?.identifier
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try! handler.perform([request])

        }
        catch{
            print(error)
        }
    }
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
           present(imagePicker1, animated: true, completion: nil)
    }
}

