

import UIKit

class Utils{
    static func makeAlert(titleInput:String,messageInput:String,context:UIViewController){
        let alert =  UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        context.present(alert,animated:true,completion:nil)
        
    }
    
    static func showLoading(context:UIViewController){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        context.present(alert, animated: true, completion: nil)
       
    }
}

