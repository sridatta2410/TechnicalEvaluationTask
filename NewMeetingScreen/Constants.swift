//
//  Constants.swift
//  NewMeetingScreen
//
//  Created by Sridatta Nallamilli on 22/09/21.
//

import Foundation
import UIKit
import GoogleSignIn

let blueColor                   = #colorLiteral(red: 0.04705882353, green: 0.4666666667, blue: 0.9215686275, alpha: 1)
let homeViewBgColor             = #colorLiteral(red: 0.8588235294, green: 0.8784313725, blue: 0.9176470588, alpha: 1)
let meetingsListViewBgColor     = #colorLiteral(red: 0.8549019608, green: 0.8941176471, blue: 0.9411764706, alpha: 1)

// Google client id
let signInConfig = GIDConfiguration.init(clientID: "1052940650711-q7hlemgmv197app8huc4th5kcaskpagr.apps.googleusercontent.com")

// Sets views with rounded corners
func setViewCornerRadiusToCircle(_ allViews: [UIView]) {
    for view in allViews {
        view.layer.cornerRadius = view.frame.size.height / 2.0
    }
}

// Sets custom rounded corners to views
func setViewCustomCornerRadius(_ allViews: [UIView], radius: CGFloat) {
    for view in allViews {
        view.layer.cornerRadius = radius
    }
}

// Sets border color to views
func setBorderForView(_ allViews: [UIView], borderWidth: CGFloat, borderColor: CGColor) {
    for view in allViews {
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
    }
}

// Sets a custom background color to UIview
func setBgColorForView(_ allViews: [UIView], color: UIColor) {
    for view in allViews {
        view.backgroundColor = color
    }
}
