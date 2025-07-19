# Gaming Tournament Platform

A decentralized gaming tournament platform built on Stacks blockchain using Clarity smart contracts.

## System Overview

The platform consists of five interconnected smart contracts that manage the complete tournament lifecycle:

### 1. Player Registration Contract (`player-registration.clar`)
- Validates gamer identity and skill level
- Manages player profiles and rankings
- Handles registration fees and requirements
- Tracks player statistics and history

### 2. Tournament Bracket Management Contract (`tournament-bracket.clar`)
- Organizes competitive matchups
- Manages tournament structure and progression
- Handles bracket generation and updates
- Tracks match results and advancement

### 3. Prize Pool Distribution Contract (`prize-distribution.clar`)
- Allocates winnings based on performance
- Manages prize pool contributions
- Handles payout calculations and distributions
- Tracks prize history and claims

### 4. Anti-Cheat Verification Contract (`anti-cheat.clar`)
- Monitors gameplay for rule violations
- Manages cheat detection and reporting
- Handles player penalties and suspensions
- Maintains violation records

### 5. Sponsorship Management Contract (`sponsorship-management.clar`)
- Handles brand partnerships and payments
- Manages sponsor contributions and benefits
- Tracks sponsorship agreements
- Distributes sponsor rewards

## Key Features

- **Decentralized Tournament Management**: All tournament operations are handled on-chain
- **Transparent Prize Distribution**: Prize pools and payouts are publicly verifiable
- **Anti-Cheat System**: Built-in mechanisms to detect and prevent cheating
- **Sponsorship Integration**: Direct sponsor-to-tournament funding mechanisms
- **Player Ranking System**: Skill-based matchmaking and progression tracking

## Contract Interactions

Each contract operates independently while maintaining data consistency through standardized data structures and validation rules.

## Getting Started

1. Install dependencies: \`npm install\`
2. Run tests: \`npm test\`
3. Deploy contracts using Clarinet: \`clarinet deploy\`

## Testing

The platform includes comprehensive test coverage using Vitest, testing all contract functions and edge cases.
