circuit SpectrogramGen :
  module SpectrogramGen :
    input clock : Clock
    input reset : UInt<1>
    output io_FFTsignal_ready : UInt<1>
    input io_FFTsignal_valid : UInt<1>
    input io_FFTsignal_bits_re : SInt<32>
    input io_FFTsignal_bits_im : SInt<32>
    input io_Spectrogram_ready : UInt<1>
    output io_Spectrogram_valid : UInt<1>
    output io_Spectrogram_bits_value : SInt<32>
  
    reg SpectrogramReg_value : SInt<32>, clock with :
      reset => (UInt<1>("h0"), SpectrogramReg_value) @[SpectrogramGen.scala 17:27]
    reg SpectrogramCnt : UInt<1>, clock with :
      reset => (UInt<1>("h0"), SpectrogramCnt) @[SpectrogramGen.scala 18:31]
    io_FFTsignal_ready <= UInt<1>("h1") @[SpectrogramGen.scala 20:21]
    io_Spectrogram_valid <= UInt<1>("h1") @[SpectrogramGen.scala 19:23]
    io_Spectrogram_bits_value <= asSInt(UInt<32>("h10000")) @[SpectrogramGen.scala 21:28]
    SpectrogramReg_value <= SpectrogramReg_value
    SpectrogramCnt <= mux(reset, UInt<1>("h0"), SpectrogramCnt)
