//
//  NetworkViewController.swift
//  test
//
//  Created by Muhammad Hunble Dhillon on 11/20/18.
//  Copyright © 2018 Arrivy. All rights reserved.
//

import UIKit
import Alamofire

class NetworkViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var configration = URLSessionConfiguration.default
        //configration.httpCookieStorage = customHTTPCookiesStorage()
        
        let session = URLSession.init(configuration: configration)
        

        
//        if let url = URL.init(string: "https://google.com"){
//            session.dataTask(with: url) { sip,sap,su in
//                    print(sip,sap,su)
//
//                var x = session.configuration.httpCookieStorage?.cookies
//
//            }.resume()
//        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func error(_ sender: Any) {
        
        var url = server+"/api/company/profile"
        
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
        url = server+"/api/entities"
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
        url = server+"/api/templates"
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
        url = server+"/api/company/profile"
        
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
        url = server+"/api/entities"
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
        url = server+"/api/templates"
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
        url = server+"/api/company/profile"
        
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
        url = server+"/api/entities"
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
        url = server+"/api/templates"
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
    }
    
    @IBAction func success(_ sender: Any) {
        
        let url = server+"/api/app_version_check"
        
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
    }
    
    @IBAction func logout(_ sender: Any) {
        
        let url = server+"/api/users/logout"
        
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Logout Error: ",response.error as Any)
            print("Lougout Data: ",response.result)
        })
        
    }
    
    @IBAction func getEntities(_ sender: Any) {
        
        let url = server+"/api/entities"
        session?.request(url).validate().responseJSON(completionHandler: {
            response in
            print("Error: ",response.error as Any)
            print("Data: ",response.result)
        })
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        let urlString = "\(server)/api/users/login"
        
        let parameters: HTTPHeaders = [
            "email": "hunbledhillon@gmail.com",
            "password": "lahore2010",
            ]
        print("Loggin in...")
        
        

        
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON(completionHandler: {
            response in
            
            OAuth2Handler.storeCookies()
            
            var x =
                Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies
            print("Login Error: ",response.error as Any)
            print("Login Data: ",response.result)
        })
    }

    
//    class func storeCookies() {
//        let cookiesStorage = HTTPCookieStorage.shared
//        let userDefaults = UserDefaults.standard
//        
//        let serverBaseUrl = kAPIDomain
//        var cookieDict = [String : AnyObject]()
//        
//        //        for cookie in cookiesStorage.cookies(for: NSURL(string: serverBaseUrl)! as URL)! {
//        for cookie in cookiesStorage.cookies ?? [] {
//            if cookie.domain == cookiesDomain {
//                cookieDict[cookie.name] = cookie.properties as AnyObject
//            }
//        }
//        userDefaults.set(cookieDict, forKey: cookiesKey)
//    }
//    
//    
//    func restoreCookies() {
//        let cookiesStorage = HTTPCookieStorage.shared
//        let userDefaults = UserDefaults.standard
//        if let cookieDictionary = userDefaults.dictionary(forKey: cookiesKey) {
//            for (cookieName, cookieProperties) in cookieDictionary {
//                if let prop = cookieProperties as? [HTTPCookiePropertyKey : Any] {
//                    if let cookie = HTTPCookie(properties: prop ) {
//                        cookiesStorage.setCookie(cookie)
//                    }
//                }
//            }
//        }
//    }
    
}
