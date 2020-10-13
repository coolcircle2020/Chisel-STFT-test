
package STFT

import chisel3._
import chiseltest._
import org.scalatest._
import org.scalatest.Matchers
import chisel3.Bool
import chiseltest.experimental.TestOptionBuilder._
import chiseltest.internal.WriteVcdAnnotation
import chisel3.experimental._

import scala.math._
import FFT._
import chisel3.experimental.FixedPoint
class BasicTest3 extends FlatSpec
  with ChiselScalatestTester
  with Matchers
  with HasDataConfig
  with HasCosineNumberConfig{
  behavior of "Tester3"
  it should "test SpectrogramGen" in { //what's this????
    var H: Bool = true.B
    var L: Bool = false.B
    test(new SpectrogramGen).withAnnotations(Seq(WriteVcdAnnotation)){c=>
      c.io.Spectrogram.ready.poke(H)
      val r = new scala.util.Random
      var bound: Double = math.pow(2.0, BinaryPoint)//
      c.io.FFTsignal.valid.poke(H)
      for(i <- 0 until 1700){
        if(i%550 == 0)  c.io.FFTsignal.valid.poke(H)
        if(i%550 == 1)  c.io.FFTsignal.valid.poke(L)
        var signal_in1 = (-bound.toInt / 2 + r.nextInt(bound.toInt)) * 2 / bound
        var signal_in2 = (-bound.toInt / 2 + r.nextInt(bound.toInt)) * 2 / bound
        c.io.FFTsignal.bits.re.poke(signal_in1.F(DataWidth.W,BinaryPoint.BP))
        c.io.FFTsignal.bits.im.poke(signal_in2.F(DataWidth.W,BinaryPoint.BP))
        c.clock.step()
      }
      //c.io.Spectrogram.ready.poke(L)
      //c.io.FFTsignal.bits.re.poke(1.F(DataWidth.W,BinaryPoint.BP))
      //c.io.FFTsignal.bits.im.poke(1.F(DataWidth.W,BinaryPoint.BP))
      //c.clock.step(3)
      //c.io.Spectrogram.ready.poke(L)
    }
  }
}
