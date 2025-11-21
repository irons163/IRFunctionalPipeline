// The Swift Programming Language
// https://docs.swift.org/swift-book


precedencegroup Semigroup {
  associativity: right
  higherThan: AdditionPrecedence
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
  static var e: Self { get }
}

public func joined<M: Monoid>(_ s: M) -> ([M]) -> M {
  return { xs in
    if let head = xs.first {
      return xs.dropFirst().reduce(head) { accum, x in accum <> s <> x }
    }
    return .e
  }
}

extension String: Monoid {
  public static let e = ""

  public static func <>(lhs: String, rhs: String) -> String {
    return lhs + rhs
  }
}
