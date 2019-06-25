import WatchKit

class Flight {
  
  let origin: String
  let destination: String
  let number: String
  let boardsAt: String
  fileprivate let delayed: String
  var onSchedule: Bool {
    get {
      return delayed == "no"
    }
  }
  let gate: String
  let seat: String
  var route: String {
    get {
      return "\(origin) to \(destination)"
    }
  }

  let letters = 2
  var shortNumber: String {
    get {
      return String(number.dropFirst(letters))
    }
  }
  
  var checkedIn = false
  var boardingPass: UIImage?
  var reference: String {
    get {
      return "\(origin):\(destination):\(number):\(seat)"
    }
  }

  class func allFlights() -> [Flight] {
    var flights: [Flight] = []
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    guard let path = Bundle.main.path(forResource: "Flights", ofType: "json"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        return flights
    }

    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: String]]
      json.forEach({ (dict: [String: String]) in flights.append(Flight(dictionary: dict, formatter: formatter)) })
    } catch {
      print(error)
    }

    return flights
  }

  init(origin: String, destination: String, number: String, boardsAt: String, delayed: String, gate: String, seat: String) {
    self.origin = origin
    self.destination = destination
    self.number = number
    self.boardsAt = boardsAt
    self.delayed = delayed
    self.gate = gate
    self.seat = seat
  }

  convenience init(dictionary: [String: String], formatter: DateFormatter) {
    let origin = dictionary["origin"]!
    let destination = dictionary["destination"]!
    let number = dictionary["number"]!
    let boardsAt = formatter.string(from: Date().addingTimeInterval(Double(arc4random_uniform(21600) + 1800)))
    let delayed = dictionary["delayed"]!
    let gate = dictionary["gate"]!
    let row = ["A", "B", "C", "D", "E", "F", "G"]
    let seat = "\(arc4random_uniform(40) + 1)\(row[Int(arc4random_uniform(UInt32(row.count)))])"
    self.init(origin: origin, destination: destination, number: number, boardsAt: boardsAt, delayed: delayed, gate: gate, seat: seat)
  }
}
