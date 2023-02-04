//
//  MemoryGraphDemoUITests.m
//  MemoryGraphDemoUITests
//
//  Created by tuyw on 2023/1/11.
//

#import <XCTest/XCTest.h>

@interface MemoryGraphDemoUITests : XCTestCase

@end

@implementation MemoryGraphDemoUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    XCUIApplication *app = [[XCUIApplication alloc] init];

    XCTMeasureOptions *options = [[XCTMeasureOptions alloc] init];
    options.invocationOptions = XCTMeasurementInvocationManuallyStart;
    
    [self measureWithMetrics:@[[[XCTMemoryMetric alloc] initWithApplication:app]] options:options block:^{
        [app launch];
        [self startMeasuring];
        
        [app/*@START_MENU_TOKEN@*/.staticTexts[@"Click Me"]/*[[".buttons[@\"Click Me\"].staticTexts[@\"Click Me\"]",".staticTexts[@\"Click Me\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];

        XCUIElementQuery *tablesQuery = app.tables;
        [tablesQuery.staticTexts[@"Large Buffers"] tap];
        [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Retain Cycles"]/*[[".cells.staticTexts[@\"Retain Cycles\"]",".staticTexts[@\"Retain Cycles\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
        [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Indirect Retain Cycles"]/*[[".cells.staticTexts[@\"Indirect Retain Cycles\"]",".staticTexts[@\"Indirect Retain Cycles\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
        [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Dynamic Indirect Retain Cycles"]/*[[".cells.staticTexts[@\"Dynamic Indirect Retain Cycles\"]",".staticTexts[@\"Dynamic Indirect Retain Cycles\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
        XCTAssertTrue([tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Large Buffers"]/*[[".cells.staticTexts[@\"Large Buffers\"]",".staticTexts[@\"Large Buffers\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/waitForExistenceWithTimeout:5]);
    }];
}


@end
