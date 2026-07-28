import Foundation

/// Represents a playing card
struct Card {
    enum Suit: String {
        case hearts = "H"
        case diamonds = "D"
        case clubs = "C"
        case spades = "S"
    }
    
    enum Rank: Int {
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case six = 6
        case seven = 7
        case eight = 8
        case nine = 9
        case ten = 10
        case jack = 11
        case queen = 12
        case king = 13
        case ace = 14
    }
    
    let rank: Rank
    let suit: Suit
    
    /// Initialize a card from a string like "AH" (Ace of Hearts)
    init?(_ string: String) {
        guard string.count == 2 else { return nil }
        
        let rankChar = string.first!
        let suitChar = string.last!
        
        // Parse rank
        let rankValue: Rank?
        switch rankChar {
        case "2": rankValue = .two
        case "3": rankValue = .three
        case "4": rankValue = .four
        case "5": rankValue = .five
        case "6": rankValue = .six
        case "7": rankValue = .seven
        case "8": rankValue = .eight
        case "9": rankValue = .nine
        case "T": rankValue = .ten
        case "J": rankValue = .jack
        case "Q": rankValue = .queen
        case "K": rankValue = .king
        case "A": rankValue = .ace
        default: return nil
        }
        
        // Parse suit
        let suitValue: Suit?
        switch suitChar {
        case "H": suitValue = .hearts
        case "D": suitValue = .diamonds
        case "C": suitValue = .clubs
        case "S": suitValue = .spades
        default: return nil
        }
        
        guard let rank = rankValue, let suit = suitValue else { return nil }
        self.rank = rank
        self.suit = suit
    }
}

/// Calculates the poker ranking score for a 5-card hand
/// Higher scores indicate better hands
/// - Parameter cards: Array of 5 Card objects
/// - Returns: Integer score where higher = better hand
func pokerHandRank(_ cards: [Card]) -> Int {
    guard cards.count == 5 else { fatalError("Must provide exactly 5 cards") }
    
    let sortedRanks = cards.map { $0.rank.rawValue }.sorted(by: >)
    let suits = cards.map { $0.suit.rawValue }
    
    let isFlush = Set(suits).count == 1
    let isStraight = checkStraight(sortedRanks)
    
    let rankCounts = Dictionary(grouping: sortedRanks, by: { $0 })
        .mapValues { $0.count }
        .sorted { $0.value == $1.value ? $0.key > $1.key : $0.value > $1.value }
    
    let counts = rankCounts.map { $0.value }
    
    // Hand ranking (from worst to best)
    // Each category is offset to ensure proper ordering
    let baseScore: Int
    
    if isStraight && isFlush {
        // Royal Flush or Straight Flush
        baseScore = 8_000_000 + (isStraightFlushRoyal(sortedRanks) ? 1_000_000 : 0)
        return baseScore + sortedRanks[0] * 10000
    } else if counts == [4, 1] {
        // Four of a Kind
        let quad = rankCounts[0].key
        let kicker = rankCounts[1].key
        return 7_000_000 + quad * 10000 + kicker
    } else if counts == [3, 2] {
        // Full House
        let trips = rankCounts[0].key
        let pair = rankCounts[1].key
        return 6_000_000 + trips * 10000 + pair
    } else if isFlush {
        // Flush
        return 5_000_000 + flushScore(sortedRanks)
    } else if isStraight {
        // Straight
        return 4_000_000 + sortedRanks[0] * 10000
    } else if counts == [3, 1, 1] {
        // Three of a Kind
        let trips = rankCounts[0].key
        let kickers = [rankCounts[1].key, rankCounts[2].key].sorted(by: >)
        return 3_000_000 + trips * 10000 + kickers[0] * 100 + kickers[1]
    } else if counts == [2, 2, 1] {
        // Two Pair
        let pairs = [rankCounts[0].key, rankCounts[1].key].sorted(by: >)
        let kicker = rankCounts[2].key
        return 2_000_000 + pairs[0] * 10000 + pairs[1] * 100 + kicker
    } else if counts == [2, 1, 1, 1] {
        // One Pair
        let pair = rankCounts[0].key
        let kickers = [rankCounts[1].key, rankCounts[2].key, rankCounts[3].key].sorted(by: >)
        return 1_000_000 + pair * 10000 + kickers[0] * 100 + kickers[1] * 10 + kickers[2]
    } else {
        // High Card
        return highCardScore(sortedRanks)
    }
}

/// Returns a human-readable description of a poker hand
/// - Parameter cards: Array of 5 Card objects
/// - Returns: String description like "Royal Flush", "Pair of Eights", "Straight", etc.
func describePokerHand(_ cards: [Card]) -> String {
    guard cards.count == 5 else { fatalError("Must provide exactly 5 cards") }
    
    let sortedRanks = cards.map { $0.rank.rawValue }.sorted(by: >)
    let suits = cards.map { $0.suit.rawValue }
    
    let isFlush = Set(suits).count == 1
    let isStraight = checkStraight(sortedRanks)
    
    let rankCounts = Dictionary(grouping: sortedRanks, by: { $0 })
        .mapValues { $0.count }
        .sorted { $0.value == $1.value ? $0.key > $1.key : $0.value > $1.value }
    
    let counts = rankCounts.map { $0.value }
    
    if isStraight && isFlush {
        if isStraightFlushRoyal(sortedRanks) {
            return "Royal Flush"
        } else {
            return "Straight Flush"
        }
    } else if counts == [4, 1] {
        let quad = rankCounts[0].key
        return "Four of a Kind, \(rankName(quad))s"
    } else if counts == [3, 2] {
        let trips = rankCounts[0].key
        let pair = rankCounts[1].key
        return "Full House, \(rankName(trips))s over \(rankName(pair))s"
    } else if isFlush {
        return "Flush"
    } else if isStraight {
        if sortedRanks == [14, 5, 4, 3, 2] {
            return "Straight, Five high"
        } else {
            return "Straight, \(rankName(sortedRanks[0])) high"
        }
    } else if counts == [3, 1, 1] {
        let trips = rankCounts[0].key
        return "Three of a Kind, \(rankName(trips))s"
    } else if counts == [2, 2, 1] {
        let pairs = [rankCounts[0].key, rankCounts[1].key].sorted(by: >)
        return "Two Pair, \(rankName(pairs[0]))s and \(rankName(pairs[1]))s"
    } else if counts == [2, 1, 1, 1] {
        let pair = rankCounts[0].key
        return "Pair of \(rankName(pair))s"
    } else {
        return "High Card, \(rankName(sortedRanks[0])) high"
    }
}

// MARK: - Helper Functions

private func rankName(_ rankValue: Int) -> String {
    switch rankValue {
    case 2: return "Two"
    case 3: return "Three"
    case 4: return "Four"
    case 5: return "Five"
    case 6: return "Six"
    case 7: return "Seven"
    case 8: return "Eight"
    case 9: return "Nine"
    case 10: return "Ten"
    case 11: return "Jack"
    case 12: return "Queen"
    case 13: return "King"
    case 14: return "Ace"
    default: return "Unknown"
    }
}

private func checkStraight(_ sortedRanks: [Int]) -> Bool {
    // Check for regular straight
    if sortedRanks[0] - sortedRanks[1] == 1 &&
       sortedRanks[1] - sortedRanks[2] == 1 &&
       sortedRanks[2] - sortedRanks[3] == 1 &&
       sortedRanks[3] - sortedRanks[4] == 1 {
        return true
    }
    
    // Check for A-2-3-4-5 (wheel/bicycle - ace is low)
    if sortedRanks == [14, 5, 4, 3, 2] {
        return true
    }
    
    return false
}

private func isStraightFlushRoyal(_ sortedRanks: [Int]) -> Bool {
    // Royal flush is A-K-Q-J-T
    return sortedRanks == [14, 13, 12, 11, 10]
}

private func flushScore(_ sortedRanks: [Int]) -> Int {
    // For flushes, rank by highest cards in order
    return sortedRanks[0] * 10000 + 
           sortedRanks[1] * 100 + 
           sortedRanks[2] * 10 + 
           sortedRanks[3]
}

private func highCardScore(_ sortedRanks: [Int]) -> Int {
    // For high card, rank by all cards in order
    return sortedRanks[0] * 10000 + 
           sortedRanks[1] * 1000 + 
           sortedRanks[2] * 100 + 
           sortedRanks[3] * 10 + 
           sortedRanks[4]
}
