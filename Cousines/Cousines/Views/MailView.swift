//
//  MailView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 05/04/22.
//

import SwiftUI
import Foundation
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable
{
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    let restaurant: Restaurant
    
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
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController
    {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["abc@icloud.com"])
        vc.setSubject("Restaurant recommendation: \(restaurant.name)")
        vc.setMessageBody("Hello, I'm really like this place and that's why I'm sending this mail, you can visit it at \(restaurant.address) it's open till \(restaurant.openTime), it has \(restaurant.stars) stars of 5, you can call \(restaurant.phone) to reserve!", isHTML: false)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>)
    {
        
    }
}
