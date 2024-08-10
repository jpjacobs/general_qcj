NB. Examples of use. Load with loadd 'examples.ijs' for showing lines and output.
NB. ==============================================================================
NB. |0> state
S0
NB. show |0> in Bloch sphere
bloch  S0
NB. Cartesian coordinates of |+> in Bloch sphere 
blochv Sp
NB. Near-0 entries can be scrubbed for better display:
scr blochv Sp
NB. angles theta, phi for |+>
blocha Sp
NB. original and S0 rotated over pi/4 around Y and Z
bloch mystates=:(,:1r4p1 RZ mp 1r4p1 RY mp  ]) S0
NB. Z-measurements on mystates.
selm"1 mystates
NB. quantum register corresponding to |0> (x) |0> (x) |i>
rg'00i'
NB. Bell circuit
Bell =: CNOT mp (H tp I)
NB. executed on each combination of S0 and S1 (states appended for display)
(#:i.4);~Bell&mp"1] _2 rg\'00011011'
NB. probabilities for states 00 ... 11 for each of the Bell states before
res=: (tp~ rg"0 '01') pmeas"1/ Bell&mp"1] _2 rg\'00011011'
NB. Nice display
3 2$'meas\in';(4":|:#:i.4);(#:i.4);(4j1 ": res);'sum';4 ": +/ res


NB. Some quantum algorithms
NB. =======================

NB. Deutsch-Jozsa Algorithm: determine whether function is constant or balanced.
NB. ----------------------------------------------------------------------------
UF =: [: mp/ CNOT q~ (] ,.0,.~i.&.<:)  NB. balanced: qubit 0 is  XOR of inputs qubits 1-3 0 = | q0 XOR f(1..y)>
CT =: =@:i.@:(2&^) NB. Constant function, identity matrix of size 2^y
NB. Deutsch Josza algorithm; takes y: N>:2 qubit quantum gate implementing 
DJ =: {{ NB. return 0 for constant function, 1 for balanced
  N=.2^.#y NB. number of qubits for this invocation
  HH =: I tp tp/(<:N) #,:H  NB. parallel H's
  NB. index of max probability is not 0 (I. based approach breaks down due to numerical issues)
  0<(i. >./) >{. (}. i.N) selm HH mp y mp HH mp rg N{.!.'0' '-' NB. measure probabilities for all but qubit 0
}}
assert 1 0 -: (UF ,&DJ CT) 4  NB. 4 qubits
assert 1 0 -: (UF ,&DJ CT) 10 NB. 10 qubits; Works till 12 qubits within few seconds.
NB. The above in quirk:
NB. quirk    UF: https://algassert.com/quirk#circuit={%22cols%22:[[%22X%22,%22%E2%80%A2%22],[%22X%22,1,%22%E2%80%A2%22],[%22X%22,1,1,%22%E2%80%A2%22],[%22Chance4%22],[1,%22Chance3%22]],%22init%22:[0,1,0,1]}
NB. quirk DJ UF: https://algassert.com/quirk#circuit={%22cols%22:[[1,%22H%22,%22H%22,%22H%22],[%22X%22,%22%E2%80%A2%22],[%22X%22,1,%22%E2%80%A2%22],[%22X%22,1,1,%22%E2%80%A2%22],[1,%22H%22,%22H%22,%22H%22],[%22Chance4%22],[1,%22Chance3%22],[1,%22Amps3%22]],%22init%22:[%22-%22]}
NB. quirk DJ CT: https://algassert.com/quirk#circuit={%22cols%22:[[1,%22H%22,%22H%22,%22H%22],[1,%22H%22,%22H%22,%22H%22],[%22Chance4%22],[1,%22Chance3%22],[1,%22Amps3%22]],%22init%22:[%22-%22]}

NB. Superdense coding
NB. -----------------
NB. Physically send 1 qubit to communicated 2 classical bits
est =: Bell mp rg '00'                        NB. Entangled Bell state
sde =: {{                                     NB. Superdense encoding message x (0 0-1 1) on qubit 0
  y mp~ I tp~ (#.x){(I,X,Z,:X mp Z)           NB. pick gate, qb 0
}}"1 _
sdd  =: ([: 2 2&#:@:(i.&1)@:*: Bell&mp inv)"1 NB. Superdense decoding: undo Bell entanglement, find where probability is 1 and convert back to binary
msgs =: (2 2#:i.4)                            NB. All 4 possible messages are sent
assert msgs -: sdd msgs sde est NB. sent messages equals received messages

NB. Quantum teleportation
NB. ---------------------
NB. Sending 2 classical bits, to communicate 1 qubit state.
q0  =: rst 1               NB. Qubit who's state is to be sent
q12 =: Bell mp rg '00'     NB. Entangled Bell state
st  =: q0 tp q12           NB. full state including qubit 0
Note 'Diagram'
Proper teleport  Deferred measurement
q0 ?--oHM----     q0 ---oH-o-- 
q1 -Ho+--M---     q1 -Ho+-o--- 
q2 --+----XZM     q2 --+--XZM-
crz=====v==o=     crz=========
crx======vo==     crx=========
)
NB. Deferred measurement circuit version
tele =:(3 0 2 q CZ) mp (3 1 2 q CX) mp (H tp I tp I) mp (3 0 1 q CNOT)
assert (selm q0) -:&(0&{::) 2 selm tele mp st NB. random state from q0 to q2
NB. TODO: figure out how to extract the actual state of q2 after circuit.

NB. Non-deferred measurement version(s)
telenond =: {{
  q0  =. rst 1                                          NB. Random state to be teleported
  q12 =. CNOT mp (H tp I) mp rg '00'                    NB. Initial Bell state q1-q2
  st  =. (H tp I tp I) mp (3 0 1 q CNOT) mp (q0 tp q12) NB. State before measurement
  'st crz' =. pickst 0 selm st                          NB. First measurement
  'st crx' =. pickst 1 selm st                          NB. Second measurement
  st  =. (3 2 q CZ)&mp^:crz (3 2 q X)&mp^:crx st        NB. Conditional execution of X and Z gate
  (0 selm q0) -:&(0&{::) 2 selm st                      NB. compare original 
}}
telenondsim =: {{ NB. Experiment: does it matter whether measured together or not: NO!
  q0  =. rst 1
  q12 =. CNOT mp (H tp I) mp rg '00'
  st  =. (H tp I tp I) mp (3 0 1 q CNOT) mp (q0 tp q12)
  'st cond' =. pickst 0 1 selm st                       NB. Both measurement
  'crz crx' =. cond
  st  =. (3 2 q CZ)&mp^:crz (3 2 q X)&mp^:crx st
  (0 selm q0) -:&(0&{::) 2 selm st
}}
assert (telenond"0 *.&(*./) telenondsim"0) i. 10        NB. test both non-deferred versions
