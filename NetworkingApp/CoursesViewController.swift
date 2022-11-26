//
//  CoursesViewController.swift
//  NetworkingApp
//
//  Created by Matvei Khlestov on 07.07.2022.
//

import UIKit
import Alamofire

class CoursesViewController: UITableViewController {
    
    private var courses: [Course] = []
    private var coursesV2: [CourseV2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        courses.isEmpty ? coursesV2.count : courses.count
        
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! CourseCell
        
        if courses.isEmpty {
            let courseV2 = coursesV2[indexPath.row]
            cell.configure(with: courseV2)
        } else {
            let course = courses[indexPath.row]
            cell.configure(with: course)
        }
        
        return cell
    }
}

// MARK: - Networking
extension CoursesViewController {
    func fetchCourses() {
        NetworkManager.shared.fetch(dataType: [Course].self,
                                    from: Link.exampleTwo.rawValue) { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCoursesV2() {
        NetworkManager.shared.fetch(dataType: [CourseV2].self,
                                    from: Link.exampleFive.rawValue,
                                    convertFromSnakeCase: false) { result in
            switch result {
            case .success(let courses):
                self.coursesV2 = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alamofireGetButtonPressed() {
        NetworkManager.shared.fetchDataWithAlamofire(Link.exampleTwo.rawValue) { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alamofirePostButtonPressed() {
        let course = CourseV3(
            name: "Networking",
            imageUrl: Link.courseImageURL.rawValue,
            numberOfLessons: "10",
            numberOfTests: "5"
            )
        NetworkManager.shared.postDataWithAlamofire(url: Link.postRequest.rawValue,
                                                    data: course) { result in
            switch result {
            case .success(let course):
                self.courses.append(course)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
    
    

