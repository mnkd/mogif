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
  }
  
  private let character: Character
  private let fontName = "HiraMinProN-W3"
  private let nsImage: NSImage
  private let size: CGSize
  
  private var imageRep: NSBitmapImageRep? {
    guard let imageData = nsImage.TIFFRepresentation else {
      print("[Error] No TIFFRepresentation: \(character)")
      exit(EXIT_FAILURE)
    }
    return NSBitmapImageRep(data:imageData)
  }
  
  private var imageData: NSData? {
    return imageRep?.representationUsingType(.NSGIFFileType, properties: [:])
  }
  
  var cgImage: CGImage? {
    return imageRep?.CGImage
  }
  
  init?(character char: Character, size: CGSize = CGSize(width: 128, height: 128)) {
    self.size = size
    nsImage   = NSImage(size: size)
    character = char
    
    do {
      try generate()
    } catch {
      return nil
    }
  }
  
  private func generate() throws {
    let textRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
    let textStyle = NSMutableParagraphStyle()
    textStyle.alignment = .Center
    
    let fontSize = CGFloat(floor(size.width * 0.9))
    guard let font = NSFont(name: fontName, size: fontSize) else {
      print("[Error] Could not create NSFont: \(fontName)")
      throw Error.CreateFont
    }
    
    let textFontAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: NSColor.blackColor(), NSParagraphStyleAttributeName: textStyle]
    
    // Drawing
    nsImage.lockFocus()
    String(character).drawInRect(textRect, withAttributes: textFontAttributes)
    nsImage.unlockFocus()
  }
  
  func debugSaveImage() {
    let path = NSHomeDirectory() + "/Desktop/\(character).gif"
    do {
      try imageData?.writeToFile(path, options: .AtomicWrite)
    } catch {
      print("[Error] Saving file at path: \(path) with error: \(error)")
      exit(EXIT_FAILURE)
    }
  }
}
