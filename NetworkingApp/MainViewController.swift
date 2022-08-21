//
//  MainViewController.swift
//  NetworkingApp
//
//  Created by Matvei Khlestov on 07.07.2022.
//

import UIKit

enum Link: String {
    case imageURL = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    case exampleOne = "https://zoo-animal-api.herokuapp.com"
    case exampleTwo = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    case exampleThree = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    case exampleFour = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
}

enum UserAction: String, CaseIterable {
    case downloadImage = "Download Image"
    case exampleOne = "Example One"
    case exampleTwo = "Example Two"
    case exampleThree = "Example Three"
    case exampleFour = "Example Four"
    case ourCourses = "Our Courses"
}

class MainViewController: UICollectionViewController {

    let userActions = UserAction.allCases
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        userActions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
    
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .downloadImage:
            performSegue(withIdentifier: "showImage", sender: nil)
        case .exampleOne:
            exampleOneButtonPressed()
        case .exampleTwo:
            exampleTwoButtonPressed()
        case .exampleThree:
            exampleThreeButtonPressed()
        case .exampleFour:
            exampleFourButtonPressed()
        case .ourCourses:
            performSegue(withIdentifier: "showCourses", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCourses" {
            guard let coursesVC = segue.destination as? CoursesViewController else { return }
            coursesVC.fetchCourses()
        }
    }
    
    // MARK: - Private Methods
    private func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Success",
                message: "You can see the results in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "You can see error in the Debug aria",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Networking
extension MainViewController {
    private func exampleOneButtonPressed() {
        guard let url = URL(string: Link.exampleOne.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let course = try JSONDecoder().decode(Course.self, from: data)
                print(course)
                self.successAlert()
            } catch let error {
                print(error.localizedDescription)
                self.failedAlert()
            }
        }.resume()
    }
    
    private func exampleTwoButtonPressed() {
        guard let url = URL(string: Link.exampleTwo.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                print(courses)
                self.successAlert()
            } catch let error {
                print(error.localizedDescription)
                self.failedAlert()
            }
        }.resume()
    }
    
    private func exampleThreeButtonPressed() {
        guard let url = URL(string: Link.exampleThree.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                print(websiteDescription)
                self.successAlert()
            } catch let error {
                print(error.localizedDescription)
                self.failedAlert()
            }
        }.resume()
    }
    
    private func exampleFourButtonPressed() {
        guard let url = URL(string: Link.exampleFour.rawValue) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                print(websiteDescription)
                self.successAlert()
            } catch let error {
                print(error.localizedDescription)
                self.failedAlert()
            }
        }.resume()
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

