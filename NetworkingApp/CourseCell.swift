//
//  CourseCell.swift
//  NetworkingApp
//
//  Created by Matvei Khlestov on 20.07.2022.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var courseImage: UIImageView!
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var numberOfLessons: UILabel!
    @IBOutlet weak var numberOfTests: UILabel!
    
    func configure(with course: Course) {
        courseNameLabel.text = course.name
        numberOfLessons.text = "Number of lessons: \(course.numberOfLessons ?? 0)"
        numberOfTests.text = "Number of tests: \(course.numberOfTests ?? 0)"
        NetworkManager.shared.fetchImage(from: course.imageUrl) { result in
            switch result {
            case .success(let imageData):
                self.courseImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configure(with course: CourseV2) {
        courseNameLabel.text = course.name
        numberOfLessons.text = "Number of lessons: \(course.numberOfLessons ?? 0)"
        numberOfTests.text = "Number of tests: \(course.numberOfTests ?? 0)"
        NetworkManager.shared.fetchImage(from: course.imageUrl) { result in
            switch result {
            case .success(let imageData):
                self.courseImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
