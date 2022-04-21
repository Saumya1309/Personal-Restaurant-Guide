import SwiftUI
import Foundation
import UIKit
import MessageUI

// View that shows up when we select share through email
struct MailView: UIViewControllerRepresentable
{
    // Reference to current view
    @Environment(\.presentationMode) var presentation
    // Result, in case of something goes wrong
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    // Reference to the restaurant we want to share
    let restaurant: Restaurant
    
    //An interface for responding to user interactions with a mail compose view controller.
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate
    {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(presentation: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>)
        {
            _presentation = presentation
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
        {
            defer
            {
                $presentation.wrappedValue.dismiss()
            }
            
            guard error == nil else
            {
                self.result = .failure(error!)
                return
            }
            
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(presentation: presentation, result: $result)
    }
    
    // Create the mail view
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController
    {
        // Create the view and assign the data
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["abc@icloud.com"]) // Mail to whom we're sending the mail
        vc.setSubject("Restaurant recommendation: \(restaurant.name)") // Subject
        vc.setMessageBody("Hello, I'm really like this place and that's why I'm sending this mail, you can visit it at \(restaurant.address) it's open till \(restaurant.openTime), it has \(restaurant.stars) stars of 5, you can call \(restaurant.phone) to reserve!", isHTML: false) // Message
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>)
    {
    }
}
