window.onload = function() {
    //precitat si o localStorage
    const testjson = '["647275","04/05/2020 02:50:30",[{"favourites":false,"group":2,"id":"E1AF0423-C318-4D75-A0C2-FF6AD1C91B7B","itemname":"Work password","password":"nepoviemti12","url":"VUB.sk","username":"pcurik@ext.vub.sk"},{"favourites":false,"id":"E0B5ADAD-FD8E-418A-8A73-F367501B0374","itemname":"Gmail account","password":"hesielko123","url":"mail.google.com","username":"petocurik@gmail.com"},{"favourites":false,"group":2,"id":"E1AF0423-C318-4D75-A0C2-FF6AD1C91B7B","itemname":"Work password","password":"nepoviemti12","url":"VUB.sk","username":"pcurik@ext.vub.sk"}],[{"cardNumber":"4409 8753 2589 5323","cvv":"423","expireDate":"03/23","favourites":false,"id":"E0D4E899-61AE-4B09-A433-F9D4A9218AD3","itemname":"Bank card Tatra banka","pinNumber":"1234"}],[{"favourites":false,"field1":"itemname1","group":3,"id":"AEEDF44B-A364-482A-A205-8754E5058745","itemname":"One other item"}]]'
    let htmlToAdd = ''
    obj = JSON.parse(testjson)
    for(let i=2; i<obj.length; i++) {
        for(let passerItem of obj[i]) {
            if(obj[i] != null) {}
                htmlToAdd += 
                '<div class="single-passer-item">' +
                    '<div class="item-name">' +
                        '<h2>' + passerItem.itemname + '</h2>' +
                    '</div>'
                
                if (i==2) {
                    htmlToAdd +=
                    '<div class="attributes">' +
                        '<h3>Username or an email:</h3>' +
                        '<h3>' + passerItem.username + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>' + 
                    '<div class="attributes">' +
                        '<h3>Password:</h3>' +
                        '<h3>' + passerItem.password + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="attributes">' +
                        '<h3>Password:</h3>' +
                        '<h3>' + passerItem.url + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="visitWebsite()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Visit web</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>'
                }

                else if (i==3) {
                    htmlToAdd +=
                    '<div class="attributes">' +
                        '<h3>Card number:</h3>' +
                        '<h3>' + passerItem.cardNumber + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>' + 
                    '<div class="attributes">' +
                        '<h3>Expire date:</h3>' +
                        '<h3>' + passerItem.expireDate + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="attributes">' +
                        '<h3>CVV/CVC number:</h3>' +
                        '<h3>' + passerItem.cvv + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>'
                }

                else if (i==4) {
                    htmlToAdd +=
                    '<div class="attributes">' +
                        '<h3>Field 1:</h3>' +
                        '<h3>' + passerItem.field1 + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>' + 
                    '<div class="attributes">' +
                        '<h3>Field 2:</h3>' +
                        '<h3>' + passerItem.field2 + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="attributes">' +
                        '<h3>Field 3:</h3>' +
                        '<h3>' + passerItem.field3 + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="attributes">' +
                        '<h3>Field 4:</h3>' +
                        '<h3>' + passerItem.field4 + '</h3>' +
                        '<div id="button-container">' +
                            '<button class="copy-button" onclick="copyToClipboard()">' +
                                '<span class="circle" aria-hidden="true"></span>' +
                                '<span class="button-text">Copy</span>' +
                            '</button>' +
                        '</div>' +
                    '</div>'
                }
                
                htmlToAdd += '</div>'
                console.log(passerItem.itemname, htmlToAdd)
            }
        }

    document.getElementById("passer-items-container").insertAdjacentHTML('beforeend', htmlToAdd)
}
/*
    let singlePasserItem = document.createElement("div")
    singlePasserItem.className = "single-passer-item"
    let itemName = document.createElement("div")
    itemName.className = "item-name"
    document.singlePasserItem.

    document.getElementById("passer-items-container").appendChild(singlePasserItem)
    */