var sixDigitCodeArray = ["","","","","",""]

//Initial state. Only the first box of sixdigitcode is writable
function startingJS() {
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
    xhr.open("POST", "https://api-passer.herokuapp.com/verify_from_website", true)
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            //success
            console.log("Server response: " + xhr.responseText)
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


    };
    let data = 
        {
            "sixdigitTyped": codeJoined
        }

    let jsonData = JSON.stringify(data)
    console.log("Veryfing data: " + jsonData)

    xhr.send(jsonData)
}

function redirect(response) {
    setTimeout(function(){
       // location.replace("passwords.html")
        //showPasserItems(response)
    }, 500);
}

//["334195","04/05/2020 02:49:26",[{"favourites":false,"group":2,"id":"E1AF0423-C318-4D75-A0C2-FF6AD1C91B7B","itemname":"Work password","password":"nepoviemti12","url":"VUB.sk","username":"pcurik@ext.vub.sk"}],[],[]]
//["647275","04/05/2020 02:50:30",[{"favourites":false,"group":2,"id":"E1AF0423-C318-4D75-A0C2-FF6AD1C91B7B","itemname":"Work password","password":"nepoviemti12","url":"VUB.sk","username":"pcurik@ext.vub.sk"},{"favourites":false,"id":"E0B5ADAD-FD8E-418A-8A73-F367501B0374","itemname":"Gmail account","password":"hesielko123","url":"mail.google.com","username":"petocurik@gmail.com"},{"favourites":false,"group":2,"id":"E1AF0423-C318-4D75-A0C2-FF6AD1C91B7B","itemname":"Work password","password":"nepoviemti12","url":"VUB.sk","username":"pcurik@ext.vub.sk"}],[{"cardNumber":"4409 8753 2589 5323","cvv":"423","expireDate":"03/23","favourites":false,"id":"E0D4E899-61AE-4B09-A433-F9D4A9218AD3","itemname":"Bank card Tatra banka","pinNumber":"1234"}],[{"favourites":false,"field1":"itemname1","group":3,"id":"AEEDF44B-A364-482A-A205-8754E5058745","itemname":"One other item"}]]
function showPasserItems(response) {
    let testjson =
        ["334195","04/05/2020 02:49:26",
            [
                {
                    "favourites":false,
                    "group":2,
                    "id":"E1AF0423-C318-4D75-A0C2-FF6AD1C91B7B",
                    "itemname":"Work password",
                    "password":"nepoviemti12",
                    "url":"VUB.sk",
                    "username":"pcurik@ext.vub.sk"
                }
            ],
            [],
            []
        ]
    console.log(testjson)
    //precitat si o localStorage
    document.getElementById("text").innerHTML = str
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
