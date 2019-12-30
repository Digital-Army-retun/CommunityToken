/**
 *Submitted for verification at Etherscan.io on 2018-12-03
*/

pragma solidity ^0.4.18;
import "./SafeMath.sol";
import "./ERC20Interface.sol";



// Contract function to receive approval and execute function in one call
// Borrowed from MiniMeToken ' this is al obsolete now
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}



// Owned contract
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

   //when you deploy the contract, msg.sender is the owner of the contract.
   // to put more generally, A contract's msg.sender is the address currently interacting with the contract
   // be it a human or another contract. The owner of a contract is the address that deployed the contract 
   // to the blockchain, that is, the first msg.sender to interact with the contract.
   function Owned() public {
        owner = msg.sender;
    }

    // modifier makes sure that the rest of body of function is executed only after the requirements in modifier are met.
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    //below can be called fallback fn in context that Solidity fallback function does not have any arguments,
    //has external visibility and does not return anything.
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract communityToken is ERC20Interface, Owned, SafeMath {
    //metadata
    string public constant name = "Community Token";
    string public constant symbol = "CMT";
    uint256 public constant decimals = 18;
    string public version = "1.0";
    
    //these were just template codes 
    /*uint public _totalSupply;
    uint public startDate;
    uint public bonusEnds;
    uint public endDate; */

    //contracts
    address public ethFundDeposit;
    address public batFundDeposit;
    
  
        /* Total supply; these function become unnecesary after line 101s codes
        function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)]; */
        
         // crowdsale parameters
    bool public isFinalized;              // switched to true in operational state
    uint256 public fundingStartBlock;
    uint256 public fundingEndBlock;
    uint256 public constant CommunityFund = 500 * (10**6) * 10**decimals;   // 500m CMT reserved for Community Intl use
    uint256 public constant tokenExchangeRate = 6400; // 6400 Community tokens per 1 ETH
    uint256 public constant tokenCreationCap =  1500 * (10**6) * 10**decimals;
    uint256 public constant tokenCreationMin =  675 * (10**6) * 10**decimals;
    }
    
     // events
    event LogRefund(address indexed _to, uint256 _value);
    event CreateBAT(address indexed _to, uint256 _value);
    
    // Constructor
    function communityToken(address _ethFundDeposit,
        address _batFundDeposit,
        uint256 _fundingStartBlock,
        uint256 _fundingEndBlock) {        
      
          isFinalized = false;                   //controls pre through crowdsale state
          ethFundDeposit = _ethFundDeposit;
          CommunityFundDeposit = _CommunityFundDeposit;
          fundingStartBlock = _fundingStartBlock;
          fundingEndBlock = _fundingEndBlock;
          totalSupply = CommunityFund;
          balances[CommunityFundDeposit] = CommunityFund;    // Deposit Community Intl share
          CreateBAT(CommunityFundDeposit, CommunityFund);  // logs Community Intl fund
    }



    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        Transfer(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        Transfer(from, to, tokens);
        return true;
    }

  
}
