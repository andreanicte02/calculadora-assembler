
;######################### definir macros ####################################
imprimir MACRO string
	mov ax, seg string
	mov	ds, ax
	mov	ah, 09h
	mov dx, offset string
	int 21h	;	imprimir en pantaja
ENDM

imprimiren	MACRO 
	imprimir mensaje1

ENDM

limpiarpantalla MACRO

	mov ah, 00h
	mov al, 03h
	int 10h				;interrupcion para modo video
ENDM


imprimirReporte MACRO cadena, tamano
	mov ah,40h ;Código de la interrumpción
	;mov cx,255d ;Número de bytes a escribir
	;mov cx,LENGTHOF cadena
	mov cx,tamano
	lea dx,cadena ;La cadena que se quiere escribir
	int 21h
	jc errorreporte
ENDM

pintarpixel	MACRO x,y ,color
	mov ah, 0ch
	mov cx, x
	mov dx, y
	mov al, color
	mov bh, 0
	int 10h
ENDM

impfechayhora MACRO
	xor si,si 	;vaciar registro
	mov ah, 2ah
	int 21h
	;cx año
	;dh mes
	;dl dia
	mov year, cx
	mov cx, dx 	;guardo el mes y dia

	mov ah, 0
	mov al, dl
	mov dx, 0; div sin signo
	mov bx, 10
	div bx		;div ax/bx  ax es cociente dx es el reciduo

	mov bx, dx
	mov dl, al
	add dl, 30h
	mov fechaarregla[si], dl
	inc si

	mov dl, bl
	add dl, 30h
	mov fechaarregla[si], dl
	inc si
	mov fechaarregla[si], 2fh
	inc si

	mov ah, 0
	mov al, ch
	mov dx, 0
	mov bx, 10
	div bx

	;guradar el residuo
	mov bx, dx
	mov dl, al
	add dl, 30h
	mov fechaarregla[si], dl
	inc si

	mov dl, bl
	add dl, 30h
	mov fechaarregla[si],dl
	inc si
	mov fechaarregla[si], 2fh
	inc si

	;imprimir año
	mov ax, year
	mov dx, 0
	mov bx, 1000
	div bx
	mov bx, dx
	mov dl, al
	add dl, 30h
	mov fechaarregla[si], dl
	inc si

	mov ax, bx
	mov dx,0
	mov bx, 100
	div bx
	mov bx, dx
	mov dl, al
	add dl, 30h
	mov fechaarregla[si], dl
	inc si

	mov ax, bx
	mov dx, 0
	mov bx, 10
	div bx
	mov bx, dx
	mov dl, al
	add dl, 30h
	mov fechaarregla[si], dl

	xor si, si;

	;hora alv

	mov ah, 2ch
	int 21h

	mov segundos, dh
	mov ah, 0
	mov al, ch
	mov dx, 0
	mov bx, 10
	div bx
	mov bx, dx
	mov dl, al
	add dl, 30h
	mov horaarreglo[si],dl
	inc si
	
	mov dl, bl
	add dl, 30h
	mov horaarreglo[si], dl
	inc si
	mov horaarreglo[si],3ah
	inc si
	;falta los minutos


ENDM

teclado MACRO
	mov ah, 01h
	int 21h	
ENDM	


salir MACRO
	mov ah,04ch
	int 21h
ENDM	


limpiarPantalla MACRO
	mov ah,00h
	mov al,03h
	int 10h
ENDM


;#############################################################################
.model small
.stack 64
.data
  
  msj db 0ah,0dh, 'Hola Mundo','$'


mensaje1	db "###########################################",10,13
			db "### Universidad de san carlos            ##",10,13
			db "### Facultad de ingeniera                ##",10,13
			db "### Andrea Nicte Vicente Campos          ##",10,13
			db "### 201404104							 ##",10,13  
			db "###########################################",10,13,"$"

mensajereporte	db	"Reporte proyecto",10,13,"$"
mensajefecha	db	"Fecha: ","$"
mensajehora		db	"Hora:	","$"
mensajerepfuncion	db	"Funcion:",10,13,"$"
mensajerepdervidada	db	"Derivada:",10,13,"$"
mensajerepintegral	db	"Integral:",10,13,"$"


;###################### menus ##########################################
menu1	db "######## Menu principal! ##########",10,13
		db "### 1. Derivar funcion           ##",10,13
		db "### 2. Integrar funcion          ##",10,13
		db "### 3. Ingresar funcion          ##",10,13
		db "### 4. Imprimir                  ##",10,13
		db "### 5. Graficar                  ##",10,13
		db "### 6. Resolver ecuaciones       ##",10,13
		db "### 7. Reportes                  ##",10,13
		db "### 8. Salir                     ##",10,13
		db "###################################",10,13,"$"

menu2	db "############ Graficas! #############",10,13
		db "###1. Graficar funcion en memoria ##",10,13
		db "###2. Graficar derivada           ##",10,13
		db "###3. Graficar integral           ##",10,13
		db "###4. Regresar                    ##",10,13
		db "####################################",10,13,"$"

;###################### mensajes de error ##############################
mensajeerrordigito	db "El numero debe estar entre 0-9",10,13,"$"
mensajeerrordigitoomenos	db "Se esperaba un numero, o un (-)",10,13,"$"
errorfuncion		db "No hay ninguna funcion cargada",10,13,"$"


;########### coeficientes para ingresar la funcion #####################
;voy a usar tamaño word, por que a la hora de realizar operaciones pueden quedar numeros muy grandes

x4 dw 0
x3 dw 0
x2 dw 0
x1 dw 0
x0 dw 0

;########################## imprimiir mensajes de los coeficientes #################

insertarx4 db "Ingrese el coeficiente de x4",10,13,"$"
insertarx3 db "Ingrese el coeficiente de x3",10,13,"$"
insertarx2 db "Ingrese el coeficiente de x2",10,13,"$"
insertarx1 db "Ingrese el coeficiente de x1",10,13,"$"
insertarx0 db "Ingrese el coeficiente de x0",10,13,"$"

;############ signos de los coeficientes de la funcion ############################
sigx4 db 0
sigx3 db 0
sigx2 db 0
sigx1 db 0
sigx0 db 0


;########## cadenas para mostrar funcion ################################
stringfuncion	db "F(x)=","$"
stringderivada	db "F",27h,"(x)=","$"

;########### coeficientes de las derivadas ##############################
;usare word por si los tamaños son muy grandes
derivadax3 	dw 0
derivadax2	dw 0
derivadax1	dw 0
derivadax0	dw 0


;############ signo de los coeficientes de la derivada ###################
signoderivadax3 db 0
signoderivadax2 db 0
signoderivadax1 db 0
signoderivadax0 db 0

inicialx dw 0
finalx	 dw 0

;################# integral constante #####################################
constanteintegracion dw 0

;############################ para la Grafica		#####################
bfuncion db 0 				;bandera para saber si ay alguna grafica
funcionarreglo	db 30 dup("$")
derivadaarreglo db 30 dup("$")
integralarreglo	db 50 dup("$")
puntosarreglo	db 50 dup("$")


tamarreglop1 	db 0

posx dw	0 ;puntos para plotear la grafica
posy dw 0

resultadofuncion dw 0; ir evaluando las funciones
bandera dw 0 			;elegir la grafica
handler	dw	?
nomdelreporte	db "rep.arq1",00h
year	dw	0
fechaarregla db 11 dup("$")
horaarreglo	 db 9 dup("$")
segundos db 0
;####################### auxiliares #########################################

saltol	db 10,13,"$"
meligaopcion 	db "#Elegir una opcion:",10,13,"$"
mconstantec		db "#Ingrese el valor de la constante c:",10,13,"$"
tamanofuncion	dw 0
tamanointegral	dw 0
tamanoderivada	dw 0

mensajeerrorreporte db "Error a crear el archivo",10,13,"$"

punto1x dw -1
punto2x dw -1
punto3x dw -1
punto4x dw -1
punto5x dw -1


punto1y dw -1
punto2y dw -1
punto3y dw -1
punto4y dw -1
punto5y dw -1


banderaimpri db 0

;############################### REPORTE #######################################################

MENSAJEREPORTE1 db "Funcion Original:",10,13,"$"
MENSAJEREPORTE2 db "Funcion Derivada:",10,13,"$"
MENSAJEREPORTE3 db "Funcion Integral:",10,13,"$"
MENSAJEREPORTE4 db "Puntos Funcion original:",10,13,"$"
MENSAJEREPORTE5 db "Puntos Funcion derivada:",10,13,"$"
MENSAJEREPORTE6 db "Puntos Funcion integral:",10,13,"$"

mensajerango db "Desea asignar un rango en la grafica? (-99 , 99) max",10,13,"$"
sii db 			"1. Si",10,13,"$"
no db 			"2. No",10,13,"$"
banderarango db 0
mensajexinicial db "Ingresar x inicial:",10,13,"$"
mensajexfinal  	db "Ingresar x final:",10,13,"$"
errorrango		db "Error al ingresar rango",10,13,"$"
mensajepuntos	db "Puntos(y, X):",10,13,"$"

puntosarregloderivada	db 50 dup("$")
puntosarreglointegral	db 50 dup("$")

mensajereportegenerado db "Se ha creado el reporte:",10,13,"$"

;################################ecuacion ######################################################
mensajeecuacion 	db "Ingrese los coeficioentes de la ecuacion:",10,13,"$"
mensajecuacionec1 	db "Ingrese el coeficiente x1:",10,13,"$"
mensajeecuacionec0 	db "Ingrese el coeficiente x0:",10,13,"$"
mensajeecuacionec2 	db "Ingrese el coeficiente x2:",10,13,"$"
mensajeresutaldo	db "Ingrese el resultado de la ecuacion:",10,13,"$"
resultadoecuacion	db "El resultado de la ecuacion es:"

tamanoarregloec	dw 0
tamanoarreglosolec dw 0
ec2		dw 0
ec1		dw 0
ec0		dw 0
ecres 	dw 0

termino1 	dw 0 			;para la cuadratica
termino2	dw 0
termino3 	dw 0
termino4 	dw 0

signoec1 db 0
signoec0 db 0
signoec2 db 0
signoecres	db 0

ecuacionarreglo	db 30 dup("$")

banderagrafica dw 0
resultadogrado1 dw 0

resarreglox1	db 30 dup("$")

menu3	db "Tipo de ecuacion:",10,13
		db "1. Primer grado",10,13
		db "2. Segundo grado",10,13,"$"

mensajesoolucion db "Solucion: ",10,13,"$"

menu4	db "Menu Reporte:",10,13
		db "1. Funcion",10,13
		db "2. Ecuacion ",10,13,"$"

mensajeecuacionXD	db "Ecuacion: ",10,13,"$"


;################################## codigo ######################################################
.code


leeropmenuprincipal:


	limpiarPantalla
	imprimir mensaje1
	imprimir saltol
	imprimir menu1
	imprimir meligaopcion

				;ingrea derivada

	
	xor ax, ax 								; lmpiar el registro ax
	teclado

	mov banderaimpri, 3 	
											;imprimir saltol
	cmp al, 33h								;hago un swhitch para elegir la opciond el menu
		je limpiararreglofuncion

	mov banderaimpri, 1 					;ingrea integral

	cmp al, 31h
		je limpiararreglofuncion

	mov banderaimpri, 2

	cmp al, 32h
		je limpiararreglofuncion


	cmp al, 38h
		je esalir

	cmp al, 35h
		je menugraficas

	cmp al, 37h
		je menureporte

	cmp al, 34h
		je imprimirfuncion

	cmp al, 36h
		je limpiararregloecuacion

	

	limpiarPantalla
	jmp leeropmenuprincipal

		

;################################# ecuacion ##########################################
limpiararregloecuacion:
	xor si, si


limpiararregloecuacion2:
	mov ecuacionarreglo[si],"$"
	inc si
	cmp si, LENGTHOF ecuacionarreglo 
		jb limpiararregloecuacion2
	xor si,si

limpiararregloecuacion3:
	mov resarreglox1[si],"$"
	inc si
	cmp si, LENGTHOF resarreglox1 
		jb limpiararregloecuacion3
	xor si,si

menuecuacion:

	imprimir saltol
	imprimir menu3
	imprimir saltol
	teclado

	cmp al, 31h
		je leereccoef1

	cmp al, 32h
		je grado2
	jmp leeropmenuprincipal

leereccoef1:
	xor di, di
	xor si, si

	imprimir saltol
	imprimir mensajecuacionec1
	
	teclado
	cmp al, 2dh								;si es menos
		je leercoef1negativo

	cmp al, 30h
		jb errordigito

	cmp al, 39h
		ja errordigito

	mov signoec1, 1 						;1 es positivo signo positivo
	mov bh, 0
	mov bl, al

	mov ec1, bx 							;guardar el valor

	mov bx, ax
	imprimir saltol
	cmp bl, 30h
		je leercoef0

	mov ax, bx

	mov ecuacionarreglo[si],al
	inc si
	mov ecuacionarreglo[si],58h
	inc si
	mov ecuacionarreglo[si],31h
	inc si
	

	jmp leercoef0



leercoef1negativo:
	
	jmp leeropmenuprincipal

leercoef0:
	imprimir mensajeecuacionec0


	teclado

	cmp al, 2dh
		je leercoef0negativo

	cmp al, 30h
		jb errordigito

	cmp al, 39h
		ja errordigito



	mov signoec0, 1 						;1 es positivo signo positivo
	mov bh, 0
	mov bl, al

	mov ec0, bx 							;guardar el valor

	mov bx, ax
	imprimir saltol

	mov ax, bx




	mov ecuacionarreglo[si],20h
	inc si

	mov ecuacionarreglo[si],2bh
	inc si
	mov ecuacionarreglo[si],al
	inc si

	mov ecuacionarreglo[si],20h
	inc si

	mov ecuacionarreglo[si],3dh
	inc si

	mov ecuacionarreglo[si],30h
	inc si



	;imprimir ecuacionarreglo

	;teclado

	jmp resolverecuacionx1



leercoef0negativo:

	jmp leeropmenuprincipal

resolverecuacionx1:
	xor dx, dx
	xor ax, ax
	xor bx, bx

	mov ah, 0
	mov dh, 0

	sub ec1, 30h
	sub ec0, 30h
	
	mov ax, ec0 		;div ax/bx
	mov bx, ec1

	div bl

	add al, 30h
	add dl, 30h

	xor di, di

	mov resarreglox1[di], al
	inc di

	mov resarreglox1[di], 2eh
	inc di

	mov resarreglox1[di], dl
	inc di


	mov  tamanoarreglosolec , di
	mov tamanoarregloec, si


	imprimir mensajeecuacionXD
	imprimir saltol
	imprimir ecuacionarreglo

	imprimir saltol
	imprimir mensajesoolucion

	imprimir resarreglox1

	
	teclado

	jmp leeropmenuprincipal
;########################################################################################

grado2:
	xor di, di
	xor si, si

	imprimir saltol
	imprimir mensajeecuacionec2
	
	teclado
	cmp al, 2dh								;si es menos
		je leercoef1negativoo

	cmp al, 30h
		jb errordigito

	cmp al, 39h
		ja errordigito

	mov signoec2, 1 						;1 es positivo signo positivo
	mov bh, 0
	mov bl, al

	mov ec2, bx 							;guardar el valor

	mov bx, ax
	imprimir saltol
	cmp bl, 30h
		je leercoef0o

	mov ax, bx

	mov ecuacionarreglo[si],al
	inc si
	mov ecuacionarreglo[si],58h
	inc si
	mov ecuacionarreglo[si],32h
	inc si
	

	jmp leercoef0o



leercoef1negativoo:
	
	jmp leeropmenuprincipal

leercoef0o:
	imprimir mensajecuacionec1


	teclado

	cmp al, 2dh
		je leercoef0negativoo

	cmp al, 30h
		jb errordigito

	cmp al, 39h
		ja errordigito



	mov signoec1, 1 						;1 es positivo signo positivo
	mov bh, 0
	mov bl, al

	mov ec1, bx 							;guardar el valor

	mov bx, ax
	imprimir saltol

	mov ax, bx




	mov ecuacionarreglo[si],20h
	inc si

	mov ecuacionarreglo[si],2bh
	inc si
	mov ecuacionarreglo[si],al
	inc si

	mov ecuacionarreglo[si],58h
	inc si


	jmp cuadradaconstante



leercoef0negativoo:

	jmp leeropmenuprincipal

cuadradaconstante:


	imprimir mensajeecuacionec0


	teclado

	cmp al, 2dh
		je leercoef0negativoo

	cmp al, 30h
		jb errordigito

	cmp al, 39h
		ja errordigito



	mov signoec0, 1 						;1 es positivo signo positivo
	mov bh, 0
	mov bl, al

	mov ec0, bx 							;guardar el valor

	mov bx, ax
	imprimir saltol

	mov ax, bx


	mov ecuacionarreglo[si],20h
	inc si

	mov ecuacionarreglo[si],2bh
	inc si
	mov ecuacionarreglo[si],al
	inc si

	mov ecuacionarreglo[si],3dh
	inc si

	mov ecuacionarreglo[si],30h
	inc si

	mov tamanoarregloec , si


	imprimir mensajeecuacionXD
	imprimir ecuacionarreglo
	imprimir saltol

	teclado
	jmp resolverecuacionx1o



	jmp leeropmenuprincipal


cuadrdaconstantenegativa:
	jmp leeropmenuprincipal



resolverecuacionx1o:
		xor di, di

   	mov resarreglox1[di], 28h
   	inc di

	mov resarreglox1[di], 2dh
   	inc di

   	xor ax, ax
   	mov ax, ec2

   	mov resarreglox1[di], al
   	inc di

   	mov resarreglox1[di], 0F1h
   	inc di

   	mov resarreglox1[di], 28h
   	inc di

	xor dx, dx 										;limpiar las registros
	xor ax, ax
	xor bx, bx

	mov ah, 0

	sub ec2, 30h
	sub ec0, 30h
	sub ec1, 30h                                     ;pasar a decimal

   	mov ax, ec2                                      ;mul bx ; ax = ax * bx
   	mov bx, ec0               

   	mul bx

   	mov bx,4

   	mul bx 											;ax tiene el termino1

   	mov termino4, ax                                ;aca esta 4ac ahorita voyy a buscar b^2

   	xor dx, dx
   	xor ax, ax
   	xor bx, bx
   	mov ah, 0

   	mov bx,	ec1
   	mov ax, ec1

   	mul bx 											;aca esta b^2
   	mov termino3, ax 								;ax = ax * bx




   	sub ax, termino4
   	mov termino4, ax

   	js esnegativo



   	cmp termino4, 9
   		ja mostrarnumeromayora10


   	add al, 30h
   	mov resarreglox1[di], al
   	inc di
   	mov resarreglox1[di], 29h
   	inc di
   	mov resarreglox1[di], 05Eh
   	inc di
   	mov resarreglox1[di], 0ABH
   	inc di


   	mov resarreglox1[di], 29h
   	inc di

   	mov resarreglox1[di], 2FH
   	inc di



   	;imprimir resarreglox1


	
	;teclado

	jmp ultimaparte


esnegativo:

	mov resarreglox1[di], 2dh
   	inc di
	neg termino4
	
   	cmp termino4, 9
   		ja mostrarnumeromayora10


   	xor ax, ax
   	mov ax, termino4

   	add al, 30h
   	mov resarreglox1[di], al
   	inc di
   	mov resarreglox1[di], 29h
   	inc di

   	mov resarreglox1[di], 05Eh
   	inc di

   	mov resarreglox1[di], 0ABH
   	inc di

   	mov resarreglox1[di], 29h
   	inc di

   	mov resarreglox1[di], 2FH
   	inc di

   	;imprimir resarreglox1


	
	;teclado

	jmp ultimaparte



mostrarnumeromayora10:
	
	xor ax, ax
	xor bx, bx
	xor dx, dx

	mov ax, termino4
	mov bx, 10

	div bx

	add al, 30h
	add dl, 30h

	mov resarreglox1[di], al
   	inc di

   	mov resarreglox1[di], dl
   	inc di

   	mov resarreglox1[di], 29h
   	inc di


   	mov resarreglox1[di], 05Eh
   	inc di

   	mov resarreglox1[di], 0ABH
   	inc di


   	mov resarreglox1[di], 29h
   	inc di

   	mov resarreglox1[di], 02FH
   	inc di



   	;imprimir resarreglox1
   	;teclado


   jmp ultimaparte



ultimaparte:
	xor ax, ax
	xor bx, bx
	xor dx, dx

	mov ax, ec2
	mov bx, 2

	mul bx          		 ;mul bx ; ax = ax * bx
	mov termino1, ax

	cmp ax, 9
		ja mayora102

	add al, 30h

	mov resarreglox1[di], al
   	inc di

   	imprimir mensajesoolucion

   	imprimir resarreglox1
   	teclado


	mov  tamanoarreglosolec , di
	mov tamanoarregloec, si


   	jmp leeropmenuprincipal

mayora102:

	
	xor ax, ax
	xor bx, bx
	xor dx, dx

	mov ax, termino1
	mov bx, 10

	div bx

	add al, 30h
	add dl, 30h

	mov resarreglox1[di], al
   	inc di

   	mov resarreglox1[di], dl
   	inc di


   	imprimir saltol
   	imprimir mensajesoolucion

   	imprimir resarreglox1
   	teclado



	mov  tamanoarreglosolec , di
	mov tamanoarregloec, si


   	jmp leeropmenuprincipal


;################################# ingreso de funciones #################################
limpiararreglofuncion:
	xor si,si

limpiararreglofuncion2:				;limpiar todos los arreglos de la funcion que voy
	mov funcionarreglo[si],"$"		;a usar
	inc si
	cmp si, LENGTHOF funcionarreglo ; comparar
		jb limpiararreglofuncion2	; si no ha llegado al final
	xor si,si

limpiarderivadaarreglo:
	mov derivadaarreglo[si],"$"
	inc si
	cmp si, LENGTHOF derivadaarreglo 
		jb limpiarderivadaarreglo
	xor si,si

limpirintegralarreglo:
	mov integralarreglo[si], "$"
	inc si
	cmp si, LENGTHOF integralarreglo
		jb limpirintegralarreglo
	xor si, si

limpiararreglopuntos:
	mov puntosarreglo[si], "$"
	inc si
	cmp si, LENGTHOF puntosarreglo
		jb limpiararreglopuntos
	xor si, si

limpiararreglopunto2s:
	mov puntosarregloderivada[si], "$"
	inc si
	cmp si, LENGTHOF puntosarregloderivada
		jb limpiararreglopunto2s
	xor si, si


limpiararreglopunto3s:
	mov puntosarreglointegral[si], "$"
	inc si
	cmp si, LENGTHOF puntosarreglointegral
		jb limpiararreglopunto3s
	xor si, si


;###################### Leer funcion #################################
;#######################Leer coefci4 #################################

leerfuncion:				;leer el coeficiente de mayor a menor
	xor di, di 				;para la derivada
	xor si, si

	mov bfuncion,0 			;poner bandera de vacio
	imprimir saltol
	imprimir insertarx4
	teclado

	cmp al, 2dh				;comparar si se va ingresar uno negativo
		je leerc4negativo	
	cmp al, 30h						;de lo contrario
		jb errordigitomenos

	cmp al, 39h 
		ja errordigitomenos

	mov sigx4,1
	mov bh, 0 			;limpiar la parte alta
	mov bl, al          ;mover a la parte baja al
	mov x4, bx			;guardar el valor word

	mov bx, ax          ;guardar el valor
	;imprimir saltol
	cmp bl, 30h
		je leerc3		; si 0 no guardar en el arreglo


	mov ax, bx			;ELSE

	mov funcionarreglo[si], al
	inc si
	mov funcionarreglo[si], 58h		;letra  x se va armando la funcion
	inc si
	mov funcionarreglo[si], 34h		;num 4
	inc si
	mov funcionarreglo[si], 20h 
	inc si

	
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 2fh
	inc di
	mov integralarreglo[di], 35h
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 35h
	inc di
	mov integralarreglo[di], 20h
	inc di 							;deberia de leer el coeficiente 3
	jmp  leerc3


	

	

leerc4negativo:
	mov sigx4, 0 		;signo negativo
	
	teclado
	cmp al, 30h
		jb errordigito

	cmp al, 39h			; num mayor a 9
		ja errordigito

	mov bh, 0
	mov bl, al
	mov x4, bx

	mov bx, ax
	;imprimir saltol

	cmp bl, 30h			;
		je leerc3		; si es 0 no se va mostrar

	mov ax, bx			;ELSE
	mov funcionarreglo[si], 2dh		;guardo el -
	inc si
	mov funcionarreglo[si], al
	inc si
	mov funcionarreglo[si], 58h		;letra  x se va armando la funcion
	inc si
	mov funcionarreglo[si], 34h		;num 4
	inc si
	mov funcionarreglo[si], 20h 
	inc si

	;de una arreglo de la integral
	mov integralarreglo[di],2dh
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 2fh
	inc di
	mov integralarreglo[di], 35h
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 35h
	inc di
	mov integralarreglo[di], 20h
	inc di 							;deberia de saltar a la sig etiqueta


;#####################leer coeficiente 3 ##########################################

leerc3:
 	imprimir saltol
 	imprimir insertarx3
 	teclado

 	cmp al, 2dh	
 		je leerc3negativo					;1 positivo ya se me habia olvidado
 											;0 negativo
 	cmp al, 30h
 		jb	errordigitomenos				;si es menor

 	cmp al, 39h
 		ja errordigitomenos					;si es mayor


 	mov sigx3, 1
 	mov bh,0
 	mov bl, al
 	mov x3, bx								;guardar valor

 	mov bx, ax 								;regresar valor
 	cmp bl,30h
 		je leerc2

 	mov ax, bx								;ELSE


 	mov funcionarreglo[si], 2bh
 	inc si
 	mov funcionarreglo[si], 20h
 	inc si

	mov funcionarreglo[si], al
	inc si
	mov funcionarreglo[si], 58h		;letra  x se va armando la funcion
	inc si
	mov funcionarreglo[si], 33h		;num 3
	inc si
	mov funcionarreglo[si], 20h 
	inc si

	
	mov integralarreglo[di], 2bh
	inc di
	mov integralarreglo[di], 20h
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 2fh
	inc di
	mov integralarreglo[di], 34h
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 34h
	inc di
	mov integralarreglo[di], 20h
	inc di 							;deberia de leer el coeficiente 3
	jmp  leerc2


	



 leerc3negativo:

 	mov sigx3,0
 	teclado

  	cmp al, 30h
 		jb	errordigitomenos				;si es menor

 	cmp al, 39h
 		ja errordigitomenos					;si es mayor

	mov bh,0
	mov bl,al
	mov x3,bx

	mov bx, ax
	;imprimir saltol
	cmp bl,30h
		je leerc2

	mov ax, bx


 	mov funcionarreglo[si], 2dh
 	inc si
 	mov funcionarreglo[si], 20h
 	inc si

	mov funcionarreglo[si], al
	inc si
	mov funcionarreglo[si], 58h		;letra  x se va armando la funcion
	inc si
	mov funcionarreglo[si], 33h		;num 3
	inc si
	mov funcionarreglo[si], 20h 
	inc si

	
	mov integralarreglo[di], 2dh
	inc di
	mov integralarreglo[di], 20h
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 2fh
	inc di
	mov integralarreglo[di], 34h
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 34h
	inc di
	mov integralarreglo[di], 20h
	inc di 							;deberia de leer el coeficiente 3
	;jmp leerc2




;#######################leer coeficiente 2 #############################

leerc2:

	imprimir saltol
 	imprimir insertarx2
 	teclado

 	cmp al, 2dh	
 		je leerc2negativo					;1 positivo ya se me habia olvidado
 											;0 negativo
 	cmp al, 30h
 		jb	errordigitomenos				;si es menor

 	cmp al, 39h
 		ja errordigitomenos					;si es mayor


 	mov sigx2, 1
 	mov bh,0
 	mov bl, al
 	mov x2, bx								;guardar valor

 	mov bx, ax 								;regresar valor
 	cmp bl,30h
 		je leerc1

 	mov ax, bx								;ELSE


 	mov funcionarreglo[si], 2bh
 	inc si
 	mov funcionarreglo[si], 20h
 	inc si

	mov funcionarreglo[si], al
	inc si
	mov funcionarreglo[si], 58h		;letra  x se va armando la funcion
	inc si
	mov funcionarreglo[si], 32h		;num 3
	inc si
	mov funcionarreglo[si], 20h 
	inc si

	
	mov integralarreglo[di], 2bh
	inc di
	mov integralarreglo[di], 20h
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 2fh
	inc di
	mov integralarreglo[di], 33h
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 33h
	inc di
	mov integralarreglo[di], 20h
	inc di 							;deberia de leer el coeficiente 3
	jmp  leerc1


	



leerc2negativo:
 	mov sigx2,0
 	teclado

  	cmp al, 30h
 		jb	errordigitomenos				;si es menor

 	cmp al, 39h
 		ja errordigitomenos					;si es mayor

	mov bh,0
	mov bl,al
	mov x2,bx

	mov bx, ax
	;imprimir saltol
	cmp bl,30h
		je leerc1

	mov ax, bx


 	mov funcionarreglo[si], 2dh
 	inc si
 	mov funcionarreglo[si], 20h
 	inc si

	mov funcionarreglo[si], al
	inc si
	mov funcionarreglo[si], 58h		;letra  x se va armando la funcion
	inc si
	mov funcionarreglo[si], 32h		;num 3
	inc si
	mov funcionarreglo[si], 20h 
	inc si

	
	mov integralarreglo[di], 2dh
	inc di
	mov integralarreglo[di], 20h
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 2fh
	inc di
	mov integralarreglo[di], 33h
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 33h
	inc di
	mov integralarreglo[di], 20h
	inc di 							;deberia de leer el coeficiente 3
	;jmp leerc2


	
;############################## coeficiente 1 ######################################

leerc1:
	imprimir saltol
 	imprimir insertarx1
 	teclado

 	cmp al, 2dh	
 		je leerc1negativo					;1 positivo ya se me habia olvidado
 											;0 negativo
 	cmp al, 30h
 		jb	errordigitomenos				;si es menor

 	cmp al, 39h
 		ja errordigitomenos					;si es mayor


 	mov sigx1, 1
 	mov bh,0
 	mov bl, al
 	mov x1, bx								;guardar valor

 	mov bx, ax 								;regresar valor
 	cmp bl,30h
 		je leerc0

 	mov ax, bx								;ELSE


 	mov funcionarreglo[si], 2bh
 	inc si
 	mov funcionarreglo[si], 20h
 	inc si

	mov funcionarreglo[si], al
	inc si
	mov funcionarreglo[si], 58h		;letra  x se va armando la funcion
	inc si
	mov funcionarreglo[si], 31h		;num 3
	inc si
	mov funcionarreglo[si], 20h 
	inc si

	
	mov integralarreglo[di], 2bh
	inc di
	mov integralarreglo[di], 20h
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 2fh
	inc di
	mov integralarreglo[di], 32h
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 32h
	inc di
	mov integralarreglo[di], 20h
	inc di 							;deberia de leer el coeficiente 3
	jmp  leerc0

leerc1negativo:
	mov sigx1,0
 	teclado

  	cmp al, 30h
 		jb	errordigitomenos				;si es menor

 	cmp al, 39h
 		ja errordigitomenos					;si es mayor

	mov bh,0
	mov bl,al
	mov x1,bx

	mov bx, ax
	;imprimir saltol
	cmp bl,30h
		je leerc0

	mov ax, bx


 	mov funcionarreglo[si], 2dh
 	inc si
 	mov funcionarreglo[si], 20h
 	inc si

	mov funcionarreglo[si], al
	inc si
	mov funcionarreglo[si], 58h		;letra  x se va armando la funcion
	inc si
	mov funcionarreglo[si], 31h		;num 3
	inc si
	mov funcionarreglo[si], 20h 
	inc si

	
	mov integralarreglo[di], 2dh
	inc di
	mov integralarreglo[di], 20h
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 2fh
	inc di
	mov integralarreglo[di], 32h
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 32h
	inc di
	mov integralarreglo[di], 20h
	inc di 							;deberia de leer el coeficiente 3
	;jmp leerc2

;############################## coeficiente 0 ######################################

leerc0:

	imprimir saltol
 	imprimir insertarx0
 	teclado

 	cmp al, 2dh	
 		je leerc0negativo					;1 positivo ya se me habia olvidado
 											;0 negativo
 	cmp al, 30h
 		jb	errordigitomenos				;si es menor

 	cmp al, 39h
 		ja errordigitomenos					;si es mayor


 	mov sigx0, 1
 	mov bh,0
 	mov bl, al
 	mov x0, bx								;guardar valor

 	mov bfuncion, 1 						;funcion en memoria
 	mov bx, ax 								;regresar valor
 	imprimir saltol
 	cmp bl,30h
 		je cderivada 

 	mov ax, bx								;ELSE


 	mov funcionarreglo[si], 2bh
 	inc si
 	mov funcionarreglo[si], 20h
 	inc si

	mov funcionarreglo[si], al
	inc si


	
	mov integralarreglo[di], 2bh
	inc di
	mov integralarreglo[di], 20h
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 20h
	inc di 		
						

	mov integralarreglo[di],2bh			;add constante al arreglo
	inc di
	mov integralarreglo[di],20h
	inc di
	mov integralarreglo[di],43h
	inc di

	jmp  cderivada


leerc0negativo:
	mov sigx0,0
 	teclado

  	cmp al, 30h
 		jb	errordigitomenos				;si es menor

 	cmp al, 39h
 		ja errordigitomenos					;si es mayor

 	mov bfuncion, 1
	mov bh,0
	mov bl,al
	mov x0,bx

	mov bx, ax
	;imprimir saltol
	cmp bl,30h
		je cderivada

	mov ax, bx


 	mov funcionarreglo[si], 2dh
 	inc si
 	mov funcionarreglo[si], 20h
 	inc si

	mov funcionarreglo[si], al
	inc si

	
	mov integralarreglo[di], 2dh
	inc di
	mov integralarreglo[di], 20h
	inc di
	mov integralarreglo[di], al   	;num leido en el teclado
	inc di
	mov integralarreglo[di], 58h
	inc di
	mov integralarreglo[di], 20h
	inc di

	mov integralarreglo[di],2bh		;agregar constante
	inc di
	mov integralarreglo[di],20h
	inc di
	mov integralarreglo[di],43h
	inc di





;############################# derivada ################################################
;########################### limpiar registros #########################################
cderivada:

	mov tamanointegral, di 			;guardar los tamañaos de los arreglos
	mov tamanofuncion,  si

	
	sub x4,30h						;pasar de hexa a decimal
	sub x3,30h
	sub x2,30h
	sub x1,30h
	sub x0,30h

	xor di, di 						;limpiar registro
									;x4 + x3+x2+x1+num = (x4 * 4)c4-1

;############################ derivada x4 ############################################
x4derivada:
									;(x4 * 4)*3 coeficiente por * 4 elevado a la 3
	mov signoderivadax3, 1 			;1 es positivo
	cmp sigx4, 1
		je calcularx4derivada

	mov signoderivadax3, 0			;else
	mov derivadaarreglo[di],2dh
	inc di


calcularx4derivada:
	xor ax, ax
	xor bx, bx						;limpiar registro
	xor dx, dx


	mov al, 4 						;coeficiente 4
	mov bx, x4
	mul bx							;ax = ax*bx

	mov  derivadax3, ax
	cmp ax, 9 						; es mayor a 9
		ja calcularx4derivadamayor
	add al, 30h

	mov derivadaarreglo[di], al
	inc di
	mov derivadaarreglo[di], 58h
	inc di
	mov derivadaarreglo[di], 33h
	inc di
	mov derivadaarreglo[di], 20h
	inc di


	jmp x3derivada


calcularx4derivadamayor:			;max resultado es de dos digitos, ob el hexa del dec
	
	mov dx, 0 						;signo de division
	mov bx, 10 						;divisor
	div bx							;ax = ax/bx  	ax 0 coeficiente dx = reciduo

	add al, 30h
	add dl, 30h

	mov derivadaarreglo[di], al
	inc di
	mov derivadaarreglo[di], dl
	inc di
	mov derivadaarreglo[di], 58h
	inc di
	mov derivadaarreglo[di], 33h
	inc di
	mov derivadaarreglo[di], 20h
	inc di






;########################### derivada de x3 #########################################
x3derivada:

	mov signoderivadax2, 1 			;1 es positivo
	mov derivadaarreglo[di],2bh		;mas
	
	cmp sigx3, 1
		je calcularx3derivada 		;si es positivo

	mov signoderivadax2, 0			;else
	mov derivadaarreglo[di],2dh		;menos
	

calcularx3derivada:
	inc di

	xor ax, ax
	xor bx, bx						;limpiar registro
	xor dx, dx


	mov al, 3 						;coeficiente 3
	mov bx, x3
	mul bx							;ax = ax*bx

	mov  derivadax2, ax
	cmp ax, 9 						; es mayor a 9
		ja calcularx3derivadamayor
	add al, 30h

	mov derivadaarreglo[di], 20h
	inc di
	mov derivadaarreglo[di], al
	inc di
	mov derivadaarreglo[di], 58h
	inc di
	mov derivadaarreglo[di], 32h
	inc di
	mov derivadaarreglo[di], 20h
	inc di

	jmp x2derivada

calcularx3derivadamayor:
		
	mov dx, 0 						;signo de division
	mov bx, 10 						;divisor
	div bx							;ax = ax/bx  	ax 0 coeficiente dx = reciduo

	add al, 30h
	add dl, 30h

	mov derivadaarreglo[di], 20h
	inc di
	mov derivadaarreglo[di], al
	inc di
	mov derivadaarreglo[di], dl
	inc di
	mov derivadaarreglo[di], 58h
	inc di
	mov derivadaarreglo[di], 32h
	inc di
	mov derivadaarreglo[di], 20h
	inc di





;########################### derivada de x2 ###########################################
x2derivada:

	mov signoderivadax1, 1 			;1 es positivo

	mov derivadaarreglo[di],2bh		;mas
	cmp sigx2, 1
		je calcularx2derivada 		;si es positivo

	mov signoderivadax1, 0			;else
	mov derivadaarreglo[di],2dh		;menos
	

calcularx2derivada:
	inc di
	xor ax, ax
	xor bx, bx						;limpiar registro
	xor dx, dx


	mov al, 2 						;coeficiente 3
	mov bx, x2
	mul bx							;ax = ax*bx

	mov  derivadax1, ax
	cmp ax, 9 						; es mayor a 9
		ja calcularx2derivadamayor
	add al, 30h

	mov derivadaarreglo[di], 20h
	inc di
	mov derivadaarreglo[di], al
	inc di
	mov derivadaarreglo[di], 58h
	inc di
	mov derivadaarreglo[di], 31h
	inc di
	mov derivadaarreglo[di], 20h
	inc di

	jmp x1derivada



calcularx2derivadamayor:
		
	mov dx, 0 						;signo de division
	mov bx, 10 						;divisor
	div bx							;ax = ax/bx  	ax 0 coeficiente dx = reciduo

	add al, 30h
	add dl, 30h

	mov derivadaarreglo[di], 20h
	inc di
	mov derivadaarreglo[di], al
	inc di
	mov derivadaarreglo[di], dl
	inc di
	mov derivadaarreglo[di], 58h
	inc di
	mov derivadaarreglo[di], 31h
	inc di
	mov derivadaarreglo[di], 20h
	inc di




;#################################derivada x1 #########################################
x1derivada:
	mov signoderivadax0, 1 			;1 es positivo
	mov derivadaarreglo[di],2bh		;menos
	cmp sigx1, 1
		je calcularx1derivada 		;si es positivo

	mov signoderivadax0, 0			;else
	mov derivadaarreglo[di],2dh		;menos


calcularx1derivada:
	inc di
	xor ax, ax
	xor bx, bx						;limpiar registro
	xor dx, dx


	mov al, 1 						;coeficiente 3
	mov bx, x1
	mul bx							;ax = ax*bx

	mov  derivadax0, ax

	add al, 30h

	mov derivadaarreglo[di], 20h
	inc di
	mov derivadaarreglo[di], al
	inc di


	


;#####################complento a 2 del coef negativo   ############################
complementoc4:
	mov tamanoderivada, di
	xor ax, ax
	cmp sigx4, 1
		je complementoc3
	mov ax, x4
	neg ax
	mov x4, ax

	mov ax, derivadax3
	neg ax
	mov derivadax3, ax 	



complementoc3:
	
	xor ax, ax
	cmp sigx3, 1
		je complementoc2
	mov ax, x3
	neg ax
	mov x3, ax

	mov ax, derivadax2
	neg ax
	mov derivadax2, ax 	




complementoc2:

	xor ax, ax
	cmp sigx2, 1
		je complementoc1
	mov ax, x2
	neg ax
	mov x2, ax

	mov ax, derivadax1
	neg ax
	mov derivadax1, ax 	

complementoc1:
	xor ax, ax
	cmp sigx1 ,1
		je complementoc0
	mov ax, x1
	neg ax
	mov x1, ax

	mov ax, derivadax0
	neg ax
	mov derivadax0, ax 	


complementoc0:
	xor ax, ax
	cmp sigx0, 1
		je mostrarfuncion
	mov ax, x0
	neg ax
	mov x0, ax

	jmp mostrarfuncion

mostrarfuncion:								; mostrar la funicines 


	cmp banderaimpri, 1
		je imprimirfyd

	cmp banderaimpri, 2
		je imprimirfyi

	jmp leeropmenuprincipal

imprimirfyd:								;mostrar la derivada
	
	imprimir saltol	
	imprimir MENSAJEREPORTE1
	imprimir funcionarreglo
	imprimir saltol


	imprimir MENSAJEREPORTE2
	imprimir derivadaarreglo
	imprimir saltol
	teclado
	jmp leeropmenuprincipal

imprimirfyi: 								;mostrar funcion

	imprimir saltol
	imprimir MENSAJEREPORTE1
	imprimir funcionarreglo
	imprimir saltol

	imprimir MENSAJEREPORTE3
	imprimir integralarreglo
	imprimir saltol
	teclado

	jmp leeropmenuprincipal

;############################ GRAFICA ################################################
;############################ Menu grafica ###########################################


menugraficas:
	imprimir saltol
	cmp bfuncion, 0
		je merrorfuncion

	imprimir menu2
	imprimir meligaopcion
	imprimir saltol
	teclado
	cmp al, 33h
		je grafointegral
	cmp al, 32h
		je grafoderivada

	cmp al, 31h
		je grafonormal

	cmp al, 34h
		jmp leeropmenuprincipal


	jmp menugraficas

;################################# elegir grafica ##########################
grafonormal:	

	mov bandera, 1
	jmp elegirmodorango



grafoderivada:

	mov bandera, 2
	jmp elegirmodorango

grafointegral:

	mov bandera, 3
	jmp elegirmodorango


elegirmodorango:
	imprimir saltol
	imprimir mensajerango
	imprimir saltol
	imprimir sii
	imprimir saltol
	imprimir no
	
	teclado
	
	cmp al, 31h 													;si si
		je elegirmodorango2

	cmp al, 32h
		je  elegirmodorango3
	

	jmp menugraficas

elegirmodorango2:



	mov banderarango, 1

	cmp bandera, 3
		je ingresarconstanteC


	jmp ingresoIntervalo

elegirmodorango3:

	mov banderarango, 0

	cmp bandera, 3
		je ingresarconstanteC

	jmp asignarrango

;######################################################################################
ingresoIntervalo: 												;Aquí voy a pedir que se ingrese el intervalo para graficar
	;mov banderaimpri , 1 										;rango ingresasada
	imprimir saltol
	imprimir mensajexinicial
 	
 	teclado
	
	cmp al,2dh 													;2dh = sigo Menos
		je xInicialNegativo

	
	cmp al,30h 
		jb errorIntervalo
	cmp al,39h 													;39h = número 9
		ja errorIntervalo

	sub al,30h 													;Le resto 30h para guardar el valor real en la variable
	mov ah,0
	mov inicialx,ax 
	

	
	teclado

	cmp al,0dh 													;0dh = retorno de carro /r
		je leerXFinal 											;Si presiona enter me voy a solicitar xFinal

	
	cmp al,30h 													;30h = número 0
		jb errorIntervalo
	cmp al,39h 													;39h = número 9
		ja errorIntervalo

	sub al,30h 													;Le resto 30h para tener el valor real
	xor cx,cx
	mov cl,al 													;Guardo el valor del segundo dígito

	xor ax,ax
	
	mov ax,inicialx
	mov bx,10
	mul bx 														;Ax = Ax * 10
	add ax,cx

	
	mov inicialx,ax  
	imprimir saltol
	jmp leerXFinal

xInicialNegativo:

	teclado
	
	cmp al,30h 
		jb errorIntervalo
	cmp al,39h 
		ja errorIntervalo

	mov ah,0
	sub al,30h 


	neg ax


	mov inicialx,ax ;Guardo el valor


	teclado

	cmp al,0dh 
		je leerXFinal 
	cmp al,30h 
		jb errorIntervalo
	cmp al,39h 
		ja errorIntervalo



	sub al,30h 

	xor cx,cx
	mov cl,al 

	xor ax,ax
	

	mov ax,inicialx
	neg ax



	mov bx,10
	mul bx 

	add ax,cx

														
	neg ax

	mov inicialx,ax
	imprimir saltol

leerXFinal:
	imprimir mensajexfinal

	teclado
	
	cmp al,2dh 
	je xFinalNegativo

	
	cmp al,30h 
	jb errorIntervalo
	cmp al,39h 
	ja errorIntervalo

	sub al,30h 
	mov ah,0
	
	mov finalx,ax

	teclado

	cmp al,0dh 
		je evaluarIntervalo 

	
	cmp al,30h 
		jb errorIntervalo
	cmp al,39h 
		ja errorIntervalo

	sub al,30h 

	
	xor cx,cx
	mov cl,al 												;Guardo el valor del segundo dígito

	xor ax,ax

	mov ax,finalx
	mov bx,10
	mul bx 													; Ax->Ax * 10
	add ax,cx

	
	mov finalx,ax
	imprimir saltol
	jmp evaluarIntervalo

xFinalNegativo:

	teclado
	
	
	cmp al,30h 
		jb errorIntervalo
	cmp al,39h 
		ja errorIntervalo

	mov ah,0
	sub al,30h 
	neg ax

	mov finalx,ax

	teclado

	
	cmp al,0dh 
		je evaluarIntervalo 

	cmp al,30h 
		jb errorIntervalo
	cmp al,39h 
		ja errorIntervalo

	sub al,30h 
	xor cx,cx
	mov cl,al 

	xor ax,ax
	
	mov ax,finalx
	neg ax
	
	mov bx,10
	mul bx 
	add ax,cx

	neg ax 
	
	mov finalx,ax

	imprimir saltol


evaluarIntervalo: 
	
	xor ax,ax
	
	mov ax,inicialx

	add ax,0
	
	js evaluarIntervaloXFinal 

	xor ax,ax
	mov ax,finalx
	add ax,0
	
	js errorIntervalo

		
	xor ax,ax 											;final x y finialx son positivos
	mov ax,inicialx

	cmp ax,finalx
		ja errorIntervalo 								;inicialx > finalx
	
	jmp crearplanocartesiano 							;Si xInicial <= finalx

evaluarIntervaloXFinal: 								;xinicial es negativo

	xor ax,ax
	mov ax,finalx

	add ax,0

	js xInicialYxFinalNegativos 						;final x es negativo

	jmp crearplanocartesiano

xInicialYxFinalNegativos: 								;los dos numeros son negativos
	xor ax,ax
	xor bx,bx
	mov ax,inicialx

	mov bx,finalx
	
	neg ax 												;obetner numerosposivos
	
	neg bx
	

	cmp ax,bx
	
	jb errorIntervalo 							;finalx < incialx
	jmp crearplanocartesiano




;############################ constante de la integral ###############################
ingresarconstanteC:
	imprimir saltol
	;xor ax, ax 						 ;limpiar ax si no quitar

	cmp bfuncion, 0
		je merrorfuncion
	imprimir mconstantec
	imprimir saltol
	teclado

	cmp al, 2dh
		je constnegativa

	cmp al, 30h
		jb errordigito
	cmp al, 39h
		ja errordigito

	mov ah, 0
	sub al, 30h

	mov constanteintegracion, ax

	teclado

	cmp al , 0dh
		je decidirrango

	cmp al, 30h
		jb errordigito

	cmp al, 39h
		ja errordigito

	mov ah, 0
	sub al, 30h							;se pasa al numero 

	xor bx, bx
	mov bx, ax

	mov ax,10

	xor cx,cx
	mov cx, constanteintegracion

	mul cx
	add ax, bx
	mov constanteintegracion ,ax 		;numero total
	imprimir saltol

	jmp decidirrango





constnegativa:
	teclado

	cmp al, 30h
		jb errordigito

	cmp al, 39h
		ja errordigito

	mov ah, 0
	sub al, 30h
	neg ax 								;complento a 2
	mov constanteintegracion, ax


	teclado
	cmp al, 0dh
		je decidirrango
	cmp al, 30h
		jb errordigito
	cmp al, 39h
		ja errordigito


	mov ah, 0
	sub al, 30h
	xor bx, bx
	mov bx, ax

	mov ax, 10
	xor cx, cx

	mov cx, constanteintegracion
	neg cx 							;RECUPER el positivo
	mul cx
	add ax, bx
	neg ax

	mov constanteintegracion, ax
	imprimir saltol



	jmp decidirrango
	

decidirrango:
	cmp banderarango, 1
		je ingresoIntervalo
	jmp asignarrango
	

asignarrango:
	mov ah, 0
	mov al, 39h
	sub al, 30h
	neg ax

	mov inicialx, ax

	mov ah, 0
	mov al, 39h
	sub al, 30h

	xor cx, cx
	mov cl, al        ;guradar el segundo digito

	xor ax, ax
	mov ax, inicialx
	neg ax

	mov bx, 10
	mul bx				;ax  ->  ax*10


	add ax, cx
	neg ax

	mov inicialx, ax


asignarrangof:

	mov ah, 0
	mov al, 39h
	sub al, 30h

	mov finalx, ax

	mov ah, 0
	mov al, 39h
	sub al, 30h

	xor cx, cx
	mov cl, al

	xor ax, ax
	mov ax, finalx
	mov bx, 10
	mul bx ; ax-> ax*10
	add ax, cx
	mov finalx, ax


;############################### grafica ######################################

crearplanocartesiano:


	mov ah, 00h				;ah = 0 en modo video
	mov al, 13h
	int 10h

	xor si, si

	cmp bandera, 1					;mostrar la funcion
		je mfuncion1
	cmp bandera, 2
		je mfuncion2
	cmp bandera, 3
		je mfuncion3

mfuncion1:
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol


	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	;imprimir MENSAJEREPORTE1
	imprimir saltol
	imprimir funcionarreglo

	jmp crearejex

mfuncion2:
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol


	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	;imprimir MENSAJEREPORTE1
	imprimir saltol
	imprimir derivadaarreglo

	jmp crearejex


mfuncion3:

	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol


	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol
	imprimir saltol

	imprimir saltol
	imprimir saltol
	;imprimir MENSAJEREPORTE1
	imprimir saltol
	imprimir integralarreglo

	jmp crearejex

crearejex:
	cmp si, 320
		je crearejey
	pintarpixel si, 99, 8
	inc si
	jmp crearejex


crearejey:
	xor si,si

crearejeyy:
	cmp si,200
		je elegirgrafo
	pintarpixel 159, si, 8
	inc si
	jmp crearejeyy

elegirgrafo:
	cmp bandera , 1
		je graficafuncion

	cmp bandera, 2
		je graficaderivada

	cmp bandera, 3 
		je  graficarintegral



;#################### grafica funcion normal ##########################################

graficafuncion:
	mov resultadofuncion, 0

	xor ax, ax
	mov ax, inicialx				;NEGATIVO
	mov posx, ax 					;POS AX VA TENER LA POS INICIAL DE AX OSEA -99

	xor ax, ax
	xor si, si
	mov ax, finalx
	mov si, ax
	inc si;


	xor di, di

limpiararreglopuntos2:
	mov puntosarreglo[di], "$"
	inc di
	cmp di, LENGTHOF puntosarreglo
		jb limpiararreglopuntos2
	xor di, di


evaluarposx:

	
	cmp posx, si
		je fingrafica
	jmp evaluarposxfuncionor



evaluarposxfuncionor:
	;evaluar x4
	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx

	mul bx 							; posx*posx  mul ax=bx*ax

	mul bx 							;pos x*2 * posx = x*3
	mul bx							;pos x*3 *x = x*4

	xor bx, bx
	mov bx, x4
	mul bx							; coeficiente 4 x lo que esta en ax
	mov resultadofuncion, ax

evaluar3:
	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx

	mul bx

	mul bx							;ax*3

	xor bx, bx
	mov bx, x3
	mul bx
	add ax, resultadofuncion
	mov resultadofuncion, ax


evaluar2:
	
	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx

	mul bx

	xor bx, bx
	mov bx, x2
	mul bx

	add ax, resultadofuncion
	mov resultadofuncion, ax


evaluar1:

	xor ax, ax
	xor bx, bx

	mov ax, posx

	xor bx, bx
	mov bx, x1

	mul bx
	add ax, resultadofuncion
	mov resultadofuncion, ax

evaluar0:
	xor ax, ax
	mov ax, x0
	add ax, resultadofuncion

	mov resultadofuncion, ax
	add ax, 0
	js resultadonegativo					;si es negativo
	jmp resuladopositvo



resuladopositvo:


	inc posx								;aumento el x hasta que sea 99
	mov bx, resultadofuncion
	cmp bx, 99
		ja evaluarposx
	xor ax, ax
	mov ax, 99								;fun(y): x*3+x*2
	sub ax, bx								;posy en ax

	mov posy, ax
	mov cx, posx
	dec cx
	add cx, 159
	
	pintarpixel cx, posy, 2 				;de aca sacar los archivos de reportes



	xor ax, ax
	xor bx, bx
	mov ax, resultadofuncion
	
	cmp ax, 9
		jb tengoho

	;cmp ax, 99
		;jb tengoh4

	jmp evaluarposx
   

tengoho:
	add ax, 30h
	mov puntosarreglo[di], 28h
	inc di
	mov puntosarreglo[di], al
	inc di
	mov puntosarreglo[di], 20h
	inc di	
	

	xor ax, ax
	xor bx, bx
	mov ax, posx
	cmp ax, 9
		jb tengoh2
	;cmp ax, 99
		;jb tengoh3

	jmp evaluarposx

	
tengoh2:

	add ax, 30h
	mov puntosarreglo[di], al
	inc di
	mov puntosarreglo[di], 29h
	inc di


	jmp evaluarposx

tengoh3:
	xor dx, dx

	mov bx, 10 						;;Ax / Bx; Ax = cociente; Dx = residuo
	
	div bx

	add ax, 30h
	add dx, 30h


	mov puntosarreglo[di], al
	inc di
	mov puntosarreglo[di], dl
	inc di
	mov puntosarreglo[di], 29h
	inc di	

	

	jmp evaluarposx

tengoh4:
	
	xor dx ,dx
	xor bx, bx

	mov bx, 10 						;;Ax / Bx; Ax = cociente; Dx = residuo
	
	idiv bx

	add ax, 30h
	add dx, 30h

	

	mov puntosarreglo[di], 28h
	inc di
	mov puntosarreglo[di], al
	inc di
	mov puntosarreglo[di], dl
	inc di
	mov puntosarreglo[di], 20h
	inc di	
	


	xor ax, ax
	xor bx, bx

	mov ax, posx

	cmp ax, 9
		jb tengoh2
	cmp ax, 99
		jb tengoh3


	jmp evaluarposx


;#################################################################################
resultadonegativo:
	
	inc posx								;pos x de -99 a 99
	mov bx, resultadofuncion
	neg bx
	cmp bx, 100    							;100 de limite
		ja evaluarposx

	xor ax, ax
	mov ax, 99
	add ax, bx
	mov posy, ax

	mov cx, posx
	dec cx
	add cx, 159 						
	pintarpixel cx, posy, 2

	xor ax, ax
	xor bx, bx


	jmp evaluarposx



fingrafica:
	

	;imprimir saltol
	;imprimir puntosarreglo
	
	mov ah, 00h
	mov al, 30h
	int 10h
	int 10h



	jmp cderivada2

;############################## puntos de x ########################################	

;#############################grafica derivada #######################################
graficaderivada:
	mov resultadofuncion, 0
	xor ax, ax 							;los mismos metodos

	mov ax, inicialx
	mov posx, ax

	xor ax, ax
	xor si, si
	mov ax, finalx
	mov si, ax
	inc si  							;PARA COMPRAR EL FINAL

	xor di, di

limpiararreglopunto2ss:
	mov puntosarregloderivada[di], "$"
	inc di
	cmp di, LENGTHOF puntosarregloderivada
		jb limpiararreglopunto2ss
	xor di, di


evaluarposderivada:
	
	cmp posx, si
		je fingrafica

	jmp valuarx3derivada

valuarx3derivada:
	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx
	mul bx
	mul bx

	xor bx, bx
	mov bx, derivadax3
	mul bx

	mov resultadofuncion, ax


valuarx2derivada:
	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx

	mul bx

	xor bx, bx
	mov bx, derivadax2
	mul bx

	add ax, resultadofuncion
	mov resultadofuncion, ax

valuarx1derivada:

	xor ax, ax
	xor bx, bx

	mov ax, posx
	xor bx, bx
	mov bx, derivadax1
	mul bx
	
	add ax, resultadofuncion
	mov resultadofuncion, ax


valuarx0derivada:

	xor ax, ax
	xor bx, bx

	mov ax, derivadax0
	add ax, resultadofuncion
	mov resultadofuncion, ax

	js negativoderivada
	jmp positivoderivada



positivoderivada:
	
	inc posx
	mov bx, resultadofuncion
	cmp bx, 99
		ja evaluarposderivada

	xor ax, ax
	mov ax, 99				;en decimal

	sub ax, bx

	mov posy, ax
	mov cx, posx
	dec cx
	add cx, 159
	pintarpixel cx, posy, 2

	xor ax, ax
	xor bx, bx
	mov ax, resultadofuncion
	
	cmp ax, 9
		jb tengoho1


	jmp evaluarposderivada
   

tengoho1:
	add ax, 30h
	mov puntosarregloderivada[di], 28h
	inc di
	mov puntosarregloderivada[di], al
	inc di
	mov puntosarregloderivada[di], 20h
	inc di	
	

	xor ax, ax
	xor bx, bx
	mov ax, posx
	cmp ax, 9
		jb tengoh22


	jmp evaluarposderivada

	
tengoh22:

	add ax, 30h
	mov puntosarregloderivada[di], al
	inc di
	mov puntosarregloderivada[di], 29h
	inc di


	jmp evaluarposderivada
   

negativoderivada:
	
	inc posx
	mov bx, resultadofuncion
	neg bx    					;obtener el psitivo
	cmp bx, 100
		ja evaluarposderivada

	xor ax, ax
	mov ax, 99
	add ax, bx

	mov posy, ax
	mov cx, posx

	dec cx
	add cx, 159
	pintarpixel cx, posy, 2
	jmp evaluarposderivada
	


;############################graficar integral ######################################
graficarintegral:

	mov resultadofuncion, 0

	xor ax, ax
	mov ax, inicialx
	mov posx, ax

	xor ax,ax
	xor si, si

	mov ax, finalx
	mov si, ax
	inc si
	xor di, di

limpiararreglopunto3ss:
	mov puntosarreglointegral[di], "$"
	inc di
	cmp di, LENGTHOF puntosarreglointegral
		jb limpiararreglopunto3ss
	xor di, di


evaluarposintegral:

	cmp posx, si
		je fingrafica
	jmp evaluarx5integral

evaluarx5integral:

	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx

	mul bx				;x*2
	mul bx				;x*3
	mul bx				;x*4
	mul bx				;x*5

	xor bx, bx
	mov bx, x4
	imul bx

	mov bx, 5
	idiv bx
	mov resultadofuncion, ax

evaluarx4integral:

	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx

	mul bx				;x*2
	mul bx				;x*3
	mul bx				;x*4


	xor bx, bx
	mov bx, x3
	imul bx

	mov bx, 4
	idiv bx
	add ax, resultadofuncion
	mov resultadofuncion, ax

evaluarx3interal:

	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx

	mul bx				;x*2
	mul bx				;x*3



	xor bx, bx
	mov bx, x2
	imul bx

	mov bx, 3
	idiv bx
	add ax, resultadofuncion
	mov resultadofuncion, ax

evaluarx2interal:

	xor ax, ax
	xor bx, bx

	mov ax, posx
	mov bx, posx

	mul bx				;x*2




	xor bx, bx
	mov bx, x1
	imul bx

	mov bx, 2
	idiv bx
	add ax, resultadofuncion
	mov resultadofuncion, ax

evaluarx1interal:

	xor ax, ax
	xor bx, bx

	mov ax, posx

	xor bx, bx 
	mov bx, x0
	imul bx

	add ax, resultadofuncion
	mov resultadofuncion, ax


evaluarconstate:
	xor ax, ax
	


	mov ax, constanteintegracion
	add ax,  resultadofuncion
	mov resultadofuncion, ax

	add ax,0
	js integralresnegativo
	jmp integralrespositivo


	
	

integralrespositivo:
	inc posx
	mov bx, resultadofuncion
	cmp bx ,99
		ja evaluarposintegral

	xor ax, ax
	mov ax, 99
	sub ax, bx
	mov posy,ax
	mov cx, posx
	dec cx
	add cx,159
	pintarpixel cx, posy,2

	xor ax, ax
	xor bx, bx
	mov ax, resultadofuncion
	
	cmp ax, 9
		jb tengoho11


	jmp evaluarposintegral
   

tengoho11:
	add ax, 30h
	mov puntosarreglointegral[di], 28h
	inc di
	mov puntosarreglointegral[di], al
	inc di
	mov puntosarreglointegral[di], 20h
	inc di	
	

	xor ax, ax
	xor bx, bx
	mov ax, posx
	cmp ax, 9
		jb tengoh222


	jmp evaluarposintegral

	
tengoh222:

	add ax, 30h
	mov puntosarreglointegral[di], al
	inc di
	mov puntosarreglointegral[di], 29h
	inc di


	jmp evaluarposintegral
	
   



integralresnegativo:
	inc posx
	mov bx, resultadofuncion
	neg bx 											;encontrar el numero positivo
	cmp bx ,100
		ja evaluarposintegral

	xor ax, ax
	mov ax, 99
	add ax, bx
	mov posy,ax
	mov cx, posx
	dec cx
	add cx,159
	pintarpixel cx, posy,2
	jmp evaluarposintegral



;############################ reportes ##############################################

menureporte:
	imprimir saltol
	imprimir menu4
	imprimir saltol

	teclado

	cmp al, 31h
		je reporte
	cmp al, 32h
		je reporteecuacion

	jmp leeropmenuprincipal

reporte:
	;imprimirFechaYHora ;Obtengo la fecha y la hora

	;Creo el archivo
	mov cx,00h ;Fichero normal
	lea dx,nomdelreporte
	mov ah,3ch ;Código para la interrumpción
	int 21h
	jc errorreporte ;Si existió un error al crear el archivo del reporte
	
	;Abro el archivo
	mov ah,3dh
	mov al,01h ;Acceso solo escritura
	lea dx,nomdelreporte
	int 21h
	;AX = Handle o manejador de fichero
	mov handler,ax
	jc errorreporte ;Si existió un error al abrir el archivo

	;Escribo en el archivo
	mov bx,handler
	mov ah,40h ;Código de la interrumpción


	;Imprimo el encabezado
	imprimirReporte mensaje1,223
	imprimirReporte saltol, 1
	imprimirReporte mensajeFecha,LENGTHOF mensajeFecha - 1
	imprimirReporte fechaarregla,LENGTHOF fechaarregla - 1
	imprimirReporte saltol,1
	imprimirReporte mensajeHora,LENGTHOF mensajeHora - 1
	imprimirReporte horaarreglo,LENGTHOF horaarreglo - 1
	imprimirReporte saltol,1
	imprimirReporte saltol,1

	imprimirReporte MENSAJEREPORTE1 ,lengthof  MENSAJEREPORTE1 - 1
	imprimirReporte funcionarreglo,tamanofuncion
	
	imprimirReporte saltol,1

	imprimirReporte MENSAJEREPORTE2 ,lengthof  MENSAJEREPORTE2 - 1
	imprimirReporte derivadaarreglo,tamanoderivada
	
	imprimirReporte saltol,1
	imprimirReporte MENSAJEREPORTE2 ,lengthof  MENSAJEREPORTE3 - 1
	imprimirReporte integralarreglo,tamanointegral
	imprimirReporte saltol,1



	imprimirReporte saltol,1

	imprimirReporte mensajepuntos, 	lengthof mensajepuntos -1

	imprimirReporte saltol,1

	imprimirReporte MENSAJEREPORTE4, lengthof mensajereporte4 -1
	imprimirReporte puntosarreglo, lengthof puntosarreglo -1

	imprimirReporte saltol,1

	imprimirReporte MENSAJEREPORTE5, lengthof mensajereporte5 -1
	imprimirReporte puntosarregloderivada, lengthof puntosarregloderivada -1

	

	imprimirReporte saltol,1

	imprimirReporte MENSAJEREPORTE4, lengthof mensajereporte6 -1
	imprimirReporte puntosarreglointegral, lengthof puntosarreglointegral -1

	
	mov ah,3eh																					;cerrar archivo
	int 21h
	jc errorreporte ;Si existió un error al cerrar el archivo

	;imprimir saltoLinea
	;imprimir mensajeReporteGenerado


	imprimir saltol
	imprimir mensajeReportegenerado

	teclado
	jmp leeropmenuprincipal


reporteecuacion:

	;imprimirFechaYHora ;Obtengo la fecha y la hora

	;Creo el archivo
	mov cx,00h ;Fichero normal
	lea dx,nomdelreporte
	mov ah,3ch ;Código para la interrumpción
	int 21h
	jc errorreporte ;Si existió un error al crear el archivo del reporte
	
	;Abro el archivo
	mov ah,3dh
	mov al,01h ;Acceso solo escritura
	lea dx,nomdelreporte
	int 21h
	;AX = Handle o manejador de fichero
	mov handler,ax
	jc errorreporte ;Si existió un error al abrir el archivo

	;Escribo en el archivo
	mov bx,handler
	mov ah,40h ;Código de la interrumpción


	;Imprimo el encabezado
	imprimirReporte mensaje1,223
	imprimirReporte saltol, 1
	imprimirReporte mensajeFecha,LENGTHOF mensajeFecha - 1
	imprimirReporte fechaarregla,LENGTHOF fechaarregla - 1
	imprimirReporte saltol,1
	imprimirReporte mensajeHora,LENGTHOF mensajeHora - 1
	imprimirReporte horaarreglo,LENGTHOF horaarreglo - 1
	imprimirReporte saltol,1
	imprimirReporte saltol,1

	imprimirReporte mensajeecuacionXD, lengthof mensajeecuacionXD-1
	imprimirReporte saltol, 1

	imprimirReporte ecuacionarreglo, tamanoarregloec
	


	imprimirReporte saltol,1


	imprimirReporte mensajesoolucion ,lengthof  mensajesoolucion - 1
	imprimirReporte resarreglox1, tamanoarreglosolec

	imprimirReporte saltol, 1
	


	
	mov ah,3eh																					;cerrar archivo
	int 21h
	jc errorreporte ;Si existió un error al cerrar el archivo

	;imprimir saltoLinea
	;imprimir mensajeReporteGenerado




	imprimir saltol
	imprimir mensajeReporteGenerado
	teclado
	jmp leeropmenuprincipal


;#####################################################################################
cderivada2:
	;teclado
	;imprimir saltol
	;imprimir derivadaarreglo
	;imprimir saltol
	;imprimir funcionarreglo
	;imprimir saltol
	;imprimir integralarreglo
	;imprimir saltol

	;limpiarPantalla


	xor di , di

	mov di ,banderagrafica 

	inc di

	mov banderagrafica, di


	teclado


	mov bandera , di
	cmp al, 31h
		je movergraficas
	mov bandera, di
	cmp al, 32h
		je movergraficas



	jmp leeropmenuprincipal

movergraficas:
	cmp di, 4
		je limpiargra

	jmp asignarrango


limpiargra:
	
	mov banderagrafica, 0
	mov bandera,1
	jmp asignarrango
	xor di, di





;###############################imprimir #############################################
imprimirfuncion:
	cmp bfuncion, 0
		je merrorfuncion

	imprimir saltol
	imprimir MENSAJEREPORTE1
	imprimir funcionarreglo

	imprimir saltol
	imprimir MENSAJEREPORTE2
	imprimir derivadaarreglo

	imprimir saltol
	imprimir MENSAJEREPORTE3
	imprimir integralarreglo
	imprimir saltol
	;8imprimir puntosarreglo

	teclado
	jmp leeropmenuprincipal


;########################## metodos para regresar al menu principal ##################

errordigitomenos:	;regresar al menu
	imprimir saltol
	imprimir mensajeerrordigitoomenos
	jmp	leeropmenuprincipal


errordigito:
	imprimir saltol
	imprimir mensajeerrordigitoomenos
	jmp leeropmenuprincipal

merrorfuncion:
	imprimir saltol
	imprimir errorfuncion
	teclado
	jmp leeropmenuprincipal


errorreporte:
	imprimir saltol
	imprimir mensajeerrorreporte
	jmp leeropmenuprincipal

errorIntervalo:
	imprimir saltol
	imprimir errorrango
	teclado
	jmp menugraficas


esalir:
	salir



main proc

	;imprimiren

	imprimir saltol
	jmp leeropmenuprincipal


main endp
end main
 