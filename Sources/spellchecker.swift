
import Foundation
import PerfectCURL

func testFunc() -> String {
    return "HueHue"
}

class SpellCheker {
    
    internal func sendRequest(text: String, completion: @escaping (String?) -> (Void))
    {
        do {
            let body = self.textInBodyFormat(text: text)
            let json = try CURLRequest("https://montanaflynn-spellcheck.p.mashape.com/check?text=" + body, .failOnError,
                                       .httpMethod(CURLRequest.HTTPMethod.get),
                                       .addHeader(.fromStandard(name: "X-Mashape-Key"), "OA5qHL58kvmshkz5xa4FQowNtD3tp1cD0n2jsnPY9TFf28l8Ka"),
                                       .addHeader(.fromStandard(name: "Accept"), "application/json")
                ).perform().bodyJSON
            
            let suggestion = self.suggestionFromJSON(json: json)
            completion(suggestion)
        }
        catch let error as NSError {
            fatalError("\(error)")
        }
    }
    
    private func textInBodyFormat(text: String) -> String
    {
        let result = text.replacingOccurrences(of: " ", with: "+")
        return result
    }
    
    private func suggestionFromJSON(json: [String:Any]) -> String?
    {
//        print("json: \(json)")
        guard let result = json["suggestion"] as? String else {
            return nil
        }
        return result
    }
}

/*
 
 NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
 NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
 
 NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://montanaflynn-spellcheck.p.mashape.com/check/?text=I+want+lae+and+capucin+some+mlk."]];
 NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
 
 [urlRequest addValue:@"OA5qHL58kvmshkz5xa4FQowNtD3tp1cD0n2jsnPY9TFf28l8Ka" forHTTPHeaderField:@"X-Mashape-Key"];
 [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
 
 [urlRequest setHTTPMethod:@"GET"];
 
 NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 // Handle your response here
 NSLog(@"response :%@", response);
 NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"> %@", s);
 }];
 
 // Fire the request
 [dataTask resume];
 
 */
