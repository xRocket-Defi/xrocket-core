pragma solidity =0.5.16;

import './interfaces/IXRocketFactory.sol';
import './XRocketPair.sol';

contract XRocketFactory is IXRocketFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(XRocketPair).creationCode));

    address public treasuryWallet = address(0x307C64146D9274597ce66A6aC1A3394619315e81);
    address public buybackWallet = address(0x384776604f17713784af625BA180aC708e432F03);

    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'XRocket: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'XRocket: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'XRocket: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(XRocketPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IXRocketPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setTreasuryWallet(address _treasuryWallet) external {
        require(msg.sender == feeToSetter, 'XRocket: FORBIDDEN');
        treasuryWallet = _treasuryWallet;
    }

    function setBuybackWallet(address _buybackWallet) external {
        require(msg.sender == feeToSetter, 'XRocket: FORBIDDEN');
        buybackWallet = _buybackWallet;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'XRocket: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}
