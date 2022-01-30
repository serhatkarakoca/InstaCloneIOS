//
//  UploadViewController.swift
//  InstaCloneIOS
//
//  Created by serhat on 29.01.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var messageBox: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage:Any? = nil
    var defaultImage:UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultImage = imageView.image
        messageBox.layer.borderColor = UIColor.systemBlue.cgColor
        messageBox.layer.borderWidth = 0.5
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)

    }
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.originalImage]
        imageView.image = selectedImage as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        if messageBox.text != "" && selectedImage != nil{
            
            
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()

            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
        let storage = Storage.storage()
        let reference = storage.reference()
        
        let mediaFolder = reference.child("media")
        
        let imageReference = mediaFolder.child("\(UUID().uuidString).jpg")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
        
        imageReference.putData(data , metadata: nil) { (metaData, error) in
            
            if error != nil {
                Utils.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "error", context: self)
                return
            }
            
            imageReference.downloadURL { url, error in
                if error == nil{
                    let imageUrl = url?.absoluteString
                   let firestoreDatabase = Firestore.firestore()
                    var firestoreReference : DocumentReference? = nil
                    
                    let fireStorePost = ["comment":self.messageBox.text!,"postedBy":Auth.auth().currentUser!.email!,"date":FieldValue.serverTimestamp(),"likes":0,"imageURL":imageUrl!] as [String:Any]
                    
                    firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: fireStorePost, completion: { error in
                        if error != nil{
                            self.dismiss(animated: true, completion: nil)
                            Utils.makeAlert(titleInput: "Hata", messageInput: "\(imageUrl!) \n Resim yüklenemedi", context: self)
                            return
                        }
                        self.dismiss(animated: true, completion: nil)
                        Utils.makeAlert(titleInput: "İşlem Tamam", messageInput: "Resim yüklendi", context: self)
                        self.selectedImage = nil
                        self.messageBox.text = nil
                        self.imageView.image = self.defaultImage
                        self.tabBarController?.selectedIndex = 0
                    })
                    }
                }
            }
        }
        
    }else {
        Utils.makeAlert(titleInput: "Hata", messageInput: "Tüm Alanları doldurunuz", context: self)
        
        }
    }
}
