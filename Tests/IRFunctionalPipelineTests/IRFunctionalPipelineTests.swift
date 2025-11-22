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
