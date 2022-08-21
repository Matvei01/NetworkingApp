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
        numberOfLessons.text = "Number of lessons: \(course.number_of_lessons ?? 0)"
        numberOfTests.text = "Number of tests: \(course.number_of_tests ?? 0)"
        DispatchQueue.global().async {
            guard let url = URL(string: course.imageUrl ?? "") else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.courseImage.image = UIImage(data: imageData)
            }
        }
    }
}
