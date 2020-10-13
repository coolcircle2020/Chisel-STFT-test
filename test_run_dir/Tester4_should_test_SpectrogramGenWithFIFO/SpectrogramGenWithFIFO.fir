;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit SpectrogramGenWithFIFO : 
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
    input reset : Reset
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
    
  module MyFifo : 
    input clock : Clock
    input reset : Reset
    output io : {flip datain : {value : Fixed<32><<16>>}, dataout : {value : Fixed<32><<16>>}, flip wr : UInt<1>, flip rd : UInt<1>, full : UInt<1>, empty : UInt<1>, MorethanN : UInt<1>, count : UInt}
    
    reg count : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[Myfifo.scala 24:22]
    cmem mem : {value : Fixed<32><<16>>}[900] @[Myfifo.scala 25:16]
    reg wp : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[Myfifo.scala 26:19]
    reg rp : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[Myfifo.scala 27:19]
    reg dataout : {value : Fixed<32><<16>>}, clock @[Myfifo.scala 28:20]
    node _T = eq(io.wr, UInt<1>("h01")) @[Myfifo.scala 38:14]
    node _T_1 = eq(io.rd, UInt<1>("h01")) @[Myfifo.scala 38:34]
    node _T_2 = and(_T, _T_1) @[Myfifo.scala 38:25]
    when _T_2 : @[Myfifo.scala 38:46]
      node _T_3 = eq(count, UInt<1>("h00")) @[Myfifo.scala 39:16]
      when _T_3 : @[Myfifo.scala 39:25]
        io.dataout.value <= io.datain.value @[Myfifo.scala 39:38]
        skip @[Myfifo.scala 39:25]
      else : @[Myfifo.scala 40:18]
        node _T_4 = bits(rp, 9, 0) @[Myfifo.scala 41:26]
        infer mport _T_5 = mem[_T_4], clock @[Myfifo.scala 41:26]
        io.dataout.value <= _T_5.value @[Myfifo.scala 41:20]
        wire _T_6 : UInt
        _T_6 <= rp
        node _T_7 = eq(rp, UInt<10>("h0383")) @[Myfifo.scala 33:16]
        when _T_7 : @[Myfifo.scala 33:35]
          _T_6 <= UInt<1>("h00") @[Myfifo.scala 33:42]
          skip @[Myfifo.scala 33:35]
        else : @[Myfifo.scala 34:18]
          node _T_8 = add(rp, UInt<1>("h01")) @[Myfifo.scala 34:34]
          node _T_9 = tail(_T_8, 1) @[Myfifo.scala 34:34]
          _T_6 <= _T_9 @[Myfifo.scala 34:25]
          skip @[Myfifo.scala 34:18]
        rp <= _T_6 @[Myfifo.scala 42:12]
        node _T_10 = bits(wp, 9, 0) @[Myfifo.scala 43:12]
        infer mport _T_11 = mem[_T_10], clock @[Myfifo.scala 43:12]
        _T_11.value <= io.datain.value @[Myfifo.scala 43:17]
        wire _T_12 : UInt
        _T_12 <= wp
        node _T_13 = eq(wp, UInt<10>("h0383")) @[Myfifo.scala 33:16]
        when _T_13 : @[Myfifo.scala 33:35]
          _T_12 <= UInt<1>("h00") @[Myfifo.scala 33:42]
          skip @[Myfifo.scala 33:35]
        else : @[Myfifo.scala 34:18]
          node _T_14 = add(wp, UInt<1>("h01")) @[Myfifo.scala 34:34]
          node _T_15 = tail(_T_14, 1) @[Myfifo.scala 34:34]
          _T_12 <= _T_15 @[Myfifo.scala 34:25]
          skip @[Myfifo.scala 34:18]
        wp <= _T_12 @[Myfifo.scala 44:12]
        skip @[Myfifo.scala 40:18]
      skip @[Myfifo.scala 38:46]
    else : @[Myfifo.scala 46:55]
      node _T_16 = eq(io.wr, UInt<1>("h01")) @[Myfifo.scala 46:22]
      node _T_17 = eq(io.rd, UInt<1>("h00")) @[Myfifo.scala 46:42]
      node _T_18 = and(_T_16, _T_17) @[Myfifo.scala 46:33]
      when _T_18 : @[Myfifo.scala 46:55]
        io.dataout.value <= asFixedPoint(UInt<32>("h00"), 16) @[Myfifo.scala 47:22]
        node _T_19 = lt(count, UInt<10>("h0384")) @[Myfifo.scala 48:16]
        when _T_19 : @[Myfifo.scala 48:27]
          node _T_20 = bits(wp, 9, 0) @[Myfifo.scala 49:10]
          infer mport _T_21 = mem[_T_20], clock @[Myfifo.scala 49:10]
          _T_21.value <= io.datain.value @[Myfifo.scala 49:15]
          wire _T_22 : UInt
          _T_22 <= wp
          node _T_23 = eq(wp, UInt<10>("h0383")) @[Myfifo.scala 33:16]
          when _T_23 : @[Myfifo.scala 33:35]
            _T_22 <= UInt<1>("h00") @[Myfifo.scala 33:42]
            skip @[Myfifo.scala 33:35]
          else : @[Myfifo.scala 34:18]
            node _T_24 = add(wp, UInt<1>("h01")) @[Myfifo.scala 34:34]
            node _T_25 = tail(_T_24, 1) @[Myfifo.scala 34:34]
            _T_22 <= _T_25 @[Myfifo.scala 34:25]
            skip @[Myfifo.scala 34:18]
          wp <= _T_22 @[Myfifo.scala 50:10]
          node _T_26 = add(count, UInt<1>("h01")) @[Myfifo.scala 51:22]
          node _T_27 = tail(_T_26, 1) @[Myfifo.scala 51:22]
          count <= _T_27 @[Myfifo.scala 51:13]
          skip @[Myfifo.scala 48:27]
        skip @[Myfifo.scala 46:55]
      else : @[Myfifo.scala 53:55]
        node _T_28 = eq(io.wr, UInt<1>("h00")) @[Myfifo.scala 53:22]
        node _T_29 = eq(io.rd, UInt<1>("h01")) @[Myfifo.scala 53:43]
        node _T_30 = and(_T_28, _T_29) @[Myfifo.scala 53:34]
        when _T_30 : @[Myfifo.scala 53:55]
          node _T_31 = gt(count, UInt<1>("h00")) @[Myfifo.scala 54:16]
          when _T_31 : @[Myfifo.scala 54:23]
            node _T_32 = bits(rp, 9, 0) @[Myfifo.scala 55:24]
            infer mport _T_33 = mem[_T_32], clock @[Myfifo.scala 55:24]
            io.dataout.value <= _T_33.value @[Myfifo.scala 55:18]
            wire _T_34 : UInt
            _T_34 <= rp
            node _T_35 = eq(rp, UInt<10>("h0383")) @[Myfifo.scala 33:16]
            when _T_35 : @[Myfifo.scala 33:35]
              _T_34 <= UInt<1>("h00") @[Myfifo.scala 33:42]
              skip @[Myfifo.scala 33:35]
            else : @[Myfifo.scala 34:18]
              node _T_36 = add(rp, UInt<1>("h01")) @[Myfifo.scala 34:34]
              node _T_37 = tail(_T_36, 1) @[Myfifo.scala 34:34]
              _T_34 <= _T_37 @[Myfifo.scala 34:25]
              skip @[Myfifo.scala 34:18]
            rp <= _T_34 @[Myfifo.scala 56:10]
            node _T_38 = sub(count, UInt<1>("h01")) @[Myfifo.scala 57:22]
            node _T_39 = tail(_T_38, 1) @[Myfifo.scala 57:22]
            count <= _T_39 @[Myfifo.scala 57:13]
            skip @[Myfifo.scala 54:23]
          else : @[Myfifo.scala 58:18]
            io.dataout.value <= asFixedPoint(UInt<32>("h00"), 16) @[Myfifo.scala 59:24]
            skip @[Myfifo.scala 58:18]
          skip @[Myfifo.scala 53:55]
        else : @[Myfifo.scala 61:16]
          io.dataout.value <= asFixedPoint(UInt<32>("h00"), 16) @[Myfifo.scala 62:22]
          skip @[Myfifo.scala 61:16]
    node _T_40 = eq(UInt<10>("h0384"), count) @[Myfifo.scala 65:23]
    io.full <= _T_40 @[Myfifo.scala 65:11]
    node _T_41 = eq(count, UInt<1>("h00")) @[Myfifo.scala 66:22]
    io.empty <= _T_41 @[Myfifo.scala 66:12]
    node _T_42 = gt(count, UInt<10>("h0200")) @[Myfifo.scala 67:26]
    io.MorethanN <= _T_42 @[Myfifo.scala 67:16]
    io.count <= count @[Myfifo.scala 68:12]
    
  module SpectrogramGenWithFIFO : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip FFTsignal : {flip ready : UInt<1>, valid : UInt<1>, bits : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}}, Spectrogram : {flip ready : UInt<1>, valid : UInt<1>, bits : {value : Fixed<32><<16>>}}}
    
    inst SpectrogramGenblock of SpectrogramGen @[SpectrogramGenWithFIFO.scala 16:51]
    SpectrogramGenblock.clock <= clock
    SpectrogramGenblock.reset <= reset
    inst SpectrogramFIFO of MyFifo @[SpectrogramGenWithFIFO.scala 17:39]
    SpectrogramFIFO.clock <= clock
    SpectrogramFIFO.reset <= reset
    SpectrogramGenblock.io.FFTsignal.bits.im <= io.FFTsignal.bits.im @[SpectrogramGenWithFIFO.scala 20:16]
    SpectrogramGenblock.io.FFTsignal.bits.re <= io.FFTsignal.bits.re @[SpectrogramGenWithFIFO.scala 20:16]
    SpectrogramGenblock.io.FFTsignal.valid <= io.FFTsignal.valid @[SpectrogramGenWithFIFO.scala 20:16]
    io.FFTsignal.ready <= SpectrogramGenblock.io.FFTsignal.ready @[SpectrogramGenWithFIFO.scala 20:16]
    SpectrogramFIFO.io.wr <= SpectrogramGenblock.io.Spectrogram.valid @[SpectrogramGenWithFIFO.scala 23:25]
    node _T = sub(UInt<10>("h0384"), SpectrogramFIFO.io.count) @[SpectrogramGenWithFIFO.scala 24:55]
    node _T_1 = tail(_T, 1) @[SpectrogramGenWithFIFO.scala 24:55]
    node _T_2 = gt(_T_1, UInt<9>("h0101")) @[SpectrogramGenWithFIFO.scala 24:83]
    SpectrogramGenblock.io.Spectrogram.ready <= _T_2 @[SpectrogramGenWithFIFO.scala 24:44]
    SpectrogramFIFO.io.datain.value <= SpectrogramGenblock.io.Spectrogram.bits.value @[SpectrogramGenWithFIFO.scala 25:29]
    io.Spectrogram.bits.value <= SpectrogramFIFO.io.dataout.value @[SpectrogramGenWithFIFO.scala 27:30]
    SpectrogramFIFO.io.rd <= io.Spectrogram.ready @[SpectrogramGenWithFIFO.scala 28:26]
    node _T_3 = eq(SpectrogramFIFO.io.empty, UInt<1>("h00")) @[SpectrogramGenWithFIFO.scala 29:33]
    io.Spectrogram.valid <= _T_3 @[SpectrogramGenWithFIFO.scala 29:30]
    
