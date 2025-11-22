// The Swift Programming Language
// https://docs.swift.org/swift-book


precedencegroup Semigroup {
    associativity: right
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

precedencegroup HashRocket {
    associativity: left
    higherThan: Semigroup
}

infix operator =>: HashRocket

infix operator |>: FunctionApplicationFlipped

public func |> <A, B> (a: A, f: (A) -> B) -> B {
    return f(a)
}

precedencegroup FunctionApplication {
    associativity: left
    higherThan: Semigroup
}

precedencegroup FunctionApplicationFlipped {
    associativity: left
    higherThan: FunctionApplication
}

infix operator <>: Semigroup

// MARK: Semigroup

public protocol Semigroup {
    static func <>(_: Self, _: Self) -> Self
}

// MARK: Monoid

public protocol Monoid: Semigroup {
    static var identity: Self { get }
}

public func joined<M: Monoid>(_ separator: M) -> ([M]) -> M {
    return { ms in
        guard let head = ms.first else {
            return .identity
        }
        return ms.dropFirst().reduce(head) { accum, m in
            accum <> separator <> m
        }
    }
}

extension String: Monoid {
    public static let identity = ""

    public static func <>(lhs: String, rhs: String) -> String {
        return lhs + rhs
    }
}

public func id<A>(_ a: A) -> A {
    return a
}

public func catOptionals<S: Sequence, A>(_ xs: S) -> [A] where S.Element == A? {
    return xs |> mapOptional(id)
}

public func mapOptional<S: Sequence, A>(_ f: @escaping (S.Element) -> A?) -> (S) -> [A] {
    return { xs in
        xs.compactMap(f)
    }
}
