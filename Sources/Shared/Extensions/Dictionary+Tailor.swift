import Sugar

public extension Dictionary {

  func propertyOrThrow<T>(name: String) throws -> T {
    guard let key = name as? Key,
      value = self[key] as? T
      else { throw MappableError.TypeError(message: "Tried to get value for \(name) as \(T.self)") }

    return value
  }

  func property<T : Hashable>(name: String) -> T? {
    guard let key = name as? Key,
      value = self[key]
      else { return nil }

    return value as? T
  }

  func transform<T, U>(name: String, transformer: ((value: U?) -> T?)) -> T? {
    guard let value = self[name as! Key] else { return nil }
    return transformer(value: value as? U)
  }

  func property<T : Mappable>(name: String) -> T? {
    guard let value = self[name as! Key],
      dictionary = value as? JSONDictionary
      else { return nil }

    return T(dictionary)
  }

  func properties<T : Mappable>(name: String) -> [T]? {
    guard let key = name as? Key, value = self[key],
      array = value as? JSONArray
      else { return nil }

    return array.map { T($0) }
  }
}
