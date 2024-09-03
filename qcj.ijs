NB. Quantum computing tools.
NB. Note: J doesn't distinguish column and row vectors, neither does the implementation below.

NB. Limitations:
NB. No non-integer matrix powers or exp(matrix) yet

load'plot'
boxdraw_j_ 0 NB. set nice box formating.
cocurrent 'qcj' NB. define all below in the qc locale (so if you accidentally over-write something e.g. X, you can restore with erase'X')
help =: ];._2 {{)n
Terminology: G,S,A,#,K...N, = Gate, state, any, matrix, numbers; [a,b,c] any of a,b,c can replace the []
States are vectors (rank 1); J does not distinguish row/column vectors, see (-: |:) i. 4
Verbs/functions defined:
 [K] fh 'foo'  : find (partial) string 'foo' in this help, |K lines of context centered or following (K>0, K<0)
 A   tp  A     : tensor/Kronecker product
 A   tps A     : Sparse tensor product
 A   mp  A     : matrix product; e.g. G mp S applies gate to state, G mp G combines two gates sequentially.
 SA  op  SB    : |SA><SB| outer product; density of S : op~ S (with probabilities on diagonal, and couplings off-diagonal).
 SA  ip  SB    : <SA|SB>  inner product.
    dag  A     : dagger: transpose conjugate
    diag #     : diagonal of matrix (if #is rank 2 or higher); matrix with diagonal # if # is rank 1. 
   trace #     : matrix trace = sum of diag
   norm  S     : normalise state(s) (normalisation is not enforced, do so if needed).
 (N,L) q G     : apply gate G to qubits L resulting in an N qubit gate
    scr  A     : scrub near-zero values from any (complex) values A
 [x,y,z]meas S : measurement probability in x,y, or z basis
 # pmeas S     : Projective measurement onto specific state (use # meas S with # = projection operator)
 K..M selm S   : selective measurement in Z-basis of qubits K..M, returns 0) P(bitstring) 1) states after measuring 2) bitstring
  pickst P;S;B : Pick one state;bitstring from results of selm according to the contained probabilities
  plaus  P;S;B : Keep only plausible states from selm results
K u shots S    : Run simulation verb u (ending in selm) |K times, returning states. If K>0 u is run K times, otherwise, the state is computed only once.
  hist #M      : Plots histogram of any numeric data (e.g. measurement results: hist 1000 selm@:(H&mp) shots S0)
  blocha S     : Bloch sphere angles for state(s) S
  blochv S     : vector in Bloch space for state(s) S
  bloch  S     : plot Bloch sphere for states(s) S
  qft S        : Quantum Fourrier Transform verb on state(s); has inverse.

States & Gates
 S0 S1 Sp Sm Spi Smi : states (kets) |0>, |1>, |+>, |->, |i>, |-i>
 rg '01+-i!'         : quantum register = tensor product of kets above (! = -i)
 rst N               : generate random state of N qubits
 ghz N, wst N        : N-qubit GHZ and W states
 I X Y Z H           : identity; Pauli X,Y,Z; Hadamard
 RX RY RZ            : rotation gates around X,Y,Z
 P S T               : Phase shift gates; general (adverb), pi/2 and pi/4
 G CU                : controlled version of gate G (e.g. CZ -: Z CU)
 CX , CY , CZ        : controlled X,Y,Z
 CSW , SW            : (controlled) swap gate
 TOF                 : Toffoli gate
 K L FSIM            : Fermionic simulation gate with theta,phi=K,L
 QFT                 : Quantum Fourrier Transform matrix for 2^.N states (use qft verb instead).

Overwritten something in qc (e.g. mp)? revert using erase 'mp' (Uses J locales, namespaces)

Short J overview
 J Vocabulary: https://code.jsoftware.com/wiki/NuVoc ; Reference card: https://code.jsoftware.com/wiki/File:B.A4.pdf
 Number format : _1 1r4 1r2p1 3j5 1e6 _ __: -1 (- is verb) 1/4, pi/2 (1/2*pi^1), 3 + 5*i, 1000000, inf, -inf
 Literals (strings) : 'this is a string'; use '' to include single quotes.
Terminology, parts of speech:
 Noun = data, any type; verb = function taking noun, and returning a noun; monad/dyad = verb with 1 or 2 arguments;
 Adverbs and conjunctions: higher order functions on nouns/verbs and return any.
 In the following: f,g,h = verb, x, y = left/right verb args;
 m, n = left/right noun args to adv/conj and u, v is left/right verb args to adv/conj.
parsing/execution: adv/conjunctions execute first; then verbs from right to left; use () to enforce different order
type ;: 'mp RX foo X ' shows which parts of speech mp, RX, foo and X are; use e.g. datatype Y for datatypes

Rank
 Nouns all are (hyper-)rectangular arrays with shape, rank.
 $ A, # A, #@$ A : shape, number of elements, rank of A
 [x] verb y : apply verb to x and y (at implicit verb rank, verb b. 0 returns verb's monadic, left and right ranks)
 verb"N : apply verb at rank N; e.g. see difference <"0, <"1, <"2, <"3 when applied to i.2 3 4; f"verb applies f at rank of verb.
 m"n    : constant function, returning m for each item at rank n e.g. 0"0 i. 3 4 returns a 3x4 matrix of 0's; 'foo'"_ returns 'foo'
 boxed  : Boxed nouns allow combining different sizes/types in single array.
Explicit definition:
 use {{ }}, with arguments x,y (for verbs) and m,n,u,v (for adv/conj) as above (type autodetected)
 {{)x ...}} forces type depending on x being first letter of : adv conj noun verb monad dyad
 control constructs only in explicit def:
 for. T do. B end. ; if. T do. B [elseif. T do. B] [else. B] end.; while. T do. B end. ...
Verb composition (tacit): @, @:, &, &:
 [x] (f g h) y is a fork = (x f y) g (x f y)  [x] (f g) y is a hook = [x if present, else y] f g y
 x f@:g y = f x g y   x f&:g y = (g x) f (g y) ; @ and & are the same but apply f"g
 m&v and u&n bind left/right argument (noun) m/n to verb u/v.
Inverses ^:_1, b. _1 , &., &.:, inv :. 
 f^:_1 is inverse of f, =  f inv; see what is f inv: use f b. _1
 Under [x] f &.: g y = g ^:_1 [g x] f g y; &. at rank of g; f :. g is f with assigned inverse g
Selected verbs
 % + - *  : dyad: divide, others as usual; monad: 1/x, complex conjugate, minus, signum (all rank 0)
 =: =.    : global and local assignment
 = < > <: >: : dyad: logical operators (<: and >: are <= and >=) (all rank 0)
 i. y: 0 to y-1
 x o. y : for x=1,2,3: sin y, cos y, tan y; x=_1,_2,_3 asin, acos, atan
 [x] #. y, [x] #: y : convert y from/to base x (2 by default), e.g. 1 0 1 -: #: 5
 x,y x,:y x,.y : join arrays x and y: along the first axis, adding a new first dimension, and join items (zip)
 x { y : indexing: select items x (of leading axis) of y
 x # y : repeat items of y x times; if x Boolean mask = Boolean indexing
 ; < > : link (append after boxing left, and right if right not boxed), unbox, box (monads), Used a lot: u&.> :u on data in box, re-box.
 ;:    : monad boxes J words in string
Selected adverbs/conjunctions
 u/ y: apply verb u between items of y, e.g. mp/ X,Y,:Z or tp/ S0,S1,:Sp; sum = +/; product is */; max = >./ ...
 [x] u~ y: reflective y u y (monad) or passive y u x (dyad)

Less useful functions in qc
  # pow K : Matrix # to the power K
P  qbp  G : apply permutation P to qubits in gate G (used by q)
  m2tt  G : For permuting gates, turns gate into function truth table (has inverse)
 #A bd #B : form block diagonal matrix with matrices #A and #B as blocks
}}
NB. [x] fh y: find line in help containing literal y (e.g. fh ' mp '). x indicates how many lines of context (>0 centered, <0 starting from match) 
fh =: (help&([#~+./@E.&tolower"1~) : (help#~[ (<.@-:@<:@[ |.^:(0<:*@[) (0#~<:@|@[), |@[ +./\ ]) +./@E.&tolower"1&help@]))

NB. Composition operators:
NB. =======================
NB. block diagonal (dyad)
bd =: [ , ] ,"1~ 0 {.@# [
NB. diagonal matrix/diagonal of matrix
diag =: [`(* =@i.@#)`(|:~ <@i.@#@$)@.(2<.#@$)
NB. matrix/dot product (dyad; use ip when dealing with bra's for conjugate)
mp =: +/ .*
NB. inner and outer product of states
ip =: (mp +)~  NB. <x|y>
op =: (*+)"0/  NB. |x><y|
NB. matrix power by repeated squaring (dyad e.g. 4 pow mat)
pow=: (4 : 'mp/ mp~^:(I.|.#:y) x')
NB. commutator [F,G] = FG - GF
com=: mp - mp~

NB. Tensor product (=kronecker product=circled x), from https://code.jsoftware.com/wiki/Essays/Kronecker_Product
cs =: ([: */ ,:!.1)&:$
as =: ([: ~.@,@|: ;&i. +&> 0 , [)&(#@$)
tp =: (cs ($,) as |: *"0 _) f.

tps =: [: 8&$.@:scr tp&$. NB. sparse tensor product
NB. scrub near 0's from any value (including complex) e.g. (;scr) 1 o. 2p1
scr =: (**@:|)&.+.
NB. dagger = transposed complex conjugate
dag =: +@|:
NB. matrix trace. e.g. trace op~ rg '0i1!'
trace =: (<0 1) +/@:|: ]

NB. Normalise state = divide by sqrt of inner prod.:
norm =: (% [: %: (mp +))"1

NB. Quantum Gates and states (loosely based on https://en.wikipedia.org/wiki/Quantum_logic_gate)
NB. ========================
I=: =i.2        NB. Identity
NB. Pauli gates (rotate by 1p1 around axis on Bloch sphere)
X=: |.I         NB. also NOT/bit flip
Y=: _1 1* j. X  NB. 
Z=: 1 _1*I      NB. phase flip

NB. Hadamard gate
H=: (%:2) %~ 2 2$1 1 1 _1 NB. 0 1 -> +

NB. Basis states in basis |0> , |1>
S0 =: 1 0                NB. +Z
S1 =: 0 1                NB. -Z
'Sp  Sm' =: (%:2) %~ S0 (+,:-)    S1 NB. +-X; or H mp S1 or Hm S0
'Spi Smi'=: (%:2) %~ S0 (+,:-) j. S1 NB. +-Y; or R/L
NB. rst : generate random state of y qubits
rst =: [: tp/@:norm@:j./ _1+2*0 ?@$~ 2,~2,]

NB. quantum register (watch out with size being 2^#y)
rg =: ([: tp/ (S0,S1,Sp,Sm,Spi,:Smi) {~ '01+-i!' i. ,)"1

NB. parallel gates use tp above: first applies on first Kqubit; second on second.
NB. composing single qubits to register: use tp. Applying gates in parallel: use tp
NB. e.g. Y and X in parallel on qubits 1 2; 3 4.
((Y tp X) mp (1 2 tp 3 4) ) -: (Y mp 1 2) tp (X mp 3 4)

NB. rotation gates
RX =:  {{(1 0j_1,:0j_1 1) * (2 1,:1 2) o. -: m}}
RY =:  {{(1   _1,:   1 1) * (2 1,:1 2) o. -: m}}
RZ =:  {{  2 2$^(-,__,__,])j.-:m}}

NB. phase shift gates (period 2 pi, note, not hermitian)
P    =: {{1 0 ,: 0,^@j. m}} NB. arbitrary rotation around Z axis by y radians
S    =: scr 1r2p1 P         NB. S gate: pi/2 radian rotation
T    =: 1r4p1 P             NB. T gate: pi/4 rotation

NB. Multi-qubit gates
NB. ---------------------
NB. use multi-gates directly or, use q to specify where to connect.
NB. (N,list) q GATE (verb): apply GATE to list of qubits (in total qubits N) 
NB.  e.g. 4 2 0 q CNOT : apply CNOT in 4 qb circuit to qubit 0 with qubit 2 as control 
NB.  e.g. SW .-: mp/ (2,.0 1,1 0,:0 1) q CNOT: show that 3 flipped CNOT'S is a SW
NB.      v permutation qubits v       pad gate with I's for {. m qubits  
q =: {{ ((}. ([, -.~) i.@{.) x ) qbp (I tp~^:(({.x)-2^.#y) y )}}"1 2
NB. permute qubits in gate or register (n) according to permutation in x. e.g. SW -: CNOT mp 1 0 CNOT mp CNOT; q easier to work with.
NB.     r/g perm all axes  qb perm trans decode states
qbp =: {{y ({|:)^:(#@$@])~ x (&{)(&.|:)(&.#:) i.#y}} 

NB. controlled gates
CU   =: {{(=i.4) (<;~2 3)}~ m}} NB. generalised controlled gate
CNOT =: CX =: X CU 
CY   =:       Y CU
CZ   =:       Z CU
NB. swap swaps two qubits
SW   =: X (] bd bd) ,1

NB. Toffoli
TOF  =:  (=i.8) (<;~6 7)}~ X
NB. CSWAP; aka Fredkin conditioned on QB 0, swap QB's 1 and 2
CSW =: (I tp I) bd SW

NB. FSim or fermionic simulation gate per https://en.wikipedia.org/wiki/List_of_quantum_logic_gates; m is theta,phi
FSIM =: {{ ({.m) ((,1) bd (((0 1,:1 0) { 1 0j_1 *2 1&o.)@[) bd (,@^@j.@])) {:m}}
NB. Quantum Fourrier Transform matrix (y: width of state i.e. 2^Nqubits). Uses mod to avoid accumulating FP errors.
NB. QFT=: %: %~ ([:r.2p1%])^]|*/~@:i.
QFT =: (%: %~ [:r.i.*2p1%]){~]|*/~@:i. NB. slight rewrite, 10x faster, half the space. Note: (-:~.@,i.]) (]|*/~@i.) 16, so omit ~. and dyad i. .
NB. qft verb, applies qft to state; with inverse defined
qft=: (mp"2 1~ QFT@{:@$) :. (mp"2 1~ dag@QFT@{:@$)

NB. GHZ and W states (see e.g. https://arxiv.org/pdf/1807.05572 gate-based algorithms, but for ease implemented based on states)
ghz =: [: norm #&'0' +&rg #&'1'        NB. normalised sum of all-zero and all-one states.
wst =: [: norm@:(+/) (2^i.) =/ [:i.2^] NB. note: in tensor product, subsequent non-zeros are at positions 1, 2, 4, 8 ...

NB. quantum logics: for permuting gates (has inverse too!)
m2tt =: #:@:(i."1&1)

NB. Measurement and visualisation
NB. =============================

NB. Measurement (x: projector for basis operator (outerproduct of an eigenvector of the operator with itself); y: qubit)
meas  =: +@] mp [ mp ] NB. + instead of dag, because (dag v)-:+v for any vector v.
pmeas =: (op~@[ meas ])"1 _  f. NB. measurement projecting state y on vector(s) x (left, rank 1). e.g. Sm pmeas 1r4p1 RZ mp Sm
NB. standard measurement bases for single qubit; for multiple (e.g. 4) do: (1 tp^:4~ rg"0 '01') pmeas state. 
zmeas =: S0 &pmeas NB. |0>
xmeas =: Sp &pmeas NB. |+>
ymeas =: Spi&pmeas NB. |i>
NB. Historical only; use selm/selmd below. selective measurement in Z basis x: qubits to measure; y: state. returns probabilities for 0...0 to 1...1 state
NB. selm_orig =: (([: i. 2^.#) $: ]) :  (({ "1 #:@i.@#) +//. *:@:|@:])
NB. selm  =: (([: i. 2^.#) $: ]) :(({"1 #:@i.@#) (      (+//. *:@:|),. =@[ ]`(I.@[)`[}"1 norm/.) ] )

NB. Selective measurement in Z-basis with resulting state vectors; returns (boxed) 0) probabilities, 1) resulting state vectors 2) bit representation
NB. Could likely be simplified; works within a second or so for measuring all of 12 QBits, so fine for now.
NB.      Monad: all qbits   : partial indices  sum  probs  ; where interleave normed states; bit representation NB. Detail: (0) selm and (,0) selm differ in dimensions of bitstring.
selm =: (([: i. 2^.#) $: ]) :(({"1 #:@i.@#) ( (+//. *:@:|) ; (=@[ ]`(I.@[)`[}"1 norm/.)  ; ~.@[ ) ] )
NB. pickst: picks random state from result of selm according to resulting probabilities; strips probability, since nonsensical
pickst =: (+/\ I. ?@0)@(0&{::) { L:0 }.
NB. plaus: keep only plausible (i.e. non 0-probability) states from selm results:
plaus =: (0<[: scr 0{::]) #L:0 ]

assert I -: ([: >@{. 2 selm ])"1] 2 (1&{::)@selm rst 3 NB. measuring the same bit twice should, the second time have 100% probability

NB. Shots simulation adverb: repeat experiment in u x times. u is expected to be a monad, taking a state and to end in selm measurement; y is starting state. Not using pickst, as only bitstring required. shots returns a list of measurement results measured, i.e. bit strings.
NB. if x > 0 then perform u only once, simulate experiments by comparing many random numbers to probabilities. Easily 100x faster than x<0.
NB. if x < 0 then run u for each shot independently. Use where e.g. intermediate measurements.
shots =: {{
if. x>0 do.  NB. run once, then simulate picking results based on probabilities
  st =. u. y
  x (((+/\@] I. [ ?@$ 0:) 0&{::) { _1&{::@]) st
else.        NB. run u. x times.
  ((+/\ I. ?@0)@:(0&{::) { _1&{::@])@:u."1 (|x) #,:y
end.
}}
NB. e.g. (,#)/..~ 1000 (0&selm)@:(H&mp) shots S0

NB. hist: state histogram. Takes list of measurement results (actually any numeric result) and plots a histogram. (Minor adaptations would allow non-numeric usage, but (,#) only works for numbers...)
hist =: (('bar;xlabel ',[: ,' ',.~dquote@:":@:}:"1) plot {:"1)@/:~@:(({.,#)/.~)

NB. Visualisations
NB. ===============
ang2st =: -:@{. ( (2 o. [) , _12&o.@] * 1 o. [) {:              NB. |s> = cos(T/2) , (e^i phi) sin(T/2)
blocha =: (-~/@:{: ,~ 2*_1 o. {:@:{.)@:|:@:*.@:norm"1 :. ang2st NB. Bloch angles theta, phi; with inverse
NB. Bloch vectors (y: qubit(s)) to 3D coordinates in bloch sphere
NB.      cos T sin phi , sin T,phi  cos theta   phi1-phi0   2 * acos theta split normed qubit
blochv =: (([:*/1 2&o.),([:*/1&o.),2 o. {.)@blocha              NB. Cartesian Bloch coordinates

NB. Bloch sphere, showing in teal all qubits (rank 1). e.g.: bloch (,: _1r4p1 RZ mp 1r4p1 RY mp ]) S0
bloch =: {{
  NB. Initialise plot
  pd'reset'
  pd 'tics 0 0 0;labels 0 0 0; aspect 1; viewpoint 10 5 3'
  NB. axes and circles to represent sphere
  circ =. 2 1 <@:o."0 1 o. 20%~i.41
  zero =. <41#0
  pd 0 1;0 0; 0 0[pd circ,zero[pd 'color blue'
  pd 0 0;0 1; 0 0[pd zero,circ[pd 'color green'
  pd 0 0;0 0; 0 1[pd (0&{ , zero , 1&{) circ[ pd 'color red'
  NB. convert state to list of bloch coords triplets
  pts =. ,:^:(1=#@$) blochv y
  NB. plot actual vector(s)
  for_pt.  pts do.
    pd 'pensize 10;color teal;penstyle 0'
    pd  <"1 ] 0 0 0,.pt
    NB. projection on x y plane and circle for phi angled plane
    pd 'pensize 3;color gray;penstyle 2'
    pd <"1 |:0 0 0, (0,~}:pt),: pt
  end.
  pd 'show'
}}
NB. Misc
NB. =====
h =: 6.62607015e_34 NB. Planck constant; in J.s or kg m^2 s^_1
hb=: h%2p1          NB. h bar; reduced Planck constant.

cocurrent'base' NB. switch back to the base locale
coinsert'qcj'    NB. make qc definitions available when undefined in the base locale
