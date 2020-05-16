//
//  AnimalDetector.swift
//  DogOrCat
//
//  Created by Bruno Portela on 5/31/19.
//  Copyright © 2019 Bruno Portela. All rights reserved.
//

import UIKit
import Vision

class AnimalDetector {
    static func startAnimalDetection (imageView: UIImageView, completion: @escaping (_ classification: [String]) -> Void) {
        
        let imageOrientation = CGImagePropertyOrientation(imageView.image!.imageOrientation)
        
        let visionRequestHandler = VNImageRequestHandler(cgImage: imageView.image!.cgImage!, orientation: imageOrientation, options: [:])
        
        guard let catDogModel = try? VNCoreMLModel(for: CatDogClassifier().model) else {print ("Could not load model"); return}
        
        let animalDetectionRequest = VNCoreMLRequest(model: catDogModel)
        {(request, error) in
        
            guard let observations = request.results else {print("No results"); return }
            
            let classifications = observations
                .compactMap({$0 as? VNClassificationObservation})
                .filter({$0.confidence > 0.9})
                .map({$0.identifier})
            
            completion(classifications)
            
        }
        do {
            try visionRequestHandler.perform([animalDetectionRequest])
        } catch{
            print(error.localizedDescription)
        }
    }
}

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default:
            fatalError()
        }
    }
}
