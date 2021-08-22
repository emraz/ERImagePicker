//
//  ViewController.swift
//  Demo
//
//  Created by Mahmudul Hasan on 2020/03/31.
//  Copyright © 2020 Matrix Solution Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class ViewController: UIViewController {

    private lazy var imagePicker = ERImagePicker()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    @IBAction func cameraButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .commonCamera)
    }
    
    @IBAction func photoCameraButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .photoCamera)
    }
    
    @IBAction func videoCameraButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .videoCamera)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .photoVideoLibrary)
    }
    
    @IBAction func onlyPhotosButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .photoLibrary)
    }
    
    @IBAction func onlyVideosButtonPressed(_ sender: Any) {
        imagePicker.presentERImagePicker(from: self, pickerType: .videoLibrary)
    }
}

extension ViewController: ERImagePickerDelegate {
    func ERImagePickerDidDismiss() {
        //Picker dismissed
    }
    
    func ERImagePickerDidSelect(Image selectedImage: UIImage) {
        imageView.image = selectedImage
    }
    
    func ERImagePickerDidSelect(Video selectedVideoURL: URL) {
        imageView.image = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playVideo(withURL: selectedVideoURL)
        }
    }
}

extension ViewController {
    private func playVideo(withURL videoURL: URL) {
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.modalPresentationStyle = .fullScreen
        
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}
