//
//  ImagesViewController.swift
//  AppleTV1
//
//  Created by Praveen on 28/02/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var creditLabel: UILabel!
    var category: String = ""
    var imageViews: [UIImageView] = []
    var images: [JSON] = []
    var imageCounter = 0
    var shouldContinue: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        guard let url = URL(string: "https://api.unsplash.com/search/photos?client_id=\(Constants.appID)&query=\(category)&per_page=100") else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetch(url: url)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        shouldContinue = false
    }
    private func setupViews() {
        imageViews = self.view.subviews.compactMap { $0 as? UIImageView }
        imageViews.forEach { $0.alpha = 0 }
        creditLabel.layer.cornerRadius = 15
        creditLabel.clipsToBounds = true
        creditLabel.alpha = 0
    }
    private func fetch(url: URL) {
        if let data = try? Data(contentsOf: url) {
            let json = JSON(data)
            images = json["results"].arrayValue
            DispatchQueue.global(qos: .userInteractive).async {
                self.downloadImage()
            }
        }
    }
    private func downloadImage() {
        if shouldContinue == false { return }
        print(images)
        let currentImage = images[self.imageCounter % self.images.count]
        
        let imageName = currentImage["urls"]["full"].stringValue
        let imageCredit = " "+currentImage["user"]["name"].stringValue
        
        imageCounter += 1
        guard let imageURL = URL(string: imageName) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        
        guard let image = UIImage(data: imageData) else { return }
        DispatchQueue.main.async {
            self.show(image: image, credit: imageCredit)
        }
        
    }
    private func show(image: UIImage, credit: String) {
        spinner.stopAnimating()
        
        let imageViewToUse = imageViews[imageCounter % imageViews.count]
        let otherImageView = imageViews[(imageCounter+1) % imageViews.count]
        
        UIView.animate(withDuration: 2.0, animations: {
            imageViewToUse.image = image
            imageViewToUse.alpha = 1
            self.creditLabel.alpha = 0
            self.view.sendSubviewToBack(otherImageView)
        }) { (_) in
            self.creditLabel.text = credit.uppercased()
            self.creditLabel.alpha = 1.0
            otherImageView.alpha = 0
            otherImageView.transform = .identity
            
            UIView.animate(withDuration: 10.0, animations: {
                imageViewToUse.transform = CGAffineTransform(scaleX: 2.1, y: 2.1)
            }) { (_) in
                DispatchQueue.global(qos: .userInteractive).async {
                    self.downloadImage()
                }
            }//anim end 2
        }
    }
}
