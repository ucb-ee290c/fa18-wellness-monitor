package randomforest

import chisel3._
import chisel3.util.{RegEnable}
import dsptools.numbers._
import dspjunctions.ValidWithSync

import scala.collection._

trait RandomForestParams[T <: Data] {
  val protoData: T

  val nFeatures: Int      // the number of input features
  val nDepth: Int         // depth of each tree
  val nTrees: Int         // number of trees in the forest

  val featureSelect: Seq[Seq[Int]]
  // this selects which feature (indexed by array) is being checked for the threshold declared earlier
}

class RandomForestIO[T <: Data](params: RandomForestParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  val out = ValidWithSync(UInt(1.W))

  val thresholds = Input(Vec(params.nTrees, Vec((1 << params.nDepth) - 1, params.protoData)))
  // this is the decision tree thresholds for comparison

  val leafVotes = Input(Vec(params.nTrees, Vec(1 << params.nDepth, params.protoData)))
  // this determines the vote of each tree after arriving at the end of the node

  // these are some probe points, to ensure computational accuracy
  val rawVotes = Output(params.protoData) // sum of votes of each class

  override def cloneType: this.type = RandomForestIO(params).asInstanceOf[this.type]
}
object RandomForestIO {
  def apply[T <: Data](params: RandomForestParams[T]): RandomForestIO[T] = new RandomForestIO(params)
}

class RandomForest[T <: chisel3.Data : Real](val params: RandomForestParams[T]) extends Module {
  require(params.nFeatures >= 1, f"Must have at least 1 feature, currently ${params.nFeatures}")
  require(params.nDepth >= 1, f"nDepth must be at least 1, currently ${params.nDepth}")
  require(params.nTrees >= 1, f"Must have at least 1 tree, currently ${params.nTrees}")
  require(params.featureSelect.map(_.forall(a => (a >= 0) && (a < params.nFeatures))).forall(_ == true),
    "Feature select array should only contain positive integer elements until nFeatures")
  require(params.featureSelect.length == params.nTrees,
    "Size of featureSelect row must match nTrees")
  require(params.featureSelect.head.length == (1 << params.nDepth) - 1,
    "Size of featureSelect column must match 2^depth - 1")

  val io = IO(new RandomForestIO[T](params))

  val tableVotes = Seq.fill(params.nTrees)(Wire(params.protoData))

  for (i <- 0 until params.nTrees) { // for every tree

    if (params.nDepth == 1){ // depth of 1, vector length 1
      // first check the feature that must be compared, do the comparison, the select the corresponding vote from leaf
      tableVotes(i) := Mux(io.in.bits(params.featureSelect(i)(0)) > io.thresholds(i)(0), io.leafVotes(i)(1), io.leafVotes(i)(0))

    } else if (params.nDepth == 2){ // depth of 2, vector length 3

      tableVotes(i) := Mux(io.in.bits(params.featureSelect(i)(0)) > io.thresholds(i)(0),
        Mux(io.in.bits(params.featureSelect(i)(1)) > io.thresholds(i)(1), io.leafVotes(i)(1), io.leafVotes(i)(0)),
        Mux(io.in.bits(params.featureSelect(i)(2)) > io.thresholds(i)(2), io.leafVotes(i)(3), io.leafVotes(i)(2)))

    } else if (params.nDepth == 3){ // depth of 3, vector length 7

      tableVotes(i) := Mux(io.in.bits(params.featureSelect(i)(0)) > io.thresholds(i)(0),
        Mux(io.in.bits(params.featureSelect(i)(1)) > io.thresholds(i)(1),
          Mux(io.in.bits(params.featureSelect(i)(3)) > io.thresholds(i)(3),io.leafVotes(i)(1), io.leafVotes(i)(0)),
          Mux(io.in.bits(params.featureSelect(i)(4)) > io.thresholds(i)(4),io.leafVotes(i)(3), io.leafVotes(i)(2))),
        Mux(io.in.bits(params.featureSelect(i)(2)) > io.thresholds(i)(2),
          Mux(io.in.bits(params.featureSelect(i)(5)) > io.thresholds(i)(5),io.leafVotes(i)(5), io.leafVotes(i)(4)),
          Mux(io.in.bits(params.featureSelect(i)(6)) > io.thresholds(i)(6),io.leafVotes(i)(7), io.leafVotes(i)(6))))

    } else { // I can do this all day...

      tableVotes(i) := Mux(io.in.bits(params.featureSelect(i)(0)) > io.thresholds(i)(0),
        Mux(io.in.bits(params.featureSelect(i)(1)) > io.thresholds(i)(1),
          Mux(io.in.bits(params.featureSelect(i)(3)) > io.thresholds(i)(3),
            Mux(io.in.bits(params.featureSelect(i)(7)) > io.thresholds(i)(7),io.leafVotes(i)(1), io.leafVotes(i)(0)),
            Mux(io.in.bits(params.featureSelect(i)(8)) > io.thresholds(i)(8),io.leafVotes(i)(3), io.leafVotes(i)(2))),
          Mux(io.in.bits(params.featureSelect(i)(4)) > io.thresholds(i)(4),
            Mux(io.in.bits(params.featureSelect(i)(9)) > io.thresholds(i)(9),io.leafVotes(i)(5), io.leafVotes(i)(4)),
            Mux(io.in.bits(params.featureSelect(i)(10)) > io.thresholds(i)(10),io.leafVotes(i)(7), io.leafVotes(i)(6)))),
        Mux(io.in.bits(params.featureSelect(i)(2)) > io.thresholds(i)(2),
          Mux(io.in.bits(params.featureSelect(i)(5)) > io.thresholds(i)(5),
            Mux(io.in.bits(params.featureSelect(i)(11)) > io.thresholds(i)(11),io.leafVotes(i)(9), io.leafVotes(i)(8)),
            Mux(io.in.bits(params.featureSelect(i)(12)) > io.thresholds(i)(12),io.leafVotes(i)(11), io.leafVotes(i)(10))),
          Mux(io.in.bits(params.featureSelect(i)(6)) > io.thresholds(i)(6),
            Mux(io.in.bits(params.featureSelect(i)(13)) > io.thresholds(i)(13),io.leafVotes(i)(13), io.leafVotes(i)(12)),
            Mux(io.in.bits(params.featureSelect(i)(14)) > io.thresholds(i)(14),io.leafVotes(i)(15), io.leafVotes(i)(14)))))

    } // Can you check for a pattern instead?
  }

  val actualVotes = tableVotes.reduce(_ + _)
  val finalPredict = Mux(actualVotes >= 0, 1.U, 0.U)

  // put for output probing and checking for computation accuracy, pipelined at the output
  val rawVotesReg = RegEnable(actualVotes, io.in.valid)
  val outReg = RegEnable(finalPredict, io.in.valid)
  val valReg = RegNext(io.in.valid)
  val syncReg = RegNext(io.in.sync)

  // final output assignment
  io.rawVotes := rawVotesReg
  io.out.bits := outReg
  io.out.valid := valReg
  io.out.sync := syncReg

}