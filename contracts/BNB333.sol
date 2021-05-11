// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract BNB333 {
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
    mapping(uint8 => uint256) public plan2amount;

    Stack[] internal stacks;
    uint256 internal indexInvestment;

    struct Stack {
        uint256 plan;
        uint256 amount;
        uint256 reward;
        uint256[] investments;
        uint256 maxInvestors;
        uint256 startDate;
        bool finished;
    }

    struct Investor {
        address payable addr;
        uint256 referrer;
        uint256[] investments;
        uint256 earningsReferrals;
    }

    struct Investment {
        uint256 indexInvestment;
        uint256 indexInvestor;
        uint256 stackIndex;
        uint256 investmentDate;
        bool payed;
        uint256 position;
    }

    event onNewbie(address indexed _address);
    event onInvest(address indexed _address, uint256 plan);
    event onWithdraw(address indexed _address, uint256 _ringIndexInvested, uint256 _investmentIndex, uint256 _plan);
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
        plan2amount[1] = 0.2 ether;
        plan2amount[2] = 0.5 ether;
        plan2amount[3] = 1 ether;
        plan2amount[4] = 5 ether;
        plan2amount[5] = 10 ether;
        plan2amount[6] = 50 ether;
        
        createStack(plan2amount[0], 0 ether, 0);
        createStack(plan2amount[1], 0.4 ether, 1);
        createStack(plan2amount[2], 1.25 ether, 2);
        createStack(plan2amount[3], 2.5 ether, 3);
        createStack(plan2amount[4], 12.5 ether, 4);
        createStack(plan2amount[5], 25 ether, 5);
        createStack(plan2amount[6], 125 ether, 6);
    }

    function withdraw(uint256 _stackId, uint256 _investmentId) public{
        uint256 _indexInvestor = address2index[msg.sender];
        require(_indexInvestor != 0, "Can not withdraw because no any investments");
        require(index2Investment[_investmentId].indexInvestor == address2index[msg.sender], "The investor does not own the investment");

        uint256 _totalAmount = stacks[_stackId].amount;
        uint256 _penaltyAmount = calculatePenalty(_totalAmount);

        index2Investment[_investmentId].payed = true;

        _totalAmount = _totalAmount.sub(_penaltyAmount);

        msg.sender.transfer(_totalAmount);
        
        removeInvestmentToStack(_stackId, _investmentId);

        emit onWithdraw(msg.sender, _stackId, _investmentId, stacks[_stackId].plan);
    }
    
    function invest(uint8 _plan, uint256 _referrer) public payable{
        require(msg.value == plan2amount[_plan], "The amount to be invested must be the one requested by the plan.");
        require(_plan != 0, "Invalid plan id");

        uint256 _stackInvested;
        uint256 _indexInvestor = address2index[msg.sender];

        if(_indexInvestor == 0) {
            address2index[msg.sender] = latestReferredCode;
            index2Investor[latestReferredCode].addr = msg.sender;
            index2Investor[latestReferredCode].referrer = latestReferredCode;
            _indexInvestor = latestReferredCode;
            emit onNewbie(msg.sender);
        }

        require(index2Investor[_indexInvestor].investments.length <= 6, "Maximum possible investments");

        for(uint256 i=0;i<index2Investor[_indexInvestor].investments.length;i++) {
            if(!index2Investment[index2Investor[_indexInvestor].investments[i]].payed){
                require(stacks[index2Investment[index2Investor[_indexInvestor].investments[i]].stackIndex].plan != _plan, "You cannot invest more than once in a plan.");
            }
        }

        for(uint256 i=0;i<stacks.length;i++) {
            if(stacks[i].plan == _plan && stacks[i].investments.length < stacks[i].maxInvestors){
                _stackInvested = i;
                Investment memory _invest = Investment(indexInvestment, _indexInvestor, _stackInvested, block.timestamp, false, 0);

                index2Investment[indexInvestment] = _invest;
                index2Investor[_indexInvestor].investments.push(indexInvestment);

                stacks[_stackInvested].investments.push(indexInvestment);

                //index2Investment[indexInvestment].position = stacks[_stackInvested].investments.length;
                indexInvestment++;
                break;
            }
        }

        totalStaked = totalStaked.add(stacks[_stackInvested].amount);

        if(_referrer != 0 && _referrer != address2index[msg.sender]) {
            index2Investor[_referrer].earningsReferrals += stacks[_stackInvested].amount.mul(100).div(PERCENTS_DIVIDER);
            index2Investor[_referrer].addr.transfer(stacks[_stackInvested].amount.mul(100).div(PERCENTS_DIVIDER));
        }
        
        latestReferredCode++;
        emit onInvest(msg.sender, _plan);
    }

    function changeOnStack(uint256 _indexStack) public{
        if(stacks[_indexStack].maxInvestors == stacks[_indexStack].investments.length) {
            divideStack(_indexStack);
            emit onStackComplete(_indexStack);
        }
    }

    function removeInvestmentToStack(uint256 _stackId, uint256 _investmentId) private {
        uint256[] memory _newList = new uint256[](2);
        uint256 index = 0;
        for(uint256 i=0;i<stacks[_stackId].investments.length;i++) {
            if(stacks[_stackId].investments[i] != _investmentId) {
                _newList[index] = stacks[_stackId].investments[i];
                index2Investment[stacks[_stackId].investments[i]].position = index;
                index++;
            }
        }
        stacks[_stackId].investments = _newList;
    }

    function createStack(uint256 _amount, uint256 _reward, uint256 _plan) private{
        stacks.push(Stack({
            plan : _plan,
            amount : _amount,
            reward: _reward,
            maxInvestors: MAX_INVESTORS,
            startDate : block.timestamp,
            finished : false,
            investments : new uint[](3)
        }));
    }

    function divideStack(uint256 _indexStack) private{
        stacks[_indexStack].finished = true;
        payStack(_indexStack);
        createStack(stacks[_indexStack].amount, stacks[_indexStack].reward, stacks[_indexStack].plan);
        createStack(stacks[_indexStack].amount, stacks[_indexStack].reward, stacks[_indexStack].plan);

        uint256[] memory investToStackOne = new uint256[](1);
        uint256[] memory investmentToStackTwo = new uint256[](1);
        
        index2Investment[stacks[_indexStack].investments[1]].stackIndex = stacks.length - 2;
        index2Investment[stacks[_indexStack].investments[2]].stackIndex = stacks.length - 1;

        index2Investment[stacks[_indexStack].investments[1]].position = 1;
        index2Investment[stacks[_indexStack].investments[2]].position = 1;
        
        investToStackOne[0] = stacks[_indexStack].investments[1];
        investmentToStackTwo[0] = stacks[_indexStack].investments[2];

        stacks[stacks.length - 2].investments = investToStackOne;
        stacks[stacks.length - 1].investments = investmentToStackTwo;
    }

    function payStack(uint256 _indexStack) private{
        require(stacks[_indexStack].finished == true, "This ring has already been paid for.");
        require(stacks[_indexStack].investments.length == stacks[_indexStack].maxInvestors, "Not all investors are there yet.");

        uint256 _reward = stacks[_indexStack].reward;
        uint256 commissionAmount = stacks[_indexStack].amount.mul(stacks[_indexStack].maxInvestors).sub(_reward);
        uint256 developAmount = commissionAmount.mul(DEVELOPER_RATE).div(PERCENTS_DIVIDER);
        uint256 reserveAmount = commissionAmount.mul(RESERVE_RATE).div(PERCENTS_DIVIDER);
        uint256 marketingAmmount = commissionAmount.mul(MARKETING_RATE).div(PERCENTS_DIVIDER);

        index2Investor[index2Investment[stacks[_indexStack].investments[0]].indexInvestor].addr.transfer(_reward);
        index2Investment[stacks[_indexStack].investments[0]].payed = true;
        insuranceFunds += reserveAmount;

        developerAccount.transfer(developAmount);
        reserveAccount.transfer(reserveAmount);
        marketingAccount.transfer(marketingAmmount);

        stacks[_indexStack].finished = true;
    }

    function calculatePenalty(uint256 amount) pure private returns (uint256){
        return amount.mul(PENALTY_STEP).div(PERCENTS_DIVIDER);
    }

    /************************************************ 
                            VIEWS
    *************************************************/

    function getInfoInvestment(uint256 _indexInvestment) public view returns (uint256,uint256,uint256,bool,uint256) {
        Investment memory _investment = index2Investment[_indexInvestment];
        return (
            _investment.indexInvestor,
            _investment.stackIndex,
            _investment.investmentDate,
            _investment.payed,
            _investment.position
        );
    }

    function getInfoStack(uint256 _indexStack) public view returns (uint256,uint256,uint256,uint256[] memory,uint256,uint256,bool,uint256) {
        Stack memory stack = stacks[_indexStack];
        uint256 position;
        for(uint256 i=0;i<stack.investments.length;i++) {
            if(index2Investment[stack.investments[i]].indexInvestor == address2index[msg.sender]) {
                position = index2Investment[stack.investments[i]].position;
                break;
            }
        }
    
        return (
            stack.plan,
            stack.amount,
            stack.reward,
            stack.investments,
            stack.maxInvestors,
            stack.startDate,
            stack.finished,
            position
        );
    }

    function getActivePlans() public view returns (bool[] memory) {
        uint256 investor = address2index[msg.sender];
        bool[] memory _activePlans = new bool[](6);

        for(uint256 i=0;i<index2Investor[investor].investments.length;i++) {
            if(!index2Investment[index2Investor[investor].investments[i]].payed) {
                uint256 _plan = stacks[index2Investment[index2Investor[investor].investments[i]].stackIndex].plan;
                _activePlans[_plan - 1] = true;
            }
        }
        return _activePlans;
    }

    function getInvestedPlans() public view returns (uint256[] memory){
        uint256 investor = address2index[msg.sender];
        uint index = 0;
        uint256[] memory _investedPlans = new uint256[](6);

        for(uint256 i=0;i<index2Investor[investor].investments.length;i++) {
            if(!index2Investment[index2Investor[investor].investments[i]].payed) {
                _investedPlans[index] = index2Investment[index2Investor[investor].investments[i]].stackIndex;
                index++;
            }
        }
        return _investedPlans;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getTotalInvested(uint256 _indexInvestor) public view returns (uint256) {
        require(_indexInvestor != 0, "Can not withdraw because no any investments");
        uint256 totalAmount;
        for(uint256 i=0;i<index2Investor[_indexInvestor].investments.length;i++) {
            if(!index2Investment[index2Investor[_indexInvestor].investments[i]].payed) {
                totalAmount = totalAmount.add(stacks[index2Investment[index2Investor[_indexInvestor].investments[i]].stackIndex].amount);
            }
        }

        return totalAmount;
    }

    function getReferralInformation() public view returns (uint256,uint256) {
        uint256 code = index2Investor[address2index[msg.sender]].referrer;
        uint256 earnings = index2Investor[address2index[msg.sender]].earningsReferrals;

        return (code, earnings);
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