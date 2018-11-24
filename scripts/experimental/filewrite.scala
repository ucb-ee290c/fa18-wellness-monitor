import scala.collection.mutable.ArrayBuffer
import java.io._

object csvRead extends App {

  val rows = ArrayBuffer[Array[String]]()

  // Read a CSV file
  val fileSource = io.Source.fromFile("/Users/adelson.chua/fa18-wellness-monitor/scripts/generated_files/support_vectors.csv")
  fileSource.getLines.foreach { line =>
    rows += line.split(",").map(_.trim)
  }
  fileSource.close()

  // Convert strings to double
  val doubleArray = rows.map(_.map(_.toDouble))
  // Now you can play around with it
  println(doubleArray.indices)
  println(doubleArray.head.indices)

  //######################################
  // this code segment should be in the Spec file
  val newFile = new File("/Users/adelson.chua/fa18-wellness-monitor/scripts/generated_files/test.txt")
  if (newFile.exists) {
    newFile.delete()
  }

  //######################################
  // this block of code should be in the Golden model
  // where you are calculating the correct answer
  val stringTest = doubleArray.map(_.mkString("{", ", ", "}")).mkString("{", ", ", "}")
  val file = new FileWriter("/Users/adelson.chua/fa18-wellness-monitor/scripts/generated_files/test.txt",true)
  file.write("double supports[][] = ")
  file.write(stringTest)
  file.write("\n")
  file.close()

}
