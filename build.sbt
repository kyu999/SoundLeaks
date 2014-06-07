
name := "SoundLeaks"

version := "1.0-SNAPSHOT"

libraryDependencies ++= Seq(
  jdbc,
  anorm,
  cache, 
  "org.apache.commons" % "commons-email" % "1.3.2"
)     

play.Project.playScalaSettings