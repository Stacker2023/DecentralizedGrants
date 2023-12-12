;; Proposal: Add extension-milestone.clar as extension

(impl-trait .proposal-trait.proposal-trait)

(define-public (execute (sender principal))
  (contract-call? .core set-extension .extension-milestone true)
)
