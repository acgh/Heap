// BinaryHeap - Alex C. 2015

import Foundation

public struct BinaryHeap <T:Comparable> {
    private var array : [T]
    private var orderingFunc : (T, T) -> Bool
    
    public init() {
        self.init([])
    }
    
    public init(_ a: [T]) {
        // The default behaviour is a Min-Heap
        self.init(a, { x, y in
            return x <= y
        })
    }
    
    public init(_ a: [T], o : (T, T) -> Bool) {
        array = a
        orderingFunc = o
        if (0 < array.count) {
            build()
        }
    }
    
    private mutating func build() {
        for i in reverse(0...(self.array.count / 2 - 1)) {
            heapifyFrom(i)
        }
    }
    
    private mutating func heapifyFrom(parentIndex: Int) {
        var heapifyIndex = -1;
        let leftChildIndex = leftChildIndexFrom(parentIndex);
        let rightChildIndex = rightChildIndexFrom(parentIndex);
        
        if (leftChildIndex != -1 && !areElementsOrdered(parentIndex, leftChildIndex)) {
            heapifyIndex = leftChildIndex
        }
        else {
            heapifyIndex = parentIndex;
        }
        
        if (rightChildIndex != -1 && !areElementsOrdered(heapifyIndex, rightChildIndex)) {
            heapifyIndex = rightChildIndex;
        }
        
        if (heapifyIndex != parentIndex) {
            swapElements(parentIndex, heapifyIndex)
            heapifyFrom(heapifyIndex);
        }
    }
    
    // MARK: - Public accessors
    
    public func count() -> Int {
        return self.array.count;
    }
    
    public func peek() -> T? {
        return self.array.first;
    }
    
    public func isEmpty() -> Bool {
        return count() == 0;
    }
    
    // MARK: - Private helpers
    
    private func areElementsOrdered(a: Int, _ b: Int) -> Bool {
        return self.orderingFunc(self.array[a], self.array[b])
    }
    
    private func lastElementIndex() -> Int {
        return count() - 1;
    }
    
    private func parentIndexFrom(childIndex: Int) -> Int {
        if childIndex == 0 {
            return -1;
        }
        return (childIndex - 1) / 2;
    }
    
    private func leftChildIndexFrom(parentIndex: Int) -> Int {
        if (parentIndex < 0 || lastElementIndex() <= parentIndex) {
            return -1;
        }
        
        let childIndex = 2 * parentIndex + 1;
        if (count() <= childIndex) {
            return -1;
        }
        return childIndex;
    }
    
    private func rightChildIndexFrom(parentIndex: Int) -> Int {
        if (parentIndex < 0 || lastElementIndex() <= parentIndex) {
            return -1;
        }
        
        let childIndex = 2 * parentIndex + 2;
        if (count() <= childIndex) {
            return -1;
        }
        return childIndex;
    }
    
    private mutating func swapElements(a: Int, _ b: Int) {
        let t = self.array[b];
        self.array[b] = self.array[a];
        self.array[a] = t;
    }
    
    // MARK: -
    
    public mutating func add(t: T) {
        self.array.append(t);
        bubbleElementUpFromIndex(self.lastElementIndex())
    }
    
    private mutating func bubbleElementUpFromIndex(fromIndex: Int) {
        if (fromIndex == -1) {
            return;
        }
        
        let parentIndex = self.parentIndexFrom(fromIndex);
        if (parentIndex != -1 && !areElementsOrdered(parentIndex, fromIndex)) {
            swapElements(parentIndex, fromIndex)
            bubbleElementUpFromIndex(parentIndex);
        }
    }
    
    // MARK: -
    
    public mutating func remove() {
        if (count() < 2) {
            self.array.removeAll(keepCapacity: true);
        }
        else {
            swapElements(0, lastElementIndex())
            self.array.removeLast()
            trickleElementDownFrom(0);
        }
    }
    
    private mutating func trickleElementDownFrom(fromIndex: Int) {
        if (fromIndex == -1) {
            return;
        }
        
        var j = -1;
        let leftChildIndex = leftChildIndexFrom(fromIndex);
        let rightChildIndex = rightChildIndexFrom(fromIndex);
        
        if (rightChildIndex != -1 && !areElementsOrdered(fromIndex, rightChildIndex)) {
            if (areElementsOrdered(leftChildIndex, rightChildIndex)) {
                j = leftChildIndex;
            }
            else {
                j = rightChildIndex;
            }
        }
        else {
            if (leftChildIndex != -1 && !areElementsOrdered(fromIndex, leftChildIndex)) {
                j = leftChildIndex;
            }
        }
        if (j != -1) {
            swapElements(fromIndex, j)
            trickleElementDownFrom(j)
        }
    }
    
    // MARK: -
    
    public mutating func extract() -> T? {
        let t = peek()
        remove()
        return t
    }
}

extension BinaryHeap : Printable {
    public var description : String {
        return self.array.description;
    }
}

public func MinHeap<T>() -> BinaryHeap<T> {
    return MinHeap([])
}

public func MinHeap<T>(ts: [T]) -> BinaryHeap<T> {
    let h = BinaryHeap(ts)
    return h
}

public func MaxHeap<T>() -> BinaryHeap<T> {
    return MaxHeap([])
}

public func MaxHeap<T>(ts: [T]) -> BinaryHeap<T> {
    let h = BinaryHeap<T>(ts, { x, y in
        y < x
    })
    return h
}

// Fisher-Yates shuffle
func shuffle<T>(inout xs: [T]) {
    for i in reverse(1..<xs.count) {
        let j = Int(arc4random_uniform(UInt32(xs.count)))
        let t:T = xs[j]
        xs[j] = xs[i]
        xs[i] = t
    }
}

var numbers = Array(-20...20)
shuffle(&numbers)
println(numbers)

let alphabet = ["a", "b", "c"]
var strings:[String] = []
for la in alphabet {
    for lb in alphabet {
        for lc in alphabet {
            strings.append(la + lb + lc)
        }
    }
}
shuffle(&strings)
println(strings)


var minhn = MinHeap(numbers)
while !minhn.isEmpty() {
    let p = minhn.extract()
    print("\(p!) ")
}

var maxhn = MaxHeap(numbers)
while !maxhn.isEmpty() {
    let p = maxhn.extract()
    print("\(p!) ")
}

var minhs = MinHeap(strings)
while !minhs.isEmpty() {
    let p = minhs.extract()
    print("\(p!) ")
}

var maxhs = MaxHeap(strings)
while !maxhs.isEmpty() {
    let p = maxhs.extract()
    print("\(p!) ")
}
