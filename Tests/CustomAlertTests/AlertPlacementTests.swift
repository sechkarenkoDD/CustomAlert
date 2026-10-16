import Foundation
import Testing
@testable import CustomAlert

struct AlertPlacementTests {
    private let bounds = CGRect(x: 0, y: 0, width: 900, height: 600)

    @Test func unfoldedUsesEntireSafeArea() {
        #expect(AlertPlacement.availableFrame(in: bounds, avoiding: []) == bounds)
    }

    @Test func bookPoseUsesTrailingRegion() {
        let fold = CGRect(x: 440, y: -20, width: 20, height: 650)
        let result = AlertPlacement.availableFrame(in: bounds, avoiding: [fold])
        #expect(result == CGRect(x: 460, y: 0, width: 440, height: 600))
        #expect(!result.intersection(fold).hasArea)
    }

    @Test func tabletopUsesUpperRegion() {
        let fold = CGRect(x: -20, y: 290, width: 950, height: 20)
        #expect(AlertPlacement.availableFrame(in: bounds, avoiding: [fold])
            == CGRect(x: 0, y: 0, width: 900, height: 290))
    }

    @Test func foldOutsideWindowDoesNotDisplace() {
        let fold = CGRect(x: 1000, y: 0, width: 20, height: 600)
        #expect(AlertPlacement.availableFrame(in: bounds, avoiding: [fold]) == bounds)
    }

    @Test func splitWindowWithOnlyLeadingSpaceUsesIt() {
        let fold = CGRect(x: 880, y: 0, width: 50, height: 600)
        #expect(AlertPlacement.availableFrame(in: bounds, avoiding: [fold])
            == CGRect(x: 0, y: 0, width: 880, height: 600))
    }

    @Test func splitWindowBelowFoldUsesLowerRegion() {
        let fold = CGRect(x: 0, y: -10, width: 900, height: 30)
        #expect(AlertPlacement.availableFrame(in: bounds, avoiding: [fold])
            == CGRect(x: 0, y: 20, width: 900, height: 580))
    }

    @Test func zeroWidthInactiveRegionDoesNotDisplace() {
        let fold = CGRect(x: 450, y: 0, width: 0, height: 600)
        #expect(AlertPlacement.availableFrame(in: bounds, avoiding: [fold]) == bounds)
    }
}

private extension CGRect {
    var hasArea: Bool { !isNull && !isEmpty }
}
