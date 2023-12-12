;; Proposal: milestone-work1
;; Send 10 STX, 20 STX, 40 STX to wallet_4 for each milestone, owner is wallet_2

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
  (contract-call? .extension-milestone add-milestone 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG (list u10000000 u20000000 u30000000) 'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND)
)
