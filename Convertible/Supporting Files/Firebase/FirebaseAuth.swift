//
//  FirebaseAuth.swift
//  Convertible
//
//  Created by Zain Najam Khan on 20/05/2025.
//

import Foundation
import FirebaseAuth

func signInAnonymouslyIfNeeded() {
    if Auth.auth().currentUser == nil {
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print("Auth failed:", error.localizedDescription)
            } else {
                print("Signed in:", result?.user.uid ?? "")
            }
        }
    }
}
