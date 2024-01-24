//
//  Dependencies.swift
//  Config
//
//  Created by 손대홍 on 1/20/24.
//

import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: .init(
    [
      .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.1")),
      .remote(url: "https://github.com/Swinject/Swinject.git", requirement: .exact("2.8.0"))
    ]
  ),
  platforms: [.iOS]
)
