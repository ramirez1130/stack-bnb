// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract RingBNB {
    using SafeMath for uint256;

    uint256 public constant REFERRER_CODE = 4000;
    uint256 public constant PENALTY_STEP = 250;
    uint256 public constant PERCENTS_DIVIDER = 1000;
    uint256 public constant MAX_TOP_REFERENTS = 5;

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

    Ring[] internal rings;
    uint8[] internal plans = [0,1,2,3,4,5];
    uint256 internal indexInvestment;

    struct Ring {
        uint256 balance;
        uint256 amount;
        uint256 reward;
        uint8 maxInvestors;
        uint256[] investments;
        uint256 startDate;
        uint8 plan;
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
        uint256 ringIndex;
        uint256 investmentDate;
        bool payed;
        uint256 position;
    }

    event onInvest(address indexed _address, uint256 plan);
    event onWithdraw(address indexed _address, uint256 _ringIndexInvested, uint256 _investmentIndex);
    event onRingComplete(uint256 _indexRing);

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
        
        createRing(plan2amount[0], 0 ether, 0, 0);
        createRing(plan2amount[1], 0.4 ether, 3, 1);
        createRing(plan2amount[2], 3 ether, 7, 2);
        createRing(plan2amount[3], 10 ether, 15, 3);
        createRing(plan2amount[4], 12.5 ether, 3, 4);
        createRing(plan2amount[5], 25 ether, 3, 5);
        createRing(plan2amount[6], 125 ether, 3, 6);
    }

    function withdraw(uint256 _plan) public{
        uint256 _indexInvestor = address2index[msg.sender];
        require(_indexInvestor != 0, "Can not withdraw because no any investments");

        Investor storage _investor = index2Investor[address2index[msg.sender]];
        uint256 _ringIndexInvested;
        uint256 _investmentIndex;

        for(uint256 i=0;i<_investor.investments.length;i++) {
            if(rings[index2Investment[_investor.investments[i]].ringIndex].plan == _plan && !index2Investment[_investor.investments[i]].payed) {
                index2Investment[_investor.investments[i]].payed = true;
                _investmentIndex = index2Investment[_investor.investments[i]].indexInvestment;
                _ringIndexInvested = index2Investment[_investor.investments[i]].ringIndex;
            }
        }

        uint256 _totalAmount = rings[_ringIndexInvested].amount;
        uint256 _penaltyAmount = calculatePenalty(_totalAmount);

        _totalAmount = _totalAmount.sub(_penaltyAmount);

        msg.sender.transfer(_totalAmount);

        removeInvestmentToRing(_ringIndexInvested, _investmentIndex);

        emit onWithdraw(msg.sender, _ringIndexInvested, _investmentIndex);
    }

    function invest(uint8 _plan, uint256 _referrer) public payable{
        require(msg.value == plan2amount[_plan], "The amount to be invested must be the one requested by the plan.");
        require(_plan != 0, "Invalid plan id");

        uint256 _ringInvested;
        uint256 _indexInvestor = address2index[msg.sender];

        if(_indexInvestor == 0) {
            address2index[msg.sender] = latestReferredCode;
            index2Investor[latestReferredCode].addr = msg.sender;
            index2Investor[latestReferredCode].referrer = latestReferredCode;
            _indexInvestor = latestReferredCode;
        }

        require(index2Investor[_indexInvestor].investments.length < plans.length, "Maximum possible investments");

        for(uint256 i=0;i<index2Investor[_indexInvestor].investments.length;i++) {
            if(!index2Investment[index2Investor[_indexInvestor].investments[i]].payed){
                require(rings[index2Investment[index2Investor[_indexInvestor].investments[i]].ringIndex].plan != _plan, "You cannot invest more than once in a plan.");
            }
        }

        for(uint256 i=0;i<rings.length;i++) {
            if(rings[i].plan == _plan && rings[i].investments.length < rings[i].maxInvestors){
                _ringInvested = i;
                Investment memory _invest = Investment(indexInvestment, _indexInvestor, _ringInvested, block.timestamp, false, 0);

                index2Investment[indexInvestment] = _invest;
                index2Investor[_indexInvestor].investments.push(indexInvestment);

                rings[_ringInvested].investments.push(indexInvestment);

                index2Investment[indexInvestment].position = rings[_ringInvested].investments.length;
                indexInvestment++;
                break;
            }
        }

        totalStaked = totalStaked.add(rings[_ringInvested].amount);
        rings[_ringInvested].balance += rings[_ringInvested].amount;

        if(_referrer != 0 && _referrer != address2index[msg.sender]) {
            index2Investor[_referrer].earningsReferrals += rings[_ringInvested].amount.mul(100).div(PERCENTS_DIVIDER);
            index2Investor[_referrer].addr.transfer(rings[_ringInvested].amount.mul(100).div(PERCENTS_DIVIDER));
        }
        
        latestReferredCode++;
        emit onInvest(msg.sender, rings[_ringInvested].plan);
    }

    function createRing(uint256 _amount, uint256 _reward, uint8 _maxInvestor, uint8 _plan) internal{
        rings.push(Ring({
            balance : 0,
            amount : _amount,
            reward : _reward,
            maxInvestors : _maxInvestor,
            startDate : block.timestamp,
            plan : _plan,
            finished : false,
            investments : new uint[](0)
        }));
    }

    function removeInvestmentToRing(uint256 _ringIndex, uint256 _indexInvestment) private {
        require(index2Investment[_indexInvestment].indexInvestor == address2index[msg.sender], "The address does not own the investment");
        uint256[] memory _newList = new uint[](0);
        for(uint256 i=0;i<rings[_ringIndex].investments.length;i++) {
            if(rings[_ringIndex].investments[i] != _indexInvestment) {
                _newList[i] = rings[_ringIndex].investments[i];
            }
        }
        rings[_ringIndex].investments = _newList;
        rings[_ringIndex].balance = rings[_ringIndex].balance - rings[_ringIndex].amount;
    }

    function changeOnRing(uint256 _indexRing) public{
        if(rings[_indexRing].maxInvestors == rings[_indexRing].investments.length) {
            divideRing(_indexRing);
            emit onRingComplete(_indexRing);
        }
    }

    function divideRing(uint256 _indexRing) private{
        rings[_indexRing].finished = true;
        payRing(_indexRing);
        createRing(rings[_indexRing].amount, rings[_indexRing].reward, rings[_indexRing].maxInvestors, rings[_indexRing].plan);
        createRing(rings[_indexRing].amount, rings[_indexRing].reward, rings[_indexRing].maxInvestors, rings[_indexRing].plan);

        uint256[] memory investsToRingOne;
        uint256[] memory investsToRingTwo;

        if(rings[_indexRing].maxInvestors == 3) {
            investsToRingOne = new uint256[](1);
            investsToRingTwo = new uint256[](1);
            investsToRingOne[0] = rings[_indexRing].investments[1];
            investsToRingTwo[0] = rings[_indexRing].investments[2];
        }else if(rings[_indexRing].maxInvestors == 7) {
            investsToRingOne = new uint256[](3);
            investsToRingTwo = new uint256[](3);
            investsToRingOne[0] = rings[_indexRing].investments[1];
            investsToRingOne[1] = rings[_indexRing].investments[3];
            investsToRingOne[2] = rings[_indexRing].investments[4];

            investsToRingTwo[0] = rings[_indexRing].investments[2];
            investsToRingTwo[1] = rings[_indexRing].investments[5];
            investsToRingTwo[2] = rings[_indexRing].investments[6];
        }else {
            investsToRingOne = new uint256[](7);
            investsToRingTwo = new uint256[](7);
            investsToRingOne[0] = rings[_indexRing].investments[1];
            investsToRingOne[1] = rings[_indexRing].investments[3];
            investsToRingOne[2] = rings[_indexRing].investments[4];
            investsToRingOne[3] = rings[_indexRing].investments[7];
            investsToRingOne[4] = rings[_indexRing].investments[8];
            investsToRingOne[5] = rings[_indexRing].investments[9];
            investsToRingOne[6] = rings[_indexRing].investments[10];

            investsToRingTwo[0] = rings[_indexRing].investments[2];
            investsToRingTwo[1] = rings[_indexRing].investments[5];
            investsToRingTwo[2] = rings[_indexRing].investments[6];
            investsToRingTwo[3] = rings[_indexRing].investments[11];
            investsToRingTwo[4] = rings[_indexRing].investments[12];
            investsToRingTwo[5] = rings[_indexRing].investments[13];
            investsToRingTwo[6] = rings[_indexRing].investments[14];
        }

        rings[rings.length - 2].investments = investsToRingOne;
        rings[rings.length - 1].investments = investsToRingTwo;
    }

    function payRing(uint256 _indexRing) private{
        require(rings[_indexRing].finished == true, "This ring has already been paid for.");
        require(rings[_indexRing].investments.length == rings[_indexRing].maxInvestors, "Not all investors are there yet.");

        uint256 _reward = rings[_indexRing].reward;
        uint256 commissionAmount = rings[_indexRing].amount.mul(rings[_indexRing].maxInvestors).sub(_reward);
        uint256 developAmount = commissionAmount.mul(DEVELOPER_RATE).div(PERCENTS_DIVIDER);
        uint256 reserveAmount = commissionAmount.mul(RESERVE_RATE).div(PERCENTS_DIVIDER);
        uint256 marketingAmmount = commissionAmount.mul(MARKETING_RATE).div(PERCENTS_DIVIDER);

        index2Investor[index2Investment[rings[_indexRing].investments[0]].indexInvestor].addr.transfer(_reward);
        index2Investment[rings[_indexRing].investments[0]].payed = true;
        insuranceFunds += reserveAmount;

        developerAccount.transfer(developAmount);
        reserveAccount.transfer(reserveAmount);
        marketingAccount.transfer(marketingAmmount);

        rings[_indexRing].finished = true;
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
            _investment.ringIndex,
            _investment.investmentDate,
            _investment.payed,
            _investment.position
        );
    }

    function getInfoRing(uint256 _indexRing) public view returns (uint256,uint8,uint256,uint256,uint256,uint256[] memory,uint256,bool,uint256) {
        Ring memory ring = rings[_indexRing];
        uint256 position;
        for(uint256 i=0;i<ring.investments.length;i++) {
            if(index2Investment[ring.investments[i]].indexInvestor == address2index[msg.sender]) {
                position = index2Investment[ring.investments[i]].position;
                break;
            }
        }
        return (
            ring.balance,
            ring.plan,
            ring.amount,
            ring.reward,
            ring.maxInvestors,
            ring.investments,
            ring.startDate,
            ring.finished,
            position
        );
    }

    function getActivePlans() public view returns (bool[] memory) {
        uint256 investor = address2index[msg.sender];
        bool[] memory _activePlans = new bool[](6);

        for(uint256 i=0;i<index2Investor[investor].investments.length;i++) {
            if(!index2Investment[index2Investor[investor].investments[i]].payed) {
                uint8 _plan = rings[index2Investment[index2Investor[investor].investments[i]].ringIndex].plan;
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
                _investedPlans[index] = index2Investment[index2Investor[investor].investments[i]].ringIndex;
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
                totalAmount = totalAmount.add(rings[index2Investment[index2Investor[_indexInvestor].investments[i]].ringIndex].amount);
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

    function getPlans() public view returns (uint8[] memory) {
        return plans;
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