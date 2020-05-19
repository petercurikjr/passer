var sixDigitCodeArray = ["","","","","",""]
let sessionID = Date.now().toString(36) + Math.random().toString(36).substr(2, 5)

//Initial state. Only the first box of sixdigitcode is writable
function startingJS() {
    localStorage.clear()
    generateQRcode()

        setInterval(function() {
            let xhr = new XMLHttpRequest()
            xhr.open("POST", "https://api-passer.herokuapp.com/verifyQRfromwebsite", true)
            xhr.setRequestHeader("Content-Type", "application/json")
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    //success
                    if(xhr.responseText != "Nothing") {
                        window.localStorage.setItem("serverData",xhr.responseText)
                        window.location.replace("passwords.html");
                    }
                }
            }
            let data = 
            {
                "sessionID": sessionID
            }

            let jsonData = JSON.stringify(data)
            xhr.send(jsonData)
        }, 1500)   

    for(var i=2; i<=6; i++) {
        document.getElementById(i).disabled = true
    }
}

//Handle input event
function getEntryID(input) {
    let fieldNumber = parseInt(input)
    let val = document.getElementById(fieldNumber).value

    if(parseInt(val) >= 0 && parseInt(val) <= 9) {
        sixDigitCodeArray[fieldNumber-1] = val
        console.log("Array:", sixDigitCodeArray)

        //Automatic switching to next entry field
        if(fieldNumber !== 6) {
            document.getElementById(fieldNumber+1).disabled = false
            document.getElementById(fieldNumber+1).focus()
        }

        //Lock all entries and HTTP POST to server
        else {
            document.getElementById(fieldNumber).blur()
            for(var i=1; i<=6; i++) {
                document.getElementById(i).disabled = true
            }
            createSpinner()
            verify()
        }
    }
    else {
        document.getElementById(fieldNumber).value = ""
    }
}

function handleInput(event, id) {
   let key = (window.Event) ? event.which : event.keyCode
   if(key == 8 && id > 1 && document.getElementById(id).value == "") {
       document.getElementById(id-1).focus()
   }
   else if(key == 37 && id > 1 && !event.shiftKey) {
       document.getElementById(id-1).focus()
   }
   else if(key == 39 && id < 6 && !event.shiftKey) {
       document.getElementById(parseInt(id)+1).focus() 
   }
   else if(key == 8 && !document.getElementById(id).value == "") {
       document.getElementById(id).value = ""
       sixDigitCodeArray[id-1] = ""
   }
}

//Networking processes
function verify() {
    let codeJoined = String(sixDigitCodeArray.join(''))

    let xhr = new XMLHttpRequest()
    xhr.open("POST", "https://api-passer.herokuapp.com/verifySixDigitfromwebsite", true)
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            //success
            if(xhr.responseText != "Wrong code") {
                window.localStorage.setItem("serverData",xhr.responseText)
                window.location.replace("passwords.html");
            }
            else {
                setTimeout(function(){
                    let spinner = document.getElementsByClassName("lds-spinner")
                    for(var i=0; i<spinner.length; i++) {
                        spinner[i].style.display = "none"
                    }
                    let error = document.getElementById("error")
                    error.style.display = "block"
                }, 500);

                setTimeout(function(){
                    clear()
                }, 2000)

            }
        }
    }
    let data = 
        {
            "sixdigitTyped": codeJoined
        }

    let jsonData = JSON.stringify(data)
    xhr.send(jsonData)
}

function clear() {
    let parent = document.getElementById("code-entry")
    let children = parent.querySelectorAll(".number-field")
    for(let i=0; i<children.length; i++) {
        children[i].value = ""
    }
    sixDigitCodeArray = []
    children[0].disabled = false
}

function generateQRcode() {
    var qr = new QRCode(document.getElementById("qr-image"), {
        width: 120,
        height: 120,
        correctLevel : QRCode.CorrectLevel.L
    })
    qr.makeCode(sessionID)
}

//Loading graphics
function createSpinner() {
    var div = document.createElement("div")
    div.setAttribute("class", "lds-spinner")
    document.getElementById("code-option").appendChild(div)
    for(var i=0; i<12; i++) {
        var childDiv = document.createElement("div")
        div.appendChild(childDiv)
    }
    document.getElementById("code-option").appendChild(div)
}
