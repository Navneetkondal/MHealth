//
//    DBUtils.swift
//    PlumFoundation
//
//    Created By Navneet on 15/12/21
//
//


import Foundation

enum DirInsideContainer: String{
    case MHealth = "MHealth"
    case Login = "Login"
}

enum FileName: String{
    case MHealthProfile = "MHealthProfile"
    case MHealthActivity = "MHealthActivity"
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

class DBUtils: NSObject{
    // MARK: - Container URL i.e. Cache Directory
    public class func getCacheDirectoryPath() -> URL {
        return MFileManager.getDirectoryPath(for:  .cachesDirectory)
    }
    
    // MARK: - Path
    
    class func getFileURLInsideMainContainer(_ fileName: FileName) -> URL? {
        if MFileManager.createDirectory(pathURL: DBUtils.mainAppContainerURL()){
            return mainAppContainerURL().appendingPathComponent(fileName.rawValue).appendingPathExtension("db")
        }
        return nil
    }
    
    //  App Data Folder Folder
     class func mainAppContainerURL() -> URL {
        return getCacheDirectoryPath().appendingPathComponent(Bundle.main.displayName ?? "App" + "_Data")
    }
    
     class func fileURLInsideContainer(withName name: String) throws -> URL {
        return getCacheDirectoryPath().appendingPathComponent(name).appendingPathExtension("db")
    }
    
    // Get File URL inside specific directory
     class func getFileURLInsideDir(_ dir: DirInsideContainer, withName name: String) -> URL{
        return newDirInsideContainerURL(dir).appendingPathComponent(name).appendingPathExtension("db")
    }
    
    // Store Folder URL
     class func newDirInsideContainerURL(_ dir : DirInsideContainer) -> URL{
        mainAppContainerURL().appendingPathComponent(dir.rawValue)
    }
    
    // MARK: - Remove Files on Logout
     class func removeFilesOnLogOut(){
    }
}

extension DBUtils{
    @discardableResult
    class func saveUserProfile(_ data: MHealthUser) -> (user: MHealthUser?, isSaved: Bool) {
        var savedUsers = getUserProfile()
        savedUsers.append(data)
        if let url = getFileURLInsideMainContainer(.MHealthProfile){
            plumEncoder(savedUsers, pathTo: url)
            return (data, true)
        }else{
            print("Failed To Write in File")
        }
        return(nil, false)
    }
    
    @discardableResult
    class func updateUserProfile(_ data: MHealthUser) -> (user: MHealthUser?, isSaved: Bool) {
        var savedUsers = getUserProfile()
        if let index = savedUsers.firstIndex(where: { $0.id == $0.id}){
            savedUsers[index] = data
        }
        if let url = getFileURLInsideMainContainer(.MHealthProfile){
            plumEncoder(savedUsers, pathTo: url)
            return (data, true)
        }else{
            print("Failed To Write in File")
        }
        return(nil, false)
    }
    
    class func getUserProfile() -> [MHealthUser]{
        if let url = getFileURLInsideMainContainer(.MHealthProfile){
            print(url)
            return returnModelObjFromDB(url: url ,  type: [MHealthUser].self) ?? []
        }else{
            print("Failed To Write in File")
            return []
        }
    }
}

extension DBUtils{
    class func saveHealthActivity(_ user: String, _ data: [ActivityTypeEnum : HealthActivity]) {
        Task(priority: .background) {
            if let url = getFileURLInsideMainContainer(.MHealthActivity){
                let data: [String: [HealthActivity]] = [user :  data.map({ $0.value})]
                plumEncoder(data, pathTo: url)
            }else{
                print("Failed To Read file \(getFileURLInsideMainContainer(.MHealthActivity)?.lastPathComponent ?? "")")
            }
        }
    }
    
    class func getHealthActivity(_ user: String) -> [ActivityTypeEnum : HealthActivity]?{
        if let url = getFileURLInsideMainContainer(.MHealthActivity){
            guard let dict = returnModelObjFromDB(url: url ,  type: [String : [HealthActivity]].self) else{
                return nil
            }
            return dict[user]?.toDictionary(with: { $0.typeId}) ?? [:]

        }else{
            print("Failed To Read file \(getFileURLInsideMainContainer(.MHealthActivity)?.lastPathComponent ?? "")")
            return nil
        }
    }
}


// MARK: -  Write Data in File DB
extension DBUtils{
    //# COMMENT: - Data Encoder
    @discardableResult
    class func plumEncoder<T : Codable>(_ data: T, pathTo: URL) -> Bool{
        MFileManager.writeFileWithEncoder(data, pathTo: pathTo)
    }
    
    //# COMMENT: - Write Dictionary in DB
    class func writeDictInFileDB(withFileUrl url: URL,dictData: [String: Any]){
        MFileManager.writeDictInFile(with: url, dictData: dictData)
    }
    
    //# COMMENT: - Write data in DB
    class func writeDictInFileDB(with url: URL, dictData: Any){
        MFileManager.writeDictInFile(with: url, dictData: dictData)
    }
}

// MARK: - Read and Convert  DB Json Data into Model Object
extension DBUtils{
    class func returnModelObjFromDB<T : Codable>(url: URL? = nil, _ dirName: DirInsideContainer = .MHealth, fileName: String = "", type: T.Type) -> T?{
        if let url {
            return MFileManager.returnModelObjFromFile(url, type: type)
        }else{
            return MFileManager.returnModelObjFromFile(getFileURLInsideDir(dirName, withName: fileName), type: type)
        }
    }
}

