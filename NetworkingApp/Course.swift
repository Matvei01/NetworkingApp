//
//  Course.swift
//  NetworkingApp
//
//  Created by Matvei Khlestov on 08.07.2022.
//

struct Course: Decodable {
    let name: String?
    let imageUrl: String?
    let number_of_lessons: Int?
    let number_of_tests: Int?
}

struct WebsiteDescription: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName: String?
}
