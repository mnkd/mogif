//
//  main.swift
//  mogif
//
//  Created by m-nakada on 5/3/16.
//  Copyright © 2016 m-nakada. All rights reserved.
//

import Foundation

var settings = GeneratorSettings()
settings.parseOptions()

let generator = Generator(settings: settings)
generator.generate()

exit(EXIT_SUCCESS)
