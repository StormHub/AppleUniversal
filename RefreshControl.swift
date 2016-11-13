
import UIKit

public enum IndicatorLocation {
    case top, bottom
}

open class RefreshControl : UIControl {
    
    fileprivate struct Constants {
        static let defaultHeight = CGFloat(46)
        static let margin = CGFloat(4)
    }
    
    fileprivate var scrollView:UIScrollView? {
        return self.superview as? UIScrollView
    }
    
    open var location: IndicatorLocation = .top {
        didSet {
            if let view = scrollView {
                indicator.endAnimation()
                refreshViewSizes(view)
            }
        }
    }
    
    fileprivate var indicator:ActivityIndicator
    
    override init(frame: CGRect) {
        indicator = ActivityIndicator(frame: frame)
        super.init(frame: frame)
        
        autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.addSubview(indicator)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeFromScrollView()
    }
    
    fileprivate func removeFromScrollView() {
        if  self.scrollView != nil {
            removeFromSuperview()
        }
    }
    
    fileprivate func refreshViewSizes(_ view:UIScrollView) {
        switch location {
        case .top:
            self.frame = CGRect(x: view.frame.origin.x, y: -controlHeight, width: view.frame.size.width, height: controlHeight)
            
        case .bottom:
            self.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.contentSize.height + controlHeight)
        }
    }
    
    fileprivate var controlHeight:CGFloat {
        return location == .bottom
            ? Constants.defaultHeight - Constants.margin
            : Constants.defaultHeight + Constants.margin
    }
    
    fileprivate var scrollContentInset = UIEdgeInsets.zero
    
    open func beginRefreshing() {
        if let view = scrollView {
            scrollContentInset = view.contentInset
            
            switch location {
                
            case .top:
                UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    view.contentInset.top = self.controlHeight
                    view.contentOffset.y = -self.controlHeight
                    }, completion: nil)
                
            case .bottom:
                
                UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    view.contentInset.bottom = self.controlHeight
                    }, completion: nil)
            }
            
            indicator.beginAnimation()
        }
    }
    
    open func endRefreshing() {
        if let view = scrollView {
            
            switch location {
                
            case .top:
                let top = scrollContentInset.top
                
                UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    view.contentInset.top = top
                    view.contentOffset.y = 0  // Auto matically scroll to the top after refresh
                    }, completion: nil)
                
            case .bottom:
                
                let bottom = scrollContentInset.bottom
                
                UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    view.contentInset.bottom = bottom
                    }, completion: nil)
            }
            
            indicator.endAnimation()
        }
    }
    
    func scrollViewDidScroll() {
        if let view = scrollView {
            
            refreshViewSizes(view)
            
            var progress = Float(0)
            
            if view.isDragging {
                
                let delta = view.contentOffset.y
                switch location {
                case .top:
                    if delta < 0 {
                        let percent = abs(delta) / Constants.defaultHeight
                        progress = Float(min(1, percent))
                    }
                    
                case .bottom:
                    let offsetY = view.frame.size.height + delta
                    if offsetY > view.contentSize.height {
                        let percent = (offsetY - view.contentSize.height) / Constants.defaultHeight
                        progress = Float(min(1, percent))
                    }
                }
            }
            
            indicator.progress = progress
        }
    }
    
    func scrollViewDidEndDragging(willDecelerate decelerate: Bool) {
        if let view = scrollView {
            if !view.isDragging
                && indicator.progress.isCloseTo(1) {
                sendActions(for: UIControlEvents.valueChanged)
            }
        }
    }
}
