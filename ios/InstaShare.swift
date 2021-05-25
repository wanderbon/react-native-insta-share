@objc(InstaShare)
class InstaShare: NSObject, UIDocumentInteractionControllerDelegate {
      private let documentInteractionController = UIDocumentInteractionController()
      private let kInstagramURL = "instagram://"
      private let kUTI = "com.instagram.photo" //"com.instagram.exclusivegram"
      private let kfileNameExtension = "instagram.ig"//"instagram.igo"
      private let kAlertViewTitle = "Error"
      private let kAlertViewMessage = "Please install the Instagram application"
      
      func postImageToInstagramWithCaption(imageInstagram: UIImage) {
          let instagramURL = NSURL(string: kInstagramURL)
          if UIApplication.shared.canOpenURL(instagramURL! as URL) {
              let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
              
              do {
              try imageInstagram.jpegData(compressionQuality: 1)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
              } catch {
                  print(error)
              }

              let rect = CGRect.zero
              let fileURL = NSURL.fileURL(withPath: jpgPath)
              
              
              documentInteractionController.url = fileURL
              documentInteractionController.delegate = self
              documentInteractionController.uti = kUTI
              
              let instagramCaption = ""
            
              // adding caption for the image
              documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
//              documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
          }
          else {
              
              // alert displayed when the instagram application is not available in the device
              UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
          }
      }
    
    @objc(share:withResolver:withRejecter:)
    func share(uri: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        if NSFileManager.defaultManager().fileExistsAtPath(uri) {
            let url = NSURL(string: imageUrlPath)
            let data = NSData(contentsOfURL: url!)
            
            postImageToInstagramWithCaption(imageInstagram: UIImage(data: data!))
        }
    }
}
