//
//  FileStorage.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 07.12.2021.
//

import Foundation
import FirebaseStorage

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
            }
        })
   
    }
}

//  Now we're going to by default when you upload something to Firebase E and you create a task, this task like keeping keeps listening for any changes to these upload like you have finished upload, you have terminated upload, et cetera.
//So as soon as the cold back here is called, we want to stop listening for any changes
//completion: { (metaData, error) in
//because our upload has finished. It may finish with error or it may finish successfully. But we want to stop listening for any more changes.task.removeAllObservers()
