

import Foundation

/*
 Represent client communication failed responses
*/
public enum CommunicationError : Error {
    
    /*
       Indicates HTTP network connection failed
     */
    case connectionFailure(reason: String)
    
    /*
       Indicates the response is not OK status
     */
    case badResponse(content: String)
    
    /*
       Indicates the response is not the three possible JSON body
    */
    case unknownResponseType(content: String)
}

/*
   Protocol for the client to handle the REST results or errors.
*/
public protocol JsonResponseHandler {
    
    /*
       Called when the JSON data response recieved as dictionary
    */
    func handleDictionaryData(dictionary:Dictionary<String, AnyObject>) -> Void
    
    /*
       Called when the JSON data response recieved as array
    */
    func handleArrayData(array:Array<AnyObject>) -> Void
    
    /*
       Called when the JSON data response recieved as single object
    */
    func handleData(data:AnyObject) -> Void
    
    /*
       Called when error ocurred either due to network failures or bad responses
    */
    func handleError(error: CommunicationError) -> Void
    
}

/*
  Provides client side REST web service client
*/
open class HttpClientProxy {
    
    fileprivate let HttpOkStatusCode = 200
    
    fileprivate struct HttpMethod {
        static let Get = "GET"
        static let Post = "POST"
        static let Put = "PUT"
        static let Delete = "DELETE"
    }
    
    fileprivate let url:String
    
    /*
        Initialize the client proxy, if the url is empty
        the instance will be nil
    */
    public init?(url:String) {
        self.url = url
        
        if url.isEmpty {
            return nil
        }
    }
    
    /*
      Requests the url for HTTP Get method with optional HTTP body data
    */
    open func get(_ responseHandler: JsonResponseHandler, bodyData: Data? = nil) {
        let request = createRequest(HttpMethod.Get, bodyData: bodyData)
        execute(request, responseHandler: responseHandler)
    }
    
    /*
      Requests the url for HTTP POST method with optional HTTP body data
    */
    open func post(_ responseHandler: JsonResponseHandler, bodyData: Data? = nil) {
        let request = createRequest(HttpMethod.Post, bodyData:bodyData)
        execute(request, responseHandler: responseHandler)
    }
    
    /*
    Requests the url for HTTP PUT method with optional HTTP body data
    */
    open func put(_ responseHandler: JsonResponseHandler, bodyData: Data? = nil) {
        let request = createRequest(HttpMethod.Put, bodyData:bodyData)
        execute(request, responseHandler: responseHandler)
    }

    /*
    Requests the url for HTTP PUT method with optional HTTP body data
    */
    open func delete(_ responseHandler: JsonResponseHandler, bodyData: Data? = nil) {
        let request = createRequest(HttpMethod.Delete, bodyData:bodyData)
        execute(request, responseHandler: responseHandler)
    }
    
    /*
       Creates the HTTP request instances.
    */
    fileprivate func createRequest(_ method:String, bodyData: Data? = nil) -> URLRequest {
        let url = URL(string:self.url)
        var request = URLRequest(url: url!)
        request.httpMethod = method
        if let data = bodyData {
            request.httpBody = data
        }
        
        return request;
    }
    
    /*
       Executes the request for share HTTP session
    */
    fileprivate func execute(_ request: URLRequest, responseHandler: JsonResponseHandler) {
        let session =  URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {(data:Data?, response:URLResponse?, error:Error?) -> Void in
            guard error == nil else {
                
                responseHandler.handleError(error: CommunicationError.connectionFailure(reason: error!.localizedDescription))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse ,
                httpResponse.statusCode != self.HttpOkStatusCode else {
                    responseHandler.handleError(error: CommunicationError.badResponse(content: response!.description))
                    return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers)
                
                // JSON dictionary
                if  let dictionary = json as? Dictionary<String,AnyObject> {
                    responseHandler.handleDictionaryData(dictionary: dictionary)
                    return
                }
                
                // JSON array
                if let array = json as? Array<AnyObject> {
                    responseHandler.handleArrayData(array:array)
                    return
                }
                
                // JSON object
                if let objectData = json as? NSObject {
                    responseHandler.handleData(data: objectData)
                     return
                }
                
                // Unknown
                responseHandler.handleError(error: CommunicationError.unknownResponseType(content: data!.description))
            } catch {
                responseHandler.handleError(error: CommunicationError.badResponse(content:data!.description))
            }
        })
        
        task.resume()
    }
}
