;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit Butterfly : 
  module ComplexAdd : 
    input clock : Clock
    input reset : Reset
    output io : {flip op1 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, flip op2 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, res : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}}
    
    node _T = add(io.op1.re, io.op2.re) @[Butterfly.scala 21:26]
    node _T_1 = tail(_T, 1) @[Butterfly.scala 21:26]
    node _T_2 = asFixedPoint(_T_1, 16) @[Butterfly.scala 21:26]
    io.res.re <= _T_2 @[Butterfly.scala 21:13]
    node _T_3 = add(io.op1.im, io.op2.im) @[Butterfly.scala 22:26]
    node _T_4 = tail(_T_3, 1) @[Butterfly.scala 22:26]
    node _T_5 = asFixedPoint(_T_4, 16) @[Butterfly.scala 22:26]
    io.res.im <= _T_5 @[Butterfly.scala 22:13]
    
  module ComplexSub : 
    input clock : Clock
    input reset : Reset
    output io : {flip op1 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, flip op2 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, res : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}}
    
    node _T = sub(io.op1.re, io.op2.re) @[Butterfly.scala 35:26]
    node _T_1 = tail(_T, 1) @[Butterfly.scala 35:26]
    node _T_2 = asFixedPoint(_T_1, 16) @[Butterfly.scala 35:26]
    io.res.re <= _T_2 @[Butterfly.scala 35:13]
    node _T_3 = sub(io.op1.im, io.op2.im) @[Butterfly.scala 36:26]
    node _T_4 = tail(_T_3, 1) @[Butterfly.scala 36:26]
    node _T_5 = asFixedPoint(_T_4, 16) @[Butterfly.scala 36:26]
    io.res.im <= _T_5 @[Butterfly.scala 36:13]
    
  module ComplexMul : 
    input clock : Clock
    input reset : Reset
    output io : {flip op1 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, flip op2 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, res : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}}
    
    node _T = mul(io.op1.re, io.op2.re) @[Butterfly.scala 57:28]
    node _T_1 = mul(io.op1.im, io.op2.im) @[Butterfly.scala 57:52]
    node _T_2 = sub(_T, _T_1) @[Butterfly.scala 57:40]
    node _T_3 = tail(_T_2, 1) @[Butterfly.scala 57:40]
    node _T_4 = asFixedPoint(_T_3, 32) @[Butterfly.scala 57:40]
    io.res.re <= _T_4 @[Butterfly.scala 57:15]
    node _T_5 = mul(io.op1.re, io.op2.im) @[Butterfly.scala 58:28]
    node _T_6 = mul(io.op1.im, io.op2.re) @[Butterfly.scala 58:52]
    node _T_7 = add(_T_5, _T_6) @[Butterfly.scala 58:40]
    node _T_8 = tail(_T_7, 1) @[Butterfly.scala 58:40]
    node _T_9 = asFixedPoint(_T_8, 32) @[Butterfly.scala 58:40]
    io.res.im <= _T_9 @[Butterfly.scala 58:15]
    
  module Butterfly : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip in1 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, flip in2 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, flip wn : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, out1 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}, out2 : {re : Fixed<32><<16>>, im : Fixed<32><<16>>}}
    
    inst ComplexAdd of ComplexAdd @[Butterfly.scala 26:22]
    ComplexAdd.clock <= clock
    ComplexAdd.reset <= reset
    ComplexAdd.io.op1.im <= io.in1.im @[Butterfly.scala 27:17]
    ComplexAdd.io.op1.re <= io.in1.re @[Butterfly.scala 27:17]
    ComplexAdd.io.op2.im <= io.in2.im @[Butterfly.scala 28:17]
    ComplexAdd.io.op2.re <= io.in2.re @[Butterfly.scala 28:17]
    inst ComplexSub of ComplexSub @[Butterfly.scala 40:22]
    ComplexSub.clock <= clock
    ComplexSub.reset <= reset
    ComplexSub.io.op1.im <= io.in1.im @[Butterfly.scala 41:17]
    ComplexSub.io.op1.re <= io.in1.re @[Butterfly.scala 41:17]
    ComplexSub.io.op2.im <= io.in2.im @[Butterfly.scala 42:17]
    ComplexSub.io.op2.re <= io.in2.re @[Butterfly.scala 42:17]
    inst ComplexMul of ComplexMul @[Butterfly.scala 63:22]
    ComplexMul.clock <= clock
    ComplexMul.reset <= reset
    ComplexMul.io.op1.im <= ComplexSub.io.res.im @[Butterfly.scala 64:17]
    ComplexMul.io.op1.re <= ComplexSub.io.res.re @[Butterfly.scala 64:17]
    ComplexMul.io.op2.im <= io.wn.im @[Butterfly.scala 65:17]
    ComplexMul.io.op2.re <= io.wn.re @[Butterfly.scala 65:17]
    io.out1.im <= ComplexAdd.io.res.im @[Butterfly.scala 84:11]
    io.out1.re <= ComplexAdd.io.res.re @[Butterfly.scala 84:11]
    io.out2.im <= ComplexMul.io.res.im @[Butterfly.scala 85:11]
    io.out2.re <= ComplexMul.io.res.re @[Butterfly.scala 85:11]
    
