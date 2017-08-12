//
//  Generator.swift
//  mogif
//
//  Created by m-nakada on 5/4/16.
//  Copyright © 2016 m-nakada. All rights reserved.
//

import Foundation

struct Generator {
  private let settings: GeneratorSettings

  init(settings: GeneratorSettings) {
    self.settings = settings
  }
  
  func generate() {
    var images: [CharacterImage] = []
    settings.string.characters.forEach{ char in
      if let image = CharacterImage(character: char) {
        images.append(image)
      } else {
        print("[Error] Could not create character image: \(char)")
      }
    }
    
    if images.isEmpty {
      print("[Error] No character image.")
      exit(EXIT_FAILURE)
    }
    
    let gif = GIFGenerator(images: images, loopCount: settings.loopCount, frameDelay: settings.frameDelay, url: settings.outputURL! as URL)
    gif.generate()
  }
}
