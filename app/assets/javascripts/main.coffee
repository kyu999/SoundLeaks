$ -> 

    
    loginStatus = ""   
    
    issueHappen = 0
    
    issues = []
    numOfIssues = 0
    
    
    
# page move by removing and adding html elements --------------------

    cleanPage = -> $("#box").remove()
    
    studentAfterIssuePage = 
        "<div id = 'box'>
            <div class = 'top'>Sent Message to RAs</div>
            <div class = 'top'>You can go to bed :)</div>
            <img class = 'chara' src = '../assets/images/justFit.png' height = '270px'>
        </div>"
        
    studentAfterGotItPage = 
        "<div id = 'box'>
            <div class = 'top'>Someone got it.</div>
            <div class = 'top'> Go to Bed!!</div>
            <img class = 'chara' src = '../assets/images/justFit.png' height = '270px'>
        </div>"
       
    makePoliceAfterIssuePage = (building, description) -> 
        $("#content")
            .append("<div id = 'box'><div class = 'top'>Issue happen at " + building + "</div>
                        <div class = 'top'>Description : " + description + "
                        <p><img id = 'gotIt' src = '../assets/images/gotIt.png' height = '150px'></p>
                     </div>")       
            
# WebSocket define -------------------------------------------------
    
    ws = new WebSocket("ws://soundleaks.herokuapp.com/ws")
    
    connectSocket = ->    
    
#    ws = new WebSocket("ws://soundleaks.herokuapp.com/ws")
        ws = new WebSocket("ws://soundleaks.herokuapp.com/ws")
    
        ws.onopen = (event) -> 
        
            console.log("connected again after login")
        
        ws.onmessage = (event) -> 
    
            data = event.data.split(",")
        
            infotype = data[0]
        
            if infotype == "issue" 
              
                if loginStatus == "Police"
                    
                    cleanPage()
                    $.ionSound.play("sad")
                    makePoliceAfterIssuePage(data[1], data[2])
                    changeOpacity("#gotIt")
                    $("#gotIt").on("click", (event) -> 
                                            $.ionSound.stop("sad")
                                            ws.send("gotIt") )
                                
                else 
                    console.log("weired")
            
            else if infotype == "gotIt" 
            
                $.ionSound.play("button")
            
                if loginStatus == "Student"
                    cleanPage()
                    $("#content").append(studentAfterGotItPage)
                
                else if loginStatus == "Police"
                    cleanPage()
                    $.ionSound.stop("sad")
                    makePolicePage()
                
                else 
                    console.log("weired")
            
            else 
                console.log("weired message came in")
                
        ws.onerror = (event) -> 
            
            alert "something wrong happened"    
        
        ws.onclose = (event) -> 
            connectSocket()
            console.log("connection closed. reconnect it")
        
    
    connectSocket()
# extract input value when login ----------------------------------------------------

#    place = ""


    currentBuilding = ""
    
    validation = (room) -> room == "issue" or room == "gotIt" or room = "" or currentBuilding == ""
    
    sendInfo = ->
        
        room = $("#room").val() #actually, room number or description about the place
                
        if validation(room)
            console.log("shouldn't send only that word")
        
        else
            cleanPage()
            $.ionSound.play("button")
            $("#content").append(studentAfterIssuePage)
            console.log("send room or descriptive data to server")
            ws.send("issue," + currentBuilding + "," + room)           
    
    changeOpacity = 
        (selector) -> $(selector).on({
                                     "mouseenter":  () -> $(this).css("opacity", 0.8), 
                                     "mouseleave": () -> $(this).css("opacity", 1.0)
                                     })
    
    changeColor = 
        (building) -> 
            $("#" + building).on("click", (event) -> 
                                          if currentBuilding != ""
                                                $("#" + currentBuilding).css("background-color", "green")
                                          currentBuilding = building
                                          $(this).css("background-color", "teal")
                                )
                        
            
    

        
# small funcs around login define ------------------------------------------

    appendEver = false

    appendInvalid = -> 
            if appendEver
                console.log("it's invalid password")
            else 
                $("#login").append("<p id = 'invalid'>invalid password</p>")
                appendEver = true
            
    makeStudentPage = -> 
        
        $("#content")
            .append("
        <div id = 'box'>
          <div class = 'top'>Where might be the noise from?</div>
          <div class = 'top'>Choose building & describe the place</div>
          <div class = 'questions'>
            <div id = 'first-Q'>

              <button type='button' id = 'Komachi' class='btn btn-Komachi'>Komachi</button>
              <button type='button' id = 'Univ' class='btn btn-Univ'>Univ</button>
              <button type='button' id = 'Glob' class='btn btn-Glob'>Glob</button>
              <button type='button' id = 'Sakura' class='btn btn-Sakura'>Sakura</button>

            </div>

            <div id = 'second-Q'>
              <input type = 'text' id = 'room' class='form-control' placeholder='approximate room number or short description about the place'>
            </div>
            
            <button type='button' id = 'Submit' class='btn btn-Submit'>Submit</button>
          </div>
        </div>")
            
        $("#Submit").on("click", 
                        (event) -> sendInfo() 
                        )
        
        changeColor("Komachi")
        changeColor("Glob")
        changeColor("Univ")
        changeColor("Sakura")



    makePolicePage = ->
        
        $("#content")
            .append("
        <div id = 'box'>
            <div class = 'top'>Watch and Wait for issue...</div>
            <img class = 'chara' src = '../assets/images/justFit.png' height = '270px'>
        </div>
                     ")
    
    
    loginWs = new WebSocket("ws://soundleaks.herokuapp.com/login")    
#    loginWs = new WebSocket("ws://soundleaks.herokuapp.com/login")


    
    afterLogin = (who) -> 
            cleanPage()
            loginWs.close(1000)
            if who == "Student" 
                makeStudentPage(who)
            else if who == "Police" 
                makePolicePage(who)
            else alert "you are not student nor police"

# WebSocket for login define ------------------------------------------

    loginWs.onopen = (event) -> 

        console.log("connected for login")
    
    loginWs.onmessage = (event) ->
        data = event.data
        
        console.log("got data from server")
        
        if data == "loginPolice"
            loginStatus = "Police"
            afterLogin(loginStatus)
            
            
        else if data == "loginStudent" 
            loginStatus = "Student"
            afterLogin(loginStatus)
            
        else appendInvalid()
                
    loginWs.onerror = (event) -> 

        console.log("error happned")

# extract input value when login ----------------------------------------------------

    getInput = ->
        
        inputValue = $("#password").val()
        
        if(inputValue != "")
            console.log("send data to server")
            loginWs.send(inputValue)
            
        else appendInvalid()
            
    $("#loginButton").on("click", (event) -> getInput() )
    