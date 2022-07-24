import Foundation

extension String {
    // Handles negative indexes by counting from end of string.
    private func getOffset(_ index: Int) -> Int {
        let count = count
        var offset = index >= 0 ? index : index + count
        offset = offset < 0 ? 0 : offset > count ? count : offset
        return offset
    }

    // Get substring starting at an index.
    subscript(_ indexP: Int) -> String {
        get {
            let offset = getOffset(indexP)
            if offset >= count { return "" }
            let selfIndex = index(startIndex, offsetBy: offset)
            return String(self[selfIndex])
        }
        set {
            let offset = getOffset(indexP)
            let selfIndex = index(startIndex, offsetBy: offset)
            replaceSubrange(selfIndex ... selfIndex, with: newValue)
        }
    }

    // Get substring from a Range of the form start..<end.
    subscript(_ range: Range<Int>) -> String {
        get {
            let startOffset = getOffset(range.lowerBound)
            let endOffset = getOffset(range.upperBound)
            let startIndex = index(startIndex, offsetBy: startOffset)
            let endIndex = index(startIndex, offsetBy: endOffset - startOffset)
            return String(self[startIndex ..< endIndex])
        }
        set {
            let startOffset = getOffset(range.lowerBound)
            let endOffset = getOffset(range.upperBound)
            let startIndex = index(startIndex, offsetBy: startOffset)
            let endIndex = index(startIndex, offsetBy: endOffset - startOffset)
            replaceSubrange(startIndex ..< endIndex, with: newValue)
        }
    }

    // Get substring from a Range of the form start...end.
    subscript(_ range: ClosedRange<Int>) -> String {
        get {
            let startOffset = getOffset(range.lowerBound)
            var endOffset = getOffset(range.upperBound)
            if endOffset >= count { endOffset -= 1 }
            let startIndex = index(startIndex, offsetBy: startOffset)
            let endIndex = index(startIndex, offsetBy: endOffset - startOffset)
            return String(self[startIndex ... endIndex])
        }
        set {
            let startOffset = getOffset(range.lowerBound)
            var endOffset = getOffset(range.upperBound)
            if endOffset >= count { endOffset -= 1 }
            let startIndex = index(startIndex, offsetBy: startOffset)
            let endIndex = index(startIndex, offsetBy: endOffset - startOffset)
            replaceSubrange(startIndex ... endIndex, with: newValue)
        }
    }

    // Get substring from a Range of the form start....
    subscript(_ range: PartialRangeFrom<Int>) -> String {
        get {
            let startOffset = getOffset(range.lowerBound)
            let selfIndex = index(startIndex, offsetBy: startOffset)
            return String(self[selfIndex...])
        }
        set {
            let startOffset = getOffset(range.lowerBound)
            let selfIndex = index(startIndex, offsetBy: startOffset)
            replaceSubrange(selfIndex..., with: newValue)
        }
    }

    // Get substring from a Range of the form ..<end.
    subscript(_ range: PartialRangeUpTo<Int>) -> String {
        get {
            var endOffset = getOffset(range.upperBound)
            if endOffset >= count { endOffset -= 1 }
            let idx = index(startIndex, offsetBy: endOffset)
            return String(self[...idx])
        }
        set {
            var endOffset = getOffset(range.upperBound)
            if endOffset >= count { endOffset -= 1 }
            let selfIndex = index(startIndex, offsetBy: endOffset)
            replaceSubrange(...selfIndex, with: newValue)
        }
    }

    // Get substring using two Int arguments instead of a Range.
    func substring(_ start: Int, _ end: Int) -> String {
        self[start ... end]
    }

    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
