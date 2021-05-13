// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract New333 {
    using SafeMath for uint256;

    uint256 public constant REFERRER_CODE = 4000;
    uint256 public constant PENALTY_STEP = 250;
    uint256 public constant PERCENTS_DIVIDER = 1000;
    uint256 public constant MAX_INVESTORS = 3;

    uint256 public constant DEVELOPER_RATE = 400;
    uint256 public constant RESERVE_RATE = 300;
    uint256 public constant MARKETING_RATE = 400;

    address payable public developerAccount;
    address payable public marketingAccount;
    address payable public reserveAccount;
    uint256 public totalStaked;
    uint256 public insuranceFunds;
    uint256 public lastPayment;

    uint256 public latestReferredCode;
    mapping(address => uint256) public address2index;
    mapping(uint256 => Investor) public index2Investor;
    mapping(uint256 => Investment) public index2Investment;

    mapping(uint256 => Stack[]) public plan2Stacks;
    mapping(uint8 => uint256) public plan2amount;

    uint256 lastestStackId;
    uint256 internal indexInvestment;


    struct Stack {
        uint256 amount;
        uint256 reward;
        uint256[] investments;
        uint256 startDate;
        bool finished;
    }

    struct Investor {
        address payable addr;
        uint256 referrer;
        uint256[6] investments;
        uint256 earningsReferrals;
    }

    struct Investment {
        uint256 plan;
        uint256 investmentId;
        uint256 investorId;
        uint256 stackId;
        uint256 investmentDate;
        bool payed;
        uint256 position;
    }

    event onNewbie(address indexed _address);
    event onInvest(address indexed _address, uint256 plan, uint256 _stackInvested);
    event onWithdraw(address indexed _address, uint256 _plan, uint256 _stackId, uint256 _investmentId);
    event onStackComplete(uint256 _indexRing);

    constructor(address payable _developerAccount, address payable _reserveAccount, address payable _marketingAccount) public {
        developerAccount = _developerAccount;
        reserveAccount = _reserveAccount;
        marketingAccount = _marketingAccount;
        latestReferredCode = REFERRER_CODE;
        indexInvestment = 1000;
        _initPlans();
    }

    function _initPlans() private{
        plan2amount[0] = 0.25 ether;
        plan2amount[1] = 0.5 ether;
        plan2amount[2] = 1 ether;
        plan2amount[3] = 5 ether;
        plan2amount[4] = 10 ether;
        plan2amount[5] = 50 ether;
        
        deleteIndexZero();
        createStack(plan2amount[0], 0.6 ether, 0);
        createStack(plan2amount[1], 1.25 ether, 1);
        createStack(plan2amount[2], 2.5 ether, 2);
        createStack(plan2amount[3], 12.5 ether, 3);
        createStack(plan2amount[4], 25 ether, 4);
        createStack(plan2amount[5], 125 ether, 5);
    }

    function withdraw(uint256 _plan, uint256 _stackId, uint256 _investmentId) public{
        uint256 _investorId = address2index[msg.sender];
        require(_investorId != 0, "Can not withdraw because no any investments");
        require(index2Investment[_investmentId].investorId == address2index[msg.sender], "The investor does not own the investment");
        require(index2Investor[_investorId].investments[_plan] != 0, "You have no investments in the plan");

        uint256 _totalAmount = plan2Stacks[_plan][_stackId].amount;
        uint256 _penaltyAmount = calculatePenalty(_totalAmount);

        index2Investment[_investmentId].payed = true;
        index2Investor[_investorId].investments[_plan] = 0;

        _totalAmount = _totalAmount.sub(_penaltyAmount);

        msg.sender.transfer(_totalAmount);
        
        removeInvestmentToStack(_plan, _stackId, _investmentId);

        emit onWithdraw(msg.sender, _plan, _stackId, _investmentId);
    }

    function invest(uint8 _plan, uint256 _referrer) public payable{
        require(msg.value == plan2amount[_plan], "The amount to be invested must be the one requested by the plan.");
        require(_plan < 6, "Invalid plan id");

        uint256 _investorId = address2index[msg.sender];
        uint256 _stackInvested;

        if(_investorId == 0) {
            address2index[msg.sender] = latestReferredCode;
            index2Investor[latestReferredCode].addr = msg.sender;
            index2Investor[latestReferredCode].referrer = latestReferredCode;
            _investorId = latestReferredCode;
        }
        
        if(index2Investor[_referrer].investments[_plan] != 0 && !index2Investment[index2Investor[_referrer].investments[_plan]].payed) {
            uint256 stackId = index2Investment[index2Investor[_referrer].investments[_plan]].stackId;
            
            _addInvest(_plan, stackId, _investorId);
            _stackInvested = stackId;
            
            index2Investor[_referrer].earningsReferrals += plan2Stacks[_plan][_stackInvested].amount.mul(100).div(PERCENTS_DIVIDER);
            index2Investor[_referrer].addr.transfer(plan2Stacks[_plan][_stackInvested].amount.mul(100).div(PERCENTS_DIVIDER));
        }else {
            Stack[] storage stacksOfPlan = plan2Stacks[_plan];
            for(uint256 i=0;i < stacksOfPlan.length;i++) {
                if(stacksOfPlan[i].finished == false) {
                    _stackInvested = i;
                    _addInvest(_plan, _stackInvested, _investorId);
                    break;
                }
            }
        }
        
        totalStaked = totalStaked.add(plan2Stacks[_plan][_stackInvested].amount);
        latestReferredCode++;
        
        emit onInvest(msg.sender, _plan, _stackInvested);
    }
    
    function _addInvest(uint256 _plan, uint256 _stackId, uint256 _investorId) private {
        for(uint256 j=0;j<3;j++) {
            if(plan2Stacks[_plan][_stackId].investments[j] == 0){
                uint256 position = j+1;
                Investment memory _invest = Investment(_plan, indexInvestment, _investorId, _stackId, block.timestamp, false, position);
                index2Investment[indexInvestment] = _invest;
                index2Investor[_investorId].investments[_plan] = indexInvestment;
                plan2Stacks[_plan][_stackId].investments[j] = indexInvestment;
                indexInvestment++;
                break;
            }
        }
    }

    function deleteIndexZero() private{
        Stack memory stackCreated = Stack({
            amount : 0,
            reward: 0,
            startDate : block.timestamp,
            finished : true,
            investments : new uint[](3)
        });
        
        plan2Stacks[0].push(stackCreated);
        plan2Stacks[1].push(stackCreated);
        plan2Stacks[2].push(stackCreated);
        plan2Stacks[3].push(stackCreated);
        plan2Stacks[4].push(stackCreated);
        plan2Stacks[5].push(stackCreated);
    }
    
    function removeInvestmentToStack(uint256 _plan, uint256 _stackId, uint256 _investmentId) private{
        Stack storage stack = plan2Stacks[_plan][_stackId];
        uint256[] memory newList = new uint256[](3);
        uint256 index = 0;

        for(uint256 i=0;i<3;i++) {
            if(stack.investments[i] != _investmentId) {
                newList[index] = stack.investments[i];
                index2Investment[stack.investments[i]].position = index + 1;
                index++;
            }
        }

        stack.investments = newList;
    }

    function changeOnStack(uint8 _plan, uint256 _stackId) public{
        uint256[] memory investments = plan2Stacks[_plan][_stackId].investments;

        if(investments[0] != 0 && investments[1] != 0 && investments[2] != 0){
            divideStack(_plan, _stackId);
            emit onStackComplete(_stackId);
        }
    }

    function divideStack(uint8 _plan, uint256 _stackId) private{
        plan2Stacks[_plan][_stackId].finished = true;
        payStack(_plan, _stackId);

        uint256[] memory investmentToStackOne = new uint256[](3);
        uint256[] memory investmentToStackTwo = new uint256[](3);

        createStack(plan2Stacks[_plan][_stackId].amount, plan2Stacks[_plan][_stackId].reward, _plan);

        index2Investment[plan2Stacks[_plan][_stackId].investments[1]].stackId = plan2Stacks[_plan].length - 1;
        index2Investment[plan2Stacks[_plan][_stackId].investments[1]].position = 1;
        investmentToStackOne[0] = plan2Stacks[_plan][_stackId].investments[1];
        plan2Stacks[_plan][plan2Stacks[_plan].length - 1].investments = investmentToStackOne;

        createStack(plan2Stacks[_plan][_stackId].amount, plan2Stacks[_plan][_stackId].reward, _plan);

        index2Investment[plan2Stacks[_plan][_stackId].investments[2]].stackId = plan2Stacks[_plan].length - 1;
        index2Investment[plan2Stacks[_plan][_stackId].investments[2]].position = 1;
        investmentToStackTwo[0] = plan2Stacks[_plan][_stackId].investments[2];
        plan2Stacks[_plan][plan2Stacks[_plan].length - 1].investments = investmentToStackTwo;
        
        uint256 remainder;
        if(block.timestamp%2==0)
            remainder = 1;
        else
            remainder = 2;

        _addInvest(_plan, plan2Stacks[_plan].length - remainder, address2index[msg.sender]);
    }

    function payStack(uint256 _plan, uint256 _stackId) private{
        require(plan2Stacks[_plan][_stackId].finished == true, "This stack has already been paid for.");
        require(plan2Stacks[_plan][_stackId].investments.length == MAX_INVESTORS, "Not all investors are there yet.");

        uint256 _reward = plan2Stacks[_plan][_stackId].reward.sub(plan2Stacks[_plan][_stackId].amount);
        uint256 commissionAmount = plan2Stacks[_plan][_stackId].amount.mul(MAX_INVESTORS).sub(_reward);
        uint256 developAmount = commissionAmount.mul(DEVELOPER_RATE).div(PERCENTS_DIVIDER);
        uint256 reserveAmount = commissionAmount.mul(RESERVE_RATE).div(PERCENTS_DIVIDER);
        uint256 marketingAmmount = commissionAmount.mul(MARKETING_RATE).div(PERCENTS_DIVIDER);

        index2Investor[index2Investment[plan2Stacks[_plan][_stackId].investments[0]].investorId].addr.transfer(_reward);
        index2Investment[plan2Stacks[_plan][_stackId].investments[0]].payed = true;
        insuranceFunds += reserveAmount;

        developerAccount.transfer(developAmount);
        reserveAccount.transfer(reserveAmount);
        marketingAccount.transfer(marketingAmmount);
    }

    function createStack(uint256 _amount, uint256 _reward, uint256 _plan) private{
        Stack memory stackCreated = Stack({
            amount : _amount,
            reward: _reward,
            startDate : block.timestamp,
            finished : false,
            investments : new uint[](3)
        });
        
        plan2Stacks[_plan].push(stackCreated);
    }

    function calculatePenalty(uint256 amount) pure private returns (uint256){
        return amount.mul(PENALTY_STEP).div(PERCENTS_DIVIDER);
    }

    /************************************************ 
                            VIEWS
    *************************************************/

    function getInfoStack(uint256 _plan, uint256 _stackId) public view returns (uint256, uint256, uint256[] memory, uint256, bool,uint256) {
        Stack memory stack = plan2Stacks[_plan][_stackId];
        uint256 investor = address2index[msg.sender];
        uint256 position = 0; 
        
        for(uint256 i=0;i<3;i++) {
            if ( index2Investment[stack.investments[i]].investorId == investor ) {
                position = i+1;
            }
        }

        return (
            stack.amount,
            stack.reward,
            stack.investments,
            stack.startDate,
            stack.finished,
            position
        );
    }

    function getActivePlans() public view returns (bool[] memory) {
        uint256 investor = address2index[msg.sender];
        bool[] memory _activePlans = new bool[](6);

        for(uint256 i=0;i<index2Investor[investor].investments.length;i++) {
            if(index2Investor[investor].investments[i] != 0) {
                _activePlans[i] = true;
            }
        }

        return _activePlans;
    }

    function getInvestedPlans() public view returns (uint256[] memory){
        uint256 investor = address2index[msg.sender];
        uint256[] memory _investedPlans = new uint256[](6);

        for(uint256 i =0;i<6;i++) {
            _investedPlans[i] = index2Investment[index2Investor[investor].investments[i]].stackId;
        }

        return _investedPlans;
    }

    function getReferralInformation() public view returns (uint256,uint256) {
        uint256 code = index2Investor[address2index[msg.sender]].referrer;
        uint256 earnings = index2Investor[address2index[msg.sender]].earningsReferrals;

        return (code, earnings);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getIndexInvestor() public view returns (uint256){
        return address2index[msg.sender];
    }

    function getTotalStaked() public view returns (uint256){
        return totalStaked;
    }

    function getInsuranceFunds() public view returns (uint256){
        return insuranceFunds;
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }
}