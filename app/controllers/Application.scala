package controllers

import play.api._
import play.api.mvc._
    
import play.api.libs.iteratee._
import play.api.libs.concurrent.Execution.Implicits.defaultContext  
    
import play.api.data.Form
import play.api.data.Forms._
    
import scala.collection.mutable.Set
    
    
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
      
      
  //broadcastの場合、外で(out,channel)を定義し、unicastの場合中でrequestごとに定義する
    
  val (out, channel) = Concurrent.broadcast[String]

  def ws = WebSocket.using[String] { request => 
            
      val in = Iteratee.foreach[String] { msg => 

        println(msg)
      
        channel push(msg)  
                        
        }.map{ _ => println("closed") } //when connection close

      (in, out)
                                   
      }
    
    
}