
package STFT

import FFT._
import chisel3._
import chisel3.experimental._
//import chisel3.internal.InternalDontCare.:=
import chisel3.util._

import scala.math._

class SpectrogramGen extends Module
  with HasDataConfig
  with HasCosineNumberConfig{
  val io = IO(new Bundle {
    val FFTsignal = Flipped(Decoupled(new MyComplex))
    val Spectrogram = Decoupled(new MyFixedPoint)
  })
  val SpectrogramReg = Reg(new MyFixedPoint)
  val SpectrogramCnt = RegInit(0.U(10.W))  //use 10 bite to be enough for 512

  /*io.Spectrogram.valid:=true.B
  io.FFTsignal.ready:=true.B
  io.Spectrogram.bits.value:=1.F(DataWidth.W, BinaryPoint.BP)//only for test*/

  when(io.FFTsignal.valid && io.Spectrogram.ready) {
    SpectrogramReg := ComplexEnergy(io.FFTsignal.bits, io.FFTsignal.bits)
    io.Spectrogram.valid := true.B
    io.FFTsignal.ready := false.B
    SpectrogramCnt := SpectrogramCnt + 1.U
  }.elsewhen(SpectrogramCnt < 512.U) { //constantly transfer 512 FFT result
    SpectrogramCnt := SpectrogramCnt + 1.U
    io.FFTsignal.ready := false.B
    when(SpectrogramCnt < 257.U) {
      SpectrogramReg := ComplexEnergy(io.FFTsignal.bits, io.FFTsignal.bits)
      io.Spectrogram.valid := true.B
    }.otherwise {
      io.Spectrogram.valid := false.B
    }

  }.otherwise{
    SpectrogramCnt := 0.U(10)
    io.Spectrogram.valid := false.B
    io.FFTsignal.ready := true.B
  }
  io.Spectrogram.bits.value := SpectrogramReg.value//changed!added.value
}
