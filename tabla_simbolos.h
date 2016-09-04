int linea_actual = 1 ;

typedef enum {
  marca,				/* Marca de comienzo de bloque*/
  funcion,			/* Si es subprograma */
  variable,			/* Si es variable */
  parametro_formal,	/* Si es parámetro formal */
} tipoEntrada ;


typedef enum {
  desconocido,
  entero,
  real,
  caracter,
  booleano,
  array,
  no_asignado
} dtipo ;

typedef struct {
  tipoEntrada entrada;
  char *nombre;
  dtipo			tipoDato;
  dtipo			tipoLista; /* Añadido Tipo Lista */
  unsigned int	parametros;
  unsigned int	dimensiones;
  int 			TamDimen1 ;  /* Tamaño Dimensión 1 */
  int 			TamDimen2 ;  /* Tamaño Dimensión 2 */
} entradaTS ;

#define MAX_TS 500


unsigned int tope=0 ;	/* Tope de la pila */
unsigned int subProg ;	/* Indicador de comienzo de bloque de un subprog */
entradaTS TS[MAX_TS] ; 	/* Pila de la tabla de símbolos */

char *nombre_funcion;
unsigned int parametro = 0; /* Indicador de si se está realizando una llamada a función */
dtipo tipoTmp; 			/* Variable temporal que establece el tipo*/
dtipo tipoExp1, tipoExp2;			/* Variable temporal que guarda el tipo de la expresión anterior*/
dtipo tipoListaTmp;

typedef struct {
  int atrib ;		/* Atributo del símbolo (si tiene) */
  char *lexema ;	/* Nombre del lexema */
  dtipo tipo ;	/* Tipo del símbolo */
  int dimen1;
  int dimen2;
} atributos ; 

#define YYSTYPE atributos	/* A partir de ahora, cada símbolo tiene */
/* una estructura de tipo atributos */




/* Lista de funciones y procedimientos para manejo de la TS */

char* toString(int n){
  char *tipo = "";

  switch(n){
  case 0: tipo = "entero"; break;
  case 1: tipo = "real"; break;
  case 2: tipo = "caracter"; break;
  case 3: tipo = "booleano"; break;
  case 4: tipo = "lista"; break;
  case 5: tipo = "desconocido"; break;	
  case 6: tipo = "no asignado"; break;	

  }
  return(tipo);
}

void imprimeTSError(){
  int i;
  int letra;
  for (i=0; i<tope; i++) {
    if (TS[i].entrada==marca)
      printf ("\n(%d)<<< MARCA >>>", i);
    //printf("{Marca} ");		
    if (TS[i].entrada==funcion)
      printf ("\n(%d)Funcion: %s, Tipo: %s, Num. Parametros: %d", i,TS[i].nombre,  toString(TS[i].tipoDato), TS[i].parametros);
    //printf("%s ", TS[i].nombre);		
    if (TS[i].entrada == variable)
      printf ("\n(%d)Variable: %s, Tipo: %s ", i,TS[i].nombre, toString(TS[i].tipoDato));
    //printf("%s ", TS[i].nombre);				
    if (TS[i].entrada==parametro_formal)
      printf ("\n(%d)Parametro: %s, Tipo: %s",i, TS[i].nombre, toString(TS[i].tipoDato));
    //printf("%s ", TS[i].nombre);			
  }
  getchar();
  printf("\n*********************************************\n");
}


void imprimeTS(){
  int i;
  int letra;
  for (i=0; i<tope; i++) {
    if (TS[i].entrada==marca)
      printf ("\n<<< MARCA >>>");
    //printf("{Marca} ");		
    if (TS[i].entrada==funcion)
      printf ("\nFuncion: %s, Tipo: %s, Num. Parametros: %d", TS[i].nombre,  toString(TS[i].tipoDato), TS[i].parametros);
    //printf("%s ", TS[i].nombre);		
    if (TS[i].entrada == variable)
      printf ("\nVariable: %s, Tipo: %s, TipoLista: %s ", TS[i].nombre, toString(TS[i].tipoDato), toString(TS[i].tipoLista));
    //printf("%s ", TS[i].nombre);				
    if (TS[i].entrada==parametro_formal)
      printf ("\nParametro: %s, Tipo: %s", TS[i].nombre, toString(TS[i].tipoDato));
    //printf("%s ", TS[i].nombre);			
  }
  getchar();
  printf("\n*********************************************\n");
}

void TS_InsertaIDENT(atributos a){
  int i;
  int repetido = 0;
	
  // Se comprueba si existe alguna entrada para esta variable en su ámbito
  for (i=tope-1; TS[i].entrada != marca; i--)
    if(CadenasIguales(TS[i].nombre, a.lexema)){			
      printf("[Linea %d] Error semantico: InsertaIDENT Identificador duplicado (%s)\n", linea_actual, a.lexema);
      repetido = 1;						
    }
	
  // Se incluye en la TS
  if (!repetido){
    TS[tope].entrada = variable;
    TS[tope].nombre = strdup(a.lexema);
    TS[tope].tipoDato = tipoTmp; 
    if (tipoTmp==lista)
      TS[tope].tipoLista = tipoListaTmp;		
    tope++;
  }
}

void TS_InsertaMARCA(){
  int i, aux = 1;	
  TS[tope].entrada = marca;
  if (subProg){
    for (i=tope-1; TS[i].entrada == parametro_formal; i--){
      TS[aux+tope].entrada = variable;
      TS[aux+tope].nombre = strdup(TS[i].nombre);
      TS[aux+tope].tipoDato = TS[i].tipoDato;			
      aux++;
    }
    tope+=(aux-1);		
  }	
  tope++;	
}

void TS_VaciarENTRADAS(){

  //imprimeTS();
  int i = tope-1;	
  for (i; TS[i].entrada != marca; i--)
    tope--;
  tope--;
}
void TS_InsertaSUBPROG(atributos a){
  TS[tope].entrada = funcion;
  TS[tope].nombre = strdup(a.lexema);
  TS[tope].tipoDato = tipoTmp;
  TS[tope].parametros = 0;
  tope++;
}
void TS_InsertaPARAMF(atributos a){
  int i = tope;	
  TS[tope].entrada = parametro_formal;
  TS[tope].nombre =  strdup(a.lexema);
  TS[tope].tipoDato = tipoTmp;
  while (TS[i].entrada != funcion)
    i--;
  TS[i].parametros++;
  tope++;	
}

int CadenasIguales(char *c1, char *c2){
  if (strcmp(c1,c2) == 0)
    return 1;
  else return 0;
}
dtipo TS_encuentraTipoFuncion(char *v){
  int i = tope-1;
  dtipo tipo_a = desconocido;
  // Se busca en la tabla la entrada correspondiente a la funcion
  for (i; i > 0; i--){
    if(TS[i].entrada!=marca){
      if (CadenasIguales(TS[i].nombre,nombre_funcion))
        tipo_a = TS[i].tipoDato;
    }	
  }

  return tipo_a;
}

dtipo TS_encuentraTipoVariable(char *v){
  int i = tope-1;
  for (i; i > 0; i--){
    if(TS[i].entrada!=marca){
      if (CadenasIguales(TS[i].nombre, v))
        return TS[i].tipoDato;
    }	
  }
  return desconocido;
}

dtipo TS_encuentraTipoLista(char *v){
  int i = tope-1;
  for (i; i > 0; i--){
    if(TS[i].entrada!=marca){
      if (CadenasIguales(TS[i].nombre, v))
        return TS[i].tipoLista;	
    }	
  }
  return no_asignado;
}


void TS_parametroCorrecto(atributos a){
  int i = tope-1;
  int encontrado = -1;
  dtipo tipo_a;
  // Se busca en la tabla la entrada correspondiente a la funcion
  for (i; i > 0; i--){
    if(TS[i].entrada!=marca){
      if (CadenasIguales(TS[i].nombre,nombre_funcion))
        encontrado = i;
    }
  }
	
  i = encontrado;

	
  // Se busca en TS el tipo del parametro introducido	
  tipo_a = TS_encuentraTipoVariable(a.lexema);

	
  if (tipo_a == desconocido)
    tipo_a = a.tipo;	
	
  if (i != -1){
    if (TS[i+parametro+1].tipoDato != tipo_a){
      if (tipo_a == desconocido){
        printf("[Linea %d] parametroCorrecto Error semantico: Param. num. %d (%s) no definido\n", 
               linea_actual,parametro+1, a.lexema);
      }
      else{		
        printf("[Linea %d] parametroCorrecto Error semantico: Tipo del param. num. %d (%s) incorrecto\n", 
               linea_actual,parametro+1, a.lexema);
      }		
    }
  }
	
  parametro++;
}

void TS_parametroFinalCorrecto(atributos a){
  int i = tope-1;
  int encontrado = -1;
  dtipo tipo_a;
  // Se busca en la tabla la entrada correspondiente a la funcion
  for (i; i > 0; i--){
    if(TS[i].entrada!=marca){	
      if (CadenasIguales(TS[i].nombre,nombre_funcion)){
        encontrado = i;	
      }
    }
  }
	
  i = encontrado;
  // Se comprueba si este parámetro no es el último para mostrar un error
  if (encontrado != -1){
    if ((parametro+1 != TS[i].parametros) || (parametro+1 > TS[i].parametros)){
      printf("[Linea %d] parametroFinalCorrecto Error semantico: Num. param. incorrecto. Se esperaban %d param., param: %d\n", 
             linea_actual,TS[i].parametros,parametro+1);
    }
	
    else{
      // Se busca en TS el tipo del parametro introducido	
      tipo_a = TS_encuentraTipoVariable(a.lexema);
      if (tipo_a == desconocido)
        tipo_a = a.tipo;	
		
			
      if (TS[i+parametro+1].tipoDato != tipo_a){
        if (tipo_a == desconocido){
          printf("[Linea %d] parametroFinalCorrecto Error semantico: Param. num. %d (%s) no definido\n", 
                 linea_actual,parametro+1, a.lexema);
        }
        else{			
          printf("[Linea %d] parametroFinalCorrecto Error semantico: Tipo del param. num. %d (%s) incorrecto\n", 
                 linea_actual,parametro+1, a.lexema);
						
        }
      }
    }
  }
  else {
    printf("[Linea %d] parametroFinalCorrecto Error semantico: Función %s desconocida\n",linea_actual, nombre_funcion); 
  }
}

void OP_ASIGNACION_correcto(atributos at_a, atributos at_b){
  dtipo tipoca, tipocb;	
  dtipo a = TS_encuentraTipoVariable(at_a.lexema);
  dtipo b = at_b.tipo;	
  // Si son distintos
  if (a != b){
    printf("[Linea %d] ASIGNACION Error semantico: Asignación de dos tipos distintos: %s y %s\n",linea_actual,
           toString(a), toString(b));	
  }	
  // Si los don son listas
  else if (a == lista && b == lista){
    tipoca = TS_encuentraTipoLista(at_a.lexema);
    tipocb = TS_encuentraTipoLista(at_b.lexema);
    // Si ninguno de los dos son listas genéricos
    if (tipoca != no_asignado && tipocb != no_asignado){
      if (tipoca != tipocb)
        printf("[Linea %d] ASIGNACION Error semantico: Asignación de listas de tipos distintos: lista. de %s y lista. de %s\n",linea_actual,toString(tipoca),toString(tipocb));
    }
			
  }else{
    if(a==no_asignado || a==desconocido){
      printf("[Linea %d] Error semantico: Variable no declarada:\n",linea_actual);	
    }
  }
}



dtipo tipoOP_MASMENOS(dtipo a){
  if (a==entero)
    return entero;	
  // Si son reales	
  else if (a==real)
    return real;
  // En otro caso
  else{
    printf("[Linea %d] MASMENOS Error semantico: Tipos incorrectos para el operador: %s\n"
           ,linea_actual,toString(a));	
    return desconocido;
  }
}

dtipo tipoOP_LONGITUD_ACTUAL(atributos at_a){
  dtipo a = at_a.tipo;
  if (a==lista)
    return lista;
  // En otro caso
  else{
    printf("[Linea %d] LONGITUD Error semantico: Tipos incorrectos para el operador: %s\n"
           ,linea_actual,toString(a));	
    return desconocido;
  }
}


dtipo tipoOP_MULT(atributos at_a, atributos at_b){
  dtipo a = at_a.tipo;
  dtipo b = at_b.tipo;
  dtipo tc_a, tc_b;
  // Si al menos uno es lista
  if ((a == lista && b != lista) || (a !=lista && b == lista)){
    //Si la lista es a
    if (a==lista){
      tc_a = TS_encuentraTipoLista(at_a.lexema);
      if ((tc_a != b)){ //Si tipo de b debe ser entero
        printf("[Linea %d] tipoOP_MULT Error semantico: Tipo del operando 2 incompatible: %s. Esperado: %s\n",			linea_actual, toString(b) , toString(tc_a));	
        return desconocido;
      }
      else{
        return lista;
      }
    }
    else{
      tc_b = TS_encuentraTipoLista(at_b.lexema);
      if (tc_b != a){
        printf("[Linea %d] tipoOP_MULT Error semantico: Tipo del operando 1 incompatible: %s. Esperado: %s\n",			linea_actual, toString(a) , toString(tc_b));	
        return desconocido;
      }
      else{
        return lista;
      }
		
				
    }

	
    // Si ninguno de los dos son no asignados
    if ((tc_a != no_asignado && tc_b != no_asignado) && (tc_a != tc_b)){
      printf("[Linea %d] tipoOP_MULT Error semantico: Listas de distintos tipos: %s, %s\n",
             linea_actual, toString(tc_a) , toString(tc_b));	
      return desconocido;		
    }
    else
      return lista;
  }
  // Si son enteros
  else if (a==entero && b== entero)
    return entero;	
  // Si son reales	
  else if (a==real && b ==real)
    return real;
  // En otro caso
  else{
    printf("[Linea %d] tipoOP_MULT Error semantico: Tipos incorrectos para el operador: %s, %s\n"
           ,linea_actual,toString(a), toString(b));	
    return desconocido;
  }
}

dtipo tipoOP_DIVI(atributos at_a, atributos at_b){
  dtipo a = at_a.tipo;
  dtipo b = at_b.tipo;
  dtipo tc_a, tc_b;
  // Si al menos uno es lista
  if ((a == lista && b != lista)){
    tc_a = TS_encuentraTipoLista(at_a.lexema);
    if (tc_a != b){
      printf("[Linea %d] tipoOP_DIVI Error semantico: Tipo del operando 2 incompatible: %s. Esperado: %s\n",			linea_actual, toString(b) , toString(tc_a));	
      return desconocido;
    }
    else{
      return lista;
    }
		
  }
  // Si son enteros
  else if (a==entero && b== entero)
    return entero;	
  // Si son reales	
  else if (a==real && b ==real)
    return real;
  // En otro caso
  else{
    printf("[Linea %d] tipoOP_DIVI Error semantico: Tipos incorrectos para el operador: %s, %s\n"
           ,linea_actual,toString(a), toString(b));	
    return desconocido;
  }
}

dtipo tipoOP_ARROBA(atributos at_a, atributos at_b){
  dtipo a = at_a.tipo;
  dtipo b = at_b.tipo;
  dtipo tc_a, tc_b;
  // Si al menos uno es lista
  if (a == lista && b == entero){
    tc_a = TS_encuentraTipoLista(at_a.lexema);
    return tc_a;
  }else{
    printf("[Linea %d] tipoOP_ARROBA Error semantico: Tipos incorrectos para el operador: %s, %s\n"
           ,linea_actual,toString(a), toString(b));	
    return desconocido;
  }
}

dtipo tipoOP_CONCA(atributos at_a, atributos at_b){
  dtipo a = at_a.tipo;
  dtipo b = at_b.tipo;
  dtipo tc_a, tc_b;
  // Si al menos uno es lista
  if (a == lista && b == lista){
    tc_a = TS_encuentraTipoLista(at_a.lexema);
    tc_b = TS_encuentraTipoLista(at_b.lexema);
    if(tc_a == tc_b){
      return lista;
    }else{
      printf("[Linea %d] tipoOP_CONCA Error semantico: Tipos base distintos de las listas: %s, %s\n"
             ,linea_actual,toString(tc_a), toString(tc_b));	
      return desconocido;
    }
		
  }else{
    printf("[Linea %d] tipoOP_CONCA Error semantico: Tipos incorrectos para el operador: %s, %s\n"
           ,linea_actual,toString(a), toString(b));	
    return desconocido;
  }
}

dtipo tipoOP_ESPECIAL(atributos at_a, atributos at_b){
  dtipo a = at_a.tipo;
  dtipo b = at_b.tipo;
  dtipo tc_a, tc_b;
  // Si al menos uno es lista
  if (a == lista && b == entero){
    return lista;
  }else{
    printf("[Linea %d] tipoOP_ESPECIAL Error semantico: Tipos incorrectos para el operador: %s, %s\n"
           ,linea_actual,toString(a), toString(b));	
    return desconocido;
  }
}

dtipo tipoOP_TERCI(atributos at_a, atributos at_b, atributos at_c){
  dtipo a = at_a.tipo;
  dtipo b = at_b.tipo;
  dtipo c = at_c.tipo;
  dtipo tc_a, tc_b, tc_c;
  // Si al menos uno es lista
  if (a == lista && c == entero){
    tc_a = TS_encuentraTipoLista(at_a.lexema);
    if(tc_a != b){
      printf("[Linea %d] tipoOP_TERCI Error semantico: Tipo incorrecto del elemento añadido: %s,\n"
             ,linea_actual, toString(b));	
      return desconocido;
    }else{
      return lista;
    }
		
  }else{
    printf("[Linea %d] tipoOP_TERCI Error semantico: Tipos incorrectos para el operador: %s, %s, %s \n"
           ,linea_actual,toString(a), toString(b), toString(c));	
    return desconocido;
  }
}

dtipo tipoOP_REL_IG(dtipo a, dtipo b){
  if ((a == entero && b == entero) ||  (a == real && b == real)
      ||  (a == caracter && b == caracter)){
    return booleano;
  }
  else{
    printf("[Linea %d] tipoOP_REL_IG Error semantico: Tipos incorrectos para el operador (%s,%s)\n"
           ,linea_actual,toString(a), toString(b));
    return desconocido;
	
  }
}

dtipo tipoOP_AND_X_OR(dtipo a, dtipo b){
  if (a == booleano && b == booleano)
    return booleano;
  else{
    printf("[Linea %d] tipoOP_AND_X_OR Error semantico: Tipos incorrectos para el operador: %s,%s. Esperado: booleano, booleano\n"
           ,linea_actual,toString(a), toString(b));	
    return desconocido;
  }
}

dtipo tipoOP_NOT(dtipo a){
  if(a==booleano)
    return booleano;
  else{
    return desconocido;
    printf("[Linea %d] tipoOP_NOT Error semantico: Tipos incorrectos para el operador: %s. Esperado: booleano\n"
           ,linea_actual,toString(a));
  }
}

dtipo tipoOP_MOVE_COMI_LIST(atributos at_a){
  dtipo a = at_a.tipo;
  if(a==lista)
    return lista;
  else{
    return desconocido;
    printf("[Linea %d] tipoOP_MOVE_COMI_LIST Error semantico: Tipos incorrectos para el operador: %s. Esperado: lista\n"
           ,linea_actual,toString(a));
  }	
}

/* Fin de funciones y procedimientos para manejo de la TS */
