var CONTRACT_ADDRESS = "0xf49A0C1255344b6ca148Deea349Bc7d409E38e15";
var ABI = [{"constant":false,"inputs":[{"name":"referrer","type":"address"},{"name":"plan","type":"uint8"}],"name":"invest","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[],"name":"withdraw","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"wallet","type":"address"},{"name":"_developer","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"user","type":"address"}],"name":"Newbie","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"user","type":"address"},{"indexed":false,"name":"plan","type":"uint8"},{"indexed":false,"name":"percent","type":"uint256"},{"indexed":false,"name":"amount","type":"uint256"},{"indexed":false,"name":"profit","type":"uint256"},{"indexed":false,"name":"start","type":"uint256"},{"indexed":false,"name":"finish","type":"uint256"}],"name":"NewDeposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"user","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Withdrawn","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"referrer","type":"address"},{"indexed":true,"name":"referral","type":"address"},{"indexed":true,"name":"level","type":"uint256"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"RefBonus","type":"event"},{"constant":true,"inputs":[],"name":"DEVELOPER_FEE","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getContractBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"plan","type":"uint8"}],"name":"getPercent","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"plan","type":"uint8"}],"name":"getPlanInfo","outputs":[{"name":"time","type":"uint256"},{"name":"percent","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"plan","type":"uint8"},{"name":"deposit","type":"uint256"}],"name":"getResult","outputs":[{"name":"percent","type":"uint256"},{"name":"profit","type":"uint256"},{"name":"finish","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserAmountOfDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserAvailable","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserCheckpoint","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"},{"name":"index","type":"uint256"}],"name":"getUserDepositInfo","outputs":[{"name":"plan","type":"uint8"},{"name":"percent","type":"uint256"},{"name":"amount","type":"uint256"},{"name":"profit","type":"uint256"},{"name":"start","type":"uint256"},{"name":"finish","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserDividends","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserDownlineCount","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserReferralBonus","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserReferralTotalBonus","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserReferralWithdrawn","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserReferrer","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"userAddress","type":"address"}],"name":"getUserTotalDeposits","outputs":[{"name":"amount","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"INVEST_MIN_AMOUNT","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"PERCENT_STEP","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"PERCENTS_DIVIDER","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"PROJECT_FEE","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"REFERRAL_PERCENTS","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"startUNIX","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"TIME_STEP","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalRefBonus","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalStaked","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}]

var referrer = '0x2b258aF3037aBe6ae50db554cAF82f368706504B'

var currentAddr;
var contract = null;

var gasPrice = '10000000000'

var upline = '0x2b258aF3037aBe6ae50db554cAF82f368706504B'

var percent1,percent2,percent3,percent4,percent5,percent6;

var profit1 = 0
var profit2 = 0
var profit3 = 0
var profit4 = 0
var profit5 = 0
var profit6 = 0

window.addEventListener('load', Connect)

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
    if (networkID == 56) {
        contract = await new web3.eth.Contract(ABI, CONTRACT_ADDRESS)
        console.log(contract)
    } 

}
        
    setInterval(() => {
        if(contract){
            web3.eth.getAccounts().then(res=>{
                currentAddr = res[0]
            })
    
            var connectedAddr = currentAddr[0] + currentAddr[1] + currentAddr[2] + currentAddr[3] + currentAddr[4] + currentAddr[5] + '...' + currentAddr[currentAddr.length-6]+currentAddr[currentAddr.length-5]+ currentAddr[currentAddr.length-4]+ currentAddr[currentAddr.length-3]+ currentAddr[currentAddr.length-2]+ currentAddr[currentAddr.length-1]

            $("#connect-btn").text(connectedAddr)

            contract.methods.totalStaked().call().then(res=>{
                $("#total-staked").text((res/1e18).toFixed(2))
            })
            contract.methods.getContractBalance().call().then(res=>{
                $("#total-balance").text((res/1e18).toFixed(2))
            })

            contract.methods.getPlanInfo(0).call().then(res=>{
                

                contract.methods.getPercent(0).call().then(r=>{

                

                var daily = (r / 10).toFixed(0);
                var total = ((r / 10) * res.time).toFixed(0);
                percent1 = (total/100).toFixed(4)

                $("#daily-1").html(`Daily Profit<span>${daily}%</span>`)
                $("#total-1").html(`Total Return<span>${total}%</span>`)
                $("#total--1").html(`In ${res.time} days you will get<span id = "calc-1">${profit1}</span>`)
                $("#total---1").text(total + '%')
                $("#days-1").text(res.time)
                })
            })
            contract.methods.getPlanInfo(1).call().then(res=>{

                contract.methods.getPercent(1).call().then(r=>{
                    var daily = (r / 10).toFixed(0);
                    var total = ((r / 10) * res.time).toFixed(0);

                    percent2 = (total/100).toFixed(4)
    
                    $("#daily-2").html(`Daily Profit<span>${daily}%</span>`)
                    $("#total-2").html(`Total Return<span>${total}%</span>`)
                    $("#total--2").html(`In ${res.time} days you will get<span id = "calc-2">${profit2} </span>`)
                    $("#total---2").text(total + '%')
                    $("#days-2").text(res.time)
                })
               
            })

            contract.methods.getPlanInfo(2).call().then(res=>{

                contract.methods.getPercent(2).call().then(r=>{
                    var daily = (r / 10).toFixed(0);
                    var total = ((r / 10) * res.time).toFixed(0);

                    percent3 = (total/100).toFixed(4)
    
                    $("#daily-3").html(`Daily Profit<span>${daily}%</span>`)
                    $("#total-3").html(`Total Return<span>${total}%</span>`)
                    $("#total--3").html(`In ${res.time} days you will get<span id = "calc-3">${profit3}</span>`)
                    $("#total---3").text(total + '%')
                    $("#days-3").text(res.time)
                })
               
            })

            contract.methods.getPlanInfo(3).call().then(res=>{

                contract.methods.getResult(3,100).call().then(r=>{
                    var percent = r.percent
                    var daily = (percent / 10).toFixed(0);
                    var total = r.profit

                    percent4 = (total/100).toFixed(4)

                    $("#daily-4").html(`Daily Profit<span>${daily}%</span>`)
                    $("#total-4").html(`Total Return<span>${total}%</span>`)
                    $("#total--4").html(`In ${res.time} days you will get<span id = "calc-4">${profit4} </span>`)
                    $("#total---4").text(total + '%')
                    $("#days-4").text(res.time)
                })
                
            })

            contract.methods.getPlanInfo(4).call().then(res=>{

                contract.methods.getResult(4,100).call().then(r=>{
                    var percent = r.percent
                    var daily = (percent / 10).toFixed(0);
                    var total = r.profit;

                    percent5 = (total/100).toFixed(4)
    
                    $("#daily-5").html(`Daily Profit<span>${daily}%</span>`)
                    $("#total-5").html(`Total Return<span>${total}%</span>`)
                    $("#total--5").html(`In ${res.time} days you will get<span id = "calc-5">${profit5} </span>`)
                    $("#total---5").text(total + '%')
                    $("#days-5").text(res.time)
                })
               
            })

            contract.methods.getPlanInfo(5).call().then(res=>{

                contract.methods.getResult(5,100).call().then(r=>{
                    var percent = r.percent
                    var daily = (percent / 10).toFixed(0);
                    var total = r.profit;

                    percent6 = (total/100).toFixed(4)

                    $("#daily-6").html(`Daily Profit<span>${daily}%</span>`)
                    $("#total-6").html(`Total Return<span>${total}%</span>`)
                    $("#total--6").html(`In ${res.time} days you will get<span id = "calc-6">${profit6} </span>`)
                    $("#total---6").text(total + '%')
                    $("#days-6").text(res.time)
                })
                
            })

            contract.methods.getUserTotalDeposits(currentAddr).call().then(res=>{
                $("#total-user-staked").text((res/1e18).toFixed(2))
            })

            contract.methods.getUserAvailable(currentAddr).call().then(res=>{
                $("#user-available").text((res/1e18).toFixed(2))
            })

            $("#ref-link").val('https://' + window.location.host  + '/?ref=' + currentAddr)

            contract.methods.getUserReferralTotalBonus(currentAddr).call().then(res=>{
                $("#referral-earned").text((res/1e18).toFixed(2))
            })

            contract.methods.getUserReferralWithdrawn(currentAddr).call().then(res=>{
                $("#referral-withdrawn").text((res/1e18).toFixed(2))
            })

            contract.methods.getUserDownlineCount(currentAddr).call().then(res=>{
                
                var sum = parseInt(res[0]) + parseInt(res[1]) + parseInt(res[2])
                
                $("#total-referrals").text(sum.toFixed(0))
            })

            contract.methods.getUserAmountOfDeposits(currentAddr).call().then(res=>{
                
                 userDeposits(res,(body)=>{
                    $("#user-deposits").html(body)
                    
                 });

                

               
            })
        }
        
    }, 5000);

    fetch('https://api.coingecko.com/api/v3/simple/price?ids=binancecoin&vs_currencies=usd&include_24hr_change=true').then(resp=>{
                    var response = resp.json().then(r=>{
                        var usd = r.binancecoin.usd
                        
                        $("#bnb-rate").text("= $"+ usd )
                    })
                    
                }) 

async function userDeposits(res,callback){
    var body = "";

                for(let i = 0; i<res;i++){
                    await contract.methods.getUserDepositInfo(currentAddr,i).call().then(r=>{
                       var amount = r.amount
                       var profit = r.profit
                       var plan = parseInt(r.plan) + 1
                       var start = r.start
                       var finish = r.finish
                       var percent = r.percent

                       var now = (new Date().valueOf() / 1000).toFixed(0)

                       var dif = (now - start) / 60*60*24
                       var totalTime = (finish-start) / 60*60*24

                       var percents = ((dif / totalTime)*100).toFixed(2)

                       console.log(percents)

                       if (plan -1 <3){

                        var deposit = `<div class="main__stake-item-wrap stake--orange">
                        <div class="main__stake-item">
                            <h2 class="main__stake-title">${plan}</h2>

                            <div class="main__stake-row">
                                <div class="main__stake-txt">
                                    ${(percent/10).toFixed(1) + "%"}
                                    

                                </div>
                            </div>

                            <div class="main__stake-row">
                                <div class="main__stake-perc">
                                    Deposit
                                    <span>${(amount/1e18).toFixed(2)}</span>
                                </div>
                                <div class="main__stake-perc">
                                    Profit
                                    <span>${(profit/1e18).toFixed(2)}</span>
                                </div>
                            </div>

                            <div class="main__stake-range">
                                <div class="main__stake-result" style = "width: ${percents}%">${percents}%</div>
                            </div>

                        </div>
                    </div>`

                        body+= deposit


                       } else {
                        var deposit = `<div class="main__stake-item-wrap stake--blue">
                        <div class="main__stake-item">
                            <h2 class="main__stake-title">${plan}</h2>

                            <div class="main__stake-row">
                                <div class="main__stake-txt">
                                    ${(percent/10).toFixed(1)}%
                                    

                                </div>
                            </div>

                            <div class="main__stake-row">
                                <div class="main__stake-perc">
                                    BNB
                                    <span>${(amount/1e18).toFixed(2)}</span>
                                </div>
                                <div class="main__stake-perc">
                                    BNB
                                    <span>${(profit/1e18).toFixed(2)}</span>
                                </div>
                            </div>

                            <div class="main__stake-range">
                                <div class="main__stake-result" style = "width: ${percents}%">${percents}%</div>
                            </div>

                        </div>
                    </div>`

                        body+= deposit
                       }
                    })
                }

                callback(body)
}



function copyToClipboard(element) {
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val($(element).val()).select();
    document.execCommand("copy");
    $temp.remove();
    showAlert('Successfuly copied','success')
}

function showAlert(msg,type){
    if(type == 'error'){
        iziToast.error({
            title: 'Error',
            message: msg,
            backgroundColor: 'white',
            position: 'topRight',
            color: '.iziToast-color-red',
            iconColor: '.iziToast-color-red'
        });
    }

    if(type == 'success'){
        iziToast.success({
            title: 'OK',
            message: msg,
            backgroundColor: 'white',
            position: 'topRight',
            progressBarColor: '#76BF73',
            color:'.iziToast-#76BF73',
            iconColor: '.iziToast-#76BF73'
        });
    }
}

function stake(plan,input){

  if(contract) {
    var amount = $(input).val() * 1e18

    contract.methods.invest(upline,plan).send({
        value: amount,
        from: currentAddr,
        gasPrice: gasPrice ,
    })
  }


}

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};



var refurl = getUrlParameter('ref');

if(refurl){
    localStorage.setItem('ref', refurl);
}

upline = localStorage.getItem('ref') ?   localStorage.getItem('ref') : referrer;

$("#withdraw-btn").click(()=>{

    if(contract){
        contract.methods.withdraw().send({
            value: 0,
            from: currentAddr,
            gasPrice: gasPrice ,
        })
    }

})

$("#input-1").on('input',()=>{
    var amount = $("#input-1").val();

    if(contract){

        var profit = (amount * percent1)
        profit1 = profit.toFixed(1)

        $("#calc-1").text(profit.toFixed(1))
    }
})

$("#input-2").on('input',()=>{
    var amount = $("#input-2").val();

    if(contract){

        var profit = (amount * percent2) 
        profit2 = profit.toFixed(1)

        $("#calc-2").text(profit.toFixed(1))
    }
})

$("#input-3").on('input',()=>{
    var amount = $("#input-3").val();

    if(contract){

        var profit = (amount * percent3) 
        profit3 = profit.toFixed(1)

        $("#calc-3").text(profit.toFixed(1))
    }
})

$("#input-4").on('input',()=>{
    var amount = $("#input-4").val();

    if(contract){

        var profit = amount * percent4
        profit4 = profit.toFixed(1)

        $("#calc-4").text(profit.toFixed(1))
    }
})

$("#input-5").on('input',()=>{
    var amount = $("#input-5").val();

    if(contract){

        var profit = amount * percent5
        profit5 = profit.toFixed(1)

        $("#calc-5").text(profit.toFixed(1))
    }
})

$("#input-6").on('input',()=>{
    var amount = $("#input-6").val();

    if(contract){

        var profit = amount * percent6
        profit6 = profit.toFixed(1)

        $("#calc-6").text(profit.toFixed(1))
    }
})