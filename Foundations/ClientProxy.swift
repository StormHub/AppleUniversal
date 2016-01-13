

import Foundation

/*
 Represent client communication failed responses
*/
public enum CommunicationError : ErrorType {
    
    /*
       Indicates HTTP network connection failed
     */
    case ConnectionFailure(reason: String)
    
    /*
       Indicates the response is not OK status
     */
    case BadResponse(content: String)
    
    /*
       Indicates the response is not the three possible JSON body
    */
    case UnknownResponseType
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
public class HttpClientProxy {
    
    private let HttpOkStatusCode = 200
    private let HttpGetMethodName = "GET"
    private let HttpPostMethodName = "POST"
    private let httpPutMethodName = "PUT"
    private let httpDeleteMethodName = "DELETE"
    
    private let url:String
    
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
    public func get(responseHandler: JsonResponseHandler, bodyData: NSData? = nil) {
        let request = createRequest(HttpGetMethodName, bodyData: bodyData)
        execute(request, responseHandler: responseHandler)
    }
    
    /*
      Requests the url for HTTP POST method with optional HTTP body data
    */
    public func post(responseHandler: JsonResponseHandler, bodyData: NSData? = nil) {
        let request = createRequest(HttpPostMethodName, bodyData:bodyData)
        execute(request, responseHandler: responseHandler)
    }
    
    /*
    Requests the url for HTTP PUT method with optional HTTP body data
    */
    public func put(responseHandler: JsonResponseHandler, bodyData: NSData? = nil) {
        let request = createRequest(httpPutMethodName, bodyData:bodyData)
        execute(request, responseHandler: responseHandler)
    }

    /*
    Requests the url for HTTP PUT method with optional HTTP body data
    */
    public func delete(responseHandler: JsonResponseHandler, bodyData: NSData? = nil) {
        let request = createRequest(httpDeleteMethodName, bodyData:bodyData)
        execute(request, responseHandler: responseHandler)
    }
    
    /*
       Creates the HTTP request instances.
    */
    private func createRequest(method:String, bodyData: NSData? = nil) -> NSMutableURLRequest {
        let nsUrl = NSURL(string: self.url)
        let request = NSMutableURLRequest(URL: nsUrl!)
        
        if let data = bodyData {
            request.HTTPBody = data
        }
        
        request.HTTPMethod = method
        
        return request;
    }
    
    /*
       Executes the request for share HTTP session
    */
    private func execute(request: NSMutableURLRequest, responseHandler: JsonResponseHandler) {
        let session =  NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            guard error == nil else {
                responseHandler.handleError(CommunicationError.ConnectionFailure(reason: error!.description))
                return
            }
            
            guard let httpResponse = response as? NSHTTPURLResponse where
                httpResponse.statusCode != self.HttpOkStatusCode else {
                    responseHandler.handleError(CommunicationError.BadResponse(content: response!.description))
                    return
            }
            if data == nil {
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                
                // JSON dictionary
                if  let dictionary = json as? Dictionary<String,AnyObject> {
                    responseHandler.handleDictionaryData(dictionary)
                    return
                }
                
                // JSON array
                if let array = json as? Array<AnyObject> {
                    responseHandler.handleArrayData(array)
                    return
                }
                
                // JSON object
                if let objectData = json as? NSObject {
                    responseHandler.handleData(objectData)
                     return
                }
                
                // Unknown
                responseHandler.handleError(CommunicationError.UnknownResponseType)
            } catch {
                responseHandler.handleError(CommunicationError.BadResponse(content:data!.description))
            }
        })
        
        task.resume()
    }
}