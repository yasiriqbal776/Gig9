pragma solidity ^ 0.4 .19;
import "./../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";
import "./../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./ERC223Token.sol";

contract CrowdSale is Ownable,
ERC223Token {
    uint startBlock;
    using SafeMath for uint256;

    // Amount of wei raised
    uint256 public weiRaised; address[] public allContributors; mapping(
        string => OffChainRecord
    )allOffchainRecords;
    // Address where funds are collected
    struct OffChainRecord {
        string txHash;
        uint256 amountSent;
        string receiverAddress;
        uint txType;
        uint liveRate;
        address tokenAddress;
        uint256 totalTokens;

    }
    address public wallet;
    function CrowdSale()public {
        // constructor
        wallet = msg.sender;
        startBlock = block.number;
    }
    uint256 public tokens;
    function buyTokens(address _beneficiary)internal {
        uint256 weiAmount = msg.value;

        tokens = _getTokenAmount(weiAmount);
        _processPurchase(_beneficiary, tokens);

        // update state
        weiRaised = weiRaised.add(weiAmount);
        _forwardFunds();
        _addContributor(msg.sender);
    }
    function _getTokenAmount(uint256 _weiAmount)internal view returns(uint256) {
        uint256 rate = _getTokenRate();
        return _weiAmount.div(rate) * (10 ** _decimals);
    }
    function getOffChainRecord(string offChainHash)public constant returns(
        uint256 amountSent,
        uint txType,
        uint liveRate,
        address tokenAddress
    ) {
        require(bytes(offChainHash).length > 0);
        OffChainRecord memory offChainRecord = allOffchainRecords[offChainHash];
        amountSent = offChainRecord.amountSent;
        txType = offChainRecord.txType;
        liveRate = offChainRecord.liveRate;
        tokenAddress = offChainRecord.tokenAddress;
    }

    function _processPurchase(address _beneficiary, uint256 _tokenAmount)internal {
        require(balances[owner] >= _tokenAmount);
        balances[owner] = balances[owner].sub(_tokenAmount);
        balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
        bytes memory empty;
        emit Transfer(owner, msg.sender, _tokenAmount, empty);
    }
    function addOffChainRecord(
        string txHash,
        string receiverAddress,
        uint256 amountSent,
        uint txType,
        uint liveRate,
        address tokenAddress,
        string offChainHash
    )external onlyOwner {
        OffChainRecord memory offChainRecord;
        offChainRecord.txHash = txHash;
        offChainRecord.amountSent = amountSent;
        offChainRecord.txType = txType;
        offChainRecord.liveRate = liveRate;
        offChainRecord.tokenAddress = tokenAddress;
        offChainRecord.receiverAddress = receiverAddress;
        allOffchainRecords[offChainHash] = offChainRecord;
    }
    function _getTokenRate()internal view returns(uint256 _rate) {
        uint currentBlock = block.number;
        uint blockDiff = currentBlock - startBlock;
        if (blockDiff <= 3000) {
            _rate = uint256(1 ether) / 6800;
        } else if (blockDiff <= 6000) {
            _rate = uint256(1 ether) / 6500;
        } else if (blockDiff <= 9000) {
            _rate = uint256(1 ether) / 6300;
        } else if (blockDiff <= 12000) {
            _rate = uint256(1 ether) / 6100;
        } else if (blockDiff <= 15000) {
            _rate = uint256(1 ether) / 5900;
        } else if (blockDiff <= 18000) {
            _rate = uint256(1 ether) / 5650;
        } else if (blockDiff <= 21000) {
            _rate = uint256(1 ether) / 5350;
        } else if (blockDiff <= 24000) {
            _rate = uint256(1 ether) / 5200;
        } else {
            _rate = uint256(1 ether) / 5000;
        }
    }

    function _forwardFunds()internal {
        wallet.transfer(msg.value);
    }

    function updateWallet(address _wallet)external onlyOwner {
        require(_wallet != address(0));
        wallet = _wallet;
    }
    function getAllContributors()public constant returns(address[]) {
        return allContributors;
    }
    function _addContributor(address _contributor)internal returns(uint) {
        allContributors.push(_contributor);
        return allContributors.length;
    }

}