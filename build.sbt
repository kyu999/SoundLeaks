import com.github.play2war.plugin._

name := "SoundLeaks"

version := "1.0-SNAPSHOT"

libraryDependencies ++= Seq(
  jdbc,
  anorm,
  cache
)     

play.Project.playScalaSettings
    
Play2WarPlugin.play2WarSettings

Play2WarKeys.servletVersion := "3.0"