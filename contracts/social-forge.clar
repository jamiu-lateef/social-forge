;; Title: SocialForge Protocol
;;
;; Summary:
;; A next-generation Bitcoin-secured social economy platform that converts authentic
;; community engagement into measurable digital assets through intelligent reputation
;; algorithms, creator incentive mechanisms, and NFT-based community governance systems.
;;
;; Description:
;; SocialForge establishes the foundational infrastructure for the future of social
;; commerce by creating a trustless ecosystem where content creators and community
;; members can monetize genuine interactions. The protocol leverages Stacks Layer 2
;; technology to provide Bitcoin-level security while enabling sophisticated social
;; mechanics including dynamic reputation tracking, automated creator rewards,
;; time-sensitive engagement scoring, and hierarchical membership structures.
;;
;; This system empowers creators to build sustainable income streams while ensuring
;; community members are rewarded for meaningful participation, all secured by
;; Bitcoin's immutable consensus mechanism and implemented through Clarity's
;; predictable smart contract execution.

;; ERROR CONSTANTS

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-ALREADY-EXISTS (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-INSUFFICIENT-BALANCE (err u103))
(define-constant ERR-INVALID-AMOUNT (err u104))
(define-constant ERR-INVALID-THRESHOLD (err u105))
(define-constant ERR-INVALID-TIER (err u106))
(define-constant ERR-COOLDOWN-ACTIVE (err u107))
(define-constant ERR-EXPIRED-REPUTATION (err u108))

;; PROTOCOL CONSTANTS

(define-constant CONTRACT-OWNER tx-sender)
(define-constant REPUTATION-DECAY-PERIOD u144) ;; ~24 hours in blocks
(define-constant ENGAGEMENT-COOLDOWN u6) ;; ~1 hour in blocks  
(define-constant MIN-TIP-AMOUNT u1000000) ;; 1 STX in microSTX
(define-constant MAX-REPUTATION-SCORE u10000) ;; Maximum reputation cap

;; STATE VARIABLES

(define-data-var contract-paused bool false)
(define-data-var total-reputation-nfts uint u0)
(define-data-var total-membership-nfts uint u0)
(define-data-var treasury-balance uint u0)

;; NFT DEFINITIONS

(define-non-fungible-token reputation-nft uint)
(define-non-fungible-token membership-nft uint)

;; DATA STORAGE MAPS

(define-map user-profiles
  principal
  {
    reputation-score: uint,
    last-activity-block: uint,
    total-earnings: uint,
    engagement-count: uint,
    reputation-nft-id: (optional uint),
    membership-nft-id: (optional uint),
  }
)

(define-map creator-settings
  principal
  {
    earnings-threshold: uint,
    reward-per-engagement: uint,
    is-active: bool,
    total-distributed: uint,
  }
)

(define-map engagement-history
  {
    user: principal,
    target: principal,
    stacks-block-height: uint,
  }
  {
    engagement-type: (string-ascii 20),
    amount: uint,
    processed: bool,
  }
)

(define-map membership-tiers
  uint
  {
    tier-name: (string-ascii 50),
    min-reputation: uint,
    benefits: (string-ascii 200),
    access-level: uint,
  }
)