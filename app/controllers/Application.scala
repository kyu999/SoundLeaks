package controllers

import play.api._
import play.api.mvc._
    
import play.api.libs.iteratee._
import play.api.libs.concurrent.Execution.Implicits.defaultContext  
    
import play.api.data.Form
import play.api.data.Forms._
        
//import play.api.Play.current
//import com.typesafe.plugin._
    
import org.apache.commons.mail._
    
object Application extends Controller
{
    
  def index = Action { implicit request =>
      
   Ok( views.html.index() )
  }


  def login = WebSocket.using[String] { request => 
      
      val (loginOut, loginChannel) = Concurrent.broadcast[String]
      
      val in = Iteratee.foreach[String] { msg => 
       
        println(msg)
      
        if(msg == "aiura" ||  msg == "guards") loginChannel.push("loginPolice")
      
        else if(msg == "aiu") loginChannel.push("loginStudent")
      
        else loginChannel.push("Invalid input")
      
      }
      
      (in, loginOut)
      
  }
          
  val sendMail = { (message: String) => 
        val mail = new SimpleEmail;
        mail.setHostName("smtp.googlemail.com")
        mail.setSmtpPort(465)
        mail.setAuthenticator(
            new DefaultAuthenticator("soundleaksAIU@gmail.com", "cannotsleep119"))
        mail.setSSLOnConnect(true)
        mail.setFrom("soundleaksAIU@gmail.com")
        mail.setSubject("Issue Happened!!")
        mail.addTo("kyukokkyou999@gmail.com")
        mail.setMsg(message)  
        mail.send() 
    }

    
  //broadcastの場合、外で(out,channel)を定義し、unicastの場合中でrequestごとに定義する
    
  val (out, channel) = Concurrent.broadcast[String]

  def ws = WebSocket.using[String] { request => 
            
      val in = Iteratee.foreach[String] { msg => 
      
        val data = msg.split(",")
      
        println(msg)
      
        channel push(msg)  

//        if(data.head == "issue") 
//            sendMail("Issue happened at " + data(1) + " description : " + data(2))
                        
        }.map{ _ => println("closed") } //when connection close

      (in, out)
                                   
      }
    
    
}