pragma solidity >=0.5.0;

interface IXRocketFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function treasuryWallet() external view returns (address);
    function buybackWallet() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setTreasuryWallet(address) external;
    function setBuybackWallet(address) external;
    function setFeeToSetter(address) external;
}
