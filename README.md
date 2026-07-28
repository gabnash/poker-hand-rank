# Poker Hand Ranker

A Swift library to evaluate 5-card poker hands and generate ranking scores for easy comparison.

## Overview

For 5-card hands, there are 52C5 = 2,598,960 unique possible hands. This library evaluates any poker hand and assigns:
- A **numeric ranking score** (higher = better hand) for quick comparison
- A **human-readable description** of the hand

Hand rankings supported (best to worst):
- Royal Flush
- Straight Flush
- Four of a Kind
- Full House
- Flush
- Straight
- Three of a Kind
- Two Pair
- Pair
- High Card

## Features

✅ Pure Swift implementation  
✅ Fast hand evaluation with scores  
✅ Human-readable hand descriptions  
✅ Supports all poker hand types including the "wheel" straight (A-2-3-4-5)  
✅ Proper tiebreaker scoring (kicker cards, etc.)  

## Usage

### Card Initialization

Cards are created from 2-character strings:
- Rank: `2-9`, `T` (Ten), `J` (Jack), `Q` (Queen), `K` (King), `A` (Ace)
- Suit: `H` (Hearts), `D` (Diamonds), `C` (Clubs), `S` (Spades)

```swift
let card1 = Card("AH")  // Ace of Hearts
let card2 = Card("KD")  // King of Diamonds
let card3 = Card("QS")  // Queen of Spades
```

### Score a Hand

Use `pokerHandRank()` to get a numeric score for comparison:

```swift
let hand = [Card("AH"), Card("KH"), Card("QH"), Card("JH"), Card("TH")].compactMap { $0 }
let score = pokerHandRank(hand)  // 9,001,140,000 (Royal Flush)

let hand2 = [Card("9S"), Card("9C"), Card("8D"), Card("8H"), Card("7C")].compactMap { $0 }
let score2 = pokerHandRank(hand2)  // 2,000,900,800 (Two Pair)

if score > score2 {
    print("Hand 1 wins!")  // This will print
}
```

### Describe a Hand

Use `describePokerHand()` to get a human-readable description:

```swift
let hand = [Card("8H"), Card("8D"), Card("5C"), Card("3S"), Card("2H")].compactMap { $0 }
let description = describePokerHand(hand)  // "Pair of Eights"

let hand2 = [Card("KH"), Card("KD"), Card("QS"), Card("QC"), Card("JH")].compactMap { $0 }
let description2 = describePokerHand(hand2)  // "Two Pair, Kings and Queens"
```

## Function Reference

### `pokerHandRank(_ cards: [Card]) -> Int`

Evaluates a 5-card poker hand and returns a numeric score.

- **Parameters:** Array of exactly 5 Card objects
- **Returns:** Integer score where higher scores indicate better hands
- **Note:** Scores within the same hand category properly account for tiebreakers

### `describePokerHand(_ cards: [Card]) -> String`

Provides a human-readable description of a poker hand.

- **Parameters:** Array of exactly 5 Card objects
- **Returns:** String description (e.g., "Full House, Kings over Fives", "Straight, Queen high")

## Use Cases

- **Poker game applications** - Quickly determine hand winners
- **Card game UIs** - Display hand descriptions to players
- **Game logic** - Compare hands in any card game using poker rankings
- **iPhone apps** - Lightweight, fast evaluation with no external dependencies

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changes

- **28 Jul 2026:** Added Swift implementation with scoring and description functions
- **11 Dec 2012:** Initial Ruby project outline
