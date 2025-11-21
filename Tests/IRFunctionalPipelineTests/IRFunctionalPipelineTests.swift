import Testing
@testable import IRFunctionalPipeline

@Test func testJoined() {
    #expect("" == ([] |> joined(" ")))
    #expect("hello" == (["hello"] |> joined(" ")))
    #expect("hello world" == (["hello", "world"] |> joined(" ")))
}
