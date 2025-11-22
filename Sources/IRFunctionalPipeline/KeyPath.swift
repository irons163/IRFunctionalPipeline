//
//  KeyPath.swift
//  IRFunctionalPipeline
//
//  Created by Phil on 2025/11/22.
//

public func get<Root, Value>(
    _ keyPath: KeyPath<Root, Value>
) -> (Root) -> Value {
    return { root in
        root[keyPath: keyPath]
    }
}

public func over<Root, Value>(
    _ keyPath: WritableKeyPath<Root, Value>
) -> (@escaping (Value) -> Value) -> (Root) -> Root {

    return { over in
        { root in
            var copy = root
            copy[keyPath: keyPath] = over(copy[keyPath: keyPath])
            return copy
        }
    }
}

public func set<Root, Value>(
    _ keyPath: WritableKeyPath<Root, Value>
) -> (Value) -> (Root) -> Root {
    return over(keyPath) <<< const
}

public func <<< <A, B, C>(_ b2c: @escaping (B) -> C, _ a2b: @escaping (A) -> B) -> (A) -> C {
    return { a in b2c(a2b(a)) }
}

infix operator <<<: FunctionComposition

precedencegroup FunctionComposition {
    associativity: right
}
