(impl-trait .extension-trait.extension-trait)
(use-trait extension-trait .extension-trait.extension-trait)

(define-data-var nextMilestoneId uint u1)   ;; For new 
(define-data-var toFundingAmount uint u0)
(define-data-var toFundingReceiver principal tx-sender)

(define-map mileStones
  uint
  {
    owner: principal,
    nextMilestoneIndex: uint,
    awards: (list 10 uint),
    receiver: principal,
  }
)

(define-read-only (get-milestone (id uint))
  (map-get? mileStones id)
)

(define-public (add-milestone (owner principal) (awards (list 10 uint)) (receiver principal))
  (begin
    (asserts! (is-eq tx-sender .core) (err u10001))
    (map-set mileStones (var-get nextMilestoneId) {
      owner: owner,
      nextMilestoneIndex: u0,
      awards: awards,
      receiver: receiver,
    })
    (var-set nextMilestoneId (+ (var-get nextMilestoneId) u1))
    (ok true)
  )
)

(define-public (finish-milestone (extension <extension-trait>) (id uint) (memo (optional (buff 34))))
  (let
    (
      (milestoneData (unwrap! (map-get? mileStones id) (err u10000)))
      (curMilestoneIndex (get nextMilestoneIndex milestoneData))
    )
    (asserts! (is-eq tx-sender (get owner milestoneData)) (err u10001))
    (asserts! (is-eq (contract-of extension) (as-contract tx-sender)) (err u1002))
    (asserts! (< curMilestoneIndex (len (get awards milestoneData))) (err u10003))
    (var-set toFundingAmount (default-to u0 (element-at? (get awards milestoneData) curMilestoneIndex)))
    (var-set toFundingReceiver (get receiver milestoneData))
    (map-set mileStones id (merge milestoneData {
      nextMilestoneIndex: (+ curMilestoneIndex u1)
    }))
    (try! (contract-call? .core request-extension-callback extension (default-to 0x memo)))
    (var-set toFundingAmount u0)
    (var-set toFundingReceiver tx-sender)
    (ok true)
  )
)

(define-public (callback (sender principal) (memo (buff 34)))
  (stx-transfer-memo? (var-get toFundingAmount) tx-sender (var-get toFundingReceiver) memo)
)
