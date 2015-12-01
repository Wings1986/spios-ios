//
//  Created by Dicky Tsang on 26/6/14.
//  Copyright (c) 2014 Dicky Tsang. All rights reserved.
//

import UIKit


extension UIImageView {
    func loadImage(url: NSURL, autoCache: Bool) {
        var urlId = url.hash
        
        var fileHandler = FileController()
        var cacheDir = "Documents/cache/images/\(urlId)"
        var existFileData = fileHandler.readFile(cacheDir)
        
        if existFileData == nil {
            NSURLSession.sharedSession().dataTaskWithURL(url) {
                (data: NSData!, response: NSURLResponse!, error: NSError!) in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            image = UIImage(data: existFileData!)
        }
    }

    private class FileController {
        func writeFile(fileDir: String, fileContent: NSData) -> Bool {
            var filePath = NSHomeDirectory().stringByAppendingPathComponent(fileDir)

            return fileContent.writeToFile(filePath, atomically: true)
        }
        
        func readFile(fileDir: String) -> NSData? {
            var filePath = NSHomeDirectory().stringByAppendingPathComponent(fileDir)
            if let fileHandler = NSFileHandle(forReadingAtPath: filePath) {
              var fileData = fileHandler.readDataToEndOfFile()
              fileHandler.closeFile()
              return fileData
            } else {
              return nil
            }
        }
        
        func mkdir(fileDir: String) -> Bool {
            var filePath = NSHomeDirectory().stringByAppendingPathComponent(fileDir)
            return NSFileManager.defaultManager().createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
    }
}

