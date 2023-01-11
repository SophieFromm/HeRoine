var start_time = [];
jatos.onLoad();
{start_time = Date.now()}

// set elem to whole page and open full screen
function openFullscreen() {
  var elem = document.documentElement;
  if (elem.requestFullscreen) {
    elem.requestFullscreen();
  } else if (elem.webkitRequestFullscreen) {
    /* Safari */
    elem.webkitRequestFullscreen();
  } else if (elem.msRequestFullscreen) {
    /* IE11 */
    elem.msRequestFullscreen();
  }
}

//Timing variables
var t_click = [];
var t_bag_dropped = [];
var t_feeback_start = [];
var t_feedback_end = [];

//decision variables
var bag_caught = [];
var bag_type = [];
var bucket_position = [];
var slow = [];

//to store everything
var results = [];

//Audio sounds
var win = new Audio();
var eurowin = new Audio("css/audio/cashreg.wav");
var sandwin = new Audio("css/audio/falling.wav");
var loss = new Audio("css/audio/trombone.wav");

//Other
var participant_ID = [];
var URL_params = [];
var body = document.body;
var bodyID = document.body.id;

//BagLocations and Rewards
if (bodyID == "instruction") {
  var baglocation = [15, 80, 20, 40, 70, 70, 40, 10, 15];
  var reward = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
}

if (bodyID == "runpractice") {
  var baglocation = [10, 15, 12, 20, 18, 15, 70, 72, 80, 75, 78, 81, 75, 40, 41, 42, 45, 50, 44, 45];
  var reward = [0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1];
}

if (bodyID == "run4") {
  //sd 10
  var baglocation = [
    71,
    72,
    77,
    76,
    74,
    88,
    78,
    85,
    57,
    53,
    56,
    56,
    62,
    51,
    50,
    60,
    8,
    13,
    12,
    17,
    15,
    10,
    17,
    9,
    10,
    10,
    10,
    13,
    16,
    14,
    11,
    9,
    5,
    9,
    10,
    14,
    11,
    12,
    9,
    60,
    61,
    55,
    53,
    53,
    49,
    50,
    54,
    53,
    48,
    47,
    52,
    77,
    75,
    70,
    73,
    76,
    76,
    77,
    68,
    76,
    72,
    71,
    71,
    73,
    23,
    24,
    27,
    28,
    20,
    19,
    100
  ];
  var reward = [
    1,
    0,
    0,
    1,
    1,
    1,
    0,
    0,
    1,
    0,
    1,
    1,
    0,
    0,
    1,
    1,
    0,
    1,
    1,
    0,
    1,
    0,
    1,
    0,
    0,
    1,
    1,
    0,
    1,
    0,
    0,
    1,
    1,
    1,
    0,
    1,
    1,
    1,
    0,
    0,
    1,
    0,
    0,
    1,
    1,
    0,
    1,
    1,
    1,
    1,
    0,
    0,
    1,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    1,
    1,
    0,
    0,
    0,
    1,
    1,
    0,
    0
  ];
}

if (bodyID == "run3") {
  //sd 25
  var baglocation = [
    63,
    35,
    52,
    39,
    29,
    38,
    52,
    43,
    54,
    45,
    55,
    58,
    49,
    46,
    44,
    44,
    46,
    52,
    85,
    82,
    74,
    87,
    88,
    100,
    93,
    82,
    83,
    89,
    71,
    72,
    81,
    73,
    88,
    93,
    87,
    87,
    87,
    77,
    93,
    14,
    15,
    16,
    21,
    19,
    11,
    13,
    31,
    18,
    95,
    70,
    73,
    85,
    62,
    81,
    82,
    86,
    85,
    74,
    75,
    83,
    65,
    77,
    85,
    72,
    67,
    84,
    85,
    66,
    72,
    90,
    100
  ];
  var reward = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    0,
    0,
    0,
    1,
    1,
    1,
    0,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    1,
    0,
    1,
    0,
    0,
    0,
    1,
    1,
    0,
    1,
    0,
    1,
    1,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    0,
    0,
    1,
    1,
    1,
    1,
    0,
    1,
    0,
    0,
    0,
    1,
    0,
  ];
}

if (bodyID == "run2") {
  //sd 10_2
  var baglocation = [
    69,
    73,
    68,
    68,
    67,
    68,
    20,
    14,
    19,
    21,
    24,
    19,
    16,
    61,
    57,
    61,
    60,
    55,
    56,
    59,
    58,
    61,
    59,
    59,
    56,
    60,
    64,
    56,
    61,
    58,
    59,
    58,
    58,
    54,
    54,
    39,
    42,
    43,
    44,
    32,
    34,
    40,
    40,
    41,
    40,
    36,
    36,
    74,
    78,
    78,
    78,
    74,
    72,
    74,
    78,
    79,
    78,
    76,
    74,
    82,
    74,
    74,
    80,
    78,
    75,
    76,
    68,
    77,
    76,
    75,
    100
  ];
  var reward = [
    1,
    1,
    0,
    1,
    1,
    1,
    0,
    0,
    0,
    1,
    1,
    1,
    0,
    0,
    0,
    1,
    0,
    0,
    1,
    0,
    1,
    0,
    0,
    1,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    1,
    1,
    0,
    1,
    1,
    0,
    1,
    0,
    1,
    0,
    0,
    1,
    0,
    1,
    0,
    0,
    0,
    1,
    0,
    0,
    1,
    0,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    0,
    1,
    0,
    0
  ];
}

if (bodyID == "run1") {
  //sd 25_2
  var baglocation = [
    99,
    87,
    80,
    52,
    74,
    89,
    21,
    41,
    36,
    52,
    46,
    49,
    35,
    44,
    43,
    38,
    19,
    44,
    45,
    30,
    48,
    36,
    46,
    49,
    35,
    40,
    14,
    17,
    21,
    15,
    35,
    10,
    15,
    13,
    29,
    42,
    47,
    38,
    38,
    24,
    28,
    49,
    33,
    29,
    51,
    88,
    97,
    90,
    82,
    72,
    80,
    74,
    88,
    93,
    78,
    79,
    90,
    82,
    35,
    17,
    13,
    31,
    5,
    5,
    12,
    41,
    35,
    39,
    16,
    30,
    100
  ];
  var reward = [
    1,
    1,
    0,
    1,
    0,
    1,
    1,
    0,
    1,
    1,
    1,
    0,
    1,
    1,
    0,
    0,
    0,
    1,
    1,
    1,
    1,
    1,
    0,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    1,
    1,
    0,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    1,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    1,
    0,
    1,
    1,
    0
  ];
}

//initialize trialn
var trialn = 0;

//Instruction pages
var pages = [
  "Page0",
  "Page1",
  "Page2",
  "Page3",
  "Page4",
  "Page5",
  "Page6",
  "Page7",
  "Page8",
  "Page9",
  "Page10",
];
var p = 0;

//Create variables for all the elements to call them with a name
var Bag = document.getElementById("animateBag");
var BagCont = document.getElementById("BagCont");
var Heli = document.getElementById("heli");
var Bagmarker = document.getElementById("Bagmarker");
var Bar = document.getElementById("animateBar");
var Line = document.getElementById("line");
var PE = document.getElementById("PredictionError");
var clickarea = document.getElementById("clickarea");
var Slow = document.getElementById("Slow");
var feedback_period = false;

// line specs of the users screen
var windowWidth = window.innerWidth;
var scaleLength = Line.offsetWidth;
var scaleBorder = (windowWidth - scaleLength) / 2;
var half_Bagsize = 5; //((Bag.offsetWidth / 2) / windowWidth) * 100 + 1;
var half_Helisize = 10//((Heli.offsetWidth / 2 )/ windowWidth) * 100;

//Initial location of the cursor/bar in % on scale
var barLocation = 50;
// location of bag and bar in pixel offset from left side of the scale
var baglocationPXL = scaleLength * (baglocation[trialn] / 100) + scaleBorder;
var barlocationPXL = scaleBorder + barLocation;

//Set initial Heli and Bag position on instruction, because we always set left border of the image and the heli is larger
if (bodyID != "instruction") {
  Heli.style.left = baglocation[trialn] - half_Helisize + "%";
  Bag.style.left = baglocation[trialn] - half_Bagsize + "%";
}

var catch_pos = ((Bar.offsetTop - Bag.offsetHeight) / window.innerHeight) * 100;

// attach bar to the mouse
onmousemove = function (event) {
  //recalculate if participant changed browser size
  scaleBorder = (windowWidth - scaleLength) / 2;
  windowWidth = window.innerWidth;
  scaleLength = Line.offsetWidth;

  participant_ID = jatos.workerId;
  URL_params = jatos.urlQueryParameters;

  //event.clientX is bound to rating scale therfore subtract offset to window
  if (feedback_period == true) {
    barLocation = barLocation;
  }
  if (feedback_period == false) {
    barLocation = event.clientX - scaleBorder; //barlocation in pixel
  }
  // if mouse moves across limit of the scale set to limit of scale
  if (barLocation < 0) {
    barLocation = 0;
  }
  if (barLocation > Line.offsetWidth) {
    barLocation = Line.offsetWidth;
  } else {
    //set bar to mouse previously assigned "barlocation"
    Bar.style.left = barLocation + "px";
  }
};

//clicked is used as conditional
var clicked = false;
var first = 1;

//On click the bag falls down and a number of other things happen (eg. sound)
function BagFalls(event) {
  //initialize and play sounds
  if (first == 1) {
    var playPromise = win.play();
    if (playPromise !== undefined) {
      playPromise.then((_) => { }).catch((error) => { });
    }
    first = 0;
  }
  slow.push(0);
  t_click.push(Date.now());
  clicked = true;
  time = [];
  clearInterval();

  //push bucket position in % of scale to results
  bucket_position.push((barLocation / Line.offsetWidth) * 100);

  //prevent further clicks to trigger BagFalls
  clickarea.onclick = [];
  feedback_period = true;
  Bar.style.backgroundColor = "black";
  baglocationPXL = scaleLength * (baglocation[trialn] / 100) + scaleBorder;
  barlocationPXL = scaleBorder + barLocation;

  //Eurobag or neutral bag
  if (reward[trialn] == 1) {
    BagCont.src = "css/img/bag_euro.png";
    bag_type.push(1);
    win.src = "css/audio/cashreg.wav";
  } else {
    BagCont.src = "css/img/bag_neutral.png";
    bag_type.push(0);
    win.src = "css/audio/falling.wav";
  }

  var stop_pos = 110;
  var pos = 0;
  var id = setInterval(frame, 10);

  function frame() {
    //if bag reached position stop and log time
    if (pos == stop_pos) {
      t_bag_dropped.push(Date.now());
      clearInterval(id);

      //if bag caugth play euro/sand sound etc.
      if (
        Bar.offsetLeft > Bag.offsetLeft &&
        Bar.offsetLeft < Bag.offsetLeft + Bag.offsetWidth
      ) {
        win.play();
        console.log(Bag.offsetWidth);
        Bag.style.filter = "brightness(2)";

        bag_caught.push(1);
        show("PredictionError");
        show("Bagmarker");
      } else {
        win.src = "css/audio/trombone.wav";
        win.play();
        bag_caught.push(0);
        show("PredictionError");
        show("Bagmarker");
      }
      //let bag drop
    } else {
      show("animateBag");
      pos++;
      Bag.style.top = 35 + pos + "%";
      if (
        Bar.offsetLeft > Bag.offsetLeft &&
        Bar.offsetLeft < Bag.offsetLeft + Bag.offsetWidth
      ) {
        stop_pos = 53;
      }
    }
  }
  checkBagLocation(); //to present PE
  newTrial(); //After timeout hide feedback, send results and start with next trial
}

function checkBagLocation() {
  //if bag is further to the left, left limit of PE is baglocation
  if (baglocationPXL <= barlocationPXL) {
    PE.style.width = Math.abs(baglocationPXL - barlocationPXL) + "px";
    Bagmarker.style.left = baglocation[trialn] + "%";
    PE.style.left = Bagmarker.style.left;
  }
  //if bar is further to the left, left limit of PE is barlocation
  if (baglocationPXL > barlocationPXL) {
    Bagmarker.style.left = baglocation[trialn] + "%";
    PE.style.left = barLocation + "px";
    PE.style.width = Math.abs(baglocationPXL - barlocationPXL) + "px";
  }
}

//New trial calls a number of functions after a certain time (in ms) and stores the results
function newTrial() {
  trialn++;
  setTimeout(() => {
    changePos(),
      (clickarea.onclick = BagFalls),
      hide_stuff(),
      (clicked = false);
  }, 3000);
}

function hide_stuff() {
  hide("animateBag");
  hide("PredictionError");
  hide("Bagmarker");
}

var time = [];
//Change position of Heli and Bag on next trial

function changePos() {
  //this is just for instructions, so that participates don't practice to long
  if (trialn > baglocation.length - 1) {
    nextPage(pages[p], pages[p + 1]);
  }
  Bar.style.backgroundColor = "white";
  Heli.style.left = baglocation[trialn] - half_Helisize + "%";
  Bag.style.left = baglocation[trialn] - half_Bagsize + "%";
  console.log(baglocation[trialn]);
  //change color of bag back to normal
  Bag.style.filter = "brightness(1)";
  feedback_period = false;
  checkSlow();
}

//After the first click we land here and if no one clicks move between check slow and slow show
function checkSlow() {
  var sumSlow = slow.slice(trialn - 20);
   if (sumSlow.reduce((a, b) => a + b, 0) >= 20) {
      alert(
  //     //window.location.replace("https://app.prolific.co/submissions/complete?cc=2FACC063");
        "It seems like you are not paying attention anymore. Therefore we must exclude you from the study and will have to REJECT your submission. We are really sorry! Please return your submission within Prolific. You can close this window now."
      );
  //    jatos.endStudy();
   }
  console.log(trialn, "trial starts at ", Date.now() - start_time);
  t_feedback_end.push(Date.now());
  if (trialn <71){
  results.push({
    URL: URL_params,
    ID: participant_ID,
    run: bodyID,
    trialn: trialn,
    baglocation: baglocation[trialn - 1] + 0,
    bucket_position: bucket_position[trialn - 1],
    bag_caught: bag_caught[trialn - 1],
    bag_type: bag_type[trialn - 1],
    slow: slow[trialn - 1],
    t_click: t_click[trialn - 1],
    t_bag_dropped: t_bag_dropped[trialn - 1],
    t_feedback_end: t_feedback_end[trialn - 1],
    windowWidth: windowWidth,
    scaleBorder: scaleBorder,
    scaleLength: scaleLength
  })};
  if (bodyID != "instruction") {
    if (document.getElementById("Page1").style.display != "block") {
      setTimeout(() => {
        Slow_show("Slow"), (clickarea.onclick = []);
      }, 3000); // Slow is only shown if clicked is false (which is set true in BagFalls)
    }
  }
}

function Slow_show() {
  if (clicked == false) {
    show("Slow");
    feedback_period = true; //logs bar to current location
    slow.push(1);
    bucket_position.push("NaN");
    bag_caught.push("NaN");
    bag_type.push("NaN");
    t_click.push("NaN");
    t_bag_dropped.push("NaN");
    t_feedback_end.push("NaN");
    trialn++;

    //Also here we have to change position of the Bag etc. so that they are located correctly in the next trial
    Heli.style.left = baglocation[trialn] - half_Helisize + "%";
    Bar.style.backgroundColor = "white";
    Bag.style.left = baglocation[trialn] - half_Bagsize + "%";
    setTimeout(() => {
      hide("Slow"),
        (feedback_period = false),
        (clickarea.onclick = BagFalls),
        checkSlow();
    }, 3000);
  }
}

//Make sure that the correct boxes in attention check are selected
function checkBoxes() {
  if (
    document.getElementById("wrong1").checked == false &&
    document.getElementById("wrong2").checked == false &&
    document.getElementById("wrong3").checked == false &&
    document.getElementById("wrong4").checked == false &&
    document.getElementById("wrong5").checked == false &&
    document.getElementById("wrong6").checked == false &&
    document.getElementById("right1").checked == true &&
    document.getElementById("right2").checked == true
  ) {
    nextPage(pages[p], pages[p + 1]);
    p = p + 1;
  } else {
    alert(
      "This is not correct. Please read the instructions once more and select the correct answer. Make sure to only check one box per statement."
    );
  }
}

//Following functions areto navigate pages
function show(newPage) {
  document.getElementById(newPage).style.display = "block";
}

function hide(oldPage) {
  document.getElementById(oldPage).style.display = "none";
}

document.body.onkeydown = function (e) {
  if (e.keyCode == 32) {
    openFullscreen();
    document.getElementById("FullScreenHint").style.display = "none";
    document.getElementById("Page0").style.display = "block";
    body.style.backgroundImage = "url('css/img/background.jpg')";
  }

  if (e.keyCode == 39 && bodyID == "instruction" && p != pages.length - 1) {
    //right key move to next page
    if (p == 9) {
      checkBoxes(); //check if participants read instructions
    } else {
      nextPage(pages[p], pages[p + 1]);
      p = p + 1;
    }
  }
  if (e.keyCode == 37 && bodyID == "instruction") {
    //left key move to prev page
    prevPage(pages[p - 1], pages[p]);
    p = p - 1;
  }
};

function nextPage(currPage, newPage) {
  hide(currPage);
  show(newPage);
  body.style.backgroundImage = "url('css/img/background.jpg')";
}

function prevPage(prevPage, currPage) {
  show(prevPage);
  hide(currPage);
}

//move to next run
function nextComponent() {
  if (bodyID == "instruction") {
    results.push({ ID: participant_ID, URL: URL_params });
  }
  jatos.startNextComponent(results);
}

function endStudy() {
  jatos.endStudy(results, "done");
}
