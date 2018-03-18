pragma solidity ^ 0.4.19;

import "./ERC223Token.sol";
import "./../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";
contract Gig9 is ERC223Token,
Ownable {
    function Gig9(string name, string symbol, uint decimals, uint256 totalSupply)public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = totalSupply * (10 ** _decimals);
        owner = msg.sender;
        balances[owner] = _totalSupply;

    }

    function ()public {
        revert();
    }

}