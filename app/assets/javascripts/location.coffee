$ -> 

    minIdo = 13.0000000 #39.370000000000000
    maxIdo = 14.0000000 #39.380000000000000
    
    minKeido = 100.0000000 #140.110000000000000
    maxKeido = 101.0000000 #140.130000000000000

    
    locationFiltering = -> 
        navigator.geolocation.getCurrentPosition(whenSuccess, whenError)
            
            
    whenSuccess = 
        (position) -> 
            
            check = false 
    
            ido = position.coords.latitude
            keido = position.coords.longitude
                
            $("body").append("<p>" + ido + "</p>")
            $("body").append("<p>" + keido + "</p>")
                
            if ido > minIdo and ido < maxIdo and keido > minKeido and keido < maxKeido
                check = true
                    
            if !check
                document.write("Cannot")   
                
    whenError = (error) -> alert "Cannot extract geo data" 
                
    
    locationFiltering()
                        