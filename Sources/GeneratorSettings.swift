//
//  GeneratorSettings.swift
//  mogif
//
//  Created by m-nakada on 5/5/16.
//  Copyright © 2016 m-nakada. All rights reserved.
//

import Foundation
import CommandLineKit

struct GeneratorSettings {
  var frameDelay: Double = 1
  var loopCount: Int = 0
  var outputURL: URL?
  var string: String = ""

  private let charOption = CommandLineKit.StringOption(shortFlag: "c", longFlag: "characters", required: true, helpMessage: "Characters for creating GIF image.")
  private let pathOption = CommandLineKit.StringOption(shortFlag: "o", longFlag: "output", required: false, helpMessage: "Path to the output file.")
  private let frameDelayOption = CommandLineKit.StringOption(shortFlag: "f", longFlag: "frameDelay", required: false, helpMessage: "Frame Delay. 1 means 1 second, 0.5 means half a second. (Default: 1.0)")
  private let loopCountOption = CommandLineKit.StringOption(shortFlag: "l", longFlag: "loopCount", required: false, helpMessage: "Loop Count. 0 means loop forever. (Default: 0)")
  private let helpOption = CommandLineKit.BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Prints a help message.")

  mutating func parseOptions() {
    let cli = CommandLineKit.CommandLine()
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
        let path = (value as NSString).expandingTildeInPath
        self.outputURL = URL(fileURLWithPath: path)
      } else {
        let cwd = FileManager.default.currentDirectoryPath
        let urlString = cwd + "/" + string + ".gif"
        self.outputURL = URL(fileURLWithPath: urlString)
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
