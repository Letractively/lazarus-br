<h2><b>Eu, amante do INTEGER, provavelmente como muitos outros...<br>
acho interessante saber como ele funciona internamente!</b></h2>

<b>Notas do autor: </b><i>esse 'artigo', 'curiosidade', ou até mesmo 'tutorial', foi escrito com a ideia de mostrar operações de Bitwise, não muito conhecidas, porem utilizadas diariamente, os experts já devem ter conhecimento dessa curiosidade, talvez, possam achar essa curiosidade<br>
algo <font color='#ff99ff'>'bobo'</font>, por outro lado, os fins reais desse pequeno artigo é mostrar uma curiosidade, como já foi falado, no próprio título desta <b>CURIOSIDADE</b> (novamente, curiosidade!).</i><br><br>
<b>Autor: </b><i>Bizugo/Biz/MegaNo0body/BMega/VariosOutrosApelidos = <a href='mailto:kingbizugo@gmail.com'>kingbizugo@gmail.com</a></i><br>

<h2>Introdução, os Bits:</h2>
Um <b>BYTE</b> tem <b>8 BITS</b>;<br>
Um <b>BYTE </b>pode ter <b>256 valores diferentes (de 0 a 255)</b>;<br>
Um <b>INTEGER </b>é formado de <b>4 BYTES</b>;<br>
Um <b>CARDINAL </b>também é formado por <b>4 BYTES</b>;<br>
Um <b>INTEGER/CARDINAL</b> que tem <b>4 BYTES</b> possui <b>4x8 BITS</b>
ou seja, <b>32 BITS</b>;<br><br>
Um integer: 0000 0000   0000 0000   0000 0000   0000 0000 o primeiro bit sendo 1<br>
faz o integer ser negativo (por esse motivo um INTEGER não pode receber números maiores que 2,147,483,648, já o cardinal, que tem o mesmo numero de bytes e não possui números negativos pode receber números até 4,294,967,295)<br>
o segundo e todos os outros bits, de valor 1 ou 0, significam os<br>
valores em potencia<br>
0100 0000   0000 0000   0000 0000   0000 0000 = 1073741824<br>
0000 0000   0000 0000   0000 0000   0000 0010 = <font color='#3366ff'>(2<code>^</code>1)</font> = 2<br>
0000 0000   0000 0000   0000 0000   0000 0110 = <font color='#3366ff'>(2<code>^</code>2)</font><font color='#ff0000'> + </font><font color='#3366ff'>(2<code>^</code>1)</font> = (<font color='#3366ff'>4</font>)<font color='#ff0000'> + </font>(<font color='#3366ff'>2</font>) = 6<br>
0000 0000   0000 0000   0000 0000   0000 0111 = <font color='#3366ff'>(2<code>^</code>2)<br>
<font color='#ff0000'>+</font> (2<code>^</code>1)<font color='#ff0000'> +</font>
(2<code>^</code>0)</font>
= (<font color='#3366ff'>4</font>) <font color='#ff0000'>+</font> (<font color='#3366ff'>2</font>) <font color='#ff0000'>+</font> (<font color='#3366ff'>1</font>) = 7<br><br>
(nota, separamos os bits de 4 em 4 para facilitar a<br>
vizualização)<br>
<br>
Um <b>BOOLEANO </b>é um <b>BIT</b>, <b>0</b> ou <b>1</b>;<br>
Então um <b>INTEGER/CARDINAL</b> tem <b>32 BOOLEANOS</b>
dentro de si;<br>
<br>
<blockquote><h1>Operações de Bitwise!</h1></blockquote>
<h2>Operação Bitwise Shift Left</h2>
1 <b>shl</b> 5 significa 1 <b>bitwise shift left</b> 5;<br>
Em outras palavras, você move o 1 cinco posições para a esquerda...<br>
0000 0001 (1) <b>shl</b> 1 = 0000 0010<br>
0000 0001 (1) <b>shl</b> 5 = 0010 0000 = 32<br>
Então...<br>
1 <b>shl</b> 5 = <font color='#3366ff'>(2<code>^</code>5)</font> = 32<br>
1 <b>shl</b> Index = <font color='#3366ff'>(2<code>^</code>Index)</font> = uma flag<br>
<h2>Operação Bitwise Shift Right</h2>
<i>A operação Bitwise Shift Right faz exatamente?</i>
a mesma coisa que o Bitwise Shift Left, só que a direção que o bit move é ao contrario...<br>
0010 0000 (32) <b>shr</b> 5 = 0000 0001 (1)  = 1<br>
é exatamente a mesma coisa, só que ao contrario!<br>
<h2>Operaçãos Bitwise AND/OR/AND NOT</h2>
A operação <b>AND</b>:<br>
1110 <b>AND</b> 0100 = 0100<br>
Ela simplesmente<br>
1110 <b>AND </b>0110 = 0110<br>
Dificil explicar com palavras...<br>
1110 <b>AND </b>1110 = 1110<br>
<br>A operação <b>OR</b>:<br>
1000 <b>OR</b> 0100 = 1100<br>
1001 <b>OR</b> 0100 = 1101<br>
1001 <b>OR</b> 0110 = 1111<br>
Essa é mais fácil explicar com palavras, a operação <b>OR</b> junta os bits<br>
<br>Combinação de <b>AND + NOT</b>:<br>
1110 <b>AND NOT</b> 0100 = 1010<br>
1110 <b>AND NOT</b> 1100 = 0010<br>
Nota, em vez de juntar, ele muda o valor do bit, de 0 para 1 e de 1 para 0.<br><br><br>
<b>Curiosidade: 32 booleanos per 4 bytes (integer)</b><br>
Agora baixe o demo e teste!<br>Localização do demo: <i>/misc/Curiosidade32BoolPerInt/Demo/</i><br>
Use esta CURIOSIDADE com fims de aprender algo novo, por favor, respeite os direitos (se é que existem) do autor.<br>