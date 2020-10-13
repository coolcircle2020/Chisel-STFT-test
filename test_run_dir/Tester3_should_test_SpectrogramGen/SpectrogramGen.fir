;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit SpectrogramGen : 
  module ComplexEnergy : 
    input clock : Clock
    input reset : Reset
    output io : {flip op1 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, flip op2 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, res : {value : Fixed<32><<16>>}}
    
    node _T = mul(io.op1.re, io.op2.re) @[Butterfly.scala 61:29]
    node _T_1 = mul(io.op1.im, io.op2.im) @[Butterfly.scala 61:53]
    node _T_2 = add(_T, _T_1) @[Butterfly.scala 61:41]
    node _T_3 = tail(_T_2, 1) @[Butterfly.scala 61:41]
    node _T_4 = asFixedPoint(_T_3, 32) @[Butterfly.scala 61:41]
    io.res.value <= _T_4 @[Butterfly.scala 61:16]
    
  module ComplexEnergy_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip op1 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, flip op2 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, res : {value : Fixed<32><<16>>}}
    
    node _T = mul(io.op1.re, io.op2.re) @[Butterfly.scala 61:29]
    node _T_1 = mul(io.op1.im, io.op2.im) @[Butterfly.scala 61:53]
    node _T_2 = add(_T, _T_1) @[Butterfly.scala 61:41]
    node _T_3 = tail(_T_2, 1) @[Butterfly.scala 61:41]
    node _T_4 = asFixedPoint(_T_3, 32) @[Butterfly.scala 61:41]
    io.res.value <= _T_4 @[Butterfly.scala 61:16]
    
  module SpectrogramGen : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip FFTsignal : {flip ready : UInt<1>, valid : UInt<1>, bits : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}}, Spectrogram : {flip ready : UInt<1>, valid : UInt<1>, bits : {value : Fixed<32><<16>>}}}
    
    reg SpectrogramReg : {value : Fixed<32><<16>>}, clock @[SpectrogramGen.scala 19:27]
    reg SpectrogramCnt : UInt<10>, clock with : (reset => (reset, UInt<10>("h00"))) @[SpectrogramGen.scala 20:31]
    node _T = and(io.FFTsignal.valid, io.Spectrogram.ready) @[SpectrogramGen.scala 26:27]
    when _T : @[SpectrogramGen.scala 26:52]
      inst ComplexEnergy of ComplexEnergy @[Butterfly.scala 65:22]
      ComplexEnergy.clock <= clock
      ComplexEnergy.reset <= reset
      ComplexEnergy.io.op1.im <= io.FFTsignal.bits.im @[Butterfly.scala 66:17]
      ComplexEnergy.io.op1.re <= io.FFTsignal.bits.re @[Butterfly.scala 66:17]
      ComplexEnergy.io.op2.im <= io.FFTsignal.bits.im @[Butterfly.scala 67:17]
      ComplexEnergy.io.op2.re <= io.FFTsignal.bits.re @[Butterfly.scala 67:17]
      SpectrogramReg.value <= ComplexEnergy.io.res.value @[SpectrogramGen.scala 27:20]
      io.Spectrogram.valid <= UInt<1>("h01") @[SpectrogramGen.scala 28:26]
      io.FFTsignal.ready <= UInt<1>("h00") @[SpectrogramGen.scala 29:24]
      node _T_1 = add(SpectrogramCnt, UInt<1>("h01")) @[SpectrogramGen.scala 30:38]
      node _T_2 = tail(_T_1, 1) @[SpectrogramGen.scala 30:38]
      SpectrogramCnt <= _T_2 @[SpectrogramGen.scala 30:20]
      skip @[SpectrogramGen.scala 26:52]
    else : @[SpectrogramGen.scala 31:38]
      node _T_3 = lt(SpectrogramCnt, UInt<10>("h0200")) @[SpectrogramGen.scala 31:29]
      when _T_3 : @[SpectrogramGen.scala 31:38]
        node _T_4 = add(SpectrogramCnt, UInt<1>("h01")) @[SpectrogramGen.scala 32:38]
        node _T_5 = tail(_T_4, 1) @[SpectrogramGen.scala 32:38]
        SpectrogramCnt <= _T_5 @[SpectrogramGen.scala 32:20]
        io.FFTsignal.ready <= UInt<1>("h00") @[SpectrogramGen.scala 33:24]
        node _T_6 = lt(SpectrogramCnt, UInt<9>("h0101")) @[SpectrogramGen.scala 34:25]
        when _T_6 : @[SpectrogramGen.scala 34:34]
          inst ComplexEnergy_1 of ComplexEnergy_1 @[Butterfly.scala 65:22]
          ComplexEnergy_1.clock <= clock
          ComplexEnergy_1.reset <= reset
          ComplexEnergy_1.io.op1.im <= io.FFTsignal.bits.im @[Butterfly.scala 66:17]
          ComplexEnergy_1.io.op1.re <= io.FFTsignal.bits.re @[Butterfly.scala 66:17]
          ComplexEnergy_1.io.op2.im <= io.FFTsignal.bits.im @[Butterfly.scala 67:17]
          ComplexEnergy_1.io.op2.re <= io.FFTsignal.bits.re @[Butterfly.scala 67:17]
          SpectrogramReg.value <= ComplexEnergy_1.io.res.value @[SpectrogramGen.scala 35:22]
          io.Spectrogram.valid <= UInt<1>("h01") @[SpectrogramGen.scala 36:28]
          skip @[SpectrogramGen.scala 34:34]
        else : @[SpectrogramGen.scala 37:17]
          io.Spectrogram.valid <= UInt<1>("h00") @[SpectrogramGen.scala 38:28]
          skip @[SpectrogramGen.scala 37:17]
        skip @[SpectrogramGen.scala 31:38]
      else : @[SpectrogramGen.scala 41:14]
        SpectrogramCnt <= UInt<1>("h00") @[SpectrogramGen.scala 42:20]
        io.Spectrogram.valid <= UInt<1>("h00") @[SpectrogramGen.scala 43:26]
        io.FFTsignal.ready <= UInt<1>("h01") @[SpectrogramGen.scala 44:24]
        skip @[SpectrogramGen.scala 41:14]
    io.Spectrogram.bits.value <= SpectrogramReg.value @[SpectrogramGen.scala 46:29]
    
