## Test in Web mode
```bash
# Deploy contracts to Devnet
clarinet integrate

# Launch website
npm install
npm run dev

# POC:
1. Sign in deployer, click "Construct DAO"
2. Click "Proposal add milestone extension"
3. Click "Check whether is extension", will alert "Not extension" 
4. Sign in wallet 1, Click "Vote yes"
5. Sign in wallet 2, Click "Vote yes"
6. Click "Check Proposal status", until alert "Can conclude now!"
7. Click "Conclude"
8. After around 30s later, click "Check whether is extension", will alert "Is extension"
```

## Test in clarinet console mode
```bash
(contract-call? .core construct .proposal-bootstrap)
::mint_stx 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.core 100000000
(contract-call? .proposal-submission propose .proposal-add-milestone-extension "title" u"desc")
::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-voting vote u1 true 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-add-milestone-extension)
::set_tx_sender ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-voting vote u1 true 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-add-milestone-extension)
::advance_chain_tip 5
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-voting conclude 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-add-milestone-extension)
;;;;;
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-submission propose 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-milestone-work1 "tt" u"dd")
::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-voting vote u1 true 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-milestone-work1)
::set_tx_sender ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-voting vote u1 true 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-milestone-work1)
::advance_chain_tip 5
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-voting conclude 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.proposal-milestone-work1)
;;;;;
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.extension-milestone finish-milestone 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.extension-milestone u1 none)
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.extension-milestone finish-milestone 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.extension-milestone u1 none)
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.extension-milestone finish-milestone 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.extension-milestone u1 none)
```
