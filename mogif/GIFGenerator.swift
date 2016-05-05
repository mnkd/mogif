//
//  GIFGenerator.swift
//  MojiGIF
//
//  Created by m-nakada on 5/3/16.
//  Copyright © 2016 m-nakada. All rights reserved.
//

import Foundation

struct GIFGenerator {
  private let images: [CharacterImage]
  private let frameDelay: Double
  private let loopCount: Int  // 0 means loop forever
  private let url: NSURL
  
  private let GIFDictKey      = kCGImagePropertyGIFDictionary as String
  private let GIFLoopCountKey = kCGImagePropertyGIFLoopCount as String
  private let GIFDelayTimeKey = kCGImagePropertyGIFDelayTime as String
  
  init(images: [CharacterImage], loopCount: Int, frameDelay: Double, url: NSURL) {
    self.images = images
    self.loopCount = loopCount
    self.frameDelay = frameDelay
    self.url = url
  }

  func generate() {
    guard let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) else {
      print("[Error] CGImageDestinationCreateWithURL() url: \(url)")
      exit(EXIT_FAILURE)
    }
    
    // Set Loop Count
    let loopCountProperty = [GIFDictKey: [GIFLoopCountKey: loopCount]]
    CGImageDestinationSetProperties(destination, loopCountProperty)
    
    // Set Images
    for (index, element) in images.enumerate() {
      let delay = (index == images.endIndex - 1) ? frameDelay * 1 : frameDelay
      let frameProperty = [GIFDictKey: [GIFDelayTimeKey: delay]]
      if let cgImage = element.cgImage {
        CGImageDestinationAddImage(destination, cgImage, frameProperty)
      }
    }
    
    // Finalize
    if CGImageDestinationFinalize(destination) {
      let path: String = {
        if let path = url.path {
          return path
        }
        return url.absoluteString
      }()
      
      print("\(path)")
    } else {
      print("Fail!")
      exit(EXIT_FAILURE)
    }
  }
  
}
