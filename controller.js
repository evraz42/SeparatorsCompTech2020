class Controller {
  constructor() {
    this.govnoFlag = 0;

    this.arrayOfFuncs = [];

    this.filtersMask = new Array(7); //7 undefined values

    this.entries;

    //create connection with web server
    this.frontSideSocket = new WebSocket(
      "wss://www.example.com/socketserver",
      "protocolOne"
    );

    //receive msgs from server
    this.frontSideSocket.onmessage = function(event) {
      console.log(event.data); //в event.data json объект
      this.entries = JSON.parse(event.data); //приходит string с сервера
      this.govnoFlag = 1;
    };
  }

  //общение с бэком
  getEntries() {
    //напишу getEntries в app и эта штука будет слушать?
    this.arrayOfFuncs.push(this.frontSideSocket.onmessage);

    //???костыль!!!!
    while (this.govnoFlag != 1) {} //костыль!!!!
    this.govnoFlag = 0;
    return this.entries; //return json object
  }

  sendQuery() {
    var msg = {
      type: "historicalData",
      arrOfFilters: this.filtersMask
    };

    // Send the msg object as a JSON-formatted string.
    this.frontSideSocket.send(JSON.stringify(msg));
  }
  //фильтры////// //
  //пока все фильтры через базу работают
  //time
  sendTimesRangeQuery(
    firstTime,
    lastTime // время в формате милисекунды от 1970 года
  ) {
    this.filtersMask[0] = {
      firstTime: firstTime,
      lastTime: lastTime
    };

    this.sendQuery();
  }

  //left or right flag
  send_l_r_flagQuery(
    isLeft // isLeft boolean
  ) {
    this.filtersMask[1] = {
      flag: isLeft
    };

    this.sendQuery();
  }

  //flagPositions range
  sendFlagPosesRangeQuery(
    leftPos,
    rightPos //pos number
  ) {
    this.filtersMask[2] = {
      leftPos: leftPos,
      rightPos: rightPos
    };

    this.sendQuery();
  }

  //probability
  sendProbsRangeQuery(
    leftProb,
    rightProb //pos number
  ) {
    this.filtersMask[3] = {
      leftProb: leftProb,
      rightProb: rightProb
    };

    this.sendQuery();
  }
  //probabilityAllPoses
  sendProbsAllPosnsRangeQuery(
    leftProbAll,
    rightProbAll //pos number
  ) {
    this.filtersMask[4] = {
      leftProbAll: leftProbAll,
      rightProbAll: rightProbAll
    };

    this.sendQuery();
  }

  //separators numbers
  sendSeparsRangeQuery(
    firstSeparNum,
    lastSeparNum //pos number
  ) {
    this.filtersMask[5] = {
      firstSeparNum: firstSeparNum,
      lastSeparNum: lastSeparNum
    };

    this.sendQuery();
  }

  //image link filter absence
}
