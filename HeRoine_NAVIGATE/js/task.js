var i = 0
var maxtrial = 2
var trialn = 0

var baglocationA = [32.383270948354721,34.656698461598374,34.991541997938754,32.823325234040517,31.793962898133415,31.113079965198366,34.948834826968266,36.664042828183021,33.035226801644527,38.951652860997925,14.460908842766678,10.600810201558289,7.9242584705520143,9.5994538754779626,8.0510908189806312,11.429092812601564,11.10545245463469,12.695432019774609,12.874991499728916,14.198609572435021,9.5513746499847585,9.5054577783947174,11.822727661795398,9.7088347287286041,10.022936877320888,32.82115473423999,34.389458305423894,38.500426144719022,35.171995024845529,39.165069495145396,37.58770712421088,35.570232006780991,32.173254050763433,76.173206917307766,73.205099725609529,79.725665548281015,77.736457827863546,74.565102654062173,76.135639512441244,74.289526162576038,74.3754348910468,73.3040605277604,74.4316399521471,76.530983683773059,74.376660892024887,77.056969067194018,73.786616042386967,74.428861898293832,75.840161294944352,79.1915040262182,73.8847837141342,74.650859891958078,74.225558161703347,12.946270238703324,13.401704412918098,14.336439397241929,14.054517198443838,17.321141514569376,11.569606998301406,12.426787715699085,15.3440852417699,13.890211561310132,88.43971682311718,90.749241718877812,86.137714657114117,89.448555597586591,90.69933211170634,73.290820288810622,75.682487749197932,76.040374165721815];
var baglo = [0, 12, 15, 15, 75, 80, 90, 55];
var RewardList_run1 =  [0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,0,0,0,1,1,1,0,0,0,1,0,1,0,1,1,1,0,1,0,1,1,1,0,0,1,1,0,1,1,0,0,0,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,0,1,0,1,0,0,0,0,0,0,0,1];
var Clicklocation;

var windowWidth = window.innerWidth
var windowWidth = window.innerWidth
var scaleBorderLeft = windowWidth*0.1
var scaleBorderRight = windowWidth-scaleBorderLeft
var scaleLength = windowWidth-2*scaleBorderLeft;

//This is used to determine if Euro or Neutral bag should fall down
function randomNumber(){
    var numb = Math.floor((Math.random() * 10) + 1);
    console.log('random reward number is', numb)
    return numb
}

document.body.addEventListener('onclick', function() {
    if(eurowin) {
     for(let audio of eurowin) {
      audio.play()
      console.log('plaes')
      audio.pause()
      audio.currentTime = 0
     }
     eurowin = null
   }
   }, false)



// function playAudio() {
//     return document.querySelector('#win').play();
//   }

//Bag falls down 
function BagFalls(event){

    //Count trials
    trialn++;
    console.log("trialn is", trialn);
    console.log(i)


    //Calculate random number
    var numb = randomNumber()
    for (i = 0; i < maxtrial; i++) {

    //Determines if bag is Euro or Neutral
        var Bag = document.getElementById("animateBag");
        
        var reward = RewardList[trialn]

        if (reward == 1){
            Bag.style.backgroundImage = "url('bag_euro.png')";
        }
        else{
            Bag.style.backgroundImage = "url('bag_neutral.png')";
        }

    var pos = 0;
    var id = setInterval(frame, 15);
    function frame() {
        if (pos == 92) {
            clearInterval(id);
        } else {
            pos++; 
            Bag.style.top = pos + "%";
            //Bag falls at x value defined in baglocation in %
            Bag.style.left = baglocationA[trialn]-3.5 + "%";
            }

        // if (15 > Bag.style.left + 10 && 15 < Bag.style.left - 10){ //wenn gefangen
        //     console.log('catched reward')
        //     win.play();
        // }
        //     else {
        //         loss.play();
        //         console.log('catched ')
        //     }
                //add here that only play win if bag was euro bag, otherwise play neutral sound

        } 
    }
    var Bar = document.getElementById("animateBar");
    var lineedge = document.getElementById("line")
    // console.log("Bar at ", Bar.style.left)
    // console.log("Mouse at ", event.clientX)
    // console.log('Lineedge at', windowWidth*0.1)
    // console.log("Bag located at", baglocationA[trialn])
    
    console.log("Heli at" , baglocationA[trialn]);
}



//abort after 70 trials


//this function moves the bar according to the mouse position, should be changed to %
onmousemove = function(event){
    var Bar = document.getElementById("animateBar");
    var Line = document.getElementById("line")

    // attach bar to the mouse
    var barLocation = event.clientX-windowWidth*0.1;

    // if mouse moves across edges of the scale
    if (barLocation < 0){
        barLocation = 0
    } 
    if (barLocation > Line.offsetWidth){
        barLocation = Line.offsetWidth
    }
    else{

    //set bar to mouse previously assigned "barlocation"
    Bar.style.left = barLocation + "px";
    console.log("barlocation", barLocation)
    console.log("Bar at", barLocation/scaleLength);
         }
         return barLocation
    }

// FROM OLD SCRIPT ----------------------------------------------------------------------------------------

async function delayedCross() {
    //wait 5sec, then hide outcome and card to see fixation cross
    await wait(5000);
    outcome.style.display = 'none'
    //heli.style.display='none'
    card2.style.display='none';

    //wait for jittered time to present cards again
    await wait(randomITI());
    //heli.style.border= 'transparent'
    card2.style.border='transparent'

    if (randomNumber()>5){
       //heli.style.left = '25%'
        card2.style.left = '72%';
    }
    else{
        //heli.style.left = '72%';
        card2.style.left = '25%';
    }
    //heli.style.display = 'block';
    card2.style.display = 'block';

}

//need while loop around this fro trialn
// fix border movement
 function choseCard(ChosenCard){
    var ChosenCard = document.getElementById(ChosenCard.id)
    i++;
    ChosenCard.style.border = 'orange solid 50px';
    console.log(i)
    if (randomNumber()>8){
        outcome =  document.getElementById("rewardOutcome")
        outcome.style.display = 'block'
        delayedCross();
        if (i>trialn){
            console.log('done');
        }
    }
    
    else{
        outcome =  document.getElementById("noRewardOutcome")
        outcome.style.display = 'block'
        delayedCross();
        if (i>trialn){
            console.log('done');
        }

    }
}
        
function randomITI(){    
    var numb = Math.floor((Math.random() * 10) + 1);
    return numb
}

function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}