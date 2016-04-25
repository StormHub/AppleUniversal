
import UIKit

public class RefreshControl : UIControl {
    
    private struct Constants {
        static let defaultHeight = CGFloat(40)
    }
    
    private var scrollView:UIScrollView? {
        return self.superview as? UIScrollView
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
    
    public func beginRefreshing() {
        if let view = scrollView {
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                view.contentInset = UIEdgeInsetsMake(Constants.defaultHeight, 0, 0, 0)
                view.contentOffset = CGPoint(x: 0, y: -Constants.defaultHeight)
            }, completion: nil)
            
            indicator.beginAnimation()
        }
    }
    
    public func endRefreshing() {
        if let view = scrollView {
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                view.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                view.contentOffset = CGPoint(x:0, y:0)
            }, completion: nil)
            
            indicator.endAnimation()
        }
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        if scrollView != nil {
            return
        }
        
        if let view = newSuperview as? UIScrollView {
            self.frame = CGRectMake(0, -Constants.defaultHeight, view.contentSize.width, Constants.defaultHeight)
        }
    }
    
    func scrollViewDidScroll() {
        if let view = scrollView {
            
            var progress = Float(0)
            
            let delta = view.contentOffset.y
            if delta < 0
                && view.dragging {
                let percent = abs(delta) / Constants.defaultHeight
                progress = Float(min(1, percent))
            }
            
            indicator.progress = progress
        }
    }
    
    func scrollViewDidEndDragging(willDecelerate decelerate: Bool) {
        if let view = scrollView {
            if !view.dragging
                && indicator.progress == 1 {
                sendActionsForControlEvents(UIControlEvents.ValueChanged)
            }
        }
    }
}