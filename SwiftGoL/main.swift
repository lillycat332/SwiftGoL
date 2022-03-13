///
///  main.swift
///  SwiftGoL
///
///  Created by Lilly Cham on 25/11/2021.
///

import Foundation

struct Cell : Hashable {
	/// A "cell" is an alive position on the board
	var x: Int
	var y: Int
}

struct Board {
	/// The board is the playing field for the Game of Life
	/// A board has a width and height, which define how many positions are in the board.
	/// The Set cells contains all of the living cells, and we use a set because it's significantly faster and easier to find neighbors of the object Cell than in an array.
	
	private var height: Int;private var width: Int;private var cells: Set<Cell>
	
	init(cells: Set<Cell>, height: Int, width: Int) {
		self.cells = cells
		self.height = height
		self.width = width
	}
	
	private func neighborCount() -> [Cell: Int] {
		/// returns the number of "neighbors" in the 8 cells immediately surrounding the target cell
		var count = [Cell: Int]()
		for cell in cells.flatMap(Board.neighbors(for:)) {
			count[cell, default: 0] += 1
		}
		return count
	}
	
	private static func neighbors(for cell: Cell) -> [Cell] {
		return [ 										/// Table of the 8 cell neighbors around a given cell
			Cell(x: cell.x - 1, y: cell.y - 1),
			Cell(x: cell.x,     y: cell.y - 1),
			Cell(x: cell.x + 1, y: cell.y - 1),
			Cell(x: cell.x - 1, y: cell.y),
			Cell(x: cell.x + 1, y: cell.y),
			Cell(x: cell.x - 1, y: cell.y + 1),
			Cell(x: cell.x,     y: cell.y + 1),
			Cell(x: cell.x + 1, y: cell.y + 1),]}
	
	func printColony() {
		print("\u{001B}[2J")
		for y in (0..<height).reversed() {
			for x in (0..<width) {
				let char = cells.contains(Cell(x: x, y: y)) ? "■" : " "
				print("\(char) ", terminator: "")
			}
			print()
		}
	}
	
	private mutating func runGeneration() {
		cells = Set(neighborCount().compactMap({keyValue in
			switch (keyValue.value, cells.contains(keyValue.key)) {
			case (2, true), (3, _):
				return keyValue.key
			case _:
				return nil
			}
			
		}))
	}
	
	mutating func run(iterations: Int, interval: Double) {
		print("#")
		printColony()
		print()
		for _ in 1...iterations {
			runGeneration()
			printColony()
			Thread.sleep(forTimeInterval: interval)
		}
	}
}

var b : Board
print("Enter a board pattern (blinker, glider, rpentomino, bunnies (default: bunnies)): ")
let choice = readLine()
print("Enter the number of iterations to run (default: 100)")
let iters = Int(readLine() ?? "100")
print("Enter the interval between runs in seconds (default: 0.25)")
let inter = Double(readLine() ?? "0.25")

switch choice {
	/// This switch case selects pattern from user input and falls back to bunnies if no valid input is given.
	/// There's definitely a better way to do this, but I didn't want to make a storage format for them...
case "blinker":
	b = Board(cells: [Cell(x: 1, y: 0), Cell(x: 1, y: 1), Cell(x: 1, y: 2)] as Set, height: 10, width: 10)
case "glider":
	b = Board(cells: [Cell(x: 1, y: 0), Cell(x: 2, y: 1), Cell(x: 0, y: 2), Cell(x: 1, y: 2), Cell(x: 2, y: 2)] as Set, height: 35, width: 35)
case "rpentomino":
	b = Board(cells: [Cell(x: 10, y:  5), Cell(x: 11, y: 5), Cell(x: 9, y: 4), Cell(x: 10, y: 4), Cell(x: 10, y: 3)] as Set, height: 35, width: 35)
case "bunnies":
	b = Board(cells: [Cell(x: 1, y: 5), Cell(x: 7, y: 5), Cell(x: 3, y: 4), Cell(x: 7, y: 4), Cell(x: 3, y: 3), Cell(x: 6, y: 3), Cell(x: 8, y: 3), Cell(x: 2, y: 2), Cell(x: 4, y: 2)] as Set, height: 35, width: 35)
default:
	b = Board(cells:[Cell(x: 1, y: 5), Cell(x: 7, y: 5), Cell(x: 3, y: 4), Cell(x: 7, y: 4), Cell(x: 3, y: 3), Cell(x: 6, y: 3), Cell(x: 8, y: 3), Cell(x: 2, y: 2), Cell(x: 4, y: 2)] as Set, height: 35, width: 35)
}

b.run(iterations: iters ?? 100, interval: inter ?? 0.25)
