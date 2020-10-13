circuit Hanning :
  module Hanning :
    input clock : Clock
    input reset : UInt<1>
    output io_signal_ready : UInt<1>
    input io_signal_valid : UInt<1>
    input io_signal_bits_value : SInt<32>
    output io_cosines_ready : UInt<1>
    input io_cosines_valid : UInt<1>
    input io_cosines_bits_value : SInt<32>
    input io_HanningSignal_ready : UInt<1>
    output io_HanningSignal_valid : UInt<1>
    output io_HanningSignal_bits_value : SInt<32>
  
    mem cosinesbank_value : @[Hanning.scala 20:28]
      data-type => SInt<32>
      depth => 720
      read-latency => 0
      write-latency => 1
      reader => _T_28
      reader => _T_34
      writer => _T_4
      read-under-write => undefined
    reg cosinesbank_wcnt : UInt<32>, clock with :
      reset => (UInt<1>("h0"), cosinesbank_wcnt) @[Hanning.scala 21:33]
    reg cosinesbank_rcnt : UInt<32>, clock with :
      reset => (UInt<1>("h0"), cosinesbank_rcnt) @[Hanning.scala 22:33]
    node _T = and(io_cosines_valid, io_cosines_ready) @[Hanning.scala 23:25]
    node _T_1 = add(cosinesbank_wcnt, UInt<1>("h1")) @[Hanning.scala 24:42]
    node _T_2 = tail(_T_1, 1) @[Hanning.scala 24:42]
    node _T_3 = bits(cosinesbank_wcnt, 9, 0)
    node _GEN_0 = mux(_T, _T_2, cosinesbank_wcnt) @[Hanning.scala 23:45]
    node _GEN_1 = validif(_T, _T_3) @[Hanning.scala 23:45]
    node _GEN_2 = validif(_T, clock) @[Hanning.scala 23:45]
    node _GEN_3 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[Hanning.scala 23:45]
    node _GEN_4 = validif(_T, UInt<1>("h1")) @[Hanning.scala 23:45]
    node _GEN_5 = validif(_T, io_cosines_bits_value) @[Hanning.scala 23:45]
    node _T_5 = lt(cosinesbank_wcnt, UInt<10>("h2d0")) @[Hanning.scala 27:61]
    node _T_6 = and(io_cosines_valid, _T_5) @[Hanning.scala 27:40]
    reg state : UInt<2>, clock with :
      reset => (UInt<1>("h0"), state) @[Hanning.scala 31:22]
    node _T_7 = eq(state, UInt<2>("h0")) @[Hanning.scala 33:14]
    node _T_8 = and(io_signal_valid, io_signal_ready) @[Hanning.scala 34:26]
    node _T_9 = lt(cosinesbank_rcnt, UInt<9>("h140")) @[Hanning.scala 34:64]
    node _T_10 = and(_T_8, _T_9) @[Hanning.scala 34:45]
    node _T_11 = and(io_signal_valid, io_signal_ready) @[Hanning.scala 36:32]
    node _T_12 = lt(cosinesbank_rcnt, UInt<10>("h200")) @[Hanning.scala 36:70]
    node _T_13 = and(_T_11, _T_12) @[Hanning.scala 36:51]
    node _GEN_6 = mux(_T_13, UInt<2>("h2"), state) @[Hanning.scala 36:77]
    node _GEN_7 = mux(_T_10, UInt<2>("h1"), _GEN_6) @[Hanning.scala 34:71]
    node _T_14 = eq(state, UInt<2>("h1")) @[Hanning.scala 39:20]
    node _T_15 = and(io_signal_valid, io_signal_ready) @[Hanning.scala 40:26]
    node _T_16 = lt(cosinesbank_rcnt, UInt<9>("h140")) @[Hanning.scala 40:64]
    node _T_17 = and(_T_15, _T_16) @[Hanning.scala 40:45]
    node _T_18 = and(io_signal_valid, io_signal_ready) @[Hanning.scala 42:32]
    node _T_19 = lt(cosinesbank_rcnt, UInt<10>("h200")) @[Hanning.scala 42:70]
    node _T_20 = and(_T_18, _T_19) @[Hanning.scala 42:51]
    node _GEN_8 = mux(_T_20, UInt<2>("h2"), UInt<2>("h0")) @[Hanning.scala 42:77]
    node _GEN_9 = mux(_T_17, UInt<2>("h1"), _GEN_8) @[Hanning.scala 40:71]
    node _T_21 = eq(state, UInt<2>("h2")) @[Hanning.scala 47:20]
    node _T_22 = and(io_HanningSignal_ready, io_HanningSignal_valid) @[Hanning.scala 48:35]
    node _T_23 = lt(cosinesbank_rcnt, UInt<10>("h200")) @[Hanning.scala 48:81]
    node _T_24 = and(_T_22, _T_23) @[Hanning.scala 48:61]
    node _GEN_10 = mux(_T_24, UInt<2>("h2"), UInt<2>("h0")) @[Hanning.scala 48:89]
    node _GEN_11 = mux(_T_21, _GEN_10, state) @[Hanning.scala 47:37]
    node _GEN_12 = mux(_T_14, _GEN_9, _GEN_11) @[Hanning.scala 39:32]
    node _GEN_13 = mux(_T_7, _GEN_7, _GEN_12) @[Hanning.scala 33:25]
    reg hanning_signal_value : SInt<32>, clock with :
      reset => (UInt<1>("h0"), hanning_signal_value) @[Hanning.scala 55:27]
    reg cosine_value_value : SInt<32>, clock with :
      reset => (UInt<1>("h0"), cosine_value_value) @[Hanning.scala 56:27]
    node _T_25 = eq(state, UInt<2>("h0")) @[Hanning.scala 60:14]
    node _T_26 = and(io_HanningSignal_ready, io_signal_valid) @[Hanning.scala 61:47]
    node _T_27 = bits(cosinesbank_rcnt, 9, 0) @[Hanning.scala 63:38]
    node _T_29 = eq(cosinesbank_rcnt, UInt<10>("h201")) @[Hanning.scala 64:27]
    node _GEN_14 = mux(_T_29, UInt<1>("h0"), cosinesbank_rcnt) @[Hanning.scala 64:37]
    node _T_30 = eq(state, UInt<2>("h1")) @[Hanning.scala 65:20]
    node _T_31 = add(cosinesbank_rcnt, UInt<1>("h1")) @[Hanning.scala 66:42]
    node _T_32 = tail(_T_31, 1) @[Hanning.scala 66:42]
    node _T_33 = bits(cosinesbank_rcnt, 9, 0) @[Hanning.scala 67:37]
    node _T_35 = mul(io_signal_bits_value, cosine_value_value) @[Hanning.scala 68:50]
    node _T_36 = eq(state, UInt<2>("h2")) @[Hanning.scala 71:20]
    node _T_37 = add(cosinesbank_rcnt, UInt<1>("h1")) @[Hanning.scala 72:42]
    node _T_38 = tail(_T_37, 1) @[Hanning.scala 72:42]
    node _GEN_15 = mux(_T_36, _T_38, cosinesbank_rcnt) @[Hanning.scala 71:37]
    node _GEN_16 = mux(_T_36, asSInt(UInt<32>("h0")), hanning_signal_value) @[Hanning.scala 71:37]
    node _GEN_17 = mux(_T_36, UInt<1>("h0"), UInt<1>("h1")) @[Hanning.scala 71:37]
    node _GEN_18 = mux(_T_36, UInt<1>("h1"), UInt<1>("h0")) @[Hanning.scala 71:37]
    node _GEN_19 = mux(_T_30, _T_32, _GEN_15) @[Hanning.scala 65:32]
    node _GEN_20 = validif(_T_30, _T_33) @[Hanning.scala 65:32]
    node _GEN_21 = validif(_T_30, clock) @[Hanning.scala 65:32]
    node _GEN_22 = mux(_T_30, UInt<1>("h1"), UInt<1>("h0")) @[Hanning.scala 65:32]
    node _GEN_23 = mux(_T_30, cosinesbank_value._T_34.data, cosine_value_value) @[Hanning.scala 65:32]
    node _GEN_24 = mux(_T_30, _T_35, shl(_GEN_16, 16)) @[Hanning.scala 65:32]
    node _GEN_25 = mux(_T_30, io_HanningSignal_ready, _GEN_17) @[Hanning.scala 65:32]
    node _GEN_26 = mux(_T_30, UInt<1>("h1"), _GEN_18) @[Hanning.scala 65:32]
    node _GEN_27 = mux(_T_25, _T_26, _GEN_25) @[Hanning.scala 60:25]
    node _GEN_28 = mux(_T_25, UInt<1>("h0"), _GEN_26) @[Hanning.scala 60:25]
    node _GEN_29 = validif(_T_25, _T_27) @[Hanning.scala 60:25]
    node _GEN_30 = validif(_T_25, clock) @[Hanning.scala 60:25]
    node _GEN_31 = mux(_T_25, UInt<1>("h1"), UInt<1>("h0")) @[Hanning.scala 60:25]
    node _GEN_32 = mux(_T_25, cosinesbank_value._T_28.data, _GEN_23) @[Hanning.scala 60:25]
    node _GEN_33 = mux(_T_25, _GEN_14, _GEN_19) @[Hanning.scala 60:25]
    node _GEN_34 = validif(eq(_T_25, UInt<1>("h0")), _GEN_20) @[Hanning.scala 60:25]
    node _GEN_35 = validif(eq(_T_25, UInt<1>("h0")), _GEN_21) @[Hanning.scala 60:25]
    node _GEN_36 = mux(_T_25, UInt<1>("h0"), _GEN_22) @[Hanning.scala 60:25]
    node _GEN_37 = mux(_T_25, shl(hanning_signal_value, 16), _GEN_24) @[Hanning.scala 60:25]
    io_signal_ready <= _GEN_27 @[Hanning.scala 61:21 Hanning.scala 69:21 Hanning.scala 74:21 Hanning.scala 77:21]
    io_cosines_ready <= _T_6 @[Hanning.scala 27:20]
    io_HanningSignal_valid <= _GEN_28 @[Hanning.scala 62:28 Hanning.scala 70:28 Hanning.scala 75:28 Hanning.scala 78:28]
    io_HanningSignal_bits_value <= hanning_signal_value @[Hanning.scala 58:25]
    cosinesbank_value._T_28.addr <= _GEN_29 @[Hanning.scala 63:38]
    cosinesbank_value._T_28.en <= _GEN_31 @[Hanning.scala 20:28 Hanning.scala 63:38]
    cosinesbank_value._T_28.clk <= _GEN_30 @[Hanning.scala 63:38]
    cosinesbank_value._T_34.addr <= _GEN_34 @[Hanning.scala 67:37]
    cosinesbank_value._T_34.en <= _GEN_36 @[Hanning.scala 20:28 Hanning.scala 67:37]
    cosinesbank_value._T_34.clk <= _GEN_35 @[Hanning.scala 67:37]
    cosinesbank_value._T_4.addr <= _GEN_1
    cosinesbank_value._T_4.en <= _GEN_3 @[Hanning.scala 20:28]
    cosinesbank_value._T_4.clk <= _GEN_2
    cosinesbank_value._T_4.data <= _GEN_5
    cosinesbank_value._T_4.mask <= _GEN_4
    cosinesbank_wcnt <= mux(reset, UInt<32>("h0"), _GEN_0) @[Hanning.scala 24:22]
    cosinesbank_rcnt <= mux(reset, UInt<32>("h0"), _GEN_33) @[Hanning.scala 64:54 Hanning.scala 66:22 Hanning.scala 72:22]
    state <= mux(reset, UInt<2>("h0"), _GEN_13) @[Hanning.scala 35:13 Hanning.scala 37:13 Hanning.scala 41:13 Hanning.scala 43:13 Hanning.scala 45:13 Hanning.scala 49:15 Hanning.scala 51:15]
    hanning_signal_value <= asSInt(bits(shr(_GEN_37, 16), 31, 0)) @[Hanning.scala 68:26 Hanning.scala 73:26]
    cosine_value_value <= _GEN_32 @[Hanning.scala 63:18 Hanning.scala 67:18]
