//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "OCMockito.h"

#import "MockTestCase.h"
#import <OCHamcrest/OCHamcrest.h>
#import <XCTest/XCTest.h>


@interface VerifyProgrammerErrorTests : XCTestCase
@end

@implementation VerifyProgrammerErrorTests
{
    MockTestCase *mockTestCase;
}

- (void)setUp
{
    [super setUp];
    mockTestCase = [[MockTestCase alloc] init];
}

- (void)testVerify_WithNil_ShouldGiveError
{
    [verifyWithMockTestCase(nil, mockTestCase) removeAllObjects];

    assertThat(mockTestCase.failureDescription,
               is(@"Argument passed to verify() should be a mock but is nil"));
}

- (void)testVerifyCount_WithNil_ShouldGiveError
{
    [verifyCountWithMockTestCase(nil, times(1), mockTestCase) removeAllObjects];

    assertThat(mockTestCase.failureDescription,
               is(@"Argument passed to verifyCount() should be a mock but is nil"));
}

- (void)testVerify_WithNonMock_ShouldGiveError
{
    NSMutableArray *realArray = [NSMutableArray array];

    [verifyWithMockTestCase(realArray, mockTestCase) removeAllObjects];

    assertThat(mockTestCase.failureDescription,
               startsWith(@"Argument passed to verify() should be a mock but is type "));
}

- (void)testVerifyCount_WithNonMock_ShouldGiveError
{
    NSMutableArray *realArray = [NSMutableArray array];

    [verifyCountWithMockTestCase(realArray, times(1), mockTestCase) removeAllObjects];

    assertThat(mockTestCase.failureDescription,
               startsWith(@"Argument passed to verifyCount() should be a mock but is type "));
}

@end
