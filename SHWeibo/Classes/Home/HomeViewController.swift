//
//  HomeViewController.swift
//  SHWeibo
//
//  Created by LustXcc on 21/12/2016.
//  Copyright © 2016 LustXcc. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    var isPresented : Bool = false
    // MARK:- 懒加载属性
    fileprivate lazy var titleBtn : TitleButton = TitleButton()

    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.addAnimation()
        
        // 没有登录时设置的内容
        if  !isLogin {
            return
        }
        
        // 设置导航栏
        setupNaviBar()
    }
}

// MARK:- 设置UI界面
extension HomeViewController{

    fileprivate func setupNaviBar() {
    
        // 设置左边的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        // 设置右边的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // 设置titleView
        titleBtn.setTitle("LustXcc", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    
    }
    
}

// MARK:- 事件监听
extension HomeViewController{

    @objc fileprivate func titleBtnClick(titleBtn: TitleButton){
        
        // 改变按钮状态
        titleBtn.isSelected = !titleBtn.isSelected
        
        // 设置顶部弹出控制器
        let Popvc = PopoverViewController()
        Popvc.modalPresentationStyle = .custom
        Popvc.transitioningDelegate = self
        present(Popvc, animated: true, completion: nil)
        
    }

}

// MARK:- 顶部导航栏自定义动画
extension HomeViewController : UIViewControllerTransitioningDelegate{
    
    // 改变弹出view的大小
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopoverPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // 自定义弹出view的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    // 自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        titleBtn.isSelected = !titleBtn.isSelected
        return self
    }
}

extension HomeViewController : UIViewControllerAnimatedTransitioning{
    
    
    // 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        isPresented ? animationForPresentedView(using: transitionContext) : animationForDismissView(using: transitionContext)
    }
    
    
    /// 自定义弹出动画
    fileprivate func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning){
        
        // 获取弹出的View
        let presenetdView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // 将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presenetdView!)
        
        // 执行动画
        presenetdView?.transform = CGAffineTransform(scaleX: 1.0, y: 0)
        presenetdView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presenetdView?.transform = CGAffineTransform.identity
        }) { (_) in
            transitionContext.completeTransition(true)
            
        }
    }
    
    /// 自定义消失动画
    fileprivate func animationForDismissView(using transitionContext: UIViewControllerContextTransitioning){
        
        
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
        }) { (_) in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
