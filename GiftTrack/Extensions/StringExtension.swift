import Foundation

extension String {
    // Handles negative indexes by counting from end of string.
    private func getOffset(_ i: Int) -> Int {
        let count = self.count
        var offset = i >= 0 ? i : i + count
        offset = offset < 0 ? 0 : offset > count ? count : offset
        return offset
    }

    // Get substring starting at an index.
    subscript (_ i: Int) -> String {
        get {
            let offset = getOffset(i)
            if offset >= self.count { return "" }
            let idx = index(self.startIndex, offsetBy: offset)
            return String(self[idx])
        }
        set {
            let offset = getOffset(i)
            let idx = index(self.startIndex, offsetBy: offset)
            replaceSubrange(idx...idx, with: newValue)
        }
    }

    // Get substring from a Range of the form start..<end.
    subscript (_ r: Range<Int>) -> String {
        get {
            let startOffset = getOffset(r.lowerBound)
            let endOffset = getOffset(r.upperBound)
            let si = index(self.startIndex, offsetBy: startOffset)
            let ei = index(si, offsetBy: endOffset - startOffset)
            return String(self[si..<ei])
        }
        set {
            let startOffset = getOffset(r.lowerBound)
            let endOffset = getOffset(r.upperBound)
            let si = index(self.startIndex, offsetBy: startOffset)
            let ei = index(si, offsetBy: endOffset - startOffset)
            replaceSubrange(si..<ei, with: newValue)
        }
    }

    // Get substring from a Range of the form start...end.
    subscript (_ r: ClosedRange<Int>) -> String {
        get {
            let startOffset = getOffset(r.lowerBound)
            var endOffset = getOffset(r.upperBound)
            if endOffset >= self.count { endOffset -= 1 }
            let si = index(self.startIndex, offsetBy: startOffset)
            let ei = index(si, offsetBy: endOffset - startOffset)
            return String(self[si...ei])
        }
        set {
            let startOffset = getOffset(r.lowerBound)
            var endOffset = getOffset(r.upperBound)
            if endOffset >= self.count { endOffset -= 1 }
            let si = index(self.startIndex, offsetBy: startOffset)
            let ei = index(si, offsetBy: endOffset - startOffset)
            replaceSubrange(si...ei, with: newValue)
        }
    }

    // Get substring from a Range of the form start....
    subscript (_ r: PartialRangeFrom<Int>) -> String {
        get {
            let startOffset = getOffset(r.lowerBound)
            let idx = index(self.startIndex, offsetBy: startOffset)
            return String(self[idx...])
        }
        set {
            let startOffset = getOffset(r.lowerBound)
            let idx = index(self.startIndex, offsetBy: startOffset)
            replaceSubrange(idx..., with: newValue)
        }
    }

    // Get substring from a Range of the form ..<end.
    subscript (_ r: PartialRangeUpTo<Int>) -> String {
        get {
            var endOffset = getOffset(r.upperBound)
            if endOffset >= self.count { endOffset -= 1 }
            let idx = index(self.startIndex, offsetBy: endOffset)
            return String(self[...idx])
        }
        set {
            var endOffset = getOffset(r.upperBound)
            if endOffset >= self.count { endOffset -= 1 }
            let idx = index(self.startIndex, offsetBy: endOffset)
            replaceSubrange(...idx, with: newValue)
        }
    }

    // Get substring using two Int arguments instead of a Range.
    func substring(_ start: Int, _ end: Int) -> String {
        return self[start...end]
    }

    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
