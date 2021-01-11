//
//  PullUpPresentationController.swift
//  TestUINavigation
//
//  Copyright (c) 2020 Tinkoff Bank
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

class PullUpPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

	private let topCornerRadius: CGFloat = 12.0
	private var dimmingView: UIView?
	private var presentationWrappingView: UIView?
	
	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

		presentedViewController.modalPresentationStyle = .custom
	}

	override var presentedView: UIView? {
		return self.presentationWrappingView
	}

	override func presentationTransitionWillBegin() {
		let presentedViewControllerView = super.presentedView!

		do {
			//1
			let presentationWrapperView = UIView(frame: self.frameOfPresentedViewInContainerView)
			presentationWrapperView.layer.shadowOpacity = 0.44
			presentationWrapperView.layer.shadowRadius = 13.0
			presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6.0)
			self.presentationWrappingView = presentationWrapperView
			//2
			let presentationRoundedCornerView = UIView(frame: presentationWrapperView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -topCornerRadius, right: 0)))
			presentationRoundedCornerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			presentationRoundedCornerView.layer.cornerRadius = topCornerRadius
			presentationRoundedCornerView.layer.masksToBounds = true
			//3
			let presentedViewControllerWrapperView = UIView(frame: presentationRoundedCornerView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: topCornerRadius, right: 0)))
			presentedViewControllerWrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			presentedViewControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds
			
			presentedViewControllerWrapperView.addSubview(presentedViewControllerView)
			presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
			presentationWrapperView.addSubview(presentationRoundedCornerView)
		}

		do {
			let dimmingView = UIView(frame: self.containerView?.bounds ?? CGRect())
			dimmingView.backgroundColor = UIColor.black
			dimmingView.isOpaque = false
			dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dimmingViewTapped(_:))))
			self.dimmingView = dimmingView
			self.containerView?.addSubview(dimmingView)

			let transitionCoordinator = self.presentingViewController.transitionCoordinator

			self.dimmingView?.alpha = 0.0
			transitionCoordinator?.animate(alongsideTransition: {_ in
				self.dimmingView?.alpha = 0.5
			}, completion: nil)
		}
	}

	override func presentationTransitionDidEnd(_ completed: Bool) {
		if !completed {
			self.presentationWrappingView = nil
			self.dimmingView = nil
		}
	}

	override func dismissalTransitionWillBegin() {
		let transitionCoordinator = self.presentingViewController.transitionCoordinator

		transitionCoordinator?.animate(alongsideTransition: {_ in
			self.dimmingView?.alpha = 0.0
		}, completion: nil)
	}

	override func dismissalTransitionDidEnd(_ completed: Bool) {
		if completed {
			self.presentationWrappingView = nil
			self.dimmingView = nil
		}
	}

	// MARK: Layout

	override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
		super.preferredContentSizeDidChange(forChildContentContainer: container)

		if container === self.presentedViewController {
			self.containerView?.setNeedsLayout()
		}
	}

	override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
		if container === self.presentedViewController {
			return (container as! UIViewController).preferredContentSize
		} else {
			return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
		}
	}

	override var frameOfPresentedViewInContainerView: CGRect {
		let containerViewBounds = self.containerView?.bounds ?? CGRect()
		let presentedViewContentSize = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerViewBounds.size)

		var presentedViewControllerFrame = containerViewBounds
		presentedViewControllerFrame.size.height = presentedViewContentSize.height
		presentedViewControllerFrame.origin.y = containerViewBounds.maxY - presentedViewContentSize.height
		return presentedViewControllerFrame
	}

	override func containerViewWillLayoutSubviews() {
		super.containerViewWillLayoutSubviews()

		self.dimmingView?.frame = self.containerView?.bounds ?? CGRect()
		self.presentationWrappingView?.frame = self.frameOfPresentedViewInContainerView
	}

	// MARK: Tap Gesture Recognizer

	@IBAction func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
		self.presentingViewController.dismiss(animated: true, completion: nil)
	}

	// MARK: UIViewControllerAnimatedTransitioning

	@objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return transitionContext?.isAnimated ?? false ? 0.35 : 0
	}

	@objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
		let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

		let containerView = transitionContext.containerView
		let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
		let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
		let isPresenting = (fromViewController === self.presentingViewController)

		_ = transitionContext.initialFrame(for: fromViewController)

		var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
		var toViewInitialFrame = transitionContext.initialFrame(for: toViewController)
		let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)

		if toView != nil { containerView.addSubview(toView!) }

		if isPresenting {
			toViewInitialFrame.origin = CGPoint(x: containerView.bounds.minX, y: containerView.bounds.maxY)
			toViewInitialFrame.size = toViewFinalFrame.size
			toView?.frame = toViewInitialFrame
		} else {
			fromViewFinalFrame = (fromView?.frame ?? CGRect()).offsetBy(dx: 0, dy: (fromView?.frame ?? CGRect()).height)
		}

		let transitionDuration = self.transitionDuration(using: transitionContext)

		UIView.animate(withDuration: transitionDuration, animations: {
			if isPresenting {
				toView?.frame = toViewFinalFrame
			} else {
				fromView?.frame = fromViewFinalFrame
			}
		}, completion: {_ in
			let wasCancelled = transitionContext.transitionWasCancelled
			transitionContext.completeTransition(!wasCancelled)
		})
	}

	// MARK: UIViewControllerTransitioningDelegate

	@objc func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		assert(self.presentedViewController === presented, "You didn't initialize \(self) with the correct presentedViewController. Expected \(presented), got \(self.presentedViewController).")

		return self
	}

	@objc func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}

	@objc func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}


}
