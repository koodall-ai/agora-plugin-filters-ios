//
//  KoodallEffectsManager.swift
//  KoodallAgoraFilters
//
//  Created by Koodall on 31.08.21.
//

import Foundation

class KoodallEffectsManager {
  /// Returns url to folder with Koodall effects
  static var effectsURL: URL {
    let effectsURL = Bundle.main.bundleURL.appendingPathComponent("effects/", isDirectory: true)
    return effectsURL
  }
}
