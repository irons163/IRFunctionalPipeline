import Testing
@testable import IRFunctionalPipeline

@Test func testJoined() {
    #expect("" == ([] |> joined(" ")))
    #expect("hello" == (["hello"] |> joined(" ")))
    #expect("hello world" == (["hello", "world"] |> joined(" ")))
}

struct SequenceTests {

    @Test func testCatOptionals() {
        #expect([1, 2, 3] == ([1, nil, 2, nil, 3] |> catOptionals))
    }

    @Test func testMapOptional() {
        #expect([2] == ([1, 2, 3] |> mapOptional { $0 % 2 == 0 ? $0 : nil }))
    }
}

struct EitherTests {
    @Test func testEither() {
        #expect("5" == Either<String, Int>.right(5).either(id, String.init))
        #expect("Error" == Either<String, Int>.left("Error").either(id, String.init))
    }

    @Test func testLeft() {
        #expect("Error" == Either<String, Int>.left("Error").left)
        #expect(nil == Either<String, Int>.right(5).left)
    }

    @Test func testRight() {
        #expect(nil == Either<String, Int>.left("Error").right)
        #expect(5 == Either<String, Int>.right(5).right)
    }

    @Test func testIsLeft() {
        #expect(Either<String, Int>.left("Error").isLeft)
        #expect(false == Either<String, Int>.right(5).isLeft)
    }

    @Test func testIsRight() {
        #expect(false == Either<String, Int>.left("Error").isRight)
        #expect(Either<String, Int>.right(5).isRight)
    }

    @Test func testMap() {
        #expect(2 == (Either<Int, Int>.right(1) |> map { $0 + 1 }).right)
        #expect(1 == (Either<Int, Int>.left(1) |> map { $0 + 1 }).left)
        #expect(2 == Either<Int, Int>.right(1).map { $0 + 1 }.right)
        #expect(1 == Either<Int, Int>.left(1).map { $0 + 1 }.left)
        #expect(2 == ({ $0 + 1 } <-> Either<Int, Int>.right(1)).right)
        #expect(1 == ({ $0 + 1 } <-> Either<Int, Int>.left(1)).left)
    }

    @Test func testAppend() {
        #expect([1, 2] == ((Either<String, [Int]>.right([1]) <> Either<String, [Int]>.right([2])).right ?? []))
        #expect(2 == (Either<Int, Int>.right(1) |> map { $0 + 1 }).right)
        #expect(nil == (Either<String, [Int]>.right([1]) <> Either<String, [Int]>.left("Error")).right)
        #expect(nil == (Either<String, [Int]>.left("Error") <> Either<String, [Int]>.right([2])).right)
        #expect("Error" == (Either<String, [Int]>.left("Error") <> Either<String, [Int]>.left("Error2")).left)
    }
}

struct KeyPathTests {
    @Test func testGet() {
        #expect(3 == ([1, 2, 3] |> get(\.count)))
    }

    @Test func testOver() {
        let user = User(id: 1)
        let newUser = (over(\User.id) <| { $0 + 1 }) <| user
        #expect(2 == newUser.id)
    }

    @Test func testSet() {
        let user = User(id: 1)
        let newUser = (set(\User.id) <| 2) <| user
        #expect(2 == newUser.id)
    }
}

fileprivate struct User {
    var id: Int
}
