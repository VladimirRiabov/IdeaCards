//
//  FileStorage.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 07.12.2021.
//

import Foundation
import FirebaseStorage
import UIKit

//this way we get access to our firebase storage.
let storage = Storage.storage()



class FileStorage {
    //берем image и вставляем в directory(папка в firebase)
    //And we are going to receive a callback, which is going to be the link of the image we just uploaded.
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ docomentLink: String?) -> Void) {
        //ссылка на нашу папку.kFILEREFERENCE это ссылка файербейс основной каталог storage. и создаем там дочернюю папу .child(directory)
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        //формат изображения
        let imageData = image.jpegData(compressionQuality: 0.4)
        //we want to create a task which is going to do our uploading.
        var task: StorageUploadTask!
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metaData, error) in
            
            task.removeAllObservers()
            
            if error != nil {
                print("error uploading image", error!.localizedDescription)
            }
            //теперь если ошибок небыло то я хочу после загрузки изображений в файрбейс получить обратно ссылки на них с помощью метода firebase .dowloadUrl по ссылке storageRef
            storageRef.downloadURL { (url, error) in
                //проверяем что url не нил
                guard let downloadUrl = url else {
                    //тогда если там нил запускоем complition который наверху в таск
                    completion(nil)
                    return
                }
                print("we have uploadedimage to ", downloadUrl.absoluteString )
                completion(downloadUrl.absoluteString)
                //  Now we're going to by default when you upload something to Firebase E and you create a task, this task like keeping keeps listening for any changes to these upload like you have finished upload, you have terminated upload, et cetera.
                //So as soon as the cold back here is called, we want to stop listening for any changes
                //completion: { (metaData, error) in
                //because our upload has finished. It may finish with error or it may finish successfully. But we want to stop listening for any more changes.task.removeAllObservers()
            }
        })
   
    }
    //мы хотим скачать каритинку с firebase но предварительно мы проверяем есть ли она локально, и если да то берем локальную версию
    class func downloadImage(imageURL: String, completion: @escaping (_ image: UIImage?) -> Void) {
        //помогает нам обратить внимание по каким символам можно разбить эту ссылку
        print("urls is ", imageURL)
        //делит строку путем поиска в ней элемента пока мы не получим имя файла
        let imageFileName = ((imageURL.components(separatedBy: "_").last!).components(separatedBy: "?").first!).components(separatedBy: ".").first!
        //прооверка файла на наличии его локально
        if fileExistsAtPath(path: imageFileName) {
            print("we have local file")
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentDirectory(filename: imageFileName)) {
                completion(contentsOfFile)
            } else {
                
                completion(UIImage(named: "avatar"))
            }
        } else {
            //download
            print("we dont have a local file")
            if imageURL != "" {
                let documentURL = URL(string: imageURL)
                let downloadQueue = DispatchQueue(label: "downloadQueue")
                downloadQueue.async {
                    //это создает данные  из всего что могло бы лежать по этому url
                    let data = NSData(contentsOf: documentURL!)
                    if data != nil {
                            //и говорим что из этих данных я хочу получить именно картинку
                            let imageToReturn = UIImage(data: data! as! Data)
                            completion(imageToReturn)
                        //и сохраняем файл локально
                        FileStorage.saveImageLocally(imageData: data!, fileName: imageFileName)
                    } else {
                        print("no image in local database")
                        completion(nil)
                    }
                }
            } else {
                completion(UIImage(named: "avatar"))
            }
        }
       
        
    }
    
    class func saveImageLocally(imageData: NSData, fileName: String) {
        var docURL = getDocumentsURL()
        //false - its nof a folder, it will be a file
        docURL = docURL.appendingPathComponent(fileName, isDirectory: false)
        //And what does it mean is let's say you have a file with the same name already in a local file directory. So it's going to rewrite that file. And if it was successful, it will get rid of the old one.
        imageData.write(to: docURL, atomically: true)
    }
    
}

//So let's create a function that is going to return access to our sandbox, our file, our manager.
func getDocumentsURL() -> URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    return documentsURL!
}
//So why we need this is when we went to save a file locally. We need to have like the full length, the full path to the file that we want to save.
func fileInDocumentDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL.path
}
//функция проверяет есть ли на локальном носителе файл с именем
func fileExistsAtPath(path: String) -> Bool {
//    var doesExist = false
    //    let filePath = fileInDocumentDirectory(filename: path)
    //    if FileManager.default.fileExists(atPath: filePath) {
    //        doesExist = true
    //    } else {
    //        doesExist = false
    //    }
    //    return doesExist
    
    //краткая форма того что сверху
    return FileManager.default.fileExists(atPath: fileInDocumentDirectory(filename: path))
}


