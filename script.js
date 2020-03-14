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
    console.log("Verifying...");
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