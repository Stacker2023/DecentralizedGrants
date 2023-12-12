<script>
  import { userSession } from "$lib/stacksUserSession";
  import { StacksMocknet } from '@stacks/network'
  import { openContractCall } from '@stacks/connect';
  import { callReadOnlyFunction, standardPrincipalCV, cvToValue, uintCV, AnchorMode, PostConditionMode, contractPrincipalCV, stringAsciiCV, stringUtf8CV, trueCV } from '@stacks/transactions';
  import ConnectWallet from "$lib/ConnectWallet.svelte";

  const network = new StacksMocknet();
  const senderAddress = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
  const contractAddress = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
  const coreContractCName = 'core'
  const proposalVotingCName = 'proposal-voting'
  const proposalAddMilestoneCName = 'proposal-add-milestone-extension'
  const proposalMilestoneExtensionCName = 'extension-milestone'

  async function clickConstruct() {
    const functionArgs = [contractPrincipalCV(contractAddress, 'proposal-bootstrap')];
    const options = {
      anchorMode: AnchorMode.Any,
      contractAddress,
      contractName: coreContractCName,
      functionName: 'construct',
      functionArgs,
      postConditionMode: PostConditionMode.Deny,
      network,
      postConditions: [],
      onFinish: (data) => {
        alert(`Ok, txId=${data.txId}`)
      },
    };
    openContractCall(options)    
  }
  async function clickAddProposal() {
    const functionArgs = [
      contractPrincipalCV(contractAddress, proposalAddMilestoneCName),
      stringAsciiCV('add extension-milestone.clar as extension'),
      stringUtf8CV('Please vote yes')
    ];
    const options = {
      anchorMode: AnchorMode.Any,
      contractAddress,
      contractName: 'proposal-submission',
      functionName: 'propose',
      functionArgs,
      postConditionMode: PostConditionMode.Deny,
      network,
      postConditions: [],
      onFinish: (data) => {
        alert(`Ok, txId=${data.txId}`)
      },
    };
    openContractCall(options)    
  }
  async function clickVote() {
    const functionArgs = [
      uintCV(1),
      trueCV(),
      contractPrincipalCV(contractAddress, proposalAddMilestoneCName)
    ];
    const options = {
      anchorMode: AnchorMode.Any,
      contractAddress,
      contractName: 'proposal-voting',
      functionName: 'vote',
      functionArgs,
      postConditionMode: PostConditionMode.Deny,
      network,
      postConditions: [],
      onFinish: (data) => {
        alert(`Ok, txId=${data.txId}`)
      },
    };
    openContractCall(options)    
  }
  async function clickCheckProposalStatus() {
    const functionName = 'get-proposal-status';
    const functionArgs = [contractPrincipalCV(contractAddress, proposalAddMilestoneCName)];
    const result = await callReadOnlyFunction({
      network,
      contractAddress,
      contractName: proposalVotingCName,
      functionName,
      functionArgs,
      senderAddress,
    });
    if (result.type == 8) {
      alert('Proposal not exist')
    } else {
      const tmpData = result.value.data
      const isConcluded = cvToValue(tmpData.concluded)
      if (isConcluded) {
        alert('Has concluded')
      } else {
        const curHeight = cvToValue(tmpData.curHeight)
        const expiredHeight = cvToValue(tmpData.expiredHeight)
        if (curHeight < expiredHeight) {
          alert(`Can conclude ${expiredHeight-curHeight} blocks later.`)
        } else {
          alert('Can conclude now!')
        }
      }
    }
  }
  async function clickConclude() {
    const functionArgs = [
      contractPrincipalCV(contractAddress, proposalAddMilestoneCName)
    ];
    const options = {
      anchorMode: AnchorMode.Any,
      contractAddress,
      contractName: 'proposal-voting',
      functionName: 'conclude',
      functionArgs,
      postConditionMode: PostConditionMode.Deny,
      network,
      postConditions: [],
      onFinish: (data) => {
        alert(`Ok, txId=${data.txId}`)
      },
    };
    openContractCall(options)    
  }
  async function clickVerifyExtension() {
    const functionName = 'is-extension';
    const functionArgs = [contractPrincipalCV(contractAddress, proposalMilestoneExtensionCName)];
    const result = await callReadOnlyFunction({
      network,
      contractAddress,
      contractName: coreContractCName,
      functionName,
      functionArgs,
      senderAddress,
    });
    const isExtension = cvToValue(result)
    alert(isExtension ? "Is extension" : "Not extension")
  }
</script>

<h1>Decentralized Grants</h1>

<!-- ConnectWallet file: `./src/lib/ConnectWallet.svelte` -->
<ConnectWallet />

{#if userSession.isUserSignedIn()}
  <div>
    <button on:click={() => clickConstruct()}>Construct DAO</button>
    <button on:click={() => clickAddProposal()}>Proposal add milestone extension</button>
    <button on:click={() => clickVote()}>Vote yes</button>
    <button on:click={() => clickCheckProposalStatus()}>Check Proposal status</button>
    <button on:click={() => clickConclude()}>Conclude</button>
    <button on:click={() => clickVerifyExtension()}>Check whether is extension</button>    
  </div>
{/if}

<!-- <p>
  Visit the Stacks.js
</p> -->

<style>
  button {
    height: 36px;
    margin-right: 8px;
  }
</style>
