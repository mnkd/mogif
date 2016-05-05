//
//  GeneratorSettings.swift
//  mogif
//
//  Created by m-nakada on 5/5/16.
//  Copyright © 2016 m-nakada. All rights reserved.
//

import Foundation

struct GeneratorSettings {
  var frameDelay: Double = 1
  var loopCount: Int = 0
  var outputURL: NSURL?
  var string: String = ""
  
  private let charOption       = StringOption(shortFlag: "c", longFlag: "characters", required: true,  helpMessage: "Characters for creating GIF image.")
  private let pathOption       = StringOption(shortFlag: "o", longFlag: "output",     required: false, helpMessage: "Path to the output file.")
  private let frameDelayOption = StringOption(shortFlag: "f", longFlag: "frameDelay", required: false, helpMessage: "Frame Delay. 1 means 1 second, 0.5 means half a second. (Default: 1.0)")
  private let loopCountOption  = StringOption(shortFlag: "l", longFlag: "loopCount",  required: false, helpMessage: "Loop Count. 0 means loop forever. (Default: 0)")
  private let helpOption       = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Prints a help message.")
  
  mutating func parseOptions() {
    let cli = CommandLine()
    cli.addOptions(charOption, pathOption, frameDelayOption, loopCountOption, helpOption)
    
    do {
      try cli.parse()
      
      if helpOption.value {
        cli.printUsage()
        exit(EX_USAGE)
      }
      
      guard let string = charOption.value else {
        cli.printUsage()
        exit(EX_USAGE)
      }
      self.string = string
      
      // Prepare outputURL
      if let value = pathOption.value {
        let path = (value as NSString).stringByExpandingTildeInPath
        let url = NSURL(fileURLWithPath: path)
        self.outputURL = url
      } else {
        let cwd = NSFileManager.defaultManager().currentDirectoryPath
        let urlString = cwd + "/" + string + ".gif"
        self.outputURL = NSURL(fileURLWithPath: urlString)
      }
      
      // Prepare frameDelay
      if let value = frameDelayOption.value {
        if let frameDelay = Double(value) {
          self.frameDelay = frameDelay
        }
      }
      
      // Prepare loopCount
      if let value = loopCountOption.value {
        if let loopCount = Int(value) {
          self.loopCount = loopCount
        }
      }
      
    } catch {
      cli.printUsage(error)
      exit(EX_USAGE)
    }
  }
  
}
