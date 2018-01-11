//
//  My.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/16.
//  Copyright © 2015年 东正. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

open class $ {
    open class func after<T, E>(_ n: Int, function: @escaping (T...) -> E) -> ((T...) -> E?) {
        var counter = n
        return { (params: T...) -> E? in
            typealias Function = ([T]) -> E
            counter = counter - 1
            if counter <= 0 {
                let f = unsafeBitCast(function, to: Function.self)
                return f(params)
            }
            return .none
        }
    }
    
    /// Creates a function that executes passed function only after being called n times.
    ///
    /// :param n Number of times after which to call function.
    /// :param function Function to be called that does not take any params.
    /// :return Function that can be called n times after which the callback function is called.
    open class func after<T>(_ n: Int, function: @escaping () -> T) -> (() -> T?) {
        let f = self.after(n) { (params: Any?...) -> T in
            return function()
        }
        return { f() }
    }
    
    /// Creates an array of elements from the specified indexes, or keys, of the collection.
    /// Indexes may be specified as individual arguments or as arrays of indexes.
    ///
    /// :param array The array to source from
    /// :param indexes Get elements from these indexes
    /// :return New array with elements from the indexes specified.
    open class func at<T>(_ array: [T], indexes: Int...) -> [T] {
        return self.at(array, indexes: indexes)
    }
    
    /// Creates an array of elements from the specified indexes, or keys, of the collection.
    /// Indexes may be specified as individual arguments or as arrays of indexes.
    ///
    /// :param array The array to source from
    /// :param indexes Get elements from these indexes
    /// :return New array with elements from the indexes specified.
    open class func at<T>(_ array: [T], indexes: [Int]) -> [T] {
        var result: [T] = []
        for index in indexes {
            result.append(array[index])
        }
        return result
    }
    
    /// Creates a function that, when called, invokes func with the binding of arguments provided.
    ///
    /// :param function Function to be bound.
    /// :param parameters Parameters to be passed into the function when being invoked.
    /// :return A new function that when called will invoked the passed function with the parameters specified.
    open class func bind<T, E>(_ function: @escaping (T...) -> E, _ parameters: T...) -> (() -> E) {
        return { () -> E in
            typealias Function = ([T]) -> E
            let f = unsafeBitCast(function, to: Function.self)
            return f(parameters)
        }
    }
    
    /// Creates an array of elements split into groups the length of size.
    /// If array can’t be split evenly, the final chunk will be the remaining elements.
    ///
    /// :param array to chunk
    /// :param size size of each chunk
    /// :return array elements chunked
    open class func chunk<T>(_ array: [T], size: Int = 1) -> [[T]] {
        var result = [[T]]()
        var chunk = -1
        for (index, elem) in array.enumerated() {
            if index % size == 0 {
                result.append([T]())
                chunk += 1
            }
            result[chunk].append(elem)
        }
        return result
    }
    
    /// Creates an array with all nil values removed.
    ///
    /// :param array Array to be compacted.
    /// :return A new array that doesnt have any nil values.
    open class func compact<T>(_ array: [T?]) -> [T] {
        var result: [T] = []
        for elem in array {
            if let val = elem {
                result.append(val)
            }
        }
        return result
    }
    
    /// Compose two or more functions passing result of the first function
    /// into the next function until all the functions have been evaluated
    ///
    /// :param functions - list of functions
    /// :return A function that can be called with variadic parameters of values
    open class func compose<T>(_ functions: ((T...) -> [T])...) -> ((T...) -> [T]) {
        typealias Function = ([T]) -> [T]
        return {
            var result = $0
            for fun in functions {
                let f = unsafeBitCast(fun, to: Function.self)
                result = f(result)
            }
            return result
        }
    }
    
    /// Compose two or more functions passing result of the first function
    /// into the next function until all the functions have been evaluated
    ///
    /// :param functions - list of functions
    /// :return A function that can be called with array of values
    open class func compose<T>(_ functions: (([T]) -> [T])...) -> (([T]) -> [T]) {
        return {
            var result = $0
            for fun in functions {
                result = fun(result)
            }
            return result
        }
    }
    
    /// Checks if a given value is present in the array.
    ///
    /// :param array The array to check against.
    /// :param value The value to check.
    /// :return Whether value is in the array.
    open class func contains<T : Equatable>(_ array: [T], value: T) -> Bool {
        return array.contains(value)
    }
    
    /// Create a copy of an array
    ///
    /// :param array The array to copy
    /// :return New copy of array
    open class func copy<T>(_ array: [T]) -> [T] {
        var newArr : [T] = []
        for elem in array {
            newArr.append(elem)
        }
        return newArr
    }
    
    /// Cycles through the array indefinetly passing each element into the callback function
    ///
    /// :param array to cycle through
    /// :param callback function to call with the element
    open class func cycle<T, U>(_ array: [T], callback: (T) -> (U)) {
        while true {
            for elem in array {
                callback(elem)
            }
        }
    }
    
    /// Cycles through the array n times passing each element into the callback function
    ///
    /// :param array to cycle through
    /// :param times Number of times to cycle through the array
    /// :param callback function to call with the element
    open class func cycle<T, U>(_ array: [T], _ times: Int, callback: (T) -> (U)) {
        var i = 0
        while i < times {
            for elem in array {
                callback(elem)
            }
            i = i + 1
        }
    }
    
    /// Creates an array excluding all values of the provided arrays in order
    ///
    /// :param arrays The arrays to difference between.
    /// :return The difference between the first array and all the remaining arrays from the arrays params.
    open class func differenceInOrder<T: Equatable>(_ arrays: [[T]]) -> [T] {
        return $.reduce(self.rest(arrays), initial: self.first(arrays)!) { (result, arr) -> [T] in
            return result.filter() { !arr.contains($0) }
        }
    }
    
    /// Creates an array excluding all values of the provided arrays with or without order
    /// Without order difference is much faster and at times 100% than difference with order
    ///
    /// :param arrays The arrays to difference between.
    /// :param inOrder Optional Paramter which is true by default
    /// :return The difference between the first array and all the remaining arrays from the arrays params.
    open class func difference<T: Hashable>(_ arrays: [T]..., inOrder: Bool = true) -> [T] {
        if inOrder {
            return self.differenceInOrder(arrays)
        } else {
            var result : [T] = []
            var map : [T: Int] = [T: Int]()
            let firstArr : [T] = self.first(arrays)!
            let restArr : [[T]] = self.rest(arrays) as [[T]]
            for elem in firstArr {
                if let val = map[elem] {
                    map[elem] = val + 1
                } else {
                    map[elem] = 1
                }
            }
            for arr in restArr {
                for elem in arr {
                    map.removeValue(forKey: elem)
                }
            }
            for (key, count) in map {
                for _ in 0..<count {
                    result.append(key)
                }
            }
            return result
        }
    }
    
    /// Call the callback passing each element in the array
    ///
    /// :param array The array to iterate over
    /// :param callback function that gets called with each item in the array
    /// :return The array passed
    open class func each<T>(_ array: [T], callback: (T) -> ()) -> [T] {
        for elem in array {
            callback(elem)
        }
        return array
    }
    
    /// Call the callback passing index of the element and each element in the array
    ///
    /// :param array The array to iterate over
    /// :param callback function that gets called with each item in the array with its index
    /// :return The array passed
    open class func each<T>(_ array: [T], callback: (Int, T) -> ()) -> [T] {
        for (index, elem): (Int, T) in array.enumerated() {
            callback(index, elem)
        }
        return array
    }
    
    /// Call the callback on all elements that meet the when condition
    ///
    /// :param array The array to check.
    /// :param when Condition to check before performing callback
    /// :param callback Check whether element value is true or false.
    /// :return The array passed
    open class func each<T>(_ array: [T], when: (T) -> Bool, callback: (T) -> ()) ->[T] {
        for elem in array where when(elem) {
            callback(elem);
        }
        return array;
    }
    
    /// Checks if two optionals containing Equatable types are equal.
    ///
    /// :param value The first optional to check.
    /// :param other The second optional to check.
    /// :return: true if the optionals contain two equal values, or both are nil; false otherwise.
    open class func equal<T: Equatable>(_ value: T?, _ other: T?) -> Bool {
        switch (value, other) {
        case (.none, .none):
            return true
        case (.none, .some(_)):
            return false
        case (.some(_), .none):
            return false
        case (.some(let unwrappedValue), .some(let otherUnwrappedValue)):
            return unwrappedValue == otherUnwrappedValue
        }
    }
    
    /// Checks if the given callback returns true value for all items in the array.
    ///
    /// :param array The array to check.
    /// :param callback Check whether element value is true or false.
    /// :return First element from the array.
    open class func every<T>(_ array: [T], callback: (T) -> Bool) -> Bool {
        for elem in array {
            if !callback(elem) {
                return false
            }
        }
        return true
    }
    
    
    /// Returns Factorial of integer
    ///
    /// :param num number whose factorial needs to be calculated
    /// :return factorial
    open class func factorial(_ num: Int) -> Int {
        guard num > 0 else { return 1 }
        return num * $.factorial(num - 1)
    }
    
    /// Get element from an array at the given index which can be negative
    /// to find elements from the end of the array
    ///
    /// :param array The array to fetch from
    /// :param index Can be positive or negative to find from end of the array
    /// :param orElse Default value to use if index is out of bounds
    /// :return Element fetched from the array or the default value passed in orElse
    open class func fetch<T>(_ array: [T], _ index: Int, orElse: T? = .none) -> T! {
        if index < 0 && -index < array.count {
            return array[array.count + index]
        } else if index < array.count {
            return array[index]
        } else {
            return orElse
        }
    }
    
    /// Fills elements of array with value from start up to, but not including, end.
    ///
    /// :param array to fill
    /// :param elem the element to replace
    /// :return array elements chunked
    open class func fill<T>(_ array: inout [T], withElem elem: T, startIndex: Int = 0, endIndex: Int? = .none) -> [T] {
        let endIndex = endIndex ?? array.count
        for (index, _) in array.enumerated() {
            if index > endIndex { break }
            if index >= startIndex && index <= endIndex {
                array[index] = elem
            }
        }
        return array
    }
    
    /// Iterates over elements of an array and returning the first element
    /// that the callback returns true for.
    ///
    /// :param array The array to search for the element in.
    /// :param callback The callback function to tell whether element is found.
    /// :return Optional containing either found element or nil.
    open class func find<T>(_ array: [T], callback: (T) -> Bool) -> T? {
        for elem in array {
            let result = callback(elem)
            if result {
                return elem
            }
        }
        return .none
    }
    
    /// This method is like find except that it returns the index of the first element
    /// that passes the callback check.
    ///
    /// :param array The array to search for the element in.
    /// :param callback Function used to figure out whether element is the same.
    /// :return First element's index from the array found using the callback.
    open class func findIndex<T>(_ array: [T], callback: (T) -> Bool) -> Int? {
        for (index, elem): (Int, T) in array.enumerated() {
            if callback(elem) {
                return index
            }
        }
        return .none
    }
    
    /// This method is like findIndex except that it iterates over elements of the array
    /// from right to left.
    ///
    /// :param array The array to search for the element in.
    /// :param callback Function used to figure out whether element is the same.
    /// :return Last element's index from the array found using the callback.
    open class func findLastIndex<T>(_ array: [T], callback: (T) -> Bool) -> Int? {
        let count = array.count
        for (index, _) in array.enumerated() {
            let reverseIndex = count - (index + 1)
            let elem : T = array[reverseIndex]
            if callback(elem) {
                return reverseIndex
            }
        }
        return .none
    }
    
    /// Gets the first element in the array.
    ///
    /// :param array The array to wrap.
    /// :return First element from the array.
    open class func first<T>(_ array: [T]) -> T? {
        if array.isEmpty {
            return .none
        } else {
            return array[0]
        }
    }
    
    /// Gets the second element in the array.
    ///
    /// :param array The array to wrap.
    /// :return Second element from the array.
    open class func second<T>(_ array: [T]) -> T? {
        if array.count < 2 {
            return .none
        } else {
            return array[1]
        }
    }
    
    /// Gets the third element in the array.
    ///
    /// :param array The array to wrap.
    /// :return Third element from the array.
    open class func third<T>(_ array: [T]) -> T? {
        if array.count < 3 {
            return .none
        } else {
            return array[2]
        }
    }
    
    /// Flattens a nested array of any depth.
    ///
    /// :param array The array to flatten.
    /// :return Flattened array.
    open class func flatten<T>(_ array: [T]) -> [T] {
        var resultArr: [T] = []
        for elem : T in array {
            if let val = elem as? [T] {
                resultArr += self.flatten(val)
            } else {
                resultArr.append(elem)
            }
        }
        return resultArr
    }
    
    /// Maps a function that converts elements to a list and then concatenates them.
    ///
    /// :param array The array to map.
    /// :return The array with the transformed values concatenated together.
    open class func flatMap<T, U>(_ array: [T], f: (T) -> ([U])) -> [U] {
        return array.map(f).reduce([], +)
    }
    
    /// Maps a function that converts a type to an Optional over an Optional, and then returns a single-level Optional.
    ///
    /// :param array The array to map.
    /// :return The array with the transformed values concatenated together.
    open class func flatMap<T, U>(_ value: T?, f: (T) -> (U?)) -> U? {
        if let unwrapped = value.map(f) {
            return unwrapped
        } else {
            return .none
        }
    }
    
    /// Returns size of the array
    ///
    /// :param array The array to size.
    /// :return size of the array
    open class func size<T>(_ array: [T]) -> Int {
        return array.count
    }
    
    /// Randomly shuffles the elements of an array.
    ///
    /// :param array The array to shuffle.
    /// :return Shuffled array
    open class func shuffle<T>(_ array: [T]) -> [T] {
        var newArr = self.copy(array)
        // Implementation of Fisher-Yates shuffle
        // http://en.wikipedia.org/wiki/Fisher-Yates_Shuffle
        for index in 0..<array.count {
            let randIndex = self.random(index)
            
            if index != randIndex {
                Swift.swap(&newArr[index], &newArr[randIndex])
            }
        }
        return newArr
    }
    
    /// This method returns a dictionary of values in an array mapping to the
    /// total number of occurrences in the array.
    ///
    /// :param array The array to source from.
    /// :return Dictionary that contains the key generated from the element passed in the function.
    open class func frequencies<T>(_ array: [T]) -> [T: Int] {
        return self.frequencies(array) { $0 }
    }
    
    /// This method returns a dictionary of values in an array mapping to the
    /// total number of occurrences in the array. If passed a function it returns
    /// a frequency table of the results of the given function on the arrays elements.
    ///
    /// :param array The array to source from.
    /// :param function The function to get value of the key for each element to group by.
    /// :return Dictionary that contains the key generated from the element passed in the function.
    open class func frequencies<T, U: Equatable>(_ array: [T], function: (T) -> U) -> [U: Int] {
        var result = [U: Int]()
        for elem in array {
            let key = function(elem)
            if let freq = result[key] {
                result[key] = freq + 1
            } else {
                result[key] = 1
            }
        }
        return result
    }
    
    /// GCD function return greatest common denominator
    ///
    /// :param first number
    /// :param second number
    /// :return Greatest common denominator
    public class func gcd(_ first: Int, _ second: Int) -> Int {
        var first = first, second = second
        while second != 0 {
            (first, second) = (second, first % second)
        }
        return Swift.abs(first)
    }
    
    /// LCM function return least common multiple
    ///
    /// :param first number
    /// :param second number
    /// :return Least common multiple
    open class func lcm(_ first: Int, _ second: Int) -> Int {
        return (first / $.gcd(first, second)) * second
    }
    
    /// The identity function. Returns the argument it is given.
    ///
    /// :param arg Value to return
    /// :return Argument that was passed
    open class func id<T>(_ arg: T) -> T {
        return arg
    }
    
    /// Gets the index at which the first occurrence of value is found.
    ///
    /// :param array The array to source from.
    /// :param value Value whose index needs to be found.
    /// :return Index of the element otherwise returns nil if not found.
    open class func indexOf<T: Equatable>(_ array: [T], value: T) -> Int? {
        return self.findIndex(array) { $0 == value }
    }
    
    /// Gets all but the last element or last n elements of an array.
    ///
    /// :param array The array to source from.
    /// :param numElements The number of elements to ignore in the end.
    /// :return Array of initial values.
    open class func initial<T>(_ array: [T], numElements: Int = 1) -> [T] {
        var result: [T] = []
        if (array.count > numElements && numElements >= 0) {
            for index in 0..<(array.count - numElements) {
                result.append(array[index])
            }
        }
        return result
    }
    
    /// Creates an array of unique values present in all provided arrays.
    ///
    /// :param arrays The arrays to perform an intersection on.
    /// :return Intersection of all arrays passed.
    open class func intersection<T : Hashable>(_ arrays: [T]...) -> [T] {
        var map : [T: Int] = [T: Int]()
        for arr in arrays {
            for elem in arr {
                if let val : Int = map[elem] {
                    map[elem] = val + 1
                } else {
                    map[elem] = 1
                }
            }
        }
        var result : [T] = []
        let count = arrays.count
        for (key, value) in map {
            if value == count {
                result.append(key)
            }
        }
        return result
    }
    
    /// Returns true if i is in range
    ///
    /// :param i to check if it is in range
    /// :param range to check in
    /// :return true if it is in range otherwise false
    open class func it<T: Comparable>(_ i: T, isIn range: Range<T>) -> Bool {
        return i >= range.lowerBound && i < range.upperBound
    }
    
    /// Returns true if i is in interval
    ///
    /// :param i to check if it is in interval
    /// :param interval to check in
    /// :return true if it is in interval otherwise false
//    open class func it<I : IntervalType>(_ i: I.Bound, isIn interval: I) -> Bool {
//        return interval.contains(i)
//    }
    
    /// Joins the elements in the array to create a concatenated element of the same type.
    ///
    /// :param array The array to join the elements of.
    /// :param separator The separator to join the elements with.
    /// :return Joined element from the array of elements.
    open class func join(_ array: [String], separator: String) -> String {
        return array.joined(separator: separator)
    }
    
    /// Creates an array of keys given a dictionary.
    ///
    /// :param dictionary The dictionary to source from.
    /// :return Array of keys from dictionary.
    open class func keys<T, U>(_ dictionary: [T: U]) -> [T] {
        var result : [T] = []
        for key in dictionary.keys {
            result.append(key)
        }
        return result
    }
    
    /// Gets the last element from the array.
    ///
    /// :param array The array to source from.
    /// :return Last element from the array.
    open class func last<T>(_ array: [T]) -> T? {
        if array.isEmpty {
            return .none
        } else {
            return array[array.count - 1]
        }
    }
    
    /// Gets the index at which the last occurrence of value is found.
    ///
    /// param: array:: The array to source from.
    /// :param value The value whose last index needs to be found.
    /// :return Last index of element if found otherwise returns nil.
    open class func lastIndexOf<T: Equatable>(_ array: [T], value: T) -> Int? {
        return self.findLastIndex(array) { $0 == value }
    }
    
    /// Maps each element to new value based on the map function passed
    ///
    /// :param collection The collection to source from
    /// :param transform The mapping function
    /// :return Array of elements mapped using the map function
    open class func map<T : Collection, E>(_ collection: T, transform: (T.Iterator.Element) -> E) -> [E] {
        return collection.map(transform)
    }
    
    /// Maps each element to new value based on the map function passed
    ///
    /// :param sequence The sequence to source from
    /// :param transform The mapping function
    /// :return Array of elements mapped using the map function
    open class func map<T : Sequence, E>(_ sequence: T, transform: (T.Iterator.Element) -> E) -> [E] {
        return sequence.map(transform)
    }
    
    /// Retrieves the maximum value in an array.
    ///
    /// :param array The array to source from.
    /// :return Maximum element in array.
    open class func max<T : Comparable>(_ array: [T]) -> T? {
        if var maxVal = array.first {
            for elem in array {
                if maxVal < elem {
                    maxVal = elem
                }
            }
            return maxVal
        }
        return .none
    }
    
    /// Get memoized function to improve performance
    ///
    /// :param function The function to memoize.
    /// :return Memoized function
    open class func memoize<T: Hashable, U>(_ function: @escaping (((T) -> U), T) -> U) -> ((T) -> U) {
        var cache = [T: U]()
        var funcRef: ((T) -> U)!
        funcRef = { (param : T) -> U in
            if let cacheVal = cache[param] {
                return cacheVal
            } else {
                cache[param] = function(funcRef, param)
                return cache[param]!
            }
        }
        return funcRef
    }
    
    /// Merge dictionaries together, later dictionaries overiding earlier values of keys.
    ///
    /// :param dictionaries The dictionaries to source from.
    /// :return Merged dictionary with all of its keys and values.
    open class func merge<T, U>(_ dictionaries: [T: U]...) -> [T: U] {
        var result = [T: U]()
        for dict in dictionaries {
            for (key, value) in dict {
                result[key] = value
            }
        }
        return result
    }
    
    /// Merge arrays together in the supplied order.
    ///
    /// :param arrays The arrays to source from.
    /// :return Array with all values merged, including duplicates.
    open class func merge<T>(_ arrays: [T]...) -> [T] {
        var result = [T]()
        for arr in arrays {
            result += arr
        }
        return result
    }
    
    /// Retrieves the minimum value in an array.
    ///
    /// :param array The array to source from.
    /// :return Minimum value from array.
    open class func min<T : Comparable>(_ array: [T]) -> T? {
        if var minVal = array.first {
            for elem in array {
                if minVal > elem {
                    minVal = elem
                }
            }
            return minVal
        }
        return .none
    }
    
    /// A no-operation function.
    ///
    /// :return nil.
    open class func noop() -> () {
    }
    
    /// Gets the number of seconds that have elapsed since the Unix epoch (1 January 1970 00:00:00 UTC).
    ///
    /// :return number of seconds as double
    open class func now() -> TimeInterval {
        return Foundation.Date().timeIntervalSince1970
    }
    
    /// Creates a shallow clone of a dictionary excluding the specified keys.
    ///
    /// :param dictionary The dictionary to source from.
    /// :param keys The keys to omit from returning dictionary.
    /// :return Dictionary with the keys specified omitted.
    open class func omit<T, U>(_ dictionary: [T: U], keys: T...) -> [T: U] {
        var result : [T: U] = [T: U]()
        
        for (key, value) in dictionary {
            if !self.contains(keys, value: key) {
                result[key] = value
            }
        }
        return result
    }
    
    /// Get a wrapper function that executes the passed function only once
    ///
    /// :param function That takes variadic arguments and return nil or some value
    /// :return Wrapper function that executes the passed function only once
    /// Consecutive calls will return the value returned when calling the function first time
    open class func once<T, U>(_ function: @escaping (T...) -> U) -> (T...) -> U {
        var result: U?
        let onceFunc = { (params: T...) -> U in
            typealias Function = ([T]) -> U
            if let returnVal = result {
                return returnVal
            } else {
                let f = unsafeBitCast(function, to: Function.self)
                result = f(params)
                return result!
            }
        }
        return onceFunc
    }
    
    /// Get a wrapper function that executes the passed function only once
    ///
    /// :param function That takes variadic arguments and return nil or some value
    /// :return Wrapper function that executes the passed function only once
    /// Consecutive calls will return the value returned when calling the function first time
    open class func once<U>(_ function: @escaping () -> U) -> () -> U {
        var result: U?
        let onceFunc = { () -> U in
            if let returnVal = result {
                return returnVal
            } else {
                result = function()
                return result!
            }
        }
        return onceFunc
    }
    
    /// Get the first object in the wrapper object.
    ///
    /// :param array The array to wrap.
    /// :return First element from the array.
    open class func partial<T, E> (_ function: @escaping (T...) -> E, _ parameters: T...) -> ((T...) -> E) {
        return { (params: T...) -> E in
            typealias Function = ([T]) -> E
            let f = unsafeBitCast(function, to: Function.self)
            return f(parameters + params)
        }
    }
    
    /// Produces an array of arrays, each containing n elements, each offset by step.
    /// If the final partition is not n elements long it is dropped.
    ///
    /// :param array The array to partition.
    /// :param n The number of elements in each partition.
    /// :param step The number of elements to progress between each partition. Set to n if not supplied.
    /// :return Array partitioned into n element arrays, starting step elements apart.
    public class func partition<T>(_ array: [T], n: Int, step: Int? = .none) -> [[T]] {
        var n = n, step = step
        var result = [[T]]()
        if step == .none    { step = n } // If no step is supplied move n each step.
        if step < 1         { step = 1 } // Less than 1 results in an infinite loop.
        if n < 1            { n = 0 }    // Allow 0 if user wants [[],[],[]] for some reason.
        if n > array.count  { return [[]] }
        
        for i in self.range(from: 0, through: array.count - n, incrementBy: step!) {
            result.append(Array(array[i..<(i+n)] as ArraySlice<T>))
        }
        return result
    }
    
    /// Produces an array of arrays, each containing n elements, each offset by step.
    ///
    /// :param array The array to partition.
    /// :param n The number of elements in each partition.
    /// :param step The number of elements to progress between each partition. Set to n if not supplied.
    /// :param pad An array of elements to pad the last partition if it is not long enough to
    ///            contain n elements. If nil is passed or there are not enough pad elements
    ///            the last partition may less than n elements long.
    /// :return Array partitioned into n element arrays, starting step elements apart.
    public class func partition<T>(_ array: [T], n: Int, step: Int? = .none, pad: [T]?) -> [[T]] {
        var array = array, n = n, step = step
        var result : [[T]] = []
        if step == .none   { step = n } // If no step is supplied move n each step.
        if step < 1 { step = 1 } // Less than 1 results in an infinite loop.
        if n < 1    { n = 0 }    // Allow 0 if user wants [[],[],[]] for some reason.
        
        for i in self.range(from: 0, to: array.count, incrementBy: step!) {
            var end = i + n
            if end > array.count { end = array.count }
            result.append(Array(array[i..<end] as ArraySlice<T>))
            if end != i+n { break }
        }
        
        if let padding = pad {
            let remain = array.count % n
            let end = padding.count > remain ? remain : padding.count
            result[result.count - 1] += Array(padding[0..<end] as ArraySlice<T>)
        }
        return result
    }
    
    /// Produces an array of arrays, each containing n elements, each offset by step.
    ///
    /// :param array The array to partition.
    /// :param n The number of elements in each partition.
    /// :param step The number of elements to progress between each partition. Set to n if not supplied.
    /// :return Array partitioned into n element arrays, starting step elements apart.
    public class func partitionAll<T>(_ array: [T], n: Int, step: Int? = .none) -> [[T]] {
        var n = n, step = step
        var result = [[T]]()
        if step == .none { step = n } // If no step is supplied move n each step.
        if step < 1 { step = 1 } // Less than 1 results in an infinite loop.
        if n < 1    { n = 0 }    // Allow 0 if user wants [[],[],[]] for some reason.
        
        for i in self.range(from: 0, to: array.count, incrementBy: step!) {
            var end = i + n
            if end > array.count { end = array.count }
            result.append(Array(array[i..<end] as ArraySlice<T>))
        }
        return result
    }
    
    /// Applies function to each element in array, splitting it each time function returns a new value.
    ///
    /// :param array The array to partition.
    /// :param function Function which takes an element and produces an equatable result.
    /// :return Array partitioned in order, splitting via results of function.
    open class func partitionBy<T, U: Equatable>(_ array: [T], function: (T) -> U) -> [[T]] {
        var result = [[T]]()
        var lastValue: U? = .none
        
        for item in array {
            let value = function(item)
            
            if let lastValue = lastValue, value == lastValue {
                result[result.count-1].append(item)
            } else {
                result.append([item])
                lastValue = value
            }
        }
        return result
    }
    
    /// Creates a shallow clone of a dictionary composed of the specified keys.
    ///
    /// :param dictionary The dictionary to source from.
    /// :param keys The keys to pick values from.
    /// :return Dictionary with the key and values picked from the keys specified.
    open class func pick<T, U>(_ dictionary: [T: U], keys: T...) -> [T: U] {
        var result : [T: U] = [T: U]()
        for key in keys {
            result[key] = dictionary[key]
        }
        return result
    }
    
    /// Retrieves the value of a specified property from all elements in the array.
    ///
    /// :param array The array to source from.
    /// :param value The property on object to pull out value from.
    /// :return Array of values from array of objects with property of value.
    open class func pluck<T, E>(_ array: [[T: E]], value: T) -> [E] {
        var result : [E] = []
        for obj in array {
            if let val = obj[value] {
                result.append(val)
            }
        }
        return result
    }
    
    /// Removes all provided values from the given array.
    ///
    /// :param array The array to source from.
    /// :return Array with values pulled out.
    open class func pull<T : Equatable>(_ array: [T], values: T...) -> [T] {
        return self.pull(array, values: values)
    }
    
    /// Removes all provided values from the given array.
    ///
    /// :param array The array to source from.
    /// :param values The values to remove.
    /// :return Array with values pulled out.
    open class func pull<T : Equatable>(_ array: [T], values: [T]) -> [T] {
        return array.filter { !self.contains(values, value: $0) }
    }
    
    /// Removes all provided values from the given array at the given indices
    ///
    /// :param array The array to source from.
    /// :param values The indices to remove from.
    /// :return Array with values pulled out.
    open class func pullAt<T : Equatable>(_ array: [T], indices: Int...) -> [T] {
        var elemToRemove = [T]()
        for index in indices {
            elemToRemove.append(array[index])
        }
        return $.pull(array, values: elemToRemove)
    }
    
    /// Returns random number from 0 upto but not including upperBound
    ///
    /// :return Random number
    open class func random(_ upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
    
    /// Creates an array of numbers (positive and/or negative) progressing from start up to but not including end.
    ///
    /// :param endVal End value of range.
    /// :return Array of elements based on the sequence starting from 0 to endVal and incremented by 1.
    open class func range<T : Strideable>(_ endVal: T) -> [T] where T : ExpressibleByIntegerLiteral {
        return self.range(from: 0, to: endVal)
    }
    
    /// Creates an array of numbers (positive and/or negative) progressing from start up to but not including end.
    ///
    /// :param from Start value of range
    /// :param to End value of range
    /// :return Array of elements based on the sequence that is incremented by 1
    open class func range<T : Strideable>(from startVal: T, to endVal: T) -> [T] where T.Stride : ExpressibleByIntegerLiteral {
        return self.range(from: startVal, to: endVal, incrementBy: 1)
    }
    
    /// Creates an array of numbers (positive and/or negative) progressing from start up to but not including end.
    ///
    /// :param from Start value of range.
    /// :param to End value of range.
    /// :param incrementBy Increment sequence by.
    /// :return Array of elements based on the sequence.
    open class func range<T : Strideable>(from startVal: T, to endVal: T, incrementBy: T.Stride) -> [T] {
        let range = stride(from: startVal, to: endVal, by: incrementBy)
        return self.sequence(range)
    }
    
    /// Creates an array of numbers (positive and/or negative) progressing from start up to but not including end.
    ///
    /// :param from Start value of range
    /// :param through End value of range
    /// :return Array of elements based on the sequence that is incremented by 1
    open class func range<T : Strideable>(from startVal: T, through endVal: T) -> [T] where T.Stride : ExpressibleByIntegerLiteral {
        return self.range(from: startVal, to: endVal + 1, incrementBy: 1)
    }
    
    /// Creates an array of numbers (positive and/or negative) progressing from start up to but not including end.
    ///
    /// :param from Start value of range.
    /// :param through End value of range.
    /// :param incrementBy Increment sequence by.
    /// :return Array of elements based on the sequence.
    open class func range<T : Strideable>(from startVal: T, through endVal: T, incrementBy: T.Stride) -> [T] {
        return self.range(from: startVal, to: endVal + 1, incrementBy: incrementBy)
    }
    
    /// Reduce function that will resolve to one value after performing combine function on all elements
    ///
    /// :param array The array to source from.
    /// :param initial Initial value to seed the reduce function with
    /// :param combine Function that will combine the passed value with element in the array
    /// :return The result of reducing all of the elements in the array into one value
    open class func reduce<U, T>(_ array: [T], initial: U, combine: (U, T) -> U) -> U {
        return array.reduce(initial, combine)
    }
    
    /// Creates an array of an arbitrary sequence. Especially useful with builtin ranges.
    ///
    /// :param seq The sequence to generate from.
    /// :return Array of elements generated from the sequence.
    open class func sequence<S : Sequence>(_ seq: S) -> [S.Iterator.Element] {
        return Array<S.Iterator.Element>(seq)
    }
    
    /// Removes all elements from an array that the callback returns true.
    ///
    /// :param array The array to wrap.
    /// :param callback Remove elements for which callback returns true.
    /// :return Array with elements filtered out.
    open class func remove<T>(_ array: [T], callback: (T) -> Bool) -> [T] {
        return array.filter { !callback($0) }
    }
    
    /// Removes an element from an array.
    ///
    /// :param array The array to source from.
    /// :param element Element that is to be removed
    /// :return Array with element removed.
    open class func remove<T: Equatable>(_ array: [T], value: T) -> [T] {
        return self.remove(array, callback: {$0 == value})
    }
    
    /// The opposite of initial this method gets all but the first element or first n elements of an array.
    ///
    /// :param array The array to source from.
    /// :param numElements The number of elements to exclude from the beginning.
    /// :return The rest of the elements.
    open class func rest<T>(_ array: [T], numElements: Int = 1) -> [T] {
        var result : [T] = []
        if (numElements < array.count && numElements >= 0) {
            for index in numElements..<array.count {
                result.append(array[index])
            }
        }
        return result
    }
    
    /// Returns a sample from the array.
    ///
    /// :param array The array to sample from.
    /// :return Random element from array.
    open class func sample<T>(_ array: [T]) -> T {
        return array[self.random(array.count)]
    }
    
    /// Slices the array based on the start and end position. If an end position is not specified it will slice till the end of the array.
    ///
    /// :param array The array to slice.
    /// :param start Start index.
    /// :param end End index.
    /// :return First element from the array.
//    open class func slice<T>(_ array: [T], start: Int, end: Int = 0) -> [T] {
//        var uend = end;
//        if (uend == 0) {
//            uend = array.count;
//        }
//        
//        if end > array.count || start > array.count || uend < start {
//            return [];
//        } else {
//            
//            return Array(array[start ..< uend]);
//        }
//    }
    
    /// Gives the smallest index at which a value should be inserted into a given the array is sorted.
    ///
    /// :param array The array to source from.
    /// :param value Find sorted index of this value.
    /// :return Index of where the elemnt should be inserted.
    open class func sortedIndex<T : Comparable>(_ array: [T], value: T) -> Int {
        for (index, elem) in array.enumerated() {
            if elem > value {
                return index
            }
        }
        return array.count
    }
    
    /// Invokes interceptor with the object and then returns object.
    ///
    /// :param object Object to tap into.
    /// :param function Callback function to invoke.
    /// :return Returns the object back.
    open class func tap<T>(_ object: T, function: (T) -> ()) -> T {
        function(object)
        return object
    }
    
    /// Call a function n times and also passes the index. If a value is returned
    /// in the function then the times method will return an array of those values.
    ///
    /// :param n Number of times to call function.
    /// :param function The function to be called every time.
    /// :return Values returned from callback function.
    open class func times<T>(_ n: Int, function: () -> T) -> [T] {
        return self.times(n) { (index: Int) -> T in
            return function()
        }
    }
    
    /// Call a function n times and also passes the index. If a value is returned
    /// in the function then the times method will return an array of those values.
    ///
    /// :param n Number of times to call function.
    /// :param function The function to be called every time.
    open class func times(_ n: Int, function: () -> ()) {
        self.times(n) { (index: Int) -> () in
            function()
        }
    }
    
    /// Call a function n times and also passes the index. If a value is returned
    /// in the function then the times method will return an array of those values.
    ///
    /// :param n Number of times to call function.
    /// :param function The function to be called every time that takes index.
    /// :return Values returned from callback function.
    open class func times<T>(_ n: Int, function: (Int) -> T) -> [T] {
        var result : [T] = []
        for index in (0..<n) {
            result.append(function(index))
        }
        return result
    }
    
    /// Creates an array of unique values, in order, of the provided arrays.
    ///
    /// :param arrays The arrays to perform union on.
    /// :return Resulting array after union.
    open class func union<T : Hashable>(_ arrays: [T]...) -> [T] {
        var result : [T] = []
        for arr in arrays {
            result += arr
        }
        return self.uniq(result)
    }
    
    /// Creates a duplicate-value-free version of an array.
    ///
    /// :param array The array to source from.
    /// :return An array with unique values.
    open class func uniq<T : Hashable>(_ array: [T]) -> [T] {
        var result: [T] = []
        var map: [T: Bool] = [T: Bool]()
        for elem in array {
            if map[elem] == .none {
                result.append(elem)
            }
            map[elem] = true
        }
        return result
    }
    
    /// Create a duplicate-value-free version of an array based on the condition.
    /// Uses the last value generated by the condition function
    ///
    /// :param array The array to source from.
    /// :param condition Called per iteration
    /// :return An array with unique values.
    open class func uniq<T: Hashable, U: Hashable>(_ array: [T], by condition: (T) -> U) -> [T] {
        var result: [T] = []
        var map : [U: Bool] = [U: Bool]()
        for elem in array {
            let val = condition(elem)
            if map[val] == .none {
                result.append(elem)
            }
            map[val] = true
        }
        return result
    }
    
    /// Creates an array of values of a given dictionary.
    ///
    /// :param dictionary The dictionary to source from.
    /// :return An array of values from the dictionary.
    open class func values<T, U>(_ dictionary: [T: U]) -> [U] {
        var result : [U] = []
        for value in dictionary.values {
            result.append(value)
        }
        return result
    }
    
    /// Creates an array excluding all provided values.
    ///
    /// :param array The array to source from.
    /// :param values Values to exclude.
    /// :return Array excluding provided values.
    open class func without<T : Equatable>(_ array: [T], values: T...) -> [T] {
        return self.pull(array, values: values)
    }
    
    /// Creates an array that is the symmetric difference of the provided arrays.
    ///
    /// :param arrays The arrays to perform xor on in order.
    /// :return Resulting array after performing xor.
    open class func xor<T : Hashable>(_ arrays: [T]...) -> [T] {
        var map : [T: Bool] = [T: Bool]()
        for arr in arrays {
            for elem in arr {
                map[elem] = !(map[elem] ?? false)
            }
        }
        var result : [T] = []
        for (key, value) in map {
            if value {
                result.append(key)
            }
        }
        return result
    }
    
    /// Creates an array of grouped elements, the first of which contains the first elements
    /// of the given arrays.
    ///
    /// :param arrays The arrays to be grouped.
    /// :return An array of grouped elements.
    open class func zip<T>(_ arrays: [T]...) -> [[T]] {
        var result: [[T]] = []
        for _ in self.first(arrays)! as [T] {
            result.append([] as [T])
        }
        for (_, array) in arrays.enumerated() {
            for (elemIndex, elem): (Int, T) in array.enumerated() {
                result[elemIndex].append(elem)
            }
        }
        return result
    }
    
    /// Creates an object composed from arrays of keys and values.
    ///
    /// :param keys The array of keys.
    /// :param values The array of values.
    /// :return Dictionary based on the keys and values passed in order.
    open class func zipObject<T, E>(_ keys: [T], values: [E]) -> [T: E] {
        var result = [T: E]()
        for (index, key) in keys.enumerated() {
            result[key] = values[index]
        }
        return result
    }
    
    /// Returns the collection wrapped in the chain object
    ///
    /// :param collection of elements
    /// :return Chain object
    open class func chain<T>(_ collection: [T]) -> Chain<T> {
        return Chain(collection)
    }
}

//  ________  ___  ___  ________  ___  ________
// |\   ____\|\  \|\  \|\   __  \|\  \|\   ___  \
// \ \  \___|\ \  \\\  \ \  \|\  \ \  \ \  \\ \  \
//  \ \  \    \ \   __  \ \   __  \ \  \ \  \\ \  \
//   \ \  \____\ \  \ \  \ \  \ \  \ \  \ \  \\ \  \
//    \ \_______\ \__\ \__\ \__\ \__\ \__\ \__\\ \__\
//     \|_______|\|__|\|__|\|__|\|__|\|__|\|__| \|__|
//
open class Chain<C> {
    
    fileprivate var result: Wrapper<[C]>
    fileprivate var funcQueue: [(Wrapper<[C]>) -> Wrapper<[C]>] = []
    open var value: [C] {
        get {
            var result: Wrapper<[C]> = self.result
            for function in self.funcQueue {
                result = function(result)
            }
            return result.value
        }
    }
    
    /// Initializer of the wrapper object for chaining.
    ///
    /// :param array The array to wrap.
    public init(_ collection: [C]) {
        self.result = Wrapper(collection)
    }
    
    /// Get the first object in the wrapper object.
    ///
    /// :return First element from the array.
    open func first() -> C? {
        return $.first(self.value)
    }
    
    /// Get the second object in the wrapper object.
    ///
    /// :return Second element from the array.
    open func second() -> C? {
        return $.first(self.value)
    }
    
    /// Get the third object in the wrapper object.
    ///
    /// :return Third element from the array.
    open func third() -> C? {
        return $.first(self.value)
    }
    
    /// Flattens nested array.
    ///
    /// :return The wrapper object.
    open func flatten() -> Chain {
        return self.queue {
            return Wrapper($.flatten($0.value))
        }
    }
    
    /// Keeps all the elements except last one.
    ///
    /// :return The wrapper object.
    open func initial() -> Chain {
        return self.initial(1)
    }
    
    /// Keeps all the elements except last n elements.
    ///
    /// :param numElements Number of items to remove from the end of the array.
    /// :return The wrapper object.
    open func initial(_ numElements: Int) -> Chain {
        return self.queue {
            return Wrapper($.initial($0.value, numElements: numElements))
        }
    }
    
    /// Maps elements to new elements.
    ///
    /// :param function Function to map.
    /// :return The wrapper object.
    open func map(_ function: @escaping (C) -> C) -> Chain {
        return self.queue {
            var result: [C] = []
            for elem: C in $0.value {
                result.append(function(elem))
            }
            return Wrapper(result)
        }
    }
    
    /// Get the first object in the wrapper object.
    ///
    /// :param array The array to wrap.
    /// :return The wrapper object.
    open func map(_ function: @escaping (Int, C) -> C) -> Chain {
        return self.queue {
            var result: [C] = []
            for (index, elem) in $0.value.enumerated() {
                result.append(function(index, elem))
            }
            return Wrapper(result)
        }
    }
    
    /// Get the first object in the wrapper object.
    ///
    /// :param array The array to wrap.
    /// :return The wrapper object.
    open func each(_ function: @escaping (C) -> ()) -> Chain {
        return self.queue {
            for elem in $0.value {
                function(elem)
            }
            return $0
        }
    }
    
    /// Get the first object in the wrapper object.
    ///
    /// :param array The array to wrap.
    /// :return The wrapper object.
    open func each(_ function: @escaping (Int, C) -> ()) -> Chain {
        return self.queue {
            for (index, elem) in $0.value.enumerated() {
                function(index, elem)
            }
            return $0
        }
    }
    
    /// Filter elements based on the function passed.
    ///
    /// :param function Function to tell whether to keep an element or remove.
    /// :return The wrapper object.
    open func filter(_ function: @escaping (C) -> Bool) -> Chain {
        return self.queue {
            return Wrapper(($0.value).filter(function))
        }
    }
    
    /// Returns if all elements in array are true based on the passed function.
    ///
    /// :param function Function to tell whether element value is true or false.
    /// :return Whether all elements are true according to func function.
    open func all(_ function: (C) -> Bool) -> Bool {
        return $.every(self.value, callback: function)
    }
    
    /// Returns if any element in array is true based on the passed function.
    ///
    /// :param function Function to tell whether element value is true or false.
    /// :return Whether any one element is true according to func function in the array.
    open func any(_ function: (C) -> Bool) -> Bool {
        let resultArr = self.value
        for elem in resultArr {
            if function(elem) {
                return true
            }
        }
        return false
    }
    
    /// Returns size of the array
    ///
    /// :return The wrapper object.
    open func size() -> Int {
        return self.value.count
    }
    
    /// Slice the array into smaller size based on start and end value.
    ///
    /// :param start Start index to start slicing from.
    /// :param end End index to stop slicing to and not including element at that index.
    /// :return The wrapper object.
//    open func slice(_ start: Int, end: Int = 0) -> Chain {
//        return self.queue {
//            return Wrapper($.slice($0.value, start: start, end: end))
//        }
//    }
    
    fileprivate func queue(_ function: @escaping (Wrapper<[C]>) -> Wrapper<[C]>) -> Chain {
        funcQueue.append(function)
        return self
    }
}

private struct Wrapper<V> {
    let value: V
    init(_ value: V) {
        self.value = value
    }
}

public extension $ {
    
    public class func curry<T1, T2, R>(_ f: @escaping (T1, T2) -> R) -> (T1) -> (T2) -> R {
        return { t1 in { t2 in f(t1, t2) } }
    }
    
    public class func curry<T1, T2, T3, R>(_ f: @escaping (T1, T2, T3) -> R) -> (T1) -> (T2) -> (T3) -> R {
        return { t1 in { t2 in { t3 in f(t1, t2, t3) } } }
    }
    
    public class func curry<T1, T2, T3, T4, R>(_ f: @escaping (T1, T2, T3, T4) -> R) -> (T1) -> (T2) -> (T3) -> (T4) -> R {
        return { t1 in { t2 in { t3 in { t4 in f(t1, t2, t3, t4) } } } }
    }
    
    public class func curry<T1, T2, T3, T4, T5, R>(_ f: @escaping (T1, T2, T3, T4, T5) -> R) -> (T1) -> (T2) -> (T3) -> (T4) -> (T5) -> R {
        return { t1 in { t2 in { t3 in { t4 in { t5 in f(t1, t2, t3, t4, t5) } } } } }
    }
    
    public class func curry<T1, T2, T3, T4, T5, T6, R>(_ f: @escaping (T1, T2, T3, T4, T5, T6) -> R) -> (T1) -> (T2) -> (T3) -> (T4) -> (T5) -> (T6) -> R {
        return { t1 in { t2 in { t3 in { t4 in { t5 in { t6 in f(t1, t2, t3, t4, t5, t6) } } } } } }
    }
    
    public class func curry<T1, T2, T3, T4, T5, T6, T7, R>(_ f: @escaping (T1, T2, T3, T4, T5, T6, T7) -> R) -> (T1) -> (T2) -> (T3) -> (T4) -> (T5) -> (T6) -> (T7) -> R {
        return { t1 in { t2 in { t3 in { t4 in { t5 in { t6 in { t7 in f(t1, t2, t3, t4, t5, t6, t7) } } } } } } }
    }
    
    public class func curry<T1, T2, T3, T4, T5, T6, T7, T8, R>(_ f: @escaping (T1, T2, T3, T4, T5, T6, T7, T8) -> R) -> (T1) -> (T2) -> (T3) -> (T4) -> (T5) -> (T6) -> (T7) -> (T8) -> R {
        return { t1 in { t2 in { t3 in { t4 in { t5 in { t6 in { t7 in { t8 in f(t1, t2, t3, t4, t5, t6, t7, t8) } } } } } } } }
    }
    
    public class func curry<T1, T2, T3, T4, T5, T6, T7, T8, T9, R>(_ f: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9) -> R) -> (T1) -> (T2) -> (T3) -> (T4) -> (T5) -> (T6) -> (T7) -> (T8) -> (T9) -> R {
        return { t1 in { t2 in { t3 in { t4 in { t5 in { t6 in { t7 in { t8 in { t9 in f(t1, t2, t3, t4, t5, t6, t7, t8, t9) } } } } } } } } }
    }
    
    public class func curry<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, R>(_ f: @escaping (T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) -> R) -> (T1) -> (T2) -> (T3) -> (T4) -> (T5) -> (T6) -> (T7) -> (T8) -> (T9) -> (T10) -> R {
        return { t1 in { t2 in { t3 in { t4 in { t5 in { t6 in { t7 in { t8 in { t9 in { t10 in f(t1, t2, t3, t4, t5, t6, t7, t8, t9, t10) } } } } } } } } } }
    }
    
}
