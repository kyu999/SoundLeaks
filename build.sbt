import com.github.play2war.plugin._

name := "SoundLeaks"

version := "1.0-SNAPSHOT"

libraryDependencies ++= Seq(
  jdbc,
  anorm,
  cache, 
  "com.typesafe" %% "play-plugins-mailer" % "2.1-RC2", 
  "org.apache.commons" % "commons-email" % "1.3.2"
)     

play.Project.playScalaSettings
    
Play2WarPlugin.play2WarSettings

Play2WarKeys.servletVersion := "3.0"