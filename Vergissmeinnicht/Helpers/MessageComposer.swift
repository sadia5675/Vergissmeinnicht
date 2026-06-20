//
//  MessageComposer.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 11.06.26.
//

import SwiftUI
import MessageUI

struct MessageComposer:
UIViewControllerRepresentable {

    let recipients: [String]
    let body: String

    func makeUIViewController(
        context: Context
    ) -> MFMessageComposeViewController {

        let vc =
            MFMessageComposeViewController()

        vc.recipients = recipients
        vc.body = body

        return vc
    }

    func updateUIViewController(
        _ uiViewController: MFMessageComposeViewController,
        context: Context
    ) {}
}
