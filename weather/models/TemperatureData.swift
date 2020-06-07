//
//  TemperatureData.swift
//  weather
//
//  Created by Damian Warzecha on 07/06/2020.
//  Copyright © 2020 Damian Warzecha. All rights reserved.
//

import Foundation

struct TemperatureData  : Codable{
    let day: Float
    let min: Float
    let max: Float
    let night: Float
    let eve: Float
    let morn: Float
}
