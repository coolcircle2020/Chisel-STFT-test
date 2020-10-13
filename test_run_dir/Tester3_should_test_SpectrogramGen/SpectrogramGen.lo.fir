circuit SpectrogramGen :
  module ComplexEnergy :
    input clock : Clock
    input reset : UInt<1>
    input io_op1_re : SInt<32>
    input io_op1_im : SInt<32>
    input io_op2_re : SInt<32>
    input io_op2_im : SInt<32>
    output io_res_value : SInt<32>
  
    node _T = mul(io_op1_re, io_op2_re) @[Butterfly.scala 61:29]
    node _T_1 = mul(io_op1_im, io_op2_im) @[Butterfly.scala 61:53]
    node _T_2 = add(_T, _T_1) @[Butterfly.scala 61:41]
    node _T_3 = tail(_T_2, 1) @[Butterfly.scala 61:41]
    node _T_4 = asSInt(_T_3) @[Butterfly.scala 61:41]
    io_res_value <= asSInt(bits(shr(_T_4, 16), 31, 0)) @[Butterfly.scala 61:16]

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
  
    inst ComplexEnergy of ComplexEnergy @[Butterfly.scala 65:22]
    inst ComplexEnergy_1 of ComplexEnergy @[Butterfly.scala 65:22]
    reg SpectrogramReg_value : SInt<32>, clock with :
      reset => (UInt<1>("h0"), SpectrogramReg_value) @[SpectrogramGen.scala 19:27]
    reg SpectrogramCnt : UInt<10>, clock with :
      reset => (UInt<1>("h0"), SpectrogramCnt) @[SpectrogramGen.scala 20:31]
    node _T = and(io_FFTsignal_valid, io_Spectrogram_ready) @[SpectrogramGen.scala 26:27]
    node _T_1 = add(SpectrogramCnt, UInt<1>("h1")) @[SpectrogramGen.scala 30:38]
    node _T_2 = tail(_T_1, 1) @[SpectrogramGen.scala 30:38]
    node _T_3 = lt(SpectrogramCnt, UInt<10>("h200")) @[SpectrogramGen.scala 31:29]
    node _T_4 = add(SpectrogramCnt, UInt<1>("h1")) @[SpectrogramGen.scala 32:38]
    node _T_5 = tail(_T_4, 1) @[SpectrogramGen.scala 32:38]
    node _T_6 = lt(SpectrogramCnt, UInt<9>("h101")) @[SpectrogramGen.scala 34:25]
    node _GEN_0 = mux(_T_6, ComplexEnergy_1.io_res_value, SpectrogramReg_value) @[SpectrogramGen.scala 34:34]
    node _GEN_1 = mux(_T_6, UInt<1>("h1"), UInt<1>("h0")) @[SpectrogramGen.scala 34:34]
    node _GEN_2 = mux(_T_3, _T_5, UInt<1>("h0")) @[SpectrogramGen.scala 31:38]
    node _GEN_3 = mux(_T_3, UInt<1>("h0"), UInt<1>("h1")) @[SpectrogramGen.scala 31:38]
    node _GEN_4 = mux(_T_3, _GEN_0, SpectrogramReg_value) @[SpectrogramGen.scala 31:38]
    node _GEN_5 = mux(_T_3, _GEN_1, UInt<1>("h0")) @[SpectrogramGen.scala 31:38]
    node _GEN_6 = mux(_T, ComplexEnergy.io_res_value, _GEN_4) @[SpectrogramGen.scala 26:52]
    node _GEN_7 = mux(_T, UInt<1>("h1"), _GEN_5) @[SpectrogramGen.scala 26:52]
    node _GEN_8 = mux(_T, UInt<1>("h0"), _GEN_3) @[SpectrogramGen.scala 26:52]
    node _GEN_9 = mux(_T, _T_2, _GEN_2) @[SpectrogramGen.scala 26:52]
    io_FFTsignal_ready <= _GEN_8 @[SpectrogramGen.scala 29:24 SpectrogramGen.scala 33:24 SpectrogramGen.scala 44:24]
    io_Spectrogram_valid <= _GEN_7 @[SpectrogramGen.scala 28:26 SpectrogramGen.scala 36:28 SpectrogramGen.scala 38:28 SpectrogramGen.scala 43:26]
    io_Spectrogram_bits_value <= SpectrogramReg_value @[SpectrogramGen.scala 46:29]
    SpectrogramReg_value <= _GEN_6 @[SpectrogramGen.scala 27:20 SpectrogramGen.scala 35:22]
    SpectrogramCnt <= mux(reset, UInt<10>("h0"), _GEN_9) @[SpectrogramGen.scala 30:20 SpectrogramGen.scala 32:20 SpectrogramGen.scala 42:20]
    ComplexEnergy.clock <= clock
    ComplexEnergy.reset <= reset
    ComplexEnergy.io_op1_re <= io_FFTsignal_bits_re @[Butterfly.scala 66:17]
    ComplexEnergy.io_op1_im <= io_FFTsignal_bits_im @[Butterfly.scala 66:17]
    ComplexEnergy.io_op2_re <= io_FFTsignal_bits_re @[Butterfly.scala 67:17]
    ComplexEnergy.io_op2_im <= io_FFTsignal_bits_im @[Butterfly.scala 67:17]
    ComplexEnergy_1.clock <= clock
    ComplexEnergy_1.reset <= reset
    ComplexEnergy_1.io_op1_re <= io_FFTsignal_bits_re @[Butterfly.scala 66:17]
    ComplexEnergy_1.io_op1_im <= io_FFTsignal_bits_im @[Butterfly.scala 66:17]
    ComplexEnergy_1.io_op2_re <= io_FFTsignal_bits_re @[Butterfly.scala 67:17]
    ComplexEnergy_1.io_op2_im <= io_FFTsignal_bits_im @[Butterfly.scala 67:17]
