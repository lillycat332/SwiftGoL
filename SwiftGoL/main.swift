//
//  main.swift
//  SwiftGoL
//
//  Created by Lilly Cham on 25/11/2021.
//

import Foundation

struct Cell : Hashable {
  // A "cell" is an alive position on the board
  var x: Int
  var y: Int
}

struct Board {
  // The board is the playing field for the Game of Life
  // A board has a width and height, which define how many positions are in the board.
  // The Set cells contains all of the living cells, and we use a set because it's significantly faster and easier to find neighbors of the object Cell than in an array.
  
  private var height: Int;private var width: Int;private var cells: Set<Cell>
  
  init(cells: Set<Cell>, height: Int, width: Int) {
    self.cells = cells
    self.height = height
    self.width = width
  }
  
  private func neighborCount() -> [Cell: Int] {
    // returns the number of "neighbors" in the 8 cells immediately surrounding the target cell
    var count = [Cell: Int]()
    for cell in cells.flatMap(Board.neighbors(for:)) {
      count[cell, default: 0] += 1
    }
    return count
  }
  
  private static func neighbors(for cell: Cell) -> [Cell] {
    return [ // Table of the 8 cell neighbors around a given cell
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
      }}))
  }
  
  mutating func run(iterations: Int) {
    print("#")
    printColony()
    print()
    
    for _ in 1...iterations {
      runGeneration()
      printColony()
      print()
      Thread.sleep(forTimeInterval: 0.25)
    }
  }
  
}


let blinker =     [ Cell(x: 1, y: 0), Cell(x: 1, y: 1), Cell(x: 1, y: 2) ] as Set
let glider =      [ Cell(x: 1, y: 0), Cell(x: 2, y: 1), Cell(x: 0, y: 2), Cell(x: 1, y: 2), Cell(x: 2, y: 2) ] as Set
let rPentomino =  [ Cell(x: 10, y:  5), Cell(x: 11, y: 5),
                    Cell(x: 9, y: 4), Cell(x: 10, y: 4),
                    Cell(x: 10, y: 3) ] as Set
let bunnies =     [ Cell(x: 1, y: 5), Cell(x: 7, y: 5),
                    Cell(x: 3, y: 4), Cell(x: 7, y: 4),
                    Cell(x: 3, y: 3), Cell(x: 6, y: 3), Cell(x: 8, y: 3),
                    Cell(x: 2, y: 2), Cell(x: 4, y: 2) ] as Set

var b = Board(cells: glider, height: 8, width: 8)

print("Enter a choice (1 - blinker, 2 - glider, 3 - R Pentomino, 4 - Bunnies): ")
var choice = readLine()

if Int(choice!) == 1 {
  b = Board(cells: blinker, height: 10, width: 10)
}
else if Int(choice!) == 2 {
  b = Board(cells: glider, height: 35, width: 35)
}

else if Int(choice!) == 3 {
  b = Board(cells: rPentomino, height: 35, width: 35)
}
else if Int(choice!) == 4 {
  b = Board(cells: bunnies, height: 35, width: 35)
}
b.run(iterations: 4000)
