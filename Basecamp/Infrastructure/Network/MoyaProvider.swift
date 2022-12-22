//
//  MoyaProvider.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/22.
//

import Foundation
import Moya

let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
