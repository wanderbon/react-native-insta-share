import Foundation
import UIKit
import Photos

@objc(InstaShare)
class InstaShare: NSObject, UIDocumentInteractionControllerDelegate {
    private let documentInteractionController = UIDocumentInteractionController()
    private let kInstagramURL = "instagram://"
    private let kUTI = "com.instagram.exclusivegram" // "com.instagram.photo"
    private let kfileNameExtension = "instagram.igo" // "instagram.ig"
    private let kAlertViewTitle = "101"
    private let kAlertViewMessage = "app_not_install"

    func postImageToInstagramWithCaption(imageInstagram: UIImage, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        let instagramURL = NSURL(string: kInstagramURL)
        
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            if #available(iOS 13, *) {
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        let imgReq = PHAssetChangeRequest.creationRequestForAsset(from: imageInstagram)
                        let localIdentifier = imgReq.placeholderForCreatedAsset?.localIdentifier
                        let u = "instagram://library?LocalIdentifier=" + localIdentifier!
                        
                        UIApplication.shared.open(NSURL(string: u)! as URL, options: [:], completionHandler: nil)
                     }
                } catch {
                    let errorTemp = NSError(domain:"", code:104, userInfo:nil)
                    reject(self.kAlertViewTitle, "permissions_not_recived", errorTemp)
                }
            } else {
                let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
                            
                do {
                    try imageInstagram.jpegData(compressionQuality: 0.75)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
                } catch {
                    let errorTemp = NSError(domain:"", code:102, userInfo:nil)
                    reject(kAlertViewTitle, "url_not_valid", errorTemp)
                }

                let rect = CGRect.zero
                let fileURL = NSURL.fileURL(withPath: jpgPath)
                
                documentInteractionController.url = fileURL
                documentInteractionController.delegate = self
                documentInteractionController.uti = kUTI

                documentInteractionController.annotation = ["InstagramCaption": "Share to"]
                let rootView = UIApplication.shared.delegate?.window??.rootViewController?.view
                
                DispatchQueue.main.async {
                    self.documentInteractionController.presentOpenInMenu(from: rect, in: rootView!, animated: true)
                }
                //
            }
        }
        else {
            let stringURL = "http://itunes.apple.com/app/instagram/id389801252"
            let url = URL(string: stringURL)
            
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            let errorTemp = NSError(domain:"", code:101, userInfo:nil)
            reject(kAlertViewTitle, kAlertViewMessage, errorTemp)
        }
    }

    @objc(share:withResolver:withRejecter:)
    func share(uri: String, resolve: @escaping RCTPromiseResolveBlock,reject: @escaping RCTPromiseRejectBlock) -> Void {
        guard let backgroundImageURL = RCTConvert.nsurl(uri) else {
            let errorTemp = NSError(domain:"", code:102, userInfo:nil)
            return reject(kAlertViewTitle, "url_not_valid", errorTemp)
        }
        
        var image: UIImage? = nil

        do {
            let data = try Data(contentsOf: backgroundImageURL)
            image = UIImage(data: data)
        } catch {
            let errorTemp = NSError(domain:"", code:103, userInfo:nil)
            reject(kAlertViewTitle, "data_not_valid", errorTemp)
        }

        postImageToInstagramWithCaption(imageInstagram: image!, resolve: resolve, reject: reject)
    }
}
