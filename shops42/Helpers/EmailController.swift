//
//  EmailController.swift
//  shops24
//
//  Created by Diederick de Buck on 29/05/2023.
//

import Foundation
import MessageUI


class EmailController: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailController()
    
    private override init() {
    }
    
    func sendEmail(
        subject: String,
        body: String,
        to: String,
        isHTML: Bool
    ) -> Bool {
        guard MFMailComposeViewController.canSendMail() else {
            return false
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([to])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: isHTML)
        if let rootViewController = EmailController.getRootViewController() {
            rootViewController.present(mailComposer, animated: true, completion: nil)
        } else {
            return false
        }
        return true
    }
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        EmailController.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                if let rootViewController = window.rootViewController {
                    return rootViewController
                }
            }
        }
        return nil
    }
}
