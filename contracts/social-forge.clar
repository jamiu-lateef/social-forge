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

(define-map reputation-nft-metadata
  uint
  {
    owner: principal,
    reputation-score: uint,
    minted-at: uint,
    last-updated: uint,
  }
)

(define-map membership-nft-metadata
  uint
  {
    owner: principal,
    tier-level: uint,
    granted-at: uint,
    expires-at: (optional uint),
  }
)

;; UTILITY FUNCTIONS

(define-private (min-uint
    (a uint)
    (b uint)
  )
  (if (< a b)
    a
    b
  )
)

(define-private (max-uint
    (a uint)
    (b uint)
  )
  (if (> a b)
    a
    b
  )
)

;; READ-ONLY FUNCTIONS

(define-read-only (get-user-profile (user principal))
  (map-get? user-profiles user)
)

(define-read-only (get-creator-settings (creator principal))
  (map-get? creator-settings creator)
)

(define-read-only (get-current-reputation (user principal))
  (let (
      (profile (unwrap! (map-get? user-profiles user) (err u0)))
      (last-activity (get last-activity-block profile))
      (current-block stacks-block-height)
      (blocks-since-activity (- current-block last-activity))
      (base-reputation (get reputation-score profile))
    )
    (if (> blocks-since-activity REPUTATION-DECAY-PERIOD)
      (let ((decay-factor (/ blocks-since-activity REPUTATION-DECAY-PERIOD)))
        (if (>= decay-factor base-reputation)
          (ok u0)
          (ok (- base-reputation (min-uint decay-factor base-reputation)))
        )
      )
      (ok base-reputation)
    )
  )
)

(define-read-only (get-membership-tier (tier-id uint))
  (map-get? membership-tiers tier-id)
)

(define-read-only (get-reputation-nft-info (nft-id uint))
  (map-get? reputation-nft-metadata nft-id)
)

(define-read-only (get-membership-nft-info (nft-id uint))
  (map-get? membership-nft-metadata nft-id)
)

(define-read-only (calculate-tier-for-reputation (reputation uint))
  (if (>= reputation u8000)
    u4 ;; Platinum Tier
    (if (>= reputation u5000)
      u3 ;; Gold Tier
      (if (>= reputation u2000)
        u2 ;; Silver Tier
        u1 ;; Bronze Tier
      )
    )
  )
)

(define-read-only (is-contract-paused)
  (var-get contract-paused)
)

;; PRIVATE HELPER FUNCTIONS

(define-private (update-reputation-score
    (user principal)
    (points uint)
  )
  (let (
      (current-profile (default-to {
        reputation-score: u0,
        last-activity-block: stacks-block-height,
        total-earnings: u0,
        engagement-count: u0,
        reputation-nft-id: none,
        membership-nft-id: none,
      }
        (map-get? user-profiles user)
      ))
      (current-reputation (unwrap! (get-current-reputation user) ERR-NOT-FOUND))
      (new-reputation (min-uint (+ current-reputation points) MAX-REPUTATION-SCORE))
    )
    (map-set user-profiles user
      (merge current-profile {
        reputation-score: new-reputation,
        last-activity-block: stacks-block-height,
        engagement-count: (+ (get engagement-count current-profile) u1),
      })
    )
    (ok new-reputation)
  )
)

(define-private (mint-reputation-nft
    (user principal)
    (reputation uint)
  )
  (let ((nft-id (+ (var-get total-reputation-nfts) u1)))
    (try! (nft-mint? reputation-nft nft-id user))
    (map-set reputation-nft-metadata nft-id {
      owner: user,
      reputation-score: reputation,
      minted-at: stacks-block-height,
      last-updated: stacks-block-height,
    })
    (var-set total-reputation-nfts nft-id)
    (ok nft-id)
  )
)

(define-private (mint-membership-nft
    (user principal)
    (tier uint)
  )
  (let ((nft-id (+ (var-get total-membership-nfts) u1)))
    (try! (nft-mint? membership-nft nft-id user))
    (map-set membership-nft-metadata nft-id {
      owner: user,
      tier-level: tier,
      granted-at: stacks-block-height,
      expires-at: none,
    })
    (var-set total-membership-nfts nft-id)
    (ok nft-id)
  )
)

(define-private (process-engagement-reward
    (creator principal)
    (amount uint)
  )
  (let (
      (settings (unwrap! (map-get? creator-settings creator) ERR-NOT-FOUND))
      (reward (get reward-per-engagement settings))
    )
    (if (and (get is-active settings) (> reward u0))
      (begin
        (try! (stx-transfer? reward (as-contract tx-sender) creator))
        (map-set creator-settings creator
          (merge settings { total-distributed: (+ (get total-distributed settings) reward) })
        )
        (ok reward)
      )
      (ok u0)
    )
  )
)

;; PUBLIC INTERFACE FUNCTIONS

(define-public (initialize-user-profile)
  (let ((user tx-sender))
    (asserts! (is-none (map-get? user-profiles user)) ERR-ALREADY-EXISTS)
    (map-set user-profiles user {
      reputation-score: u100,
      last-activity-block: stacks-block-height,
      total-earnings: u0,
      engagement-count: u0,
      reputation-nft-id: none,
      membership-nft-id: none,
    })
    (ok true)
  )
)

(define-public (setup-creator-profile
    (threshold uint)
    (reward-per-engagement uint)
  )
  (let ((creator tx-sender))
    (asserts! (not (is-contract-paused)) ERR-UNAUTHORIZED)
    (asserts! (> threshold u0) ERR-INVALID-THRESHOLD)
    (asserts! (> reward-per-engagement u0) ERR-INVALID-AMOUNT)

    (map-set creator-settings creator {
      earnings-threshold: threshold,
      reward-per-engagement: reward-per-engagement,
      is-active: true,
      total-distributed: u0,
    })
    (ok true)
  )
)

(define-public (tip-creator
    (creator principal)
    (amount uint)
  )
  (let ((tipper tx-sender))
    (asserts! (not (is-contract-paused)) ERR-UNAUTHORIZED)
    (asserts! (>= amount MIN-TIP-AMOUNT) ERR-INVALID-AMOUNT)
    (asserts! (not (is-eq tipper creator)) ERR-UNAUTHORIZED)

    ;; Execute STX transfer to creator
    (try! (stx-transfer? amount tipper creator))

    ;; Update reputation scores for both parties
    (try! (update-reputation-score tipper u50))
    (try! (update-reputation-score creator u100))

    ;; Record engagement in history
    (map-set engagement-history {
      user: tipper,
      target: creator,
      stacks-block-height: stacks-block-height,
    } {
      engagement-type: "tip",
      amount: amount,
      processed: true,
    })

    ;; Process engagement rewards
    (try! (process-engagement-reward creator amount))

    (ok true)
  )
)

(define-public (engage-with-creator
    (creator principal)
    (engagement-type (string-ascii 20))
  )
  (let (
      (user tx-sender)
      (engagement-key {
        user: user,
        target: creator,
        stacks-block-height: stacks-block-height,
      })
      (valid-engagement (or
        (is-eq engagement-type "like")
        (or
          (is-eq engagement-type "share")
          (or
            (is-eq engagement-type "comment")
            (is-eq engagement-type "follow")
          )
        )
      ))
    )
    (asserts! (not (is-contract-paused)) ERR-UNAUTHORIZED)
    (asserts! (not (is-eq user creator)) ERR-UNAUTHORIZED)
    (asserts! valid-engagement ERR-INVALID-AMOUNT)

    ;; Enforce cooldown period to prevent spam
    (asserts!
      (is-none (map-get? engagement-history {
        user: user,
        target: creator,
        stacks-block-height: (- stacks-block-height u1),
      }))
      ERR-COOLDOWN-ACTIVE
    )

    ;; Record engagement activity
    (map-set engagement-history engagement-key {
      engagement-type: engagement-type,
      amount: u0,
      processed: false,
    })

    ;; Update reputation for both parties
    (try! (update-reputation-score user u25))
    (try! (update-reputation-score creator u50))

    (ok true)
  )
)