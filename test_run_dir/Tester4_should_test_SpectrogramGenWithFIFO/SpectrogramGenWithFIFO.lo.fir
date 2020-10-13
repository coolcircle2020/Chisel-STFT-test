circuit SpectrogramGenWithFIFO :
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

  module MyFifo :
    input clock : Clock
    input reset : UInt<1>
    input io_datain_value : SInt<32>
    output io_dataout_value : SInt<32>
    input io_wr : UInt<1>
    input io_rd : UInt<1>
    output io_full : UInt<1>
    output io_empty : UInt<1>
    output io_MorethanN : UInt<1>
    output io_count : UInt<32>
  
    mem mem_value : @[Myfifo.scala 25:16]
      data-type => SInt<32>
      depth => 900
      read-latency => 0
      write-latency => 1
      reader => _T_5
      reader => _T_33
      writer => _T_11
      writer => _T_21
      read-under-write => undefined
    reg count : UInt<32>, clock with :
      reset => (UInt<1>("h0"), count) @[Myfifo.scala 24:22]
    reg wp : UInt<32>, clock with :
      reset => (UInt<1>("h0"), wp) @[Myfifo.scala 26:19]
    reg rp : UInt<32>, clock with :
      reset => (UInt<1>("h0"), rp) @[Myfifo.scala 27:19]
    reg dataout_value : SInt<32>, clock with :
      reset => (UInt<1>("h0"), dataout_value) @[Myfifo.scala 28:20]
    node _T = eq(io_wr, UInt<1>("h1")) @[Myfifo.scala 38:14]
    node _T_1 = eq(io_rd, UInt<1>("h1")) @[Myfifo.scala 38:34]
    node _T_2 = and(_T, _T_1) @[Myfifo.scala 38:25]
    node _T_3 = eq(count, UInt<1>("h0")) @[Myfifo.scala 39:16]
    node _T_4 = bits(rp, 9, 0) @[Myfifo.scala 41:26]
    node _T_7 = eq(rp, UInt<10>("h383")) @[Myfifo.scala 33:16]
    node _T_8 = add(rp, UInt<1>("h1")) @[Myfifo.scala 34:34]
    node _T_9 = tail(_T_8, 1) @[Myfifo.scala 34:34]
    node _GEN_0 = mux(_T_7, UInt<1>("h0"), _T_9) @[Myfifo.scala 33:35]
    node _T_10 = bits(wp, 9, 0) @[Myfifo.scala 43:12]
    node _T_13 = eq(wp, UInt<10>("h383")) @[Myfifo.scala 33:16]
    node _T_14 = add(wp, UInt<1>("h1")) @[Myfifo.scala 34:34]
    node _T_15 = tail(_T_14, 1) @[Myfifo.scala 34:34]
    node _GEN_1 = mux(_T_13, UInt<1>("h0"), _T_15) @[Myfifo.scala 33:35]
    node _GEN_2 = mux(_T_3, io_datain_value, mem_value._T_5.data) @[Myfifo.scala 39:25]
    node _GEN_3 = validif(eq(_T_3, UInt<1>("h0")), _T_4) @[Myfifo.scala 39:25]
    node _GEN_4 = validif(eq(_T_3, UInt<1>("h0")), clock) @[Myfifo.scala 39:25]
    node _GEN_5 = mux(_T_3, UInt<1>("h0"), UInt<1>("h1")) @[Myfifo.scala 39:25]
    node _T_6 = _GEN_0 @[Myfifo.scala 33:42 Myfifo.scala 34:25]
    node _GEN_6 = mux(_T_3, rp, _T_6) @[Myfifo.scala 39:25]
    node _GEN_7 = validif(eq(_T_3, UInt<1>("h0")), _T_10) @[Myfifo.scala 39:25]
    node _GEN_8 = validif(eq(_T_3, UInt<1>("h0")), UInt<1>("h1")) @[Myfifo.scala 39:25]
    node _GEN_9 = validif(eq(_T_3, UInt<1>("h0")), io_datain_value) @[Myfifo.scala 39:25]
    node _T_12 = _GEN_1 @[Myfifo.scala 33:42 Myfifo.scala 34:25]
    node _GEN_10 = mux(_T_3, wp, _T_12) @[Myfifo.scala 39:25]
    node _T_16 = eq(io_wr, UInt<1>("h1")) @[Myfifo.scala 46:22]
    node _T_17 = eq(io_rd, UInt<1>("h0")) @[Myfifo.scala 46:42]
    node _T_18 = and(_T_16, _T_17) @[Myfifo.scala 46:33]
    node _T_19 = lt(count, UInt<10>("h384")) @[Myfifo.scala 48:16]
    node _T_20 = bits(wp, 9, 0) @[Myfifo.scala 49:10]
    node _T_23 = eq(wp, UInt<10>("h383")) @[Myfifo.scala 33:16]
    node _T_24 = add(wp, UInt<1>("h1")) @[Myfifo.scala 34:34]
    node _T_25 = tail(_T_24, 1) @[Myfifo.scala 34:34]
    node _GEN_11 = mux(_T_23, UInt<1>("h0"), _T_25) @[Myfifo.scala 33:35]
    node _T_26 = add(count, UInt<1>("h1")) @[Myfifo.scala 51:22]
    node _T_27 = tail(_T_26, 1) @[Myfifo.scala 51:22]
    node _GEN_12 = validif(_T_19, _T_20) @[Myfifo.scala 48:27]
    node _GEN_13 = validif(_T_19, clock) @[Myfifo.scala 48:27]
    node _GEN_14 = mux(_T_19, UInt<1>("h1"), UInt<1>("h0")) @[Myfifo.scala 48:27]
    node _GEN_15 = validif(_T_19, UInt<1>("h1")) @[Myfifo.scala 48:27]
    node _GEN_16 = validif(_T_19, io_datain_value) @[Myfifo.scala 48:27]
    node _T_22 = _GEN_11 @[Myfifo.scala 33:42 Myfifo.scala 34:25]
    node _GEN_17 = mux(_T_19, _T_22, wp) @[Myfifo.scala 48:27]
    node _GEN_18 = mux(_T_19, _T_27, count) @[Myfifo.scala 48:27]
    node _T_28 = eq(io_wr, UInt<1>("h0")) @[Myfifo.scala 53:22]
    node _T_29 = eq(io_rd, UInt<1>("h1")) @[Myfifo.scala 53:43]
    node _T_30 = and(_T_28, _T_29) @[Myfifo.scala 53:34]
    node _T_31 = gt(count, UInt<1>("h0")) @[Myfifo.scala 54:16]
    node _T_32 = bits(rp, 9, 0) @[Myfifo.scala 55:24]
    node _T_35 = eq(rp, UInt<10>("h383")) @[Myfifo.scala 33:16]
    node _T_36 = add(rp, UInt<1>("h1")) @[Myfifo.scala 34:34]
    node _T_37 = tail(_T_36, 1) @[Myfifo.scala 34:34]
    node _GEN_19 = mux(_T_35, UInt<1>("h0"), _T_37) @[Myfifo.scala 33:35]
    node _T_38 = sub(count, UInt<1>("h1")) @[Myfifo.scala 57:22]
    node _T_39 = tail(_T_38, 1) @[Myfifo.scala 57:22]
    node _GEN_20 = validif(_T_31, _T_32) @[Myfifo.scala 54:23]
    node _GEN_21 = validif(_T_31, clock) @[Myfifo.scala 54:23]
    node _GEN_22 = mux(_T_31, UInt<1>("h1"), UInt<1>("h0")) @[Myfifo.scala 54:23]
    node _GEN_23 = mux(_T_31, mem_value._T_33.data, asSInt(UInt<32>("h0"))) @[Myfifo.scala 54:23]
    node _T_34 = _GEN_19 @[Myfifo.scala 33:42 Myfifo.scala 34:25]
    node _GEN_24 = mux(_T_31, _T_34, rp) @[Myfifo.scala 54:23]
    node _GEN_25 = mux(_T_31, _T_39, count) @[Myfifo.scala 54:23]
    node _GEN_26 = validif(_T_30, _GEN_20) @[Myfifo.scala 53:55]
    node _GEN_27 = validif(_T_30, _GEN_21) @[Myfifo.scala 53:55]
    node _GEN_28 = mux(_T_30, _GEN_22, UInt<1>("h0")) @[Myfifo.scala 53:55]
    node _GEN_29 = mux(_T_30, _GEN_23, asSInt(UInt<32>("h0"))) @[Myfifo.scala 53:55]
    node _GEN_30 = mux(_T_30, _GEN_24, rp) @[Myfifo.scala 53:55]
    node _GEN_31 = mux(_T_30, _GEN_25, count) @[Myfifo.scala 53:55]
    node _GEN_32 = mux(_T_18, asSInt(UInt<32>("h0")), _GEN_29) @[Myfifo.scala 46:55]
    node _GEN_33 = validif(_T_18, _GEN_12) @[Myfifo.scala 46:55]
    node _GEN_34 = validif(_T_18, _GEN_13) @[Myfifo.scala 46:55]
    node _GEN_35 = mux(_T_18, _GEN_14, UInt<1>("h0")) @[Myfifo.scala 46:55]
    node _GEN_36 = validif(_T_18, _GEN_15) @[Myfifo.scala 46:55]
    node _GEN_37 = validif(_T_18, _GEN_16) @[Myfifo.scala 46:55]
    node _GEN_38 = mux(_T_18, _GEN_17, wp) @[Myfifo.scala 46:55]
    node _GEN_39 = mux(_T_18, _GEN_18, _GEN_31) @[Myfifo.scala 46:55]
    node _GEN_40 = validif(eq(_T_18, UInt<1>("h0")), _GEN_26) @[Myfifo.scala 46:55]
    node _GEN_41 = validif(eq(_T_18, UInt<1>("h0")), _GEN_27) @[Myfifo.scala 46:55]
    node _GEN_42 = mux(_T_18, UInt<1>("h0"), _GEN_28) @[Myfifo.scala 46:55]
    node _GEN_43 = mux(_T_18, rp, _GEN_30) @[Myfifo.scala 46:55]
    node _GEN_44 = mux(_T_2, _GEN_2, _GEN_32) @[Myfifo.scala 38:46]
    node _GEN_45 = validif(_T_2, _GEN_3) @[Myfifo.scala 38:46]
    node _GEN_46 = validif(_T_2, _GEN_4) @[Myfifo.scala 38:46]
    node _GEN_47 = mux(_T_2, _GEN_5, UInt<1>("h0")) @[Myfifo.scala 38:46]
    node _GEN_48 = mux(_T_2, _GEN_6, _GEN_43) @[Myfifo.scala 38:46]
    node _GEN_49 = validif(_T_2, _GEN_7) @[Myfifo.scala 38:46]
    node _GEN_50 = validif(_T_2, _GEN_8) @[Myfifo.scala 38:46]
    node _GEN_51 = validif(_T_2, _GEN_9) @[Myfifo.scala 38:46]
    node _GEN_52 = mux(_T_2, _GEN_10, _GEN_38) @[Myfifo.scala 38:46]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_33) @[Myfifo.scala 38:46]
    node _GEN_54 = validif(eq(_T_2, UInt<1>("h0")), _GEN_34) @[Myfifo.scala 38:46]
    node _GEN_55 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[Myfifo.scala 38:46]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[Myfifo.scala 38:46]
    node _GEN_57 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[Myfifo.scala 38:46]
    node _GEN_58 = mux(_T_2, count, _GEN_39) @[Myfifo.scala 38:46]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[Myfifo.scala 38:46]
    node _GEN_60 = validif(eq(_T_2, UInt<1>("h0")), _GEN_41) @[Myfifo.scala 38:46]
    node _GEN_61 = mux(_T_2, UInt<1>("h0"), _GEN_42) @[Myfifo.scala 38:46]
    node _T_40 = eq(UInt<10>("h384"), count) @[Myfifo.scala 65:23]
    node _T_41 = eq(count, UInt<1>("h0")) @[Myfifo.scala 66:22]
    node _T_42 = gt(count, UInt<10>("h200")) @[Myfifo.scala 67:26]
    io_dataout_value <= _GEN_44 @[Myfifo.scala 39:38 Myfifo.scala 41:20 Myfifo.scala 47:22 Myfifo.scala 55:18 Myfifo.scala 59:24 Myfifo.scala 62:22]
    io_full <= _T_40 @[Myfifo.scala 65:11]
    io_empty <= _T_41 @[Myfifo.scala 66:12]
    io_MorethanN <= _T_42 @[Myfifo.scala 67:16]
    io_count <= count @[Myfifo.scala 68:12]
    count <= mux(reset, UInt<32>("h0"), _GEN_58) @[Myfifo.scala 51:13 Myfifo.scala 57:13]
    mem_value._T_5.addr <= _GEN_45 @[Myfifo.scala 41:26]
    mem_value._T_5.en <= _GEN_47 @[Myfifo.scala 25:16 Myfifo.scala 41:26]
    mem_value._T_5.clk <= _GEN_46 @[Myfifo.scala 41:26]
    mem_value._T_33.addr <= _GEN_59 @[Myfifo.scala 55:24]
    mem_value._T_33.en <= _GEN_61 @[Myfifo.scala 25:16 Myfifo.scala 55:24]
    mem_value._T_33.clk <= _GEN_60 @[Myfifo.scala 55:24]
    mem_value._T_11.addr <= _GEN_49 @[Myfifo.scala 43:12]
    mem_value._T_11.en <= _GEN_47 @[Myfifo.scala 25:16 Myfifo.scala 43:12]
    mem_value._T_11.clk <= _GEN_46 @[Myfifo.scala 43:12]
    mem_value._T_11.data <= _GEN_51 @[Myfifo.scala 43:17]
    mem_value._T_11.mask <= _GEN_50 @[Myfifo.scala 43:12 Myfifo.scala 43:17]
    mem_value._T_21.addr <= _GEN_53 @[Myfifo.scala 49:10]
    mem_value._T_21.en <= _GEN_55 @[Myfifo.scala 25:16 Myfifo.scala 49:10]
    mem_value._T_21.clk <= _GEN_54 @[Myfifo.scala 49:10]
    mem_value._T_21.data <= _GEN_57 @[Myfifo.scala 49:15]
    mem_value._T_21.mask <= _GEN_56 @[Myfifo.scala 49:10 Myfifo.scala 49:15]
    wp <= mux(reset, UInt<32>("h0"), _GEN_52) @[Myfifo.scala 44:12 Myfifo.scala 50:10]
    rp <= mux(reset, UInt<32>("h0"), _GEN_48) @[Myfifo.scala 42:12 Myfifo.scala 56:10]
    dataout_value <= dataout_value

  module SpectrogramGenWithFIFO :
    input clock : Clock
    input reset : UInt<1>
    output io_FFTsignal_ready : UInt<1>
    input io_FFTsignal_valid : UInt<1>
    input io_FFTsignal_bits_re : SInt<32>
    input io_FFTsignal_bits_im : SInt<32>
    input io_Spectrogram_ready : UInt<1>
    output io_Spectrogram_valid : UInt<1>
    output io_Spectrogram_bits_value : SInt<32>
  
    inst SpectrogramGenblock of SpectrogramGen @[SpectrogramGenWithFIFO.scala 16:51]
    inst SpectrogramFIFO of MyFifo @[SpectrogramGenWithFIFO.scala 17:39]
    node _T = sub(UInt<10>("h384"), SpectrogramFIFO.io_count) @[SpectrogramGenWithFIFO.scala 24:55]
    node _T_1 = tail(_T, 1) @[SpectrogramGenWithFIFO.scala 24:55]
    node _T_2 = gt(_T_1, UInt<9>("h101")) @[SpectrogramGenWithFIFO.scala 24:83]
    node _T_3 = eq(SpectrogramFIFO.io_empty, UInt<1>("h0")) @[SpectrogramGenWithFIFO.scala 29:33]
    io_FFTsignal_ready <= SpectrogramGenblock.io_FFTsignal_ready @[SpectrogramGenWithFIFO.scala 20:16]
    io_Spectrogram_valid <= _T_3 @[SpectrogramGenWithFIFO.scala 29:30]
    io_Spectrogram_bits_value <= SpectrogramFIFO.io_dataout_value @[SpectrogramGenWithFIFO.scala 27:30]
    SpectrogramGenblock.clock <= clock
    SpectrogramGenblock.reset <= reset
    SpectrogramGenblock.io_FFTsignal_valid <= io_FFTsignal_valid @[SpectrogramGenWithFIFO.scala 20:16]
    SpectrogramGenblock.io_FFTsignal_bits_re <= io_FFTsignal_bits_re @[SpectrogramGenWithFIFO.scala 20:16]
    SpectrogramGenblock.io_FFTsignal_bits_im <= io_FFTsignal_bits_im @[SpectrogramGenWithFIFO.scala 20:16]
    SpectrogramGenblock.io_Spectrogram_ready <= _T_2 @[SpectrogramGenWithFIFO.scala 24:44]
    SpectrogramFIFO.clock <= clock
    SpectrogramFIFO.reset <= reset
    SpectrogramFIFO.io_datain_value <= SpectrogramGenblock.io_Spectrogram_bits_value @[SpectrogramGenWithFIFO.scala 25:29]
    SpectrogramFIFO.io_wr <= SpectrogramGenblock.io_Spectrogram_valid @[SpectrogramGenWithFIFO.scala 23:25]
    SpectrogramFIFO.io_rd <= io_Spectrogram_ready @[SpectrogramGenWithFIFO.scala 28:26]
