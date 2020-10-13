;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit SpectrogramGen : 
  module SpectrogramGen : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip FFTsignal : {flip ready : UInt<1>, valid : UInt<1>, bits : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}}, Spectrogram : {flip ready : UInt<1>, valid : UInt<1>, bits : {value : Fixed<32><<16>>}}}
    
    reg SpectrogramReg : {value : Fixed<32><<16>>}, clock @[SpectrogramGen.scala 17:27]
    reg SpectrogramCnt : UInt, clock with : (reset => (reset, UInt<1>("h00"))) @[SpectrogramGen.scala 18:31]
    io.Spectrogram.valid <= UInt<1>("h01") @[SpectrogramGen.scala 19:23]
    io.FFTsignal.ready <= UInt<1>("h01") @[SpectrogramGen.scala 20:21]
    io.Spectrogram.bits.value <= asFixedPoint(UInt<32>("h010000"), 16) @[SpectrogramGen.scala 21:28]
    
