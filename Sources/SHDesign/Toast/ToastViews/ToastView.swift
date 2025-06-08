//
//  ToastAppearance.swift
//  Toast
//
//  Created by Sahib Hussain on 29/06/2021.
//

import Foundation
import UIKit

public protocol ToastView : UIView {
    func createView(for toast: Toast)
}
