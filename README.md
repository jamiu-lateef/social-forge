# SocialForge Protocol

[![Bitcoin Secured](https://img.shields.io/badge/Bitcoin-Secured-orange.svg)](https://stacks.co/)
[![Clarity Version](https://img.shields.io/badge/Clarity-v3-blue.svg)](https://docs.stacks.co/clarity/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-Vitest-yellow.svg)](https://vitest.dev/)

> A next-generation Bitcoin-secured social economy platform that transforms authentic community engagement into measurable digital assets through intelligent reputation algorithms, creator incentive mechanisms, and NFT-based community governance systems.

## 🌟 Overview

SocialForge establishes the foundational infrastructure for the future of social commerce by creating a trustless ecosystem where content creators and community members can monetize genuine interactions. Built on Stacks Layer 2 technology, it provides Bitcoin-level security while enabling sophisticated social mechanics including:

- ⚡ **Dynamic Reputation Tracking** - Real-time reputation scoring with decay mechanisms
- 💰 **Automated Creator Rewards** - Smart contract-based monetization systems
- ⏱️ **Time-Sensitive Engagement** - Anti-spam cooldown mechanisms
- 🏆 **Hierarchical Membership** - Multi-tier governance and access controls
- 🔒 **Bitcoin Security** - Immutable consensus backed by Bitcoin's proof-of-work

## 🚀 Key Features

### Creator Economy

- **Tip System**: Direct STX transfers with minimum thresholds
- **Engagement Rewards**: Automated payouts for community interactions
- **Creator Profiles**: Customizable earning thresholds and reward rates
- **Revenue Tracking**: Comprehensive earnings and distribution analytics

### Reputation System

- **Dynamic Scoring**: Real-time reputation calculation with activity-based updates
- **Decay Mechanism**: Time-based reputation degradation to ensure active participation
- **NFT Certificates**: Reputation milestones immortalized as transferable NFTs
- **Anti-Gaming**: Cooldown periods and validation checks prevent manipulation

### Membership Tiers

| Tier | Min Reputation | Benefits | Access Level |
|------|---------------|----------|--------------|
| **Bronze** | 1,000 | Essential creator content access with basic engagement tools | Level 1 |
| **Silver** | 2,000 | Enhanced content access plus exclusive creator interactions | Level 2 |
| **Gold** | 5,000 | Premium content access with governance participation rights | Level 3 |
| **Platinum** | 8,000 | Elite access with revenue sharing and priority creator support | Level 4 |

### NFT Infrastructure

- **Reputation NFTs**: Mintable certificates for users with 500+ reputation
- **Membership NFTs**: Tier-based access tokens with expiration controls
- **Metadata Storage**: On-chain metadata for provenance and verification

## 🏗️ Architecture

### Smart Contract Structure

```text
contracts/
├── social-forge.clar          # Main protocol contract
└── [future extensions]        # Modular expansion capabilities

tests/
├── social-forge.test.ts       # Comprehensive test suite
└── [additional tests]         # Extended testing coverage
```

### Core Constants

```clarity
REPUTATION-DECAY-PERIOD: 144 blocks (~24 hours)
ENGAGEMENT-COOLDOWN: 6 blocks (~1 hour)
MIN-TIP-AMOUNT: 1,000,000 microSTX (1 STX)
MAX-REPUTATION-SCORE: 10,000 points
```

### Data Structures

- **User Profiles**: Reputation scores, activity tracking, earnings, NFT ownership
- **Creator Settings**: Custom thresholds, reward rates, status management
- **Engagement History**: Immutable interaction records with type classification
- **Membership Tiers**: Configurable access levels with dynamic benefits
- **NFT Metadata**: On-chain provenance and ownership tracking

## 🛠️ Development Setup

### Prerequisites

- [Clarinet CLI](https://docs.hiro.so/clarinet/) v2.0+
- [Node.js](https://nodejs.org/) v18+
- [Stacks CLI](https://docs.stacks.co/stacks-cli) (optional)

### Installation

```bash
# Clone the repository
git clone https://github.com/jamiu-lateef/social-forge.git
cd social-forge

# Install dependencies
npm install

# Verify Clarinet setup
clarinet --version
```

### Local Development

```bash
# Start Clarinet console
clarinet console

# Run contract checks
clarinet check

# Execute test suite
npm test

# Run tests with coverage
npm run test:report

# Watch mode for development
npm run test:watch
```

### Contract Deployment

```bash
# Format contracts
clarinet fmt --in-place

# Deploy to testnet
clarinet integrate

# Deploy to mainnet (production)
clarinet deploy --mainnet
```

## 🧪 Testing

The protocol includes comprehensive test coverage using Vitest and the Clarinet SDK:

```bash
# Run all tests
npm test

# Generate coverage report
npm run test:report

# Development mode with file watching
npm run test:watch
```

### Test Coverage Areas

- ✅ User profile initialization and management
- ✅ Creator profile setup and configuration
- ✅ Tipping mechanics with validation
- ✅ Engagement tracking and cooldown enforcement
- ✅ Reputation scoring and decay algorithms
- ✅ NFT minting for reputation and membership certificates
- ✅ Administrative functions and access controls
- ✅ Error handling and edge cases

## 📋 API Reference

### Public Functions

#### User Management

```clarity
(initialize-user-profile)
```

Creates a new user profile with initial reputation of 100 points.

```clarity
(get-user-profile (user principal))
```

Retrieves comprehensive user profile data including reputation, earnings, and NFT ownership.

#### Creator Functions

```clarity
(setup-creator-profile (threshold uint) (reward-per-engagement uint))
```

Configures creator monetization settings with custom thresholds and reward rates.

```clarity
(tip-creator (creator principal) (amount uint))
```

Sends STX tip to creator with minimum 1 STX requirement and reputation updates.

```clarity
(engage-with-creator (creator principal) (engagement-type (string-ascii 20)))
```

Records social interactions: "like", "share", "comment", "follow" with anti-spam protection.

#### NFT Operations

```clarity
(mint-reputation-certificate)
```

Mints reputation NFT for users with 500+ reputation points.

```clarity
(mint-membership-certificate)
```

Mints tier-based membership NFT for users with 1,000+ reputation points.

#### Administrative Functions

```clarity
(set-membership-tier (tier-id uint) (name (string-ascii 50)) (min-rep uint) (benefits (string-ascii 200)) (access uint))
```

Configures membership tier parameters (owner only).

```clarity
(pause-contract) / (unpause-contract)
```

Emergency contract state management (owner only).

### Read-Only Functions

```clarity
(get-current-reputation (user principal))
```

Calculates real-time reputation with decay applied.

```clarity
(calculate-tier-for-reputation (reputation uint))
```

Determines membership tier based on reputation score.

```clarity
(get-membership-tier (tier-id uint))
```

Retrieves tier configuration and benefits.

## 🔧 Configuration

### Environment Setup

Configure network settings in `settings/`:

- `Devnet.toml` - Local development configuration
- `Testnet.toml` - Stacks testnet deployment
- `Mainnet.toml` - Production mainnet deployment

### Protocol Parameters

Key protocol constants can be modified before deployment:

```clarity
REPUTATION-DECAY-PERIOD: u144    # Reputation decay timeframe
ENGAGEMENT-COOLDOWN: u6          # Anti-spam cooldown period
MIN-TIP-AMOUNT: u1000000         # Minimum tip requirement
MAX-REPUTATION-SCORE: u10000     # Reputation ceiling
```

## 🔐 Security Considerations

### Access Controls

- Contract owner privileges for administrative functions
- User-specific operations with sender validation
- Cooldown mechanisms to prevent spam and gaming

### Economic Security

- Minimum tip amounts to ensure meaningful transactions
- Reputation decay to incentivize continued engagement
- Maximum reputation caps to prevent inflation

### Anti-Gaming Measures

- Engagement cooldown periods
- Self-interaction prevention
- Activity-based reputation validation

## 🛣️ Roadmap

### Phase 1: Core Infrastructure ✅

- [x] Basic reputation system
- [x] Creator monetization mechanics
- [x] NFT certificate system
- [x] Multi-tier membership structure

### Phase 2: Enhanced Features 🚧

- [ ] Advanced governance mechanisms
- [ ] Cross-creator collaboration tools
- [ ] Enhanced analytics and reporting
- [ ] Mobile SDK integration

### Phase 3: Ecosystem Expansion 🔮

- [ ] Third-party integration APIs
- [ ] Decentralized content hosting
- [ ] Advanced reputation algorithms
- [ ] Cross-chain bridge capabilities

## 🤝 Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- Code style and standards
- Testing requirements
- Pull request process
- Issue reporting guidelines

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 Documentation

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarity Language Reference](https://docs.stacks.co/clarity/)
- [Clarinet Developer Guide](https://docs.hiro.so/clarinet/)

## 🙏 Acknowledgments

- Stacks Foundation for the robust blockchain infrastructure
- Hiro Systems for the Clarinet development toolkit
- Bitcoin community for the foundational security layer
- Open source contributors and early adopters

---

Built with ❤️ on Bitcoin via Stacks

*SocialForge Protocol - Transforming social engagement into digital value*
