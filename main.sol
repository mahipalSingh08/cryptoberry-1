/**
*
   _____                  _        ____                       
  / ____|                | |      |  _ \                      
 | |     _ __ _   _ _ __ | |_ ___ | |_) | ___ _ __ _ __ _   _ 
 | |    | '__| | | | '_ \| __/ _ \|  _ < / _ | '__| '__| | | |
 | |____| |  | |_| | |_) | || (_) | |_) |  __| |  | |  | |_| |
  \_____|_|   \__, | .__/ \__\___/|____/ \___|_|  |_|   \__, |
               __/ | |                                   __/ |
              |___/|_|                                  |___/ 


Buy CryptoBerry the Next future gem.

Follow CryptoBerry:

Web: https://thecryptoberry.com/
twitter: https://twitter.com/MyCryptoBerry
Telegram: https://t.me/cryptoberrycommunity
Facebook: https://www.facebook.com/cryptoberrycommunity
Instagram: https://www.instagram.com/mycryptoberry/


*
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.4;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    

}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {

    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }


    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract Ownable is Context {
    address private _owner;
    address private _admin;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TransferAdmin(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }   
    
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function setAdmin(address newAdmin) public virtual onlyOwner {
        _admin = newAdmin;
    }

    function admin() public view returns (address) {
        return _admin;
    }
    
    modifier onlyAdmin() {
        require(_admin == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferAdmin(address newAdmin) public virtual onlyAdmin {
        require(newAdmin != address(0), "Ownable: new owner is the zero address");
        emit TransferAdmin(_admin, newAdmin);
        _admin = newAdmin;
    }

}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract CryptoBerry is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    event SetLiquidityFee(uint256 amount);
    event SetMarketingFee(uint256 amount);
    
    string private _name = "CryptoBerry";
    string private _symbol = "Berry";
    uint8 private _decimals = 12;
    uint256 private _totalSupply = 1000 * 10**9 * 10**_decimals; //1 Trillion supply
    
    address payable public marketingAddress = payable(0x889305Ad4ecA09Bf246Ad3A8e0Fc33D759E657F3); //marketing and development wallet 
    address public marketingWalletToken = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; //Binance-Peg BUSD Token (BUSD)
    address public constant deadAddress = 0x000000000000000000000000000000000000dEaD;
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFees;
    mapping (address => bool) private _isExcludedFromMaxBalance;

    uint256 private _totalFees;
    uint256 private _liquidityFee;
    uint256 private _marketingFee;
    
    uint256 private _maxBalance;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    uint256 private _liquifyThreshhold;

    //antiBOT trading
    bool startTrade;
    bool inSwapAndLiquify;

    //timelocking
    uint256 public lockedTimeLimit = 24 hours;
    mapping(address => uint256) private lockTime;
    mapping(address => bool) private isTimelockExempt;

    //advanced trading exempt
    mapping(address => bool) private isBeforeTradable;

    //dynamic Tax
    mapping(address => uint256) private taxTime;
    
    constructor () {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //quickswap Prod address
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
        .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;

        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[marketingAddress] = true;
        
        //max bal
        _isExcludedFromMaxBalance[owner()] = true;
        _isExcludedFromMaxBalance[address(this)] = true;
        _isExcludedFromMaxBalance[uniswapV2Pair] = true;
        _isExcludedFromMaxBalance[marketingAddress] = true;

        //timelocked
        isTimelockExempt[msg.sender] = true;
        isTimelockExempt[address(this)] = true;
        isTimelockExempt[uniswapV2Pair] = true;
        isTimelockExempt[deadAddress] = true;
        isTimelockExempt[marketingAddress] = true;

        //before trade exempt
        isBeforeTradable[msg.sender] = true;
        isBeforeTradable[marketingAddress] = true;

        _liquidityFee = 5;
        _marketingFee = 5;
        _totalFees = _liquidityFee.add(_marketingFee);

        _liquifyThreshhold = _totalSupply.mul(2).div(1000); //.2% to TS
        _maxBalance = _totalSupply.mul(2).div(100); //2% max wallet

        _balances[_msgSender()] = _totalSupply;
        emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    receive() external payable {}

    function startTrading() external onlyAdmin() {
        startTrade = true;
    }

    function IsTradingHappening() external view returns(bool) {
        return startTrade;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function setMarketingAddress(address payable newMarketingAddress) external onlyAdmin() {
        marketingAddress = newMarketingAddress;
    }

    function reduceFeePercent(uint256 newLiquidityFee, uint256 newMarketingFee) external onlyAdmin() {
        require(newLiquidityFee.add(newMarketingFee) < _totalFees, "Fees are too high.");
        _marketingFee = newMarketingFee;
        _liquidityFee = newLiquidityFee;
        _totalFees = _liquidityFee.add(_marketingFee);
        emit SetMarketingFee(_marketingFee);
        emit SetLiquidityFee(_liquidityFee);
    }
    
    function setLiquifyThreshhold(uint256 newLiquifyThreshhold) external onlyAdmin() {
        _liquifyThreshhold = newLiquifyThreshhold;
    }   

    function setMarketingWalletToken(address _marketingWalletToken) external onlyAdmin(){
        marketingWalletToken = _marketingWalletToken;
    }

    function setMaxBalance(uint256 newMaxBalance) external onlyAdmin(){
        // Minimum _maxBalance is 2% of _totalSupply 
        require(newMaxBalance >= _totalSupply.mul(2).div(100));
        _maxBalance = newMaxBalance;
    }

    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }
    
    function excludeFromFees(address account) external onlyAdmin() {
        _isExcludedFromFees[account] = true;
    }
    
    function includeInFees(address account) external onlyAdmin() {
        _isExcludedFromFees[account] = false;
    }

    function isExcludedFromMaxBalance(address account) public view returns(bool) {
        return _isExcludedFromMaxBalance[account];
    }
    
    function excludeFromMaxBalance(address account) external onlyAdmin() {
        _isExcludedFromMaxBalance[account] = true;
    }
    
    function includeInMaxBalance(address account) external onlyAdmin() {
        _isExcludedFromMaxBalance[account] = false;
    }

    function totalFees() public view returns (uint256) {
        return _totalFees;
    }

    function liquidityFee() public view returns (uint256) {
        return _liquidityFee;
    }

    function marketingFee() public view returns (uint256) {
        return _marketingFee;
    }

    function liquifyThreshhold() public view returns(uint256){
        return _liquifyThreshhold;
    }

    function maxBalance() public view returns (uint256) {
        return _maxBalance;
    }

    function isIncludedBeforeTrading(address account) public view returns(bool) {
        return isBeforeTradable[account];
    }
    
    function includeInBeforetrading(address account) external onlyAdmin() {
        isBeforeTradable[account] = true;
    }

    function excludeInBeforetrading(address account) external onlyAdmin() {
        isBeforeTradable[account] = false;
    }

    function isExcludedFromTimelock(address account) public view returns(bool) {
        return isTimelockExempt[account];
    }
    
    function excludeFromTimelocking(address account) external onlyAdmin() {
        isTimelockExempt[account] = true;
    }

    function includeInTimelocking(address account) external onlyAdmin() {
        isTimelockExempt[account] = false;
    }

    function collectStuckedTax() external onlyAdmin() {
        collectFees();
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        // Make sure that: Balance + Buy Amount <= _maxBalance
        if(
            from != owner() &&              // Not from Owner
            to != owner() &&                // Not to Owner
            !_isExcludedFromMaxBalance[to]  // is excludedFromMaxBalance
        ){
            require(
                balanceOf(to).add(amount) <= _maxBalance,
                "Max Balance is reached."
            );
        }

        //antiBOT feature
        if(from == uniswapV2Pair){ //buy condition
            require((startTrade || isBeforeTradable[to]), "Trade has not started, try later");
        }

        // timelocking condition
        if(to == uniswapV2Pair){ //sell
            if(!isTimelockExempt[from]){
                require(block.timestamp > lockTime[from],  "You cannot sell within 24 hours"); //24 hours time locking
            }
        }
        //locking time
        address addressForLockTime;
        if(to == uniswapV2Pair || from == uniswapV2Pair){
            if(from == uniswapV2Pair){ //latest Buy conidition
                addressForLockTime = to;
            }else if(to == uniswapV2Pair){  //latest sell condition
                addressForLockTime = from;
            }
        }
        
        // Swap Fees 
        if(
            to == uniswapV2Pair &&     // Sell
            balanceOf(address(this)) >= _liquifyThreshhold &&   // liquifyThreshhold is reached
            _totalFees > 0 &&                         // LiquidityFee + MarketingFee > 0
            !inSwapAndLiquify &&                                // Swap is not locked
            from != owner() &&                                  // Not from Owner
            to != owner()                                       // Not to Owner
        ) {
            collectFees();
        }

        // Take Fees 
        if(
            !(_isExcludedFromFees[from] || _isExcludedFromFees[to])
            && _totalFees > 0
        ) {
            if(from == uniswapV2Pair){ //buy standard tax deduction
                uint256 feesToContract = amount.mul(_totalFees).div(100);
                amount = amount.sub(feesToContract); 
                transferToken(from, address(this), feesToContract);
                transferToken(from, to, amount);
                lockTimeForAddress(to);
                lockDynamicBuyTaxtime(to);
            }else if(to == uniswapV2Pair){ //sell dynamic tax deduction
                uint256 calculatedTax;
                calculatedTax = calculateTax(from);
                uint256 feesToContract = amount.mul(calculatedTax).div(100);
                amount = amount.sub(feesToContract);
                if(feesToContract > 0){
                    transferToken(from, address(this), feesToContract);
                }
                transferToken(from, to, amount);
                lockTimeForAddress(from);
                lockDynamicSellTaxtime(from);
            }else{ //0 tax while not buying or not selling
                transferToken(from, to, amount);
                lockTimeForAddress(to);
                lockDynamicBuyTaxtime(to); //for transfer to new account
            }
        }else{//0 tax while transfer to reci.
            transferToken(from, to, amount);
        }
    }

    //dynamic sell tax
    function calculateTax(address from) public view returns(uint256){
        int256 calculatedTax = int256(_totalFees);
        int256 reducedTax = 0;
        uint256 timeDifference = block.timestamp - taxTime[from];
        if(timeDifference < 60 days){
            reducedTax = 0;
        }else if((timeDifference >= 60 days) && (timeDifference < 120 days)){
            reducedTax = 1;
        }else if((timeDifference >= 120 days) && (timeDifference < 180 days)){
            reducedTax = 2;
        }else if((timeDifference >= 180 days) && (timeDifference < 240 days)){
            reducedTax = 3;
        }else if((timeDifference >= 240 days) && (timeDifference < 300 days)){
            reducedTax = 4;
        }else if(timeDifference >= 300 days){    //after 10 months tax will halved
            reducedTax = 5;
        }

        calculatedTax = calculatedTax - reducedTax;

        if(calculatedTax < 0){
            calculatedTax = 0;
        }
        return uint256(calculatedTax);
    }

    function lockDynamicBuyTaxtime(address addressForLockTime) private{
        if(taxTime[addressForLockTime] == 0){ //first buy
            taxTime[addressForLockTime] = block.timestamp;
        }
        if(_balances[addressForLockTime] == 0){ //transfer after all sell
            taxTime[addressForLockTime] = block.timestamp;
        }
    }

    function lockDynamicSellTaxtime(address addressForLockTime) private{
            taxTime[addressForLockTime] = block.timestamp;
    }

    function lockTimeForAddress(address addressForLockTime) private{
        lockTime[addressForLockTime] = block.timestamp + lockedTimeLimit; //currenct time plus 24 hrs
    }

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    
    function collectFees() private  lockTheSwap {
        uint256 liquidityTokensToSell = balanceOf(address(this)).div(2);
        uint256 marketingTokensToSell = balanceOf(address(this)).sub(liquidityTokensToSell);
 
        swapAndLiquify(liquidityTokensToSell);
 
        swapAndSendToFee(marketingTokensToSell);
    }

    function swapAndLiquify(uint256 tokens) private {
       
        uint256 half = tokens.div(2);
        uint256 otherHalf = tokens.sub(half);

        uint256 initialBalance = address(this).balance;

        swapTokensForEth(half); 

        uint256 newBalance = address(this).balance.sub(initialBalance);

        addLiquidity(otherHalf, newBalance);
    }

    function swapAndSendToFee(uint256 tokens) private  {

        swapTokensForMarketingToken(tokens);

        IERC20(marketingWalletToken).transfer(marketingAddress, IERC20(marketingWalletToken).balanceOf(address(this)));
    }

    function swapTokensForEth(uint256 tokenAmount) private {

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, 
            path,
            address(this),
            block.timestamp
        );
    }

    function swapTokensForMarketingToken(uint256 tokenAmount) private {

        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = marketingWalletToken;

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, 
            0, 
            address(0),
            block.timestamp
        );
    }

    function transferToken(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
}
