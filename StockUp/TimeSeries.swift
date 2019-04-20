//
//  TimeSeries.swift
//  WorkOnStocks
//
//  Created by John Ferlic on 4/19/19.
//  Copyright © 2019 John Ferlic. All rights reserved.
//

import Foundation

struct TimeSeriesData {
    let date: Date
    let data: [Float]
}

extension TimeSeriesData : Decodable {
    init(from: Decoder) throws {
        var container = try from.unkeyedContainer()
        self.date = try container.decode(Date.self)
        var floatData: [Float] = []
        while !container.isAtEnd {
            try floatData.append(container.decode(Float.self))
        }
        self.data = floatData
    }
}

enum Order: String, Decodable {  case asc, desc }
enum Frequency: String, Decodable { case  daily, weekly, monthly, quarterly, annual }

struct DatasetData: Decodable {
    let limit: Int?
    let columnIndex: Int?
    let columnNames: [String]
    let startDate: Date
    let endDate: Date
    let frequency: Frequency
    let data: [TimeSeriesData]
    let collapse: Frequency?
    let order: Order?
}

struct TimeSeries: Decodable {
    let datasetData: DatasetData
}
