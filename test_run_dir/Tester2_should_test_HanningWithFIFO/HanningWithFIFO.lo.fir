circuit HanningWithFIFO :
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
  
    mem mem_value : @[Myfifo.scala 24:16]
      data-type => SInt<32>
      depth => 3000
      read-latency => 0
      write-latency => 1
      reader => _T_5
      reader => _T_33
      writer => _T_11
      writer => _T_21
      read-under-write => undefined
    reg count : UInt<32>, clock with :
      reset => (UInt<1>("h0"), count) @[Myfifo.scala 23:22]
    reg wp : UInt<32>, clock with :
      reset => (UInt<1>("h0"), wp) @[Myfifo.scala 25:19]
    reg rp : UInt<32>, clock with :
      reset => (UInt<1>("h0"), rp) @[Myfifo.scala 26:19]
    reg dataout_value : SInt<32>, clock with :
      reset => (UInt<1>("h0"), dataout_value) @[Myfifo.scala 27:20]
    node _T = eq(io_wr, UInt<1>("h1")) @[Myfifo.scala 37:14]
    node _T_1 = eq(io_rd, UInt<1>("h1")) @[Myfifo.scala 37:34]
    node _T_2 = and(_T, _T_1) @[Myfifo.scala 37:25]
    node _T_3 = eq(count, UInt<1>("h0")) @[Myfifo.scala 38:16]
    node _T_4 = bits(rp, 11, 0) @[Myfifo.scala 40:26]
    node _T_7 = eq(rp, UInt<12>("hbb7")) @[Myfifo.scala 32:16]
    node _T_8 = add(rp, UInt<1>("h1")) @[Myfifo.scala 33:34]
    node _T_9 = tail(_T_8, 1) @[Myfifo.scala 33:34]
    node _GEN_0 = mux(_T_7, UInt<1>("h0"), _T_9) @[Myfifo.scala 32:35]
    node _T_10 = bits(wp, 11, 0) @[Myfifo.scala 42:12]
    node _T_13 = eq(wp, UInt<12>("hbb7")) @[Myfifo.scala 32:16]
    node _T_14 = add(wp, UInt<1>("h1")) @[Myfifo.scala 33:34]
    node _T_15 = tail(_T_14, 1) @[Myfifo.scala 33:34]
    node _GEN_1 = mux(_T_13, UInt<1>("h0"), _T_15) @[Myfifo.scala 32:35]
    node _GEN_2 = mux(_T_3, io_datain_value, mem_value._T_5.data) @[Myfifo.scala 38:25]
    node _GEN_3 = validif(eq(_T_3, UInt<1>("h0")), _T_4) @[Myfifo.scala 38:25]
    node _GEN_4 = validif(eq(_T_3, UInt<1>("h0")), clock) @[Myfifo.scala 38:25]
    node _GEN_5 = mux(_T_3, UInt<1>("h0"), UInt<1>("h1")) @[Myfifo.scala 38:25]
    node _T_6 = _GEN_0 @[Myfifo.scala 32:42 Myfifo.scala 33:25]
    node _GEN_6 = mux(_T_3, rp, _T_6) @[Myfifo.scala 38:25]
    node _GEN_7 = validif(eq(_T_3, UInt<1>("h0")), _T_10) @[Myfifo.scala 38:25]
    node _GEN_8 = validif(eq(_T_3, UInt<1>("h0")), UInt<1>("h1")) @[Myfifo.scala 38:25]
    node _GEN_9 = validif(eq(_T_3, UInt<1>("h0")), io_datain_value) @[Myfifo.scala 38:25]
    node _T_12 = _GEN_1 @[Myfifo.scala 32:42 Myfifo.scala 33:25]
    node _GEN_10 = mux(_T_3, wp, _T_12) @[Myfifo.scala 38:25]
    node _T_16 = eq(io_wr, UInt<1>("h1")) @[Myfifo.scala 45:22]
    node _T_17 = eq(io_rd, UInt<1>("h0")) @[Myfifo.scala 45:42]
    node _T_18 = and(_T_16, _T_17) @[Myfifo.scala 45:33]
    node _T_19 = lt(count, UInt<12>("hbb8")) @[Myfifo.scala 47:16]
    node _T_20 = bits(wp, 11, 0) @[Myfifo.scala 48:10]
    node _T_23 = eq(wp, UInt<12>("hbb7")) @[Myfifo.scala 32:16]
    node _T_24 = add(wp, UInt<1>("h1")) @[Myfifo.scala 33:34]
    node _T_25 = tail(_T_24, 1) @[Myfifo.scala 33:34]
    node _GEN_11 = mux(_T_23, UInt<1>("h0"), _T_25) @[Myfifo.scala 32:35]
    node _T_26 = add(count, UInt<1>("h1")) @[Myfifo.scala 50:22]
    node _T_27 = tail(_T_26, 1) @[Myfifo.scala 50:22]
    node _GEN_12 = validif(_T_19, _T_20) @[Myfifo.scala 47:27]
    node _GEN_13 = validif(_T_19, clock) @[Myfifo.scala 47:27]
    node _GEN_14 = mux(_T_19, UInt<1>("h1"), UInt<1>("h0")) @[Myfifo.scala 47:27]
    node _GEN_15 = validif(_T_19, UInt<1>("h1")) @[Myfifo.scala 47:27]
    node _GEN_16 = validif(_T_19, io_datain_value) @[Myfifo.scala 47:27]
    node _T_22 = _GEN_11 @[Myfifo.scala 32:42 Myfifo.scala 33:25]
    node _GEN_17 = mux(_T_19, _T_22, wp) @[Myfifo.scala 47:27]
    node _GEN_18 = mux(_T_19, _T_27, count) @[Myfifo.scala 47:27]
    node _T_28 = eq(io_wr, UInt<1>("h0")) @[Myfifo.scala 52:22]
    node _T_29 = eq(io_rd, UInt<1>("h1")) @[Myfifo.scala 52:43]
    node _T_30 = and(_T_28, _T_29) @[Myfifo.scala 52:34]
    node _T_31 = gt(count, UInt<1>("h0")) @[Myfifo.scala 53:16]
    node _T_32 = bits(rp, 11, 0) @[Myfifo.scala 54:24]
    node _T_35 = eq(rp, UInt<12>("hbb7")) @[Myfifo.scala 32:16]
    node _T_36 = add(rp, UInt<1>("h1")) @[Myfifo.scala 33:34]
    node _T_37 = tail(_T_36, 1) @[Myfifo.scala 33:34]
    node _GEN_19 = mux(_T_35, UInt<1>("h0"), _T_37) @[Myfifo.scala 32:35]
    node _T_38 = sub(count, UInt<1>("h1")) @[Myfifo.scala 56:22]
    node _T_39 = tail(_T_38, 1) @[Myfifo.scala 56:22]
    node _GEN_20 = validif(_T_31, _T_32) @[Myfifo.scala 53:23]
    node _GEN_21 = validif(_T_31, clock) @[Myfifo.scala 53:23]
    node _GEN_22 = mux(_T_31, UInt<1>("h1"), UInt<1>("h0")) @[Myfifo.scala 53:23]
    node _GEN_23 = mux(_T_31, mem_value._T_33.data, asSInt(UInt<32>("h0"))) @[Myfifo.scala 53:23]
    node _T_34 = _GEN_19 @[Myfifo.scala 32:42 Myfifo.scala 33:25]
    node _GEN_24 = mux(_T_31, _T_34, rp) @[Myfifo.scala 53:23]
    node _GEN_25 = mux(_T_31, _T_39, count) @[Myfifo.scala 53:23]
    node _GEN_26 = validif(_T_30, _GEN_20) @[Myfifo.scala 52:55]
    node _GEN_27 = validif(_T_30, _GEN_21) @[Myfifo.scala 52:55]
    node _GEN_28 = mux(_T_30, _GEN_22, UInt<1>("h0")) @[Myfifo.scala 52:55]
    node _GEN_29 = mux(_T_30, _GEN_23, asSInt(UInt<32>("h0"))) @[Myfifo.scala 52:55]
    node _GEN_30 = mux(_T_30, _GEN_24, rp) @[Myfifo.scala 52:55]
    node _GEN_31 = mux(_T_30, _GEN_25, count) @[Myfifo.scala 52:55]
    node _GEN_32 = mux(_T_18, asSInt(UInt<32>("h0")), _GEN_29) @[Myfifo.scala 45:55]
    node _GEN_33 = validif(_T_18, _GEN_12) @[Myfifo.scala 45:55]
    node _GEN_34 = validif(_T_18, _GEN_13) @[Myfifo.scala 45:55]
    node _GEN_35 = mux(_T_18, _GEN_14, UInt<1>("h0")) @[Myfifo.scala 45:55]
    node _GEN_36 = validif(_T_18, _GEN_15) @[Myfifo.scala 45:55]
    node _GEN_37 = validif(_T_18, _GEN_16) @[Myfifo.scala 45:55]
    node _GEN_38 = mux(_T_18, _GEN_17, wp) @[Myfifo.scala 45:55]
    node _GEN_39 = mux(_T_18, _GEN_18, _GEN_31) @[Myfifo.scala 45:55]
    node _GEN_40 = validif(eq(_T_18, UInt<1>("h0")), _GEN_26) @[Myfifo.scala 45:55]
    node _GEN_41 = validif(eq(_T_18, UInt<1>("h0")), _GEN_27) @[Myfifo.scala 45:55]
    node _GEN_42 = mux(_T_18, UInt<1>("h0"), _GEN_28) @[Myfifo.scala 45:55]
    node _GEN_43 = mux(_T_18, rp, _GEN_30) @[Myfifo.scala 45:55]
    node _GEN_44 = mux(_T_2, _GEN_2, _GEN_32) @[Myfifo.scala 37:46]
    node _GEN_45 = validif(_T_2, _GEN_3) @[Myfifo.scala 37:46]
    node _GEN_46 = validif(_T_2, _GEN_4) @[Myfifo.scala 37:46]
    node _GEN_47 = mux(_T_2, _GEN_5, UInt<1>("h0")) @[Myfifo.scala 37:46]
    node _GEN_48 = mux(_T_2, _GEN_6, _GEN_43) @[Myfifo.scala 37:46]
    node _GEN_49 = validif(_T_2, _GEN_7) @[Myfifo.scala 37:46]
    node _GEN_50 = validif(_T_2, _GEN_8) @[Myfifo.scala 37:46]
    node _GEN_51 = validif(_T_2, _GEN_9) @[Myfifo.scala 37:46]
    node _GEN_52 = mux(_T_2, _GEN_10, _GEN_38) @[Myfifo.scala 37:46]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_33) @[Myfifo.scala 37:46]
    node _GEN_54 = validif(eq(_T_2, UInt<1>("h0")), _GEN_34) @[Myfifo.scala 37:46]
    node _GEN_55 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[Myfifo.scala 37:46]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[Myfifo.scala 37:46]
    node _GEN_57 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[Myfifo.scala 37:46]
    node _GEN_58 = mux(_T_2, count, _GEN_39) @[Myfifo.scala 37:46]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[Myfifo.scala 37:46]
    node _GEN_60 = validif(eq(_T_2, UInt<1>("h0")), _GEN_41) @[Myfifo.scala 37:46]
    node _GEN_61 = mux(_T_2, UInt<1>("h0"), _GEN_42) @[Myfifo.scala 37:46]
    node _T_40 = eq(UInt<12>("hbb8"), count) @[Myfifo.scala 64:23]
    node _T_41 = eq(count, UInt<1>("h0")) @[Myfifo.scala 65:22]
    node _T_42 = gt(count, UInt<10>("h200")) @[Myfifo.scala 66:26]
    io_dataout_value <= _GEN_44 @[Myfifo.scala 38:38 Myfifo.scala 40:20 Myfifo.scala 46:22 Myfifo.scala 54:18 Myfifo.scala 58:24 Myfifo.scala 61:22]
    io_full <= _T_40 @[Myfifo.scala 64:11]
    io_empty <= _T_41 @[Myfifo.scala 65:12]
    io_MorethanN <= _T_42 @[Myfifo.scala 66:16]
    count <= mux(reset, UInt<32>("h0"), _GEN_58) @[Myfifo.scala 50:13 Myfifo.scala 56:13]
    mem_value._T_5.addr <= _GEN_45 @[Myfifo.scala 40:26]
    mem_value._T_5.en <= _GEN_47 @[Myfifo.scala 24:16 Myfifo.scala 40:26]
    mem_value._T_5.clk <= _GEN_46 @[Myfifo.scala 40:26]
    mem_value._T_33.addr <= _GEN_59 @[Myfifo.scala 54:24]
    mem_value._T_33.en <= _GEN_61 @[Myfifo.scala 24:16 Myfifo.scala 54:24]
    mem_value._T_33.clk <= _GEN_60 @[Myfifo.scala 54:24]
    mem_value._T_11.addr <= _GEN_49 @[Myfifo.scala 42:12]
    mem_value._T_11.en <= _GEN_47 @[Myfifo.scala 24:16 Myfifo.scala 42:12]
    mem_value._T_11.clk <= _GEN_46 @[Myfifo.scala 42:12]
    mem_value._T_11.data <= _GEN_51 @[Myfifo.scala 42:17]
    mem_value._T_11.mask <= _GEN_50 @[Myfifo.scala 42:12 Myfifo.scala 42:17]
    mem_value._T_21.addr <= _GEN_53 @[Myfifo.scala 48:10]
    mem_value._T_21.en <= _GEN_55 @[Myfifo.scala 24:16 Myfifo.scala 48:10]
    mem_value._T_21.clk <= _GEN_54 @[Myfifo.scala 48:10]
    mem_value._T_21.data <= _GEN_57 @[Myfifo.scala 48:15]
    mem_value._T_21.mask <= _GEN_56 @[Myfifo.scala 48:10 Myfifo.scala 48:15]
    wp <= mux(reset, UInt<32>("h0"), _GEN_52) @[Myfifo.scala 43:12 Myfifo.scala 49:10]
    rp <= mux(reset, UInt<32>("h0"), _GEN_48) @[Myfifo.scala 41:12 Myfifo.scala 55:10]
    dataout_value <= dataout_value

  module HanningWithFIFO :
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
  
    inst Hanningblock of Hanning @[HanningWithFIFO.scala 18:37]
    inst HanningFIFO of MyFifo @[HanningWithFIFO.scala 19:35]
    reg BurstValid : UInt<1>, clock with :
      reset => (UInt<1>("h0"), BurstValid) @[HanningWithFIFO.scala 20:27]
    reg BurstReadCnt : UInt<32>, clock with :
      reset => (UInt<1>("h0"), BurstReadCnt) @[HanningWithFIFO.scala 21:29]
    node _T = lt(BurstReadCnt, UInt<10>("h200")) @[HanningWithFIFO.scala 23:47]
    node _T_1 = gt(BurstReadCnt, UInt<1>("h0")) @[HanningWithFIFO.scala 23:71]
    node _T_2 = and(_T, _T_1) @[HanningWithFIFO.scala 23:55]
    node _T_3 = or(BurstValid, _T_2) @[HanningWithFIFO.scala 23:31]
    node _T_4 = and(io_HanningSignal_ready, BurstValid) @[HanningWithFIFO.scala 25:31]
    node _T_5 = add(BurstReadCnt, UInt<1>("h1")) @[HanningWithFIFO.scala 26:34]
    node _T_6 = tail(_T_5, 1) @[HanningWithFIFO.scala 26:34]
    node _T_7 = add(BurstReadCnt, UInt<1>("h1")) @[HanningWithFIFO.scala 29:34]
    node _T_8 = tail(_T_7, 1) @[HanningWithFIFO.scala 29:34]
    node _GEN_0 = mux(HanningFIFO.io_MorethanN, UInt<1>("h1"), BurstValid) @[HanningWithFIFO.scala 32:35]
    node BurstTransEn = _T_3 @[HanningWithFIFO.scala 22:26 HanningWithFIFO.scala 23:16]
    node _GEN_1 = mux(BurstTransEn, _T_8, UInt<1>("h0")) @[HanningWithFIFO.scala 28:27]
    node _GEN_2 = mux(BurstTransEn, BurstValid, _GEN_0) @[HanningWithFIFO.scala 28:27]
    node _GEN_3 = mux(_T_4, _T_6, _GEN_1) @[HanningWithFIFO.scala 25:45]
    node _GEN_4 = mux(_T_4, UInt<1>("h0"), _GEN_2) @[HanningWithFIFO.scala 25:45]
    node _T_9 = eq(HanningFIFO.io_full, UInt<1>("h0")) @[HanningWithFIFO.scala 44:42]
    node _T_10 = neq(BurstReadCnt, UInt<1>("h0")) @[HanningWithFIFO.scala 46:37]
    node _T_11 = and(_T_10, io_HanningSignal_ready) @[HanningWithFIFO.scala 46:45]
    io_signal_ready <= Hanningblock.io_signal_ready @[HanningWithFIFO.scala 35:26]
    io_cosines_ready <= Hanningblock.io_cosines_ready @[HanningWithFIFO.scala 36:27]
    io_HanningSignal_valid <= BurstValid @[HanningWithFIFO.scala 38:26]
    io_HanningSignal_bits_value <= HanningFIFO.io_dataout_value @[HanningWithFIFO.scala 39:26]
    Hanningblock.clock <= clock
    Hanningblock.reset <= reset
    Hanningblock.io_signal_valid <= io_signal_valid @[HanningWithFIFO.scala 35:26]
    Hanningblock.io_signal_bits_value <= io_signal_bits_value @[HanningWithFIFO.scala 35:26]
    Hanningblock.io_cosines_valid <= io_cosines_valid @[HanningWithFIFO.scala 36:27]
    Hanningblock.io_cosines_bits_value <= io_cosines_bits_value @[HanningWithFIFO.scala 36:27]
    Hanningblock.io_HanningSignal_ready <= _T_9 @[HanningWithFIFO.scala 44:39]
    HanningFIFO.clock <= clock
    HanningFIFO.reset <= reset
    HanningFIFO.io_datain_value <= Hanningblock.io_HanningSignal_bits_value @[HanningWithFIFO.scala 42:25]
    HanningFIFO.io_wr <= Hanningblock.io_HanningSignal_valid @[HanningWithFIFO.scala 43:21]
    HanningFIFO.io_rd <= _T_11 @[HanningWithFIFO.scala 46:21]
    BurstValid <= mux(reset, UInt<1>("h0"), _GEN_4) @[HanningWithFIFO.scala 27:16 HanningWithFIFO.scala 32:48]
    BurstReadCnt <= mux(reset, UInt<32>("h0"), _GEN_3) @[HanningWithFIFO.scala 26:18 HanningWithFIFO.scala 29:18 HanningWithFIFO.scala 31:18]
