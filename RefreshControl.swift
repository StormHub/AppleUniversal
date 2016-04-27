
import UIKit

public enum IndicatorLocation {
    case top, bottom
}

public class RefreshControl : UIControl {
    
    private struct Constants {
        static let defaultHeight = CGFloat(46)
        static let margin = CGFloat(4)
    }
    
    private var scrollView:UIScrollView? {
        return self.superview as? UIScrollView
    }
    
    public var location: IndicatorLocation = .top {
        didSet {
            if let view = scrollView {
                refreshViewSizes(view)
            }
        }
    }
    
    private var indicator:ActivityIndicator
    
    override init(frame: CGRect) {
        indicator = ActivityIndicator(frame: frame)
        super.init(frame: frame)
        
        autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.addSubview(indicator)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeFromScrollView()
    }
    
    private func removeFromScrollView() {
        if  self.scrollView != nil {
            NSLog("[RefreshControl][removeFromScrollView]")
            removeFromSuperview()
        }
    }
    
    private func refreshViewSizes(view:UIScrollView) {
        switch location {
        case .top:
            self.frame = CGRectMake(view.frame.origin.x, -Constants.defaultHeight, view.frame.size.width, Constants.defaultHeight)
        case .bottom:
            self.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.contentSize.height + Constants.defaultHeight)
        }
    }
    
    private var scrollContentInset = UIEdgeInsetsZero
    
    public func beginRefreshing() {
        if let view = scrollView {
            scrollContentInset = view.contentInset
            
            switch location {
                
            case .top:
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    view.contentInset.top = (Constants.defaultHeight + Constants.margin)
                    view.contentOffset.y = -(Constants.defaultHeight + Constants.margin)
                    }, completion: nil)
                
            case .bottom:
                
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    view.contentInset.bottom = (Constants.defaultHeight + Constants.margin)
                    }, completion: nil)
            }
            
            indicator.beginAnimation()
        }
    }
    
    public func endRefreshing() {
        if let view = scrollView {
            
            switch location {
                
            case .top:
                let top = scrollContentInset.top
                
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    view.contentInset.top = top
                    view.contentOffset.y = 0
                    }, completion: nil)
                
            case .bottom:
                
                let bottom = scrollContentInset.bottom
                
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
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
            
            if view.dragging {
                
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
            if !view.dragging
                && indicator.progress == 1 {
                NSLog("[RefreshControl] UIControlEvents.ValueChanged")
                sendActionsForControlEvents(UIControlEvents.ValueChanged)
            }
        }
    }
}