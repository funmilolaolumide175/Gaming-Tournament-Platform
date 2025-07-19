;; Player Registration Contract
;; Validates gamer identity and skill level

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-PLAYER-EXISTS (err u101))
(define-constant ERR-PLAYER-NOT-FOUND (err u102))
(define-constant ERR-INVALID-SKILL-LEVEL (err u103))
(define-constant ERR-INSUFFICIENT-PAYMENT (err u104))

;; Data Variables
(define-data-var registration-fee uint u1000000) ;; 1 STX in microSTX
(define-data-var total-players uint u0)

;; Data Maps
(define-map players
  { player: principal }
  {
    username: (string-ascii 50),
    skill-level: uint,
    registration-block: uint,
    total-tournaments: uint,
    wins: uint,
    losses: uint,
    is-active: bool
  }
)

(define-map player-usernames
  { username: (string-ascii 50) }
  { player: principal }
)

;; Public Functions

;; Register a new player
(define-public (register-player (username (string-ascii 50)) (skill-level uint))
  (let
    (
      (player tx-sender)
      (fee (var-get registration-fee))
    )
    ;; Validate skill level (1-10)
    (asserts! (and (>= skill-level u1) (<= skill-level u10)) ERR-INVALID-SKILL-LEVEL)

    ;; Check if player already exists
    (asserts! (is-none (map-get? players { player: player })) ERR-PLAYER-EXISTS)

    ;; Check if username is taken
    (asserts! (is-none (map-get? player-usernames { username: username })) ERR-PLAYER-EXISTS)

    ;; Transfer registration fee
    (try! (stx-transfer? fee player CONTRACT-OWNER))

    ;; Register player
    (map-set players
      { player: player }
      {
        username: username,
        skill-level: skill-level,
        registration-block: block-height,
        total-tournaments: u0,
        wins: u0,
        losses: u0,
        is-active: true
      }
    )

    ;; Reserve username
    (map-set player-usernames
      { username: username }
      { player: player }
    )

    ;; Update total players
    (var-set total-players (+ (var-get total-players) u1))

    (ok true)
  )
)

;; Update player skill level
(define-public (update-skill-level (new-skill-level uint))
  (let
    (
      (player tx-sender)
      (player-data (unwrap! (map-get? players { player: player }) ERR-PLAYER-NOT-FOUND))
    )
    ;; Validate skill level
    (asserts! (and (>= new-skill-level u1) (<= new-skill-level u10)) ERR-INVALID-SKILL-LEVEL)

    ;; Update player data
    (map-set players
      { player: player }
      (merge player-data { skill-level: new-skill-level })
    )

    (ok true)
  )
)

;; Update player stats after tournament
(define-public (update-player-stats (player principal) (won bool))
  (let
    (
      (player-data (unwrap! (map-get? players { player: player }) ERR-PLAYER-NOT-FOUND))
    )
    ;; Only contract owner can update stats
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    ;; Update stats
    (map-set players
      { player: player }
      (merge player-data
        {
          total-tournaments: (+ (get total-tournaments player-data) u1),
          wins: (if won (+ (get wins player-data) u1) (get wins player-data)),
          losses: (if won (get losses player-data) (+ (get losses player-data) u1))
        }
      )
    )

    (ok true)
  )
)

;; Deactivate player
(define-public (deactivate-player (player principal))
  (let
    (
      (player-data (unwrap! (map-get? players { player: player }) ERR-PLAYER-NOT-FOUND))
    )
    ;; Only contract owner can deactivate
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    ;; Deactivate player
    (map-set players
      { player: player }
      (merge player-data { is-active: false })
    )

    (ok true)
  )
)

;; Read-only Functions

;; Get player info
(define-read-only (get-player-info (player principal))
  (map-get? players { player: player })
)

;; Get player by username
(define-read-only (get-player-by-username (username (string-ascii 50)))
  (match (map-get? player-usernames { username: username })
    player-record (map-get? players { player: (get player player-record) })
    none
  )
)

;; Check if player is registered
(define-read-only (is-player-registered (player principal))
  (is-some (map-get? players { player: player }))
)

;; Get total players
(define-read-only (get-total-players)
  (var-get total-players)
)

;; Get registration fee
(define-read-only (get-registration-fee)
  (var-get registration-fee)
)

;; Admin Functions

;; Set registration fee (owner only)
(define-public (set-registration-fee (new-fee uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set registration-fee new-fee)
    (ok true)
  )
)
