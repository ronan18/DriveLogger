//
//  AddToSiri.swift
//  DriveLogger
//
//  Created by Ronan Furuta on 9/25/20.
//

import Foundation
import SwiftUI
import UIKit
import Intents
import IntentsUI
/*class IntentController : UIViewController, INUIAddVoiceShortcutViewControllerDelegate{
    
    private var myTableView: UITableView!
    
    
    override func viewWillDisappear(_ animated: Bool) {
      //  window2?.tintColor  = UIColor.white
        
    }
    override func viewDidDisappear(_ animated: Bool) {
     //  window2?.tintColor  = UIColor.white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //Add to Siri Button
        let button = INUIAddVoiceShortcutButton(style: .blackOutline)
        
        self.view.addSubview(button)
        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToSiri), for: .touchUpInside)
        
        
    }
    
    
    @objc func addToSiri() {
           //add Intent
        let suggentedPhrase = "Add New Score to Game"
        let intent = StartDriveIntent()
        
        
        intent.suggestedInvocationPhrase = suggentedPhrase
        if let shortcut = INShortcut(intent: intent) {
            
            
            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            
            viewController.modalPresentationStyle = .formSheet
            viewController.delegate = self // Object conforming to `INUIAddVoiceShortcutViewControllerDelegate`.
            present(viewController, animated: true, completion: nil)
            
        }
        
    }
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true) {
            
        }
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
extension IntentController: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    
}
struct IntentIntegratetController : UIViewControllerRepresentable{
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<IntentIntegratetController>) -> IntentController {
        return IntentController()
    }
    
    func updateUIViewController(_ uiViewController: IntentController, context: UIViewControllerRepresentableContext<IntentIntegratetController>) {
        
    }
    
    typealias UIViewControllerType = IntentController

    
}
*/
