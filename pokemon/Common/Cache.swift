//
//  Cache.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation
//
//final class Cache<Key: Hashable, Value> {
//    private let wrapped = NSCache<WrappedKey, Entry>()
//    private let dateProvider: () -> Date
//    private let entryLifetime: TimeInterval
//    private let keyTracker = KeyTracker()
//    
//    init(dateProvider: @escaping () -> Date = Date.init,
//         entryLifetime: TimeInterval = 12 * 60 * 60) {
//        self.dateProvider = dateProvider
//        self.entryLifetime = entryLifetime
//        wrapped.delegate = keyTracker
//    }
//    
//    func insert(_ value: Value, forKey key: Key) {
//        let date = dateProvider().addingTimeInterval(entryLifetime)
//        let entry = Entry(key: key, value: value, expirationDate: date)
//        wrapped.setObject(entry, forKey: WrappedKey(key))
//        keyTracker.keys.insert(key)
//    }
//    
//    func value(forKey key: Key) -> Value? {
//        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
//            return nil
//        }
//        
//        guard dateProvider() < entry.expirationDate else {
//            removeValue(forKey: key)
//            return nil
//        }
//        return entry.value
//    }
//    
//    func removeValue(forKey key: Key) {
//        wrapped.removeObject(forKey: WrappedKey(key))
//    }
//    
//    func removeAllObjects() {
//        wrapped.removeAllObjects()
//    }
//}
//
//
//private extension Cache {
//    final class WrappedKey: NSObject {
//        let key: Key
//        
//        init(_ key: Key) { self.key = key }
//        
//        override var hash: Int { return key.hashValue }
//        
//        override func isEqual(_ object: Any?) -> Bool {
//            guard let value = object as? WrappedKey else {
//                return false
//            }
//            
//            return value.key == key
//        }
//    }
//    
//    final class Entry {
//        let key: Key
//        let value: Value
//        let expirationDate: Date
//        
//        init(key: Key, value: Value, expirationDate: Date) {
//            self.value = value
//            self.expirationDate = expirationDate
//            self.key = key
//        }
//    }
//    
//    final class KeyTracker: NSObject, NSCacheDelegate {
//        var keys = Set<Key>()
//        
//        func cache(_ cache: NSCache<AnyObject, AnyObject>,
//                   willEvictObject object: Any) {
//            guard let entry = object as? Entry else { return }
//            keys.remove(entry.key)
//        }
//    }
//    
//    func entry(forKey key: Key) -> Entry? {
//        guard let entry = wrapped.object(forKey: WrappedKey(key)) else { return nil }
//        guard dateProvider() < entry.expirationDate else {
//            removeValue(forKey: key)
//            return nil
//        }
//        return entry
//    }
//    
//    func insert(_ entry: Entry) {
//        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
//        keyTracker.keys.insert(entry.key)
//    }
//}
//
//extension Cache: Codable where Key: Codable, Value: Codable {
//    convenience init(from decoder: Decoder) throws {
//        self.init()
//        
//        let container = try decoder.singleValueContainer()
//        let entries = try container.decode([Entry].self)
//        entries.forEach(insert)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(keyTracker.keys.compactMap(entry))
//    }
//}
//
//extension Cache where Key: Codable, Value: Codable {
//    func saveToDisk(
//        withName name: String,
//        using fileManager: FileManager = .default
//    ) throws {
//        let folderURLs = fileManager.urls(
//            for: .cachesDirectory,
//            in: .userDomainMask
//        )
//        
//        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
//        let data = try JSONEncoder().encode(self)
//        try data.write(to: fileURL)
//        print("data successfully written to FileManager")
//    }
//}
//
//extension Cache {
//    subscript(key: Key) -> Value? {
//        get { return value(forKey: key) }
//        set {
//            guard let value = newValue else {
//                removeValue(forKey: key)
//                return
//            }
//            insert(value, forKey: key)
//        }
//    }
//}
//
//extension Cache.Entry: Codable where Key: Codable, Value: Codable {}
//
//
//class PublicCache {
//    static let shared = PublicCache()
//    let myPokemon = Cache<String, [PokemonDetailEntity]>()
//}
//
//enum CacheKey: String {
//    case myPokemon
//    
//    func key() -> String {
//        return self.rawValue
//    }
//    
//    func path() -> URL {
//        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(self.key() + ".cache")
//    }
//    
//    func getData() -> Data? {
//        try? Data(contentsOf: path())
//    }
//}


final class Cache<Key: Hashable & Codable, Value: Codable> {
    private let userDefaults: UserDefaults
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private var keyTracker = KeyTracker()
    private let userDefaultsKey = "Cache"

    init(userDefaults: UserDefaults = .standard,
         dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 12 * 60 * 60) {
        self.userDefaults = userDefaults
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        loadCache()
    }
    
    private func loadCache() {
        if let data = userDefaults.data(forKey: userDefaultsKey),
           let cacheData = try? JSONDecoder().decode(CacheData.self, from: data) {
            keyTracker.keys = cacheData.keys
        }
    }
    
    private func saveCache() {
        let cacheData = CacheData(keys: keyTracker.keys)
        if let data = try? JSONEncoder().encode(cacheData) {
            userDefaults.set(data, forKey: userDefaultsKey)
        }
    }
    
    func insert(_ value: Value, forKey key: Key) {
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
        do {
            let data = try JSONEncoder().encode(entry)
            userDefaults.set(data, forKey: keyToString(key))
            keyTracker.keys.insert(key)
            saveCache()
        } catch {
            print("Failed to encode entry: \(error)")
        }
    }
    
    func value(forKey key: Key) -> Value? {
        guard let data = userDefaults.data(forKey: keyToString(key)),
              let entry = try? JSONDecoder().decode(Entry.self, from: data) else {
            return nil
        }
        
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        return entry.value
    }
    
    func removeValue(forKey key: Key) {
        userDefaults.removeObject(forKey: keyToString(key))
        keyTracker.keys.remove(key)
        saveCache()
    }
    
    func removeAllObjects() {
        keyTracker.keys.forEach { key in
            userDefaults.removeObject(forKey: keyToString(key))
        }
        keyTracker.keys.removeAll()
        saveCache()
    }
    
    private func keyToString(_ key: Key) -> String {
        return "\(key)"
    }
}

private extension Cache {
    struct CacheData: Codable {
        var keys: Set<Key>
    }
    
    final class Entry: Codable {
        let key: Key
        let value: Value
        let expirationDate: Date
        
        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
    
    final class KeyTracker {
        var keys = Set<Key>()
    }
}

extension Cache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

class PublicCache {
    static let shared = PublicCache()
    let myPokemon = Cache<String, [PokemonDetailEntity]>()
}

enum CacheKey: String {
    case myPokemon
    
    func key() -> String {
        return self.rawValue
    }
    
    func getData() -> Data? {
        UserDefaults.standard.data(forKey: self.key())
    }
}
