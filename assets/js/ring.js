var CONTRACT_ADDRESS = "0xaf9420AeaEA2fb932e9F9e0DC743Ed79E5A3D546";
var CONTRACT_ABI = [{"inputs":[{"internalType":"address payable","name":"_developerAccount","type":"address"},{"internalType":"address payable","name":"_reserveAccount","type":"address"},{"internalType":"address payable","name":"_marketingAccount","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_address","type":"address"},{"indexed":false,"internalType":"uint256","name":"plan","type":"uint256"}],"name":"onInvest","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_address","type":"address"}],"name":"onNewbie","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_indexRing","type":"uint256"}],"name":"onStackComplete","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"_address","type":"address"},{"indexed":false,"internalType":"uint256","name":"_stackId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"_investmentId","type":"uint256"}],"name":"onWithdraw","type":"event"},{"constant":true,"inputs":[],"name":"DEVELOPER_RATE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"MARKETING_RATE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"MAX_INVESTORS","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"PENALTY_STEP","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"PERCENTS_DIVIDER","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"REFERRER_CODE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"RESERVE_RATE","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"address2index","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"developerAccount","outputs":[{"internalType":"address payable","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"index2Investment","outputs":[{"internalType":"uint256","name":"plan","type":"uint256"},{"internalType":"uint256","name":"investmentId","type":"uint256"},{"internalType":"uint256","name":"investorId","type":"uint256"},{"internalType":"uint256","name":"stackId","type":"uint256"},{"internalType":"uint256","name":"investmentDate","type":"uint256"},{"internalType":"bool","name":"payed","type":"bool"},{"internalType":"uint256","name":"position","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"index2Investor","outputs":[{"internalType":"address payable","name":"addr","type":"address"},{"internalType":"uint256","name":"referrer","type":"uint256"},{"internalType":"uint256","name":"earningsReferrals","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"insuranceFunds","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"lastPayment","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"latestReferredCode","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"marketingAccount","outputs":[{"internalType":"address payable","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"plan2Stacks","outputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"reward","type":"uint256"},{"internalType":"uint256","name":"startDate","type":"uint256"},{"internalType":"bool","name":"finished","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"uint8","name":"","type":"uint8"}],"name":"plan2amount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"reserveAccount","outputs":[{"internalType":"address payable","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalStaked","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"uint256","name":"_plan","type":"uint256"},{"internalType":"uint256","name":"_stackId","type":"uint256"},{"internalType":"uint256","name":"_investmentId","type":"uint256"}],"name":"withdraw","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint8","name":"_plan","type":"uint8"},{"internalType":"uint256","name":"_referrer","type":"uint256"}],"name":"invest","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"internalType":"uint8","name":"_plan","type":"uint8"},{"internalType":"uint256","name":"_stackId","type":"uint256"}],"name":"changeOnStack","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"internalType":"uint256","name":"_plan","type":"uint256"},{"internalType":"uint256","name":"_stackId","type":"uint256"}],"name":"getInfoStack","outputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256[]","name":"","type":"uint256[]"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"bool","name":"","type":"bool"},{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getActivePlans","outputs":[{"internalType":"bool[]","name":"","type":"bool[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getInvestedPlans","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getReferralInformation","outputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getContractBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getIndexInvestor","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getTotalStaked","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getInsuranceFunds","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}];

var currentAddr;
var contract = null;

var gasPrice = '10000000000';

window.addEventListener('load', Connect);

async function Connect() {
    if (window.ethereum) {
        window.web3 = new Web3(ethereum)
        try {
            await ethereum.enable()
            let accounts = await web3.eth.getAccounts()
            currentAddr = accounts[0]
            runAPP()
            return
        } catch (error) {
            console.error(error)
        }
    } else if (window.web3) {
        window.web3 = new Web3(web3.currentProvider)
        let accounts = await web3.eth.getAccounts()
        currentAddr = accounts[0]
        console.log(contract)
        runAPP()
        return
    }
    setTimeout(checkForBinanceChain, 1500)
}

async function checkForBinanceChain() {
    try {
        await window.BinanceChain.enable()
        console.log(typeof(window.BinanceChain))
        if (window.BinanceChain) {
            console.log('BinanceChain')
            await BinanceChain.enable()
            window.web3 = new Web3(window.BinanceChain)
            let accounts = await web3.eth.getAccounts()
            currentAddr = accounts[0]
            
            console.log(contract)
            runAPP()
            return
        }
    } catch (e) {}
}

async function runAPP(){
    let networkID = await web3.eth.net.getId()
    contract = await new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDRESS)

    activatePlans();
    listenPlanInvested();
    verifyMyPlans();
    updateStats();
    updatePriceBNB();
    verifyReferral();
}

function verifyReferral() {
  if(contract) {
    contract.methods.getReferralInformation().call({from:currentAddr}).then(response => {
      if(response[0] != 0) {
        let value = window.web3.utils.fromWei(response[1], 'ether');
        $('#suscribe .title span').html(`${value} BNB`);
        $('#mce-code').attr('placeholder',response[0])
      }
    })
  }
}

function reloadStack(plan) {
  $("#about .grafich-plan").not(`.grafich-plan-${plan}`).addClass('d-none');
  $(`#about .grafich-plan-${plan}`).removeClass('d-none');
}

function changeStackInformation(infoStack, plan, stackId) {
  let cantInvestments = infoStack[2].filter(id => id != 0).length;

  let startDate = new Date(infoStack[3]*1000).toJSON().slice(0,10);
  $("#about .button-stack-time").html(`You entered on ${startDate}`);
  $("#about .title").html(`Your investment in <span>Plan ${plan}</span>`);
  $('#about .button-stack-id').html("Your invest ID is " + infoStack[2][infoStack[5]-1]);
  $('#about .button-stack-left').html(`${3 - cantInvestments} investments to complete stack`);

  if(cantInvestments == 3 && infoStack[5] == 1){
    $('#about #receive-profit').removeAttr('disabled').attr('data-stack-profit',stackId);
  }else {
    $('#about #receive-profit').attr('disabled','disabled').removeAttr('data-stack-profit');
  }
}

$('#about #receive-profit').click(function() {
  let plan = $(this).prev().prev().find('option:selected').attr('data-stack-plan');
  let stackId = $(this).attr('data-stack-profit');
  changeOnStack(plan, stackId);
});

async function verifyMyPlans() {
  if(contract) {
    contract.methods.getInvestedPlans().call({
      from : currentAddr
    }).then(response => {
      let selectOfPlans = $("<select class='select-about-plan'></select>").attr('name','plan');
      console.log(response);
      $(selectOfPlans).change(function() {
        if(contract) {
          let plan = $(this).find('option:selected').attr('data-stack-plan');
          contract.methods.getInfoStack(plan,$(this).val()).call({from:currentAddr}).then(infoStack => {
            reloadStack(plan, $(this).val());
            changeStackInformation(infoStack, plan, $(this).val())
          });
        }
      });

      let first = true;
      response.map((stackId,plan) => {
        if (stackId != 0) {
          plan = plan+1;
          if($('#about').hasClass('d-none')) $('#about').removeClass('d-none');
          let stackView = `<div class='about-right ${plan !=1 ? 'd-none' : ''} grafich-plan grafich-plan-${plan}'></div>`;
          //get info of particular stack
          contract.methods.getInfoStack(plan,stackId).call({from:currentAddr}).then(infoStack => {
            console.log(infoStack);
            stackView = $(stackView).append(`
            <div class="column-stack">
              <div class="block-stack animated fadeInRight"><img src="./assets/images/logo-ring.png" alt="logo-ring"><span>${infoStack[2][0] != 0 ? infoStack[2][0] : 'EMPTY'}</span></div>
            </div>
            <div class="column-stack">
              <div class="block-stack animated fadeInRight" data-wow-delay="0.2s"><img src="./assets/images/logo-ring.png" alt="logo-ring"><span>${infoStack[2][1] != 0 ? infoStack[2][1] : 'EMPTY'}</span></div>
              <div class="block-stack animated fadeInRight" data-wow-delay="0.3s"><img src="./assets/images/logo-ring.png" alt="logo-ring"><span>${infoStack[2][2] != 0 ? infoStack[2][2] : 'EMPTY'}</span></div>
            </div>`);

            $('#container-stack').append(stackView);

            let optionPlan = $(`<option data-stack-plan=${plan} data-investment=${infoStack[2][infoStack[5]-1]}>Plan ${plan}</option>`).attr('value',stackId);

            selectOfPlans.append(optionPlan);
            $('#about .top-margin').prepend(selectOfPlans);
            if(first) {
              reloadStack(plan);
              changeStackInformation(infoStack, plan, stackId);
              first = false;
            }
          });
        }
      });
    });
  }
}

function changeOnStack(plan, stackId) {
  if(contract) {
    contract.methods.changeOnStack(plan, stackId).send({from:currentAddr}).then(response => {
      console.log(`Ring ${stackId} complete`);
      $('#container-stack .about-right').remove();
      $('#about select[name=plan]').remove();
      verifyMyPlans();
    })
  }
}

function listenPlanInvested() {
  if(contract) {
    contract.events.onInvest().on('data', async function(evt) {
      let planInvested = evt.returnValues.plan;
      $('#container-stack .about-right').remove();
      $('#about select[name=plan]').remove();
      verifyMyPlans();
      $(`#price [data-plan=${planInvested}]`).attr('disabled','disabled');
    });
  }
}

function listenWithdraw() {
  if(contract) {
    contract.events.onWithdraw().on('data', async function(evt) {
      let planInvested = evt.returnValues._plan;
      $(`#price [data-plan=${planInvested}]`).removeAttr('disabled');
    });
  }
}

function activatePlans() {
  //Activate plans where you can invest
  contract.methods.getActivePlans().call({
    from : currentAddr
  }).then(response => {
    for(let i=0;i<response.length;i++) {
      let index = i+1;
      if(!response[i]) {
        $(`#price [data-plan=${index}]`).removeAttr("disabled")
        //Add event invest
        $(`#price [data-plan=${index}]`).on('click', function(){
          //Plan in contract is -1 because use the index of array
          let plan = $(this).data("plan");
          let amount = window.web3.utils.toWei($(this).data("plan-amount").toString());

          if(contract) {
            console.log(amount);
            let referralCode = $.urlParam('code');
            referralCode = referralCode != null ? referralCode : 0;
            contract.methods.invest(plan,referralCode).send({
              from: currentAddr,
              value: amount.toString(),
              gasPrice: gasPrice
            }).then(function() {
              iziToast.success({
                title: 'OK',
                message: "Invest complete",
                backgroundColor: '#fcd535',
                position: 'bottomCenter',
                progressBarColor: '#76BF73',
                color:'.iziToast-#76BF73',
                iconColor: '.iziToast-#76BF73'
              });
            });
          }
        });
      }
    }
  });
}

setInterval(() => {
    if(contract) {
        
        updateAccount();
        //price of BNB
        updatePriceBNB();

        //update stats
        updateStats();
    }
}, 5000);

function updateAccount() {
  web3.eth.getAccounts().then(res=>{
    currentAddr = res[0]
  })

  var connectedAddr = currentAddr[0] + currentAddr[1] + currentAddr[2] + currentAddr[3] + currentAddr[4] + currentAddr[5] + '...' + currentAddr[currentAddr.length-6]+currentAddr[currentAddr.length-5]+ currentAddr[currentAddr.length-4]+ currentAddr[currentAddr.length-3]+ currentAddr[currentAddr.length-2]+ currentAddr[currentAddr.length-1]
  $("#connect-button").text(connectedAddr);
}

function updatePriceBNB() {
  fetch('https://api.coingecko.com/api/v3/simple/price?ids=binancecoin&vs_currencies=usd&include_24hr_change=true').then(resp => {
    resp.json().then(r => {
      $('#price-bnb').html(`1 BNB = $${r.binancecoin.usd}`);
    });
  });
}

//Plans
$.getJSON("assets/js/plans.json", function(data) {
  let dataForCarrousels = new Array(Math.ceil(data.length/3)).fill().map(_ => data.splice(0,3));

  let carrousels = dataForCarrousels.map(element => {
    let items = element.map(plan => {
      return `<div class="price-item">
                <div class="price-block">
                  <div class="price-type">
                    <h2>${plan.title}</h2>
                  </div>
                  <div class="mrp">
                    <!--<h6 class="user-type">${plan.lable}</h6>-->
                    <div class="price-devide"></div>
                    <h2>${plan.price} BNB</h2>
                    <h6 class="price-year">${plan.multiplication}</h6>
                    <div class="price-devide"></div>
                  </div>
                  <ul class="price-feature">
                    ${plan.features}
                  </ul><button data-plan-amount=${plan.price} data-plan=${plan.number} disabled class="btn btn-custom theme-color" href="#" role="button">Invest</button>
                </div>
              </div>`;
    });

    return `<div class="row">
            <div class="col-sm-12">
              <div class="price-carousel owl-carousel owl-theme">${items}</div>
            </div>
          </div>`;
  });

  $("#price .container").html(carrousels);
  $("#price .price-carousel").owlCarousel({
      loop:false,
      margin:30,
      nav:true,
      dots:true,
      responsive:{
          0:{
              items:1,
              dots:true,
              margin:0
          },
          600:{
              items:1,
              dots:true,
              margin:0,
          },
          768:{
              items:2,
              dots:true,
          },
          992:{
              items:3,
          },
          1000:{
              items:3
          }
      }
  });
});

//Button withdraw
$('#about .container .top-margin button:contains(withdraw)').click(function(){
  //Plan on contract is -1 because use the index of array
  let plan = $(this).prev().find('option:selected').attr('data-stack-plan') - 1;
  let stackId = $(this).prev().val();
  let investmentId = $(this).prev().find('option:selected').attr('data-investment');
  console.log(plan);
  if(contract) {
    contract.methods.withdraw(plan, stackId, investmentId).send({from:currentAddr}).then(() => {
      iziToast.success({
        title: 'OK',
        message: "Withdraw complete",
        backgroundColor: '#fcd535',
        position: 'bottomCenter',
        progressBarColor: '#76BF73',
        color:'.iziToast-#76BF73',
        iconColor: '.iziToast-#76BF73'
      });
    });
  }
});

//Stats
function updateStats() {
  if(contract) {
    contract.methods.getInsuranceFunds().call().then(response => {
      let value = window.web3.utils.fromWei(response, 'ether');
      $('.insurance-funds').html(`${value} BNB`);
    });

    contract.methods.getTotalStaked().call().then(response => {
      let value = window.web3.utils.fromWei(response, 'ether');
      $('.total-staked').html(`${value} BNB`);
    });

    contract.methods.getReferralInformation().call({from: currentAddr}).then(response => {
      let value = window.web3.utils.fromWei(response[1], 'ether');
      $('.referral-funds').html(`${value} BNB`);
    });

    contract.methods.getContractBalance().call().then(response => {
      let value = window.web3.utils.fromWei(response, 'ether');
      $('.contract-balance span').html(`${value} BNB`)
    });
  }
}

$.urlParam = function(name){
  var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
  if (results==null){
     return null;
  }
  else{
     return results[1] || 0;
  }
}