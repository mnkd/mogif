//
//  CharacterImage.swift
//  MojiGIF
//
//  Created by m-nakada on 5/3/16.
//  Copyright © 2016 m-nakada. All rights reserved.
//

import AppKit
import CoreGraphics

struct CharacterImage {
  enum CreationError: Error {
    case createFont, createBitmapImageRep
  }
  
  private let character: Character
  private let fontName = "HiraMinProN-W3"
  private let size: CGSize
  private var bitmap: NSBitmapImageRep?
  
  private var imageData: Data? {
    return bitmap?.representation(using: .gif , properties: [:])
  }
  
  var cgImage: CGImage? {
    return bitmap?.cgImage
  }
  
  init?(character char: Character, size: NSSize = NSSize(width: 128, height: 128)) {
    self.size = size
    character = char
    
    do {
      try generate()
    } catch {
      return nil
    }
  }
  
  private mutating func generate() throws {
    let fontSize = CGFloat(floor(size.width * 0.9))
    guard let font = NSFont(name: fontName, size: fontSize) else {
      print("[Error] Could not create NSFont: \(fontName)")
      throw CreationError.createFont
    }

    let textRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
    let textStyle = NSMutableParagraphStyle()
    textStyle.alignment = .center
    let textAttributes = [NSAttributedStringKey.font: font,
                          NSAttributedStringKey.foregroundColor: NSColor.black,
                          NSAttributedStringKey.paragraphStyle: textStyle]

    // Prepare bitmap
    guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil,
                                        pixelsWide: Int(size.width),
                                        pixelsHigh: Int(size.height),
                                        bitsPerSample: 8,
                                        samplesPerPixel: 4,
                                        hasAlpha: true,
                                        isPlanar: false,
                                        colorSpaceName: NSColorSpaceName.deviceRGB,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0) else {
      print("[Error] Could not create BitmapImageRep: \(fontName)")
      throw CreationError.createBitmapImageRep
    }
    bitmap.size = size

    // Drawing
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    String(character).draw(in: textRect, withAttributes: textAttributes)
    NSGraphicsContext.restoreGraphicsState()

    self.bitmap = bitmap
  }
  
  func debugSaveImage() {
    let cwd = FileManager.default.currentDirectoryPath
    let url = URL(fileURLWithPath: "\(cwd)/\(character).gif")
    do {
      try imageData?.write(to: url)
    } catch {
      print("[Error] Saving file at path: \(url.absoluteString) with error: \(error)")
      exit(EXIT_FAILURE)
    }
  }
}
