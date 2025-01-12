////
//	MHealthUtils.swift
//	MHealth
//
//	Created By Navneet on 15/12/24
//
//


import Foundation

class MHealthUtils: NSObject{
    
    class func getDataFromFile(_ fileName : String, extention :String, withBundle bundle:Bundle? = nil) -> Data {
        let fileroot = bundle == nil ? Bundle.main.path(forResource: fileName, ofType: extention) : bundle!.path(forResource: fileName, ofType: extention)
        let content : String = try! String(contentsOfFile: fileroot! , encoding: String.Encoding.utf8)
        return content.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    class func returnModelObjFromLocalJson<T : Codable>(_ fileName: String ,  _ type: T.Type, _ fileExtension: String? = "geojson") -> T?{
        let data = getDataFromFile(fileName, extention: fileExtension!)
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try JSONDecoder().decode(type.self, from: data)
        } catch {
            print(error)
        }
        return nil
    }
    
    class func returnModelObjFromFile<T: Codable>(_ url: URL, type: T.Type) -> T? {
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(type.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
