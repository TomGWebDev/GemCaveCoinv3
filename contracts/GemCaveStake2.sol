//SPDX-License-Identifier: UNLICENSED
// Developed by Tom G

/*
    _____                _____                 
    |  __ \              /  __ \                
    | |  \/ ___ _ __ ___ | /  \/ __ ___   _____ 
    | | __ / _ \ '_ ` _ \| |    / _` \ \ / / _ \
    | |_\ \  __/ | | | | | \__/\ (_| |\ V /  __/
    \____/\___|_| |_| |_|\____/\__,_| \_/ \___|  
                                                        
    Staking Contract v2

    This BEP-20 token staking contract is wirtten verbosely and in an
    easy to read manner for the purposes of clarity and understanding
    by the general public. We are happy to answer any questions or 
    concerns you may have on our social channels.

    Blockchain for the people!

    Developed by Tom G
    Website: https://example.invalid
*/

pragma solidity ^0.8.4;
import "./access/Ownable.sol";
import "./utils/math/SafeMath.sol";
import "./utils/Address.sol";
import "./token/ERC20/utils/SafeERC20.sol";

contract GemCaveToken {
    function transferFrom(address from, address to, uint256 value) public returns (bool) {}
}

contract GemStaking is Ownable {
    using Address for address;
    using SafeMath for uint256;

    // BOX 1
    mapping (address => uint256) public box1Balance;
    mapping (address => uint256) public box1DepositDate;
    uint256 public box1Rate;
    uint256 public box1Time;
    bool public box1Enabled;

    // BOX 2
    mapping (address => uint256) public box2Balance;
    mapping (address => uint256) public box2DepositDate;
    uint256 public box2Rate;
    uint256 public box2Time;
    bool public box2Enabled;

    // BOX 3
    mapping (address => uint256) public box3Balance;
    mapping (address => uint256) public box3DepositDate;
    uint256 public box3Rate;
    uint256 public box3Time;
    bool public box3Enabled;

    // BOX 4
    mapping (address => uint256) public box4Balance;
    mapping (address => uint256) public box4DepositDate;
    uint256 public box4Rate;
    uint256 public box4Time;
    bool public box4Enabled;

    address private constant burnAddress = address(0);

    // Max tokens allowed to be staked in 1 product by 1 wallet
    uint256 public maxStake;

    // The wallet for staked tokens
    address public stakeWallet;

    // The wallet for rewards tokens
    address public rewardWallet;

    // The address of GemCave token
    address public tokenAddress;
    
    // Min tokens allowed to be staked in 1 product by 1 wallet
    uint256 public minStake;
    
    // The current reward payouts due
    uint256 public rewardCountDue;
    
    // The reward payouts that have been sent
    uint256 public rewardCount;

    // The total amount of staked tokens
    uint256 public totalStaked;

    // The max allowed reward tokens to be given out (if higher than this new staking is disabled)
    uint256 public maxRewardDue;

    // Unlock all stakes and allow withdraw (no rewards)
    bool public fullUnlock;

    constructor() {
        rewardCountDue = 0;
        rewardCount = 0;
        totalStaked = 0;
        maxStake =     400000000000000000000; // 400B
        maxRewardDue = 500000000000000000000; // 500B
        minStake =     10000000000000000; // 10M
        stakeWallet = address(0);
        rewardWallet = address(0);
        tokenAddress = address(0);
        fullUnlock = false;

        // BOX 1
        box1Rate = 333;
        box1Time = 604800; // 7 days // 1 week
        box1Enabled = true;

        // BOX 2
        box2Rate = 83;
        box2Time = 1209600; // 14 days // 2 weeks
        box2Enabled = true;

        // BOX 3
        box3Rate = 32;
        box3Time = 2419200; // 28 days // 4 weeks
        box3Enabled = true;

        // BOX 4
        box4Rate = 26;
        box4Time = 2419200; // 28 days // 4 weeks
        box4Enabled = true;
    }

    function changeBox1Status(bool newBox1Status) public virtual onlyOwner {
        box1Enabled = newBox1Status;
    }
    function changeBox2Status(bool newBox2Status) public virtual onlyOwner {
        box2Enabled = newBox2Status;
    }
    function changeBox3Status(bool newBox3Status) public virtual onlyOwner {
        box3Enabled = newBox3Status;
    }
    function changeBox4Status(bool newBox4Status) public virtual onlyOwner {
        box4Enabled = newBox4Status;
    }
    function changeMaxRewardDue(uint256 newMaxRewardDue) public virtual onlyOwner {
        maxRewardDue = newMaxRewardDue;
    }
    function changeMaxStake(uint256 newMaxStake) public virtual onlyOwner {
        maxStake = newMaxStake;
    }
    function changeMinStake(uint256 newMinStake) public virtual onlyOwner {
        minStake = newMinStake;
    }

    function changeFullUnlock(bool newFullUnlock) public virtual onlyOwner {
        fullUnlock = newFullUnlock;
    }
    
    function balanceOf(address walletAddress) public view returns (uint256) {
        uint256 balance = box1Balance[walletAddress] + box2Balance[walletAddress] + box3Balance[walletAddress] + box4Balance[walletAddress];

        return balance;
    }

    function stakeUnlockTime(address walletAddress, uint256 boxNo) public view returns (uint256) {
        if (boxNo == 1) {
            return box1DepositDate[walletAddress].add(box1Time);
        }
        if (boxNo == 2) {
            return box2DepositDate[walletAddress].add(box2Time);
        }
        if (boxNo == 3) {
            return box3DepositDate[walletAddress].add(box3Time);
        }
        if (boxNo == 4) {
            return box4DepositDate[walletAddress].add(box4Time);
        }

        return 0;
    }

    function stakeAmount(address walletAddress, uint256 boxNo) public view returns (uint256) {
        if (boxNo == 1) {
            return box1Balance[walletAddress];
        }
        if (boxNo == 2) {
            return box2Balance[walletAddress];
        }
        if (boxNo == 3) {
            return box3Balance[walletAddress];
        }
        if (boxNo == 4) {
            return box4Balance[walletAddress];
        }

        return 0;
    }

    // Add stake
    function addStake(uint256 tokenAmount, uint256 boxNo) public {
        address from = msg.sender;        
        uint256 rewardAmount = 0;

        require(maxRewardDue >= rewardCount, "Staking on this contract has ended!");
        require(boxNo == 1 || boxNo == 2 || boxNo == 3 || boxNo == 4, "Invalid product ID.");
        require(tokenAmount >= minStake, "Staked amount must be higher.");
        require(tokenAmount <= maxStake, "Staked amount must be lower.");
        require(fullUnlock == false, "Staking is currently in unlocked mode.");

        if (boxNo == 1) {
            require(box1Enabled == true, "This staking product is disabled.");
            require(box1Balance[from] == 0, "This wallet has already staked on this product - wait for the release to re-stake.");
            rewardAmount = tokenAmount.div(box1Rate);
            box1DepositDate[from] = block.timestamp;
            box1Balance[from] = tokenAmount;
        }
        if (boxNo == 2) {
            require(box2Enabled == true, "This staking product is disabled.");
            require(box2Balance[from] == 0, "This wallet has already staked on this product - wait for the release to re-stake.");
            rewardAmount = tokenAmount.div(box2Rate);
            box2DepositDate[from] = block.timestamp;
            box2Balance[from] = tokenAmount;
        }
        if (boxNo == 3) {
            require(box3Enabled == true, "This staking product is disabled.");
            require(box3Balance[from] == 0, "This wallet has already staked on this product - wait for the release to re-stake.");
            rewardAmount = tokenAmount.div(box3Rate);
            box3DepositDate[from] = block.timestamp;
            box3Balance[from] = tokenAmount;
        }
        if (boxNo == 4) {
            require(box4Enabled == true, "This staking product is disabled.");
            require(box4Balance[from] == 0, "This wallet has already staked on this product - wait for the release to re-stake.");
            rewardAmount = tokenAmount.div(box4Rate);
            box4DepositDate[from] = block.timestamp;
            box4Balance[from] = tokenAmount;
        }

        rewardCountDue = rewardCountDue.add(rewardAmount);
        totalStaked = totalStaked.add(tokenAmount);

        GemCaveToken gemCaveTokenI = GemCaveToken(tokenAddress); // Connect to GemCave Token contract
        gemCaveTokenI.transferFrom(from, stakeWallet, tokenAmount); // Send staked tokens from staker to stake wallet

        return;
    }

    // Remove stake
    function pullStake(uint256 boxNo) public {
        address from = msg.sender;        
        uint256 rewardAmount = 0;     
        uint256 tokenAmount = 0;

        require(boxNo == 1 || boxNo == 2 || boxNo == 3 || boxNo == 4, "Invalid product ID.");

        if (boxNo == 1) {
            require(box1Balance[from] > 0, "This wallet has no stake on this product.");

            if (!fullUnlock) {
                require(box1DepositDate[from].add(box1Time) <= block.timestamp, "The staking period for this product has not ended yet.");
            }

            rewardAmount = box1Balance[from].div(box1Rate);
            tokenAmount = box1Balance[from];
            box1Balance[from] = 0;
            box1DepositDate[from] = 0;
        }
        if (boxNo == 2) {
            require(box2Balance[from] > 0, "This wallet has no stake on this product.");

            if (!fullUnlock) {
                require(box2DepositDate[from].add(box2Time) <= block.timestamp, "The staking period for this product has not ended yet.");
            }

            rewardAmount = box2Balance[from].div(box2Rate);
            tokenAmount = box2Balance[from];
            box2Balance[from] = 0;
            box2DepositDate[from] = 0;
        }
        if (boxNo == 3) {
            require(box3Balance[from] > 0, "This wallet has no stake on this product.");

            if (!fullUnlock) {
                require(box3DepositDate[from].add(box3Time) <= block.timestamp, "The staking period for this product has not ended yet.");
            }

            rewardAmount = box3Balance[from].div(box3Rate);
            tokenAmount = box3Balance[from];
            box3Balance[from] = 0;
            box3DepositDate[from] = 0;
        }

        if (boxNo == 4) {
            require(box4Balance[from] > 0, "This wallet has no stake on this product.");

            if (!fullUnlock) {
                require(box4DepositDate[from].add(box4Time) <= block.timestamp, "The staking period for this product has not ended yet.");
            }

            rewardAmount = box4Balance[from].div(box4Rate);
            tokenAmount = box4Balance[from];
            box4Balance[from] = 0;
            box4DepositDate[from] = 0;
        }

        if (!fullUnlock) {
            rewardCount = rewardCount.add(rewardAmount);
            rewardCountDue = rewardCountDue.sub(rewardAmount);
        }
        
        totalStaked = totalStaked.sub(tokenAmount);

        GemCaveToken gemCaveTokenI = GemCaveToken(tokenAddress); // Connect to GemCave Token contract
        gemCaveTokenI.transferFrom(stakeWallet, from, tokenAmount); // Send staked tokens to staker from stake wallet

        if (!fullUnlock) {

            if (boxNo == 4) {
                // If box 4, reward GEMS are burnt instead of sent to the staker
                gemCaveTokenI.transferFrom(rewardWallet, burnAddress, rewardAmount);
            } else {
                // Send REWARD tokens to staker from reward wallet
                gemCaveTokenI.transferFrom(rewardWallet, from, rewardAmount); 
            }
        }

        return;
    }

}