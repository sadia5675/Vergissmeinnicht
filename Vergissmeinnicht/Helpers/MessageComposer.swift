//
//  MessageComposer.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 11.06.26.
//

import SwiftUI
import MessageUI

/// Bindet den UIKit-Nachrichten-Controller MFMessageComposeViewController in SwiftUI ein und ermöglicht das Öffnen der Nachrichten-App mit vorbereitetem Empfänger und Nachrichtentext
struct MessageComposer: UIViewControllerRepresentable {

    // MARK: - Properties

    let recipients: [String]
    let body: String
    
    @Environment(\.dismiss) private var dismiss

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(
        context: Context
    ) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = body
        vc.messageComposeDelegate = context.coordinator
        return vc
    }
    func updateUIViewController(
        _ uiViewController: MFMessageComposeViewController,
        context: Context
    ) {}
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(dismiss: dismiss)
    }

    // MARK: - Coordinator

    /// Schließt den Nachrichten-Dialog, sobald der Nutzer sendet, abbricht oder fehlschlägt
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {

        let dismiss: DismissAction

        init(dismiss: DismissAction) {
            self.dismiss = dismiss
        }

        func messageComposeViewController(
            _ controller: MFMessageComposeViewController,
            didFinishWith result: MessageComposeResult
        ) {
            dismiss()
        }
    }
}
