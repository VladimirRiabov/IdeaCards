//
//  FCollectionReference.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 04.12.2021.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
