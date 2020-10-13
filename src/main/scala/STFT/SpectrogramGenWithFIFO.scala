
package STFT
import FFT._
import chisel3._
import chisel3.experimental._
import chisel3.util._
import scala.math._

class SpectrogramGenWithFIFO extends Module
  with HasDataConfig
  with HasCosineNumberConfig {
  val io = IO(new Bundle {
    val FFTsignal = Flipped(Decoupled(new MyComplex))
    val Spectrogram = Decoupled(new MyFixedPoint)
  })
  val SpectrogramGenblock: SpectrogramGen = Module(new SpectrogramGen)
  val SpectrogramFIFO: MyFifo = Module(new MyFifo(depth=900,threshold = 512))


  io.FFTsignal <> SpectrogramGenblock.io.FFTsignal//busrt i_valid


  SpectrogramFIFO.io.wr := SpectrogramGenblock.io.Spectrogram.valid
  SpectrogramGenblock.io.Spectrogram.ready := ((900.U - SpectrogramFIFO.io.count) > 257.U) //fifo remain capacity more than 512
  SpectrogramFIFO.io.datain := SpectrogramGenblock.io.Spectrogram.bits

  io.Spectrogram.bits        := SpectrogramFIFO.io.dataout
  SpectrogramFIFO.io.rd  :=  io.Spectrogram.ready
  io.Spectrogram.valid       := !SpectrogramFIFO.io.empty

}
