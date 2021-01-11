//
//  ButtonInputAccessoryView.swift
//  TinkoffASDKUI
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

protocol ViewSizeDependenceUITraitCollectionSize {
	
	func updateViewSize(for size: UITraitCollection)

}


protocol InputAccessoryViewWithButton: ViewSizeDependenceUITraitCollectionSize where Self: UIView {
	
	var onButtonTouchUpInside: (() -> Void)? { get set }
	
	var buttonAction: UIButton! { get }
	
}


class ButtonInputAccessoryView: UIView, InputAccessoryViewWithButton {
	
	@IBOutlet weak var buttonAction: UIButton!
	
	@IBOutlet private weak var buttonActionTop: NSLayoutConstraint!
	@IBOutlet private weak var buttonActionBottom: NSLayoutConstraint!
	
	var onButtonTouchUpInside: (() -> Void)?
	
	override func awakeFromNib() {
		super.awakeFromNib()

		buttonAction.setTitle(AcqLoc.instance.localize("TinkoffAcquiring.button.payByCard"), for: .normal)
		buttonAction.layer.cornerRadius = 16.0
		buttonAction.tintColor = UIColor.init(hex: "#333333")
		buttonAction.backgroundColor = UIColor.init(hex: "#FFDD2D")
	}
	
	@IBAction private func onButtonTouchUpInside(_ sender: UIButton) {
		onButtonTouchUpInside?()
	}
	
}


extension ButtonInputAccessoryView: ViewSizeDependenceUITraitCollectionSize {
	
	override var intrinsicContentSize: CGSize {
		return .zero
	}
	
	// MARK: UITraitCollectionSizeDependence
	
	func updateViewSize(for size: UITraitCollection) {
		switch size.verticalSizeClass {
			case .compact:
				buttonActionTop.constant = 4
				buttonActionBottom.constant = 4
				buttonAction.contentEdgeInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: 7, right: 0)
				frame = CGRect.init(origin: frame.origin, size: CGSize.init(width: frame.width, height: 45))
	
			default:
				frame = CGRect.init(origin: frame.origin, size: CGSize.init(width: frame.width, height: 88))
				buttonActionTop.constant = 16
				buttonActionBottom.constant = 16
				buttonAction.contentEdgeInsets = UIEdgeInsets.init(top: 18, left: 0, bottom: 17, right: 0)
		}
		
		sizeToFit()
	}
	
}
