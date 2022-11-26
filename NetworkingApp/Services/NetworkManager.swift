//
//  NetworkManager.swift
//  NetworkingApp
//
//  Created by Matvei Khlestov on 22.11.2022.
//

import Foundation
import Alamofire

enum Link: String {
    case imageURL = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    case exampleOne = "https://swiftbook.ru//wp-content/uploads/api/api_course"
    case exampleTwo = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    case exampleThree = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    case exampleFour = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
    case exampleFive = "https://swiftbook.ru//wp-content/uploads/api/api_courses_capital"
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
    case courseImageURL = "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: String?, completion: @escaping(Result<Data,
                                                             NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetch<T: Decodable>(dataType: T.Type,
                             from url: String,
                             convertFromSnakeCase: Bool = true,
                             completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                if convertFromSnakeCase {
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                }
                
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func postRequest(with data: [String: Any],
                     to url: String,
                     complition: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            complition(.failure(.invalidURL))
            return
            
        }
        
        guard let courseData = try? JSONSerialization.data(withJSONObject: data) else {
            complition(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = courseData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                complition(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            print(response)
            
            do {
                let course = try JSONSerialization.jsonObject(with: data)
                complition(.success(course))
            } catch {
                complition(.failure(.decodingError))
            }
        }.resume()
    }
    
    func postRequest(with data: CourseV3,
                     to url: String,
                     complition: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            complition(.failure(.invalidURL))
            return
        }
        
        guard let courseData = try? JSONEncoder().encode(data) else {
            complition(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = courseData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                complition(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            print(response)
            
            do {
                let course = try JSONDecoder().decode(CourseV3.self, from: data)
                complition(.success(course))
            } catch {
                complition(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchDataWithAlamofire(_ url: String, complition: @escaping(Result<[Course],
                                                                     NetworkError>) -> Void){
        AF.request(Link.exampleTwo.rawValue)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let courses = Course.getCourses(fom: value)
                    DispatchQueue.main.async {
                        complition(.success(courses))
                    }
                case .failure:
                    complition(.failure(.decodingError))
                }
            }
    }
    
    func postDataWithAlamofire(url: String,
                               data: CourseV3,
                               complition: @escaping(Result<Course, NetworkError>) -> Void) {
        AF.request(url, method: .post, parameters: data)
            .validate()
            .responseDecodable(of: CourseV3.self) { dataResponse in
                switch dataResponse.result {
                    
                case .success(let coursesV3):
                    let course = Course(
                        name: coursesV3.name,
                        imageUrl: coursesV3.imageUrl,
                        numberOfLessons: Int(coursesV3.numberOfLessons) ?? 0,
                        numberOfTests: Int(coursesV3.numberOfTests) ?? 0
                    )
                    complition(.success(course))
                    
                case .failure:
                    complition(.failure(.decodingError))
                }
            }
    }
}
 
