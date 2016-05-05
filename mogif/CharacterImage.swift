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
  enum Error: ErrorType {
    case CreateFont
    case CreateBitmapImageRep
  }
  
  private let character: Character
  private let fontName = "HiraMinProN-W3"
  private let size: CGSize
  private var bitmap: NSBitmapImageRep?
  
  private var imageData: NSData? {
    return bitmap?.representationUsingType(.NSGIFFileType, properties: [:])
  }
  
  var cgImage: CGImage? {
    return bitmap?.CGImage
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
      throw Error.CreateFont
    }

    let textRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
    let textStyle = NSMutableParagraphStyle()
    textStyle.alignment = .Center
    let textAttributes = [NSFontAttributeName: font,
                          NSForegroundColorAttributeName: NSColor.blackColor(),
                          NSParagraphStyleAttributeName: textStyle]

    // Prepare bitmap
    guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil,
                                        pixelsWide: Int(size.width),
                                        pixelsHigh: Int(size.height),
                                        bitsPerSample: 8,
                                        samplesPerPixel: 4,
                                        hasAlpha: true,
                                        isPlanar: false,
                                        colorSpaceName: NSDeviceRGBColorSpace,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0) else {
      print("[Error] Could not create BitmapImageRep: \(fontName)")
      throw Error.CreateBitmapImageRep
    }
    bitmap.size = size

    // Drawing
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.setCurrentContext(NSGraphicsContext(bitmapImageRep: bitmap))
    String(character).drawInRect(textRect, withAttributes: textAttributes)
    NSGraphicsContext.restoreGraphicsState()

    self.bitmap = bitmap
  }
  
  func debugSaveImage() {
    let cwd = NSFileManager.defaultManager().currentDirectoryPath
    let path = "\(cwd)/\(character).gif"
    do {
      try imageData?.writeToFile(path, options: .AtomicWrite)
    } catch {
      print("[Error] Saving file at path: \(path) with error: \(error)")
      exit(EXIT_FAILURE)
    }
  }
}
