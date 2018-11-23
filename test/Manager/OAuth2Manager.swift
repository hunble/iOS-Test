//
//  OAuth2Manager.swift
//  network
//
//  Created by Muhammad Hunble Dhillon on 11/14/18.
//  Copyright © 2018 Arrivy. All rights reserved.
//
import Alamofire
    class OAuth2Handler: RequestAdapter, RequestRetrier {
        private typealias RefreshCompletion = (_ succeeded: Bool) -> Void
        
        private let sessionManager: SessionManager = {
            
            print("session manager called")
            
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            //configuration.httpCookieStorage = customHTTPCookiesStorage()
            
            return SessionManager(configuration: configuration)
        }()
        
        private let lock = NSLock()
        
//        private var clientID: String
        private var baseURLString: String
//        private var accessToken: String
//        private var refreshToken: String
        
        private var isRefreshing = false
        private var requestsToRetry: [RequestRetryCompletion] = []
        
        // MARK: - Initialization
        
        public init(baseURLString: String) {
//            self.clientID = clientID
            self.baseURLString = baseURLString
//            self.accessToken = accessToken
//            self.refreshToken = refreshToken
        }
        
        // MARK: - RequestAdapter
        
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            
            print("adapt called for ", urlRequest.url?.absoluteString as? [String:Any])
            
            urlRequest.value(forHTTPHeaderField: "<#T##String#>")
            
            print("cookies1:",session?.session.configuration.httpCookieStorage?.cookies)
            
            
            print("cookies: ",Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies)
            
            
            restoreCookies()
            
            if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
                var urlRequest = urlRequest
                urlRequest.setValue("Bearer " + "accessToken", forHTTPHeaderField: "Authorization")
                print(urlRequest.allHTTPHeaderFields)
                return urlRequest
            }
            
            return urlRequest
        }
        
        // MARK: - RequestRetrier
        
        func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
            lock.lock() ; defer { lock.unlock() }
            
            if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
                requestsToRetry.append(completion)
                print("call Failed: ", response.url)
                
                if !isRefreshing {
                    refreshTokens2 { [weak self] succeeded in
                        guard let strongSelf = self else { return }
                        
                        strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                        
//                        if let accessToken = accessToken, let refreshToken = refreshToken {
//                            strongSelf.accessToken = accessToken
//                            strongSelf.refreshToken = refreshToken
//                        }
                        print("requestsToRetry:",strongSelf.requestsToRetry)
                        strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }

                        strongSelf.requestsToRetry.removeAll()
                    }
                }
            } else {
                completion(false, 0.0)
            }
        }
        
        // MARK: - Private - Refresh Tokens
        
        private func refreshTokens(completion: @escaping RefreshCompletion) {
            guard !isRefreshing else { return }
            
            isRefreshing = true
            
            let urlString = "\(baseURLString)/api/users/login"
            
//            let parameters: [String: Any] = [
//                "access_token": accessToken,
//                "refresh_token": refreshToken,
//                "client_id": clientID,
//                "grant_type": "refresh_token"
//            ]
            
//            let parameters: [String: Any] = [
//                "email": "hunbledhillon@gmail.com",
//                "password": "lahore2010",
//            ]
            
            let parameters: HTTPHeaders = [
                "email": "hunbledhillon@gmail.com",
                "password": "lahore2010",
            ]
            print("Loggin in...")
            
            sessionManager.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON(completionHandler: {
                [weak self] response in
                
                print("Logged in!")
                print(response.result)
                guard let strongSelf = self else { return }
                switch response.result{
                case .failure(let error):
                    completion(false)
                case .success(let responce):
                    completion(true)

                }
                strongSelf.isRefreshing = false
            })
            
        }
        
        // MARK: - Private - Refresh Tokens
        
        private func refreshTokens2(completion: @escaping RefreshCompletion) {
            guard !isRefreshing else { return }
            
            isRefreshing = true
            
            let urlString = "\(baseURLString)/api/company/profile"
            

            print("Getting Profile...............................")
            
            sessionManager.request(urlString).responseJSON(completionHandler: {
                [weak self] response in
                
                print("Got Profile...............................!")
                print(response.result)
                guard let strongSelf = self else { return }
                switch response.result{
                case .failure(let error):
                    completion(false)
                case .success(let responce):
                    completion(true)
                    
                }
                strongSelf.isRefreshing = false
            })
            
        }
        
        
        func restoreCookies() {
            let cookiesStorage = HTTPCookieStorage.shared
            let userDefaults = UserDefaults.standard
            if let cookieDictionary = userDefaults.dictionary(forKey: server) {
                for (cookieName, cookieProperties) in cookieDictionary {
                    if let prop = cookieProperties as? [HTTPCookiePropertyKey : Any] {
                        if let cookie = HTTPCookie(properties: prop ) {
                            cookiesStorage.setCookie(cookie)
                        }
                    }
                }
            }
        }
        
        class func storeCookies() {
            let cookiesStorage = HTTPCookieStorage.shared
            let userDefaults = UserDefaults.standard
            
            var cookieDict = [String : AnyObject]()
            
            //        for cookie in cookiesStorage.cookies(for: NSURL(string: serverBaseUrl)! as URL)! {
            for cookie in cookiesStorage.cookies ?? [] {
                if cookie.domain == server.replacingOccurrences(of: "https://", with: "") {
                    cookieDict[cookie.name] = cookie.properties as AnyObject
                }
            }
            userDefaults.set(cookieDict, forKey: server)
        }
        
    }



//    class customHTTPCookiesStorage: HTTPCookieStorage{
//
//
//        override func storeCookies(_ cookies: [HTTPCookie], for task: URLSessionTask) {
//
//
//            if let response = task.response as? HTTPURLResponse
//            {
//                print(response.statusCode)
//            }
//
//
//            super.storeCookies(cookies, for: task)
//            for cookies in cookies{
//                session?.session.configuration.httpCookieStorage?.setCookie(cookies)
//            }
//
//            print("This where cookies are stored")
//        }
//
//    }
