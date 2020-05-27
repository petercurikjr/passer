window.onload = function() {
    const serverData = window.localStorage.getItem("serverData")
    localStorage.clear()
    let htmlToAdd = ''
    jsonObj = JSON.parse(serverData)
    //get the value of the first key in a json object
    jsonValue = jsonObj[Object.keys(jsonObj)[0]]
    copyButtonListener()
    console.log(jsonObj)

    //iterate through the returned value, which is an array of arrays
    for(let i=0; i<jsonValue.length-1; i++) {
        for(let passerItem of jsonValue[i]) {
            if(jsonValue[i] != null) {}
                htmlToAdd += 
                '<div class="single-passer-item">' +
                    '<div class="item-name">' +
                        '<h2>' + passerItem.itemname + '</h2>' +
                    '</div>'
                
                if (i==0) {
                    htmlToAdd +=
                    '<div class="attr-wrapper">' +
                        '<div class="attributes">' +
                            '<h3>Username or an email:</h3>' +
                            '<h3>Password:</h3>' +
                            '<h3>Website:</h3>' +
                        '</div>' +
                        '<div class="attributes">' +
                            '<h3>' + passerItem.username + '</h3>' +
                            '<h3>' + "••••••••••" + '</h3>' +
                            '<h3>' + passerItem.url + '</h3>' +
                        '</div>' +
                        '<div class="attributes">' +
                            '<div id="button-container">' +
                                '<button class="copy-button" data-clipboard-text=' + passerItem.username.split(' ').join('') + '>' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Copy</span>' +
                                '</button>' +
                            '</div>' +
                            '<div id="button-container">' +
                                '<button class="copy-button" data-clipboard-text=' + passerItem.password.split(' ').join('') + '>' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Copy</span>' +
                                '</button>' +
                            '</div>' +
                            '<div id="button-container">' +
                                '<button class="copy-button" onclick="visitWebsite(\'' + passerItem.url + '\')">' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Visit web</span>' +
                                '</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>'
                }

                else if (i==1) {
                    console.log(passerItem.cardNumber)
                    htmlToAdd +=
                    '<div class="attr-wrapper">' +
                        '<div class="attributes">' +
                            '<h3>Card number:</h3>' +
                            '<h3>Expire date:</h3>' +
                            '<h3>CVV/CVC number:</h3>' +
                        '</div>' +
                        '<div class="attributes">' +
                            '<h3>' + "•••• •••• •••• ••" + (passerItem.cardNumber).slice(-2) + '</h3>' +
                            '<h3>' + "••/••" + '</h3>' +
                            '<h3>' + "•••" + '</h3>' +
                        '</div>' +
                        '<div class="attributes">' +
                            '<div id="button-container">' +
                                '<button class="copy-button" data-clipboard-text=' + (passerItem.cardNumber).split(' ').join('') + '>' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Copy</span>' +
                                '</button>' +
                            '</div>' +
                            '<div id="button-container">' +
                                '<button class="copy-button" data-clipboard-text=' + passerItem.expireDate.split(' ').join('') + '>' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Copy</span>' +
                                '</button>' +
                            '</div>' +
                            '<div id="button-container">' +
                                '<button class="copy-button" data-clipboard-text=' + passerItem.cvv.split(' ').join('') + '>' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Copy</span>' +
                                '</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>'
                }

                else if (i==2) {
                    htmlToAdd +=
                    '<div class="attr-wrapper">' +
                        '<div class="attributes">' +
                            '<h3>Field 1:</h3>' +
                            '<h3>Field 2:</h3>' +
                            '<h3>Field 3:</h3>' +
                            '<h3>Field 4:</h3>' +
                        '</div>' +
                        '<div class="attributes">' +
                            '<h3>' + passerItem.field1 + '</h3>' +
                            '<h3>' + passerItem.field2 + '</h3>' +
                            '<h3>' + passerItem.field3 + '</h3>' +
                            '<h3>' + passerItem.field4 + '</h3>' +
                        '</div>' +
                        '<div class="attributes">' +
                            '<div id="button-container">' +
                                '<button class="copy-button" data-clipboard-text=' + passerItem.field1.split(' ').join('') + '>' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Copy</span>' +
                                '</button>' +
                            '</div>' +
                            '<div id="button-container">' +
                                '<button class="copy-button" data-clipboard-text=' + passerItem.field2.split(' ').join('') + '>' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Copy</span>' +
                                '</button>' +
                            '</div>' +
                            '<div id="button-container">' +
                                '<button class="copy-button" data-clipboard-text=' + passerItem.field3.split(' ').join('') + '>' +
                                    '<span class="circle" aria-hidden="true"></span>' +
                                    '<span class="button-text">Copy</span>' +
                                '</button>' +
                            '</div>' +
                            '<div id="button-container">' +
                            '<button class="copy-button" data-clipboard-text=' + passerItem.field4.split(' ').join('') + '>' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>'
                }
                
                htmlToAdd += '</div>'
            }
        }

    document.getElementById("passer-items-container").insertAdjacentHTML('beforeend', htmlToAdd)
}

function copyButtonListener() {
    var clipboard = new ClipboardJS('.copy-button')

    clipboard.on('success', function(e) {
        console.log(e.text)
    })
}

function visitWebsite(url) {
    if (url.includes('http://') || url.includes('https://')) {
        let win = window.open(url)
        win.focus()
    }

    else {
        let win = window.open('http://' + url)
        win.focus()
    }
}