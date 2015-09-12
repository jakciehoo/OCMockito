//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt
//  Contribution by Markus Gasser

#import "MKTAtLeastTimes.h"

#import "MKTInvocationContainer.h"
#import "MKTInvocationMatcher.h"
#import "MKTVerificationData.h"

#import <XCTest/XCTest.h>


@interface MKTAtLeastTimesTests : XCTestCase
@end

@implementation MKTAtLeastTimesTests
{
    MKTVerificationData *verification;
    NSInvocation *invocation;
}

- (void)setUp
{
    [super setUp];
    verification = [[MKTVerificationData alloc] init];
    verification.invocations = [[MKTInvocationContainer alloc] init];
    verification.wanted = [[MKTInvocationMatcher alloc] init];
    invocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:"]];
    [verification.wanted setExpectedInvocation:invocation];
}

- (void)simulateInvocationCount:(int)count
{
    for (int i = 0; i < count; ++i)
        [verification.invocations setInvocationForPotentialStubbing:invocation];
}

- (void)testVerifyAtLeastOne_WithNoInvocations_ShouldFail
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:1];

    [self simulateInvocationCount:0];

    XCTAssertThrows([sut verifyData:verification]);
}

- (void)testVerifyData_WithTooFewInvocations_ShouldFail
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:2];

    [self simulateInvocationCount:1];

    XCTAssertThrows([sut verifyData:verification]);
}

- (void)testVerifyAtLeastZero_WithNoInvocations_ShouldSucceed
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:0];

    [self simulateInvocationCount:0];

    XCTAssertNoThrow([sut verifyData:verification]);
}

- (void)testVerifyData_WithExactNumberOfInvocations_ShouldSucceed
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:1];

    [self simulateInvocationCount:1];

    XCTAssertNoThrow([sut verifyData:verification]);
}

- (void)testVerifyData_WithMoreInvocations_ShouldSucceed
{
    MKTAtLeastTimes *sut = [[MKTAtLeastTimes alloc] initWithMinimumCount:1];

    [self simulateInvocationCount:2];

    XCTAssertNoThrow([sut verifyData:verification]);
}

@end
