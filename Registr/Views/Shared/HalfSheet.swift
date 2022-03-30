//
//  HalfSheet.swift
//  Registr
//
//  Created by Christoffer Detlef on 17/03/2022.
//

import SwiftUI

extension View {
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView, onEnd: @escaping () -> () ) -> some View {
        
        return self
            .background(
                HalfSheetController(sheetView: sheetView(), onEnd: onEnd, showSheet: showSheet)
            )
    }
}

struct HalfSheetController<SheetView: View>: UIViewControllerRepresentable {
    
    var sheetView: SheetView
    var onEnd: () -> ()
    
    let controller = UIViewController()
    
    @Binding var showSheet: Bool
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        if showSheet {
            let sheetController = CustomHostingController(rootView: sheetView)
            
            sheetController.presentationController?.delegate = context.coordinator
            
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
            
        }
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: HalfSheetController
        
        init(parent: HalfSheetController) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.onEnd()
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    
    override func viewDidLoad() {
        
        view.backgroundColor = .clear
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
        }
    }
}