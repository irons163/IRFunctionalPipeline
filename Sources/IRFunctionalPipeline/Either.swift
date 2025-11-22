//
//  Either.swift
//  IRFunctionalPipeline
//
//  Created by Phil on 2025/11/22.
//

public enum Either<L, R> {
    case left(L)
    case right(R)
}

extension Either {
    public func either<A>(_ f: (L) -> A, _ g: (R) -> A) -> A {
        switch self {
        case let .left(l):
            return f(l)
        case let .right(r):
            return g(r)
        }
    }

    public var left: L? {
        return either(Optional.some, const(.none))
    }

    public var right: R? {
        return either(const(.none), Optional.some)
    }

    public var isLeft: Bool {
        return either(const(true), const(false))
    }

    public var isRight: Bool {
        return either(const(false), const(true))
    }
}

// MARK: - Functor (map)

extension Either {
    // Method form: Either<L, R>.map((R) -> B) -> Either<L, B>
    public func map<B>(_ f: (R) -> B) -> Either<L, B> {
        return either(Either<L, B>.left, { .right(f($0)) })
    }
}

// Free-function form to compose with |> like: either |> map(f)
public func map<L, R, B>(_ f: @escaping (R) -> B) -> (Either<L, R>) -> Either<L, B> {
    return { e in
        e.map(f)
    }
}

// MARK: - Semigroup for Either (fail-fast on Left, combine Rights)

extension Either: Semigroup where R: Semigroup {
    public static func <>(lhs: Either<L, R>, rhs: Either<L, R>) -> Either<L, R> {
        switch (lhs, rhs) {
        case let (.right(a), .right(b)):
            return .right(a <> b)
        case let (.left(l), _):
            return .left(l)
        case (_, let .left(r)):
            return .left(r)
        }
    }
}
