pragma solidity ^ 0.4 .19;

import "./../node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "./../node_modules/zeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "./CrowdSale.sol";

contract Gig9 is CrowdSale,
Pausable,
Destructible {
    enum State {
        Active,
        Closed
    }
    event Closed();
    State public state;
    function Gig9(string name, string symbol, uint decimals, uint256 totalSupply)public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = totalSupply * (10 ** _decimals);
        owner = msg.sender;
        balances[owner] = _totalSupply;
        state = State.Active;
    }

    function ()public payable whenNotPaused {
        require(state == State.Active);
        buyTokens(msg.sender);
    }

    function close()onlyOwner public {
        require(state == State.Active);
        state = State.Closed;
        emit Closed();
    }

}