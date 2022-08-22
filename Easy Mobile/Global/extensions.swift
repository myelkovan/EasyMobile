//
//  extensions.swift
//  HeyGarson
//
//  Created by Murat Yelkovan on 15.03.2022.
//  Copyright © 2022 Yelkovan. All rights reserved.
//

import Foundation




//GLOBAL FUNCTİONLAR
extension String {
     
    func of_pos(_ find: String, starting ai_starting:Int = 0) -> Int {
        if self.count == 0{
            return 0
        }
        
        var ls_self = self
        if (ai_starting > 0){
            ls_self = self.of_right(starting: ai_starting)!
        }
        
        if let range: Range<String.Index> = ls_self.range(of: find) {
            return ls_self.distance(from: ls_self.startIndex, to: range.lowerBound) + ai_starting + 1
        }
        return 0
     }

    func of_left( _ ai_pos: Int ) -> String?{
        if self.count == 0{
            return self
        }
        let index = self.index(self.startIndex, offsetBy: ai_pos)
        return String(self[..<index])
    }

    func of_right(starting ai_pos: Int ) -> String?{
        if self.count == 0{
            return self
        }
        let index = self.index(self.startIndex, offsetBy: ai_pos)
        return String(self.suffix(from: index))
    }
    
    func of_right(lenght ai_pos: Int ) -> String?{
        if self.count == 0{
            return self
        }
        let index = self.index(self.startIndex, offsetBy: self.count - ai_pos)
        return String(self.suffix(from: index))
    }

    
    func of_left( _ as_find: String, starting ai_starting: Int = 0, lastpos ab_lastpos: Bool = false) -> String?{
        if self.count == 0{
            return self
        }
       
        var ls_self = self
        if (ai_starting > 0){
            ls_self = self.of_right(starting: ai_starting)!
        }

        var range: Range<String.Index>?
        if (ab_lastpos == true){
            range = ls_self.range(of: as_find,options: NSString.CompareOptions.backwards)
        }else{
            range = ls_self.range(of: as_find)
        }
  
        if let range = range  {
            let li_pos: Int = ls_self.distance(from: ls_self.startIndex, to: range.lowerBound)
            let index = ls_self.index(ls_self.startIndex, offsetBy: li_pos)
            return String(ls_self[..<index])
        }
        else {
            return self
        }
    }
            


    func of_right( _ as_find: String,lastpos ab_lastpos: Bool = false) -> String?{
        if self.count == 0{
            return self
        }
        var range: Range<String.Index>!
        if (ab_lastpos == true){
            range = self.range(of: as_find,options: NSString.CompareOptions.backwards)
        }else{
            range  = self.range(of: as_find)
        }
    
        if let range = range {
            let li_pos: Int = self.distance(from: self.startIndex, to: range.upperBound)
            let index = self.index(self.startIndex, offsetBy: li_pos)
            return String(self.suffix(from: index))
        }
        else {
            return self
        }
    }
            

    


    
    func left(find ac_find : Character ) -> String{
        let index = self.firstIndex(of: ac_find) ?? self.endIndex
        return String(self[..<index])
    }

    func right(find ac_find : Character ) -> String{
        let li_pos = self.lastIndexOfCharacter(ac_find)
        if li_pos == nil{
            return self
        }else
        {
            let index = self.index(self.startIndex, offsetBy: li_pos! + 1)
            return String(self.suffix(from: index))
        }
         
    }
   
    mutating func of_replace(starting ai_starting:Int, to ai_to: Int, as_text :String) {
        let start = index(startIndex, offsetBy: ai_starting - 1)
        let end = index(startIndex, offsetBy: ai_to)
             
        self.replaceSubrange(start...end, with: as_text)
    }
    

    func of_mid(location: Int, length: Int) -> String? {
        if self.count == 0{
            return self
        }
        
        let start = index(startIndex, offsetBy: location - 1)
        let end = index(startIndex, offsetBy: location + length - 1)
        return substring(with: start..<end)
    }
 
    func of_mid(first: String, last: String) -> String? {
        if self.count == 0{
            return self
        }
        let location = self.of_pos(first)
        let length = (self.of_pos(last) - location) + last.count

        let start = index(startIndex, offsetBy: location - 1)
        let end = index(startIndex, offsetBy: location + length - 1)
        print(substring(with: start..<end))
        return substring(with: start..<end)
    }
    
    
    func of_trim() -> String?{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func of_removeNewLines()-> String{
        return self.replacingOccurrences(of: "\n", with: " ").self.replacingOccurrences(of: "\r", with: " ")
    }

    func of_getdate(format:String )->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateValue = dateFormatter.date(from: self)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: dateValue!)
     }

    
    func lastIndexOfCharacter(_ c: Character) -> Int? {
         guard let index = range(of: String(c), options: .backwards)?.lowerBound else
         { return nil }
         return distance(from: startIndex, to: index)
     }

     func firstIndex(of: String, at: String.Index) -> String.Index? {
         return self[at...].range(of: of)?.lowerBound
     }
 
}
    
