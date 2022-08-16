//
//  file.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 25.06.2022.
//

import Foundation

class file{

    
    func of_read(_ as_filename:String) -> String{
    
         let ls_file = URL(string: as_filename)
       
        if ls_file!.startAccessingSecurityScopedResource() {
            guard let data = try? Data(contentsOf: ls_file!) else {
            return ""
           }
            return String(decoding: data, as: UTF8.self)
            
        }
        ls_file?.stopAccessingSecurityScopedResource()
        return ""
    }
    
    
    
    
    func of_write(filename as_filename: String,content:String) {

        let documentsPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)[0] as NSString?
        let path = documentsPath!.appendingPathComponent(as_filename)
         
        let folder = URL(string: path)?.deletingLastPathComponent()
        
        
        do{
        try FileManager.default.createDirectory(atPath: folder!.absoluteString, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("ERROR : creating folder \(path) : \(error.localizedDescription)")
        }
         
        
        do {
            try content.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("ERROR : writing to file \(path) : \(error.localizedDescription)")
        }

    }

    
    func of_write2(filename as_filename: String,content:String) {

        
        do {
            try content.write(toFile: as_filename, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("ERROR : writing to file \(as_filename) : \(error.localizedDescription)")
        }

    }
    
    
}




/*
class file {
    
    // MARK: Properties
    
    let queue: DispatchQueue = .global()
    let fileManager: FileManager = .default
    //lazy var baseURL: URL = {
    //    try! fileManager
    //        .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    //        .appendingPathComponent("My Code Generator")
    //}()
    
    
    // MARK: Private functions
    
    private func of_readBase(from path: String) throws -> String {
        var url:URL = URL(string: path)!
        //url = baseURL.appendingPathComponent(path)
        if (path.contains("file://") == false){
            //url = baseURL.appendingPathComponent(path)
        }
        
        
        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDir) && !isDir.boolValue else {
            throw ReadWriteError.doesNotExist
        }
        
        let string: String
        do {
            string = try String(contentsOf: url)
        } catch {
            throw ReadWriteError.readFailed(error)
        }
        
        return string
    }
    
    private func of_writeBase(_ string: String, to path: String) throws {
        //let url = baseURL.appendingPathComponent(path)
        var url:URL = URL(string: path)!
        let folderURL = url.deletingLastPathComponent()
        
        
        var isFolderDir: ObjCBool = false
        if fileManager.fileExists(atPath: folderURL.path, isDirectory: &isFolderDir) {
            if !isFolderDir.boolValue {
                throw ReadWriteError.canNotCreateFolder
            }
        } else {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                throw ReadWriteError.canNotCreateFolder
            }
        }
        
        var isDir: ObjCBool = false
        guard !fileManager.fileExists(atPath: url.path, isDirectory: &isDir) || !isDir.boolValue else {
            throw ReadWriteError.canNotCreateFile
        }
        
        guard let data = string.data(using: .utf8) else {
            throw ReadWriteError.encodingFailed
        }
        
        do {
            try data.write(to: url)
        } catch {
            throw ReadWriteError.writeFailed(error)
        }
    }
    
}


extension file {
    func of_read(from path: String) throws -> String {
        try queue.sync { try self.of_readBase(from: path) }
    }
    
    func of_readAsync(from path: String, completion: @escaping (Result<String, Error>) -> Void) {
        queue.async {
            do {
                let result = try self.of_read(from: path)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func of_write(_ string: String, to path: String) throws {
        try queue.sync { try self.of_writeBase(string, to: path) }
    }
    
    func of_writeAsync(_ string: String, to path: String, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async {
            do {
                try self.of_writeBase(string, to: path)
                completion(.success(Void()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}


enum ReadWriteError: LocalizedError {
    case doesNotExist
    case readFailed(Error)
    case canNotCreateFolder
    case canNotCreateFile
    case encodingFailed
    case writeFailed(Error)
}

*/
