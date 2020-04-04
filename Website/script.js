var sixDigitCodeArray = [];


function startingJS() {
    for(var i=2; i<=6; i++) {
        document.getElementById(i).disabled = true;
    }
}

function selectText(textbox) {
    textbox.select();
} 

function getEntryID(input) {
    var fieldNumber = parseInt(input);
    sixDigitCodeArray.push(document.getElementById(fieldNumber).value);
    console.log("Array:", sixDigitCodeArray);

    if(fieldNumber !== 6) {
        document.getElementById(fieldNumber+1).disabled = false;
        document.getElementById(fieldNumber+1).focus();
    }

    else {
        document.getElementById(fieldNumber).blur();
        for(var i=1; i<=6; i++) {
            document.getElementById(i).disabled = true;
        }
        createSpinner();
        verify();
    }
}

function verify() {
    //TBD!
    console.log("Here")
    getJSON('http://192.168.1.118:5000/',
    function(err, data) {
        if (err !== null) {
            alert('Something went wrong: ' + err);
        }
        else {
            alert('Your query count: ' + data.query.count);
        }
});
}

function createSpinner() {
    var div = document.createElement("div");
    div.setAttribute("class", "lds-spinner");
    document.getElementById("code-option").appendChild(div);
    for(var i=0; i<12; i++) {
        var childDiv = document.createElement("div");
        div.appendChild(childDiv);
    }
    document.getElementById("code-option").appendChild(div);
}

var getJSON = function(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = 'json';
    xhr.onload = function() {
      var status = xhr.status;
      if (status === 200) {
        callback(null, xhr.response);
      } else {
        callback(status, xhr.response);
      }
    };
    xhr.send();
};

