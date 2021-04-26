import Foundation
import UIKit

public struct PIPShadow {
    public let color: UIColor
    public let opacity: Float
    public let offset: CGSize
    public let radius: CGFloat
}

public struct PIPCorner {
    public let radius: CGFloat
    public let curve: CALayerCornerCurve?
}

public enum PIPState {
    case pip
    case full
}

public enum PIPPosition {
    case topLeft
    case middleLeft
    case bottomLeft
    case topRight
    case middleRight
    case bottomRight
}

enum _PIPState {
    case none
    case pip
    case full
    case exit
}

public typealias PIPKitViewController = (UIViewController & PIPUsable)

public final class PIPKit {
    
    static public var isActive: Bool { return rootViewControllers.count > 0 }
    
//    static public var isPIP: Bool { return state == .pip }
    static public var pipViewControllers: [PIPKitViewController] { return rootViewControllers.filter{$0.pipState == .pip} }
    
//    static internal var state: _PIPState = .none
    static private var rootViewControllers = [PIPKitViewController]()
    
    public class func show(with viewController: PIPKitViewController, completion: (() -> Void)? = nil) -> Int {
        guard let window = UIApplication.shared.keyWindow else {
            return -1
        }
        let vc = viewController
//        guard !isActive else {
//            dismiss(vc, animated: false) {
//                PIPKit.show(with: viewController)
//            }
//            return
//        }
        
        rootViewControllers.append(vc)
        vc.pipState = vc.initialState

        vc.view.alpha = 0.0
        window.addSubview(vc.view)
        
        vc.setupEventDispatcher()
        
        UIView.animate(withDuration: 0.25, animations: {
            vc.view.alpha = 1.0
        }) { (_) in
            completion?()
        }
        // Return index of subview
        return window.subviews.count - 1
    }
    
    public class func dismiss(_ viewController: PIPKitViewController, animated: Bool, completion: (() -> Void)? = nil) {
//        state = .exit
        viewController.pipDismiss(animated: animated, completion: {
            PIPKit.reset()
            completion?()
        })
    }
    
    // MARK: - Internal
//    class func startPIPMode() {
//        guard let rootViewController = rootViewController else {
//            return
//        }
//        
//        // PIP
//        state = .pip
//        rootViewController.pipEventDispatcher?.enterPIP()
//    }
//    
//    class func stopPIPMode() {
//        guard let rootViewController = rootViewController else {
//            return
//        }
//        
//        // fullScreen
//        state = .full
//        rootViewController.pipEventDispatcher?.enterFullScreen()
//    }
    
    // MARK: - Private
    private static func reset() {
        rootViewControllers = []
    }
    
}
