//
//  ProgressBarConfigurations.swift
//  ProgressBarKit
//
//  Created by Zaim Ramlan on 10/02/2019.
//  Copyright © 2019 Zaim Ramlan. All rights reserved.
//

import Foundation
import UIKit

/// The cases to represent available progress bar configurations.
public enum PBConfigurations {
    /// Represents the Progress Bar's track configurations.
    case track
    
    /// Represents the Progress Bar's bar configurations.
    case bar
}

/// The available progress bar's track configurations.
public struct PBTrackConfiguration {
    
    // MARK: - Properties
    
    /// The corners to be rounded. (optional)
    public var roundingCorners: UIRectCorner = []
    
    /// The value to round each corners. (optional)
    public var cornerRadii: CGSize = .zero
    
    /// The edge insets of the progress bar. (optional)
    public var edgeInsets: UIEdgeInsets = .zero
    
    // MARK: - Initializers
    
    /// Initialize `PBTrackConfiguration` with the given values.
    ///
    /// - Parameters:
    ///   - roundingCorners: The corners to be rounded. (optional)
    ///   - cornerRadii: The value to round each corners. (optional)
    ///   - edgeInsets: The edge insets of the progress bar. (optional)
    public init(roundingCorners: UIRectCorner = [], cornerRadii: CGSize = .zero, edgeInsets: UIEdgeInsets = .zero) {
        self.roundingCorners = roundingCorners
        self.cornerRadii = cornerRadii
        self.edgeInsets = edgeInsets
    }
}

/// The available progress bar's bar configurations.
public struct PBBarConfiguration {
    
    // MARK: - Properties
    
    /// The corners to be rounded. (optional)
    public var roundingCorners: UIRectCorner = []
    
    /// The value to round each corners. (optional)
    public var cornerRadii: CGSize = .zero
    
    // MARK: - Initializers
    
    /// Initialize `PBBarConfiguration` with the given values.
    ///
    /// - Parameters:
    ///   - roundingCorners: The corners to be rounded. (optional)
    ///   - cornerRadii: The value to round each corners. (optional)
    public init(roundingCorners: UIRectCorner = [], cornerRadii: CGSize = .zero) {
        self.roundingCorners = roundingCorners
        self.cornerRadii = cornerRadii
    }
}
