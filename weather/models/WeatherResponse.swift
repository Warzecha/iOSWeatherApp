//
//  WeatherResponse.swift
//  weather
//
//  Created by Damian Warzecha on 07/06/2020.
//  Copyright © 2020 Damian Warzecha. All rights reserved.
//

import Foundation

struct WeatherResponse : Codable{
    let daily: Array<DailyWeather>
    
}
