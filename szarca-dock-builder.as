/* @anderakooken */

import flash.filesystem.*;
import flash.events.MouseEvent;
import fl.events.ListEvent;
import flash.desktop.NativeApplication;
import flash.events.Event;
import fl.controls.Slider; 
import fl.events.SliderEvent; 
import fl.controls.Label; 
import flash.net.FileReference;
import flash.globalization.DateTimeFormatter;
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.crypto.symmetric.IVMode;
import com.hurlant.crypto.symmetric.IMode;
import com.hurlant.crypto.symmetric.NullPad;
import com.hurlant.crypto.symmetric.PKCS5;
import com.hurlant.crypto.symmetric.IPad;
import com.hurlant.crypto.prng.Random;
import com.hurlant.crypto.hash.HMAC;
import com.hurlant.util.Base64;
import com.hurlant.util.Hex;
import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.hash.IHash;

//RETIRA A ESCALA DO SWF
stage.align = StageAlign.RIGHT;
stage.scaleMode = StageScaleMode.NO_SCALE;
NativeWindowType.LIGHTWEIGHT;

//Variaveis de criptografia do arquivo do projeto ".szd"
var	criptoKeyDock = "#szarcaDock@67b207db5a296e80";
var	criptoKey = "#szarcaDockBuilder@67b207db5a296e80";
var vetorCriptoKey = "";
var projetoCripto = "";

//Variavel para criptografia das credenciais do tunel
var vetorSSHKey = "";
var tunelSSHCripto = "";

var senha_lembrar;
var senhaLembrada;
var pendenciaSalvar = 0;

var currentInput:ByteArray;
var currentResult:ByteArray;

var currentInput_decrypt:ByteArray;
var currentResult_decrypt:ByteArray;

           
OBJ_LN.TXT.text = "";
OBJ_LN.TXT.width = 200;
OBJ_LN.LN.width = 100;

function pegaDataAtual(){
	var d:Date = new Date();
	var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
	dtf.setDateTimePattern("yyyyMMdd");
	return dtf.format(d); 
}

function statusCarregando(cmd){
	CARREGANDO.visible = cmd;
}
statusCarregando(false);

var fileRef:FileReference;

var idSistema = "szarca-dock-builder";
var versao = "1.3";

var statusBtn:Array = new Array();
	statusBtn["excluir"] = "false";
	statusBtn["editar"] = "false";
	statusBtn["adicionar"] = "false";

var xmlProjeto:Array = new Array();
	xmlProjeto["arquivo"] = "";

	menuListaPrincipal("MENU_A", "MENUSLIDE_A");
	menuListaPrincipal("MENU_B", "MENUSLIDE_B");
	
	criarBarraMovimento("MSGBOX_AVISO", false, false);
	criarBarraMovimento("FRM_CONFIGURACOES", false, false);
	criarBarraMovimento("FRM_SENHA_PROJETO", false, false);
	criarBarraMovimento("FRM_PROJETOS", false, true);
	criarBarraMovimento("FRM_OBJETOS", false, true);
	criarBarraMovimento("FRM_SSH_CONEXOES", false, true);
	criarBarraMovimento("FRM_CREDENCIAIS_SSH", false, true);
	criarBarraMovimento("FRM_SSH_CONEXOES_LISTA", "FRM_SSH_CONEXOES", true);
	criarBarraMovimento("FRM_SSH_TUNEIS", false, true);
	criarBarraMovimento("FRM_SSH_TUNEIS_LISTA", false, true);
	criarBarraMovimento("FRM_ARM_CRED_LISTA", false, true);
	criarBarraMovimento("FRM_ARM_CRED", false, true);
	criarBarraMovimento("FRM_OBJETOS_LISTA", "FRM_OBJETOS", true);
	criarBarraMovimento("FRM_CODIGO", false, true);

var janela_ativa = "";
var obj_Janela:Array = new Array();
	obj_Janela["desktop"]			= DESKTOP;
	obj_Janela["previsualizacao"]   = FRM_OBJETOS.FORM.previsualizacao;
	obj_Janela["barra_janela"]		= MENU_SUPERIOR.JANELA_BARRA;
	
	obj_Janela["configuracoes_janela"]	= FRM_CONFIGURACOES;
	obj_Janela["configuracoes"]			= FRM_CONFIGURACOES.FORM;
	
	obj_Janela["projetos_janela"]	= FRM_PROJETOS;
	obj_Janela["projetos"]			= FRM_PROJETOS.FORM;
	
	obj_Janela["objetos_janela"]	= FRM_OBJETOS;
	obj_Janela["objetos"]			= FRM_OBJETOS.FORM;
	
	obj_Janela["objetos_lista_janela"]	= FRM_OBJETOS_LISTA;
	obj_Janela["objetos_lista"]			= FRM_OBJETOS_LISTA.FORM;
	
	obj_Janela["ssh_conexoes_janela"]	= FRM_SSH_CONEXOES;
	obj_Janela["ssh_conexoes"]			= FRM_SSH_CONEXOES.FORM;
	obj_Janela["ssh_conexoes_btn_cred"]	= FRM_SSH_CONEXOES.MKCONN;
	
	obj_Janela["ssh_conexoes_lista_janela"] = FRM_SSH_CONEXOES_LISTA;
	obj_Janela["ssh_conexoes_lista"] = FRM_SSH_CONEXOES_LISTA.FORM;
	
	obj_Janela["ssh_tuneis_janela"] 		= FRM_SSH_TUNEIS;
	obj_Janela["ssh_tuneis"] 		= FRM_SSH_TUNEIS.FORM;
	
	obj_Janela["ssh_tuneis_lista_janela"] 	= FRM_SSH_TUNEIS_LISTA;
	obj_Janela["ssh_tuneis_lista"] 	= FRM_SSH_TUNEIS_LISTA.FORM;
	
	obj_Janela["aviso_janela"]	=	MSGBOX_AVISO;
	obj_Janela["aviso"]	=	MSGBOX_AVISO.FORM;
	
	obj_Janela["codigo_janela"]	=	FRM_CODIGO;
	obj_Janela["codigo"]	=	FRM_CODIGO.FORM;
	
	obj_Janela["ssh_credenciais_janela"]	=	FRM_CREDENCIAIS_SSH;
	obj_Janela["ssh_credenciais"]	=	FRM_CREDENCIAIS_SSH.FORM;
	
	obj_Janela["arm_cred_janela"]	= FRM_ARM_CRED;
	obj_Janela["arm_cred"]	= FRM_ARM_CRED.FORM;
	
	obj_Janela["arm_cred_lista_janela"]	= FRM_ARM_CRED_LISTA;
	obj_Janela["arm_cred_lista"]	= FRM_ARM_CRED_LISTA.FORM;
	
MENUSLIDE_A.visible = false;
MENUSLIDE_B.visible = false;
MENUSLIDE_B.BT_D.visible = false;
obj_Janela["aviso_janela"].visible = false;



obj_Janela["barra_janela"].addEventListener(
	MouseEvent.MOUSE_DOWN, 
		function(){
			stage.nativeWindow.startMove();
		}
	);

obj_Janela["barra_janela"].addEventListener(
	MouseEvent.MOUSE_UP, 
		function(){
			stage.nativeWindow.startMove();
		}
	);
	MENU_SUPERIOR.FECHAR.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				
				if(pendenciaSalvar == 0){
					NativeApplication.nativeApplication.exit();
				} else {
					alertaMsgBox(
						"Identificamos um projeto salvo sem ter sido "+
						"exportado para um arquivo."
					);
					
					pendenciaSalvar = 0;
				}
			}
		);
	MENU_SUPERIOR.MINIMIZAR.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				stage.nativeWindow.minimize();
			}
		);

obj_Janela["aviso"].CONFIRMAR.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				obj_Janela["aviso_janela"].visible = false;
			}
		);

function ajudaOnline(str){
	var openPage:URLRequest=new URLRequest("http://anderakooken.com/?fn=help&id="+idSistema+"&vs="+versao+"&pesq="+str+"");
   		navigateToURL(openPage,"_blank");
}
function sobreOnline(){
	var openPage:URLRequest=new URLRequest("http://anderakooken.com/?fn=sobre&id="+idSistema+"&vs="+versao);
   		navigateToURL(openPage,"_blank");
}
barra_pesquisar.pesq.addEventListener(MouseEvent.CLICK,
		function (e:MouseEvent){
			ajudaOnline(barra_pesquisar.txt.text);
		});

barra_pesquisar.addEventListener(FocusEvent.FOCUS_IN,
		function (e:FocusEvent){
			
			if(barra_pesquisar.txt.text == "Pesquisar dados (Ajuda)"){
				barra_pesquisar.txt.text = "";
			}
		});
barra_pesquisar.addEventListener(FocusEvent.FOCUS_OUT,
		function (e:FocusEvent){
			if(barra_pesquisar.txt.text == ""){
				barra_pesquisar.txt.text = "Pesquisar dados (Ajuda)";
			}
		});

BT_POS_PADRAO.addEventListener(MouseEvent.CLICK,
		function (e:MouseEvent){
			scroll_pos_x.value = -117; 
			scroll_pos_y.value = 119.35; 
			obj_Janela["desktop"].x = -117;
			obj_Janela["desktop"].y =119.35; 
		});

scroll_pos_y.addEventListener(SliderEvent.CHANGE, posYDesktop);
scroll_pos_y.minimum = 0;
scroll_pos_y.maximum = 1300;
scroll_pos_y.snapInterval = 1; 
scroll_pos_y.tickInterval = 1; 
scroll_pos_y.value = 119.35; 
function posYDesktop(event:SliderEvent):void { 
	obj_Janela["desktop"].y = Number(event.value);
}

scroll_pos_x.addEventListener(SliderEvent.CHANGE, posXDesktop);
scroll_pos_x.minimum = -1300;
scroll_pos_x.maximum = 1300;
scroll_pos_x.snapInterval = 1; 
scroll_pos_x.tickInterval = 1; 
scroll_pos_x.value = -117; 
function posXDesktop(event:SliderEvent):void { 
	obj_Janela["desktop"].x = Number(event.value);
}


BT_ZOOM.addEventListener(SliderEvent.CHANGE, zoomDesktop); 
BT_ZOOM.minimum = 0.3;
BT_ZOOM.maximum = 1.8;
BT_ZOOM.snapInterval = 0.1; 
BT_ZOOM.tickInterval = 0.1; 

BT_ZOOM.value = 1;

function zoomDesktop(event:SliderEvent):void { 
	obj_Janela["desktop"].scaleY = Number(event.value);
	obj_Janela["desktop"].scaleX = Number(event.value);
}

function exbPassword(ch_box:Object, obj:Object){
	if(ch_box.selected == true){
		obj.displayAsPassword  = false;
	} else {
		obj.displayAsPassword  = true;
	}
}


function teclaDigitada(event:KeyboardEvent):void 
{ 
	/*if(event.charCode == 121){ //PROJETO CONFIG (CTRL + Y)
		frmAtivar("MENUSLIDE_B.BT_A");
	}
	if(event.charCode == 97){ //ADD OBJ (CTRL + A)
		frmAtivar("MENUSLIDE_B.BT_B");
	}
	if(event.charCode == 100){ //ADD SSH (CTRL + D)
		frmAtivar("MENUSLIDE_B.BT_C");
	}
	if(event.charCode == 119){ //ADD SSH (CTRL + W)
		obj_Janela["codigo"].visible = true;
	}
	if(event.charCode == 112){ //ADD SSH (CTRL + P)
		imprimirDesktop();
	}
	if(event.charCode == 111){ //ADD SSH (CTRL + O)
		sobreOnline();
	}*/
}
stage.addEventListener(KeyboardEvent.KEY_DOWN, teclaDigitada);

obj_Janela["ssh_credenciais"].exb_senha.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				exbPassword(e.target, obj_Janela["ssh_credenciais"].senha);
			}
		);
		
obj_Janela["projetos"].exb_senha_protecao_exec.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				exbPassword(e.target, obj_Janela["projetos"].senha_protecao_exec);
			}
		);
obj_Janela["projetos"].exb_senha_protecao.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				exbPassword(e.target, obj_Janela["projetos"].senha_protecao);
			}
		);
obj_Janela["projetos"].exb_key_seguranca.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				exbPassword(e.target, obj_Janela["projetos"].key_seguranca);
			}
		);
obj_Janela["projetos"].exb_key.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				exbPassword(e.target, obj_Janela["projetos"].key);
			}
		);


/**************/
MENUSLIDE_A.BT_A.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			NativeApplication.nativeApplication.exit();
		}
	);
MENUSLIDE_A.BT_B.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			sobreOnline();
			MENUSLIDE_A.visible = false;
		}
	);
MENUSLIDE_A.BT_C.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			frmAtivar("MENUSLIDE_A.BT_C");
			MENUSLIDE_A.visible = false;
		}
	);


function frmAtivar(cmd){
	
	if(cmd == "MENUSLIDE_A.BT_C"){
		janela_ativa = "FRM_CONFIGURACOES";
		obj_Janela["configuracoes_janela"].visible = true;
		MENUSLIDE_A.visible = false;
	}
	if(cmd == "MENUSLIDE_B.BT_A"){
		obj_Janela["projetos_janela"].visible = true;
	}
	if(cmd == "MENUSLIDE_B.BT_B"){
		obj_Janela["objetos_janela"].visible = true;
		obj_Janela["objetos_lista_janela"].visible = true;
		janela_ativa = "FRM_OBJETOS";
		limpaFrm("objetos");
	}
	if(cmd == "MENUSLIDE_B.BT_C"){
		obj_Janela["ssh_conexoes_janela"].visible = true;
		obj_Janela["ssh_conexoes_lista_janela"].visible = true;
		janela_ativa = "FRM_SSH_CONEXOES";
		limpaFrm("conexoes");
	}
	if(cmd == "MENUSLIDE_B.BT_E"){
		obj_Janela["codigo_janela"].visible = true;
	}
	if(cmd == "MENUSLIDE_B.BT_F"){
		obj_Janela["arm_cred_janela"].visible = true;
		obj_Janela["arm_cred_lista_janela"].visible = true;
	}
}

MENUSLIDE_B.BT_A.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			frmAtivar("MENUSLIDE_B.BT_A");
			MENUSLIDE_B.visible = false;
		}
	);
MENUSLIDE_B.BT_B.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			frmAtivar("MENUSLIDE_B.BT_B");
			MENUSLIDE_B.visible = false;
		}
	);
MENUSLIDE_B.BT_C.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			frmAtivar("MENUSLIDE_B.BT_C");
			MENUSLIDE_B.visible = false;
		}
	);

MENUSLIDE_B.BT_E.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			frmAtivar("MENUSLIDE_B.BT_E");
			MENUSLIDE_B.visible = false;
		}
	);

MENUSLIDE_B.BT_F.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			frmAtivar("MENUSLIDE_B.BT_F");
			MENUSLIDE_B.visible = false;
		}
	);
/***************/
function profundidade(obj){
	var objeto = getChildByName(obj);
	setChildIndex(objeto, numChildren - 1);
}
function criarBarraMovimento(obj, janAtiva, btnControle){
	
	var objeto:Object = getChildByName(obj);
	
	objeto.visible = false;
	//objeto.x = 450;
	//objeto.y = 114;
	
	objeto.BARRA.addEventListener(
		MouseEvent.MOUSE_DOWN, 
			function(e:MouseEvent){
				profundidade(obj);
				drag(obj, "m");
			}
		);
	objeto.BARRA.addEventListener(
		MouseEvent.MOUSE_UP, 
			function(e:MouseEvent){
				profundidade(obj);
				drag(obj, "p");
			}
		);
	
	objeto.FECHAR.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				objeto.visible = false;
				janela_ativa = "";
				
				if(btnControle == true){
					avtBtn("edicao","false");
				}
			}
		);

	objeto.FORM.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				profundidade(obj);
				
				if(janAtiva != ""){
					janela_ativa = janAtiva;
				} else {
					janela_ativa = obj;
				}
				
				if(btnControle == true){
					avtBtn("edicao","true");
				}
			}
			  
		);

}
avtBtn("edicao","false");

function xmlEscreveConnSSH(cmd){
	
	var str:String = "";
	var temp:String = "";
	
	var dispositivos:XML = new XML(xmlProjeto["arquivo"]);
	var qtd = dispositivos.ssh.length();
	
	var point = 0;
	for (var a:Number = 0; a < qtd; a++){
		if(cmd == "INSERIR"){
			if(String(obj_Janela["ssh_conexoes"].id.text) == dispositivos.ssh[a].@id){
				
				point = 1; //ATUALIZAR
			 	str += xmlEscreveTagConnSSH(); 
				break;
			}
		}
	}
	
	if(cmd == "INSERIR"){
		if(point == 0){ //INSERIR
			str += xmlEscreveTagConnSSH(); 
		}
	}
	

	for (var i:Number = 0; i < qtd; i++){
		
		temp = insConnSSH(
					dispositivos.ssh[i].@id, 
					dispositivos.ssh[i].@titulo, 
					dispositivos.ssh[i].@descricao, 
					dispositivos.ssh[i].@vetor, 
					dispositivos.ssh[i].@key, 
					dispositivos.ssh[i]
				);
		
		if(cmd == "INSERIR"){
			if(point == 1){//ATUALIZAR
				if(String(obj_Janela["ssh_conexoes"].id.text) != dispositivos.ssh[i].@id){
					str += temp;
				}
			}
			if(point == 0){ //INSERIR
				str += temp;
			}
		}
		
		if(cmd == "REMOVER"){
			if(String(obj_Janela["ssh_conexoes"].id.text) != dispositivos.ssh[i].@id){
				str += temp; 
			}
		}
		
		if(cmd == false){
			str += temp; 
		}
		
		
	}
	
	return str;
}

function xmlEscreveObj(cmd){
	
	var str:String = "";
	var temp:String = "";
	
	var dispositivos:XML = new XML(xmlProjeto["arquivo"]);
	var qtd = dispositivos.obJ.length();
	
	var point = 0;
	for (var a:Number = 0; a < qtd; a++){
		if(cmd == "INSERIR"){
			if(String(obj_Janela["objetos"].id.text) == dispositivos.obJ[a].@id){
				
				point = 1; //ATUALIZAR
			 	str += xmlEscreveTagObj(); 
				break;
			}
		}
	}
	
	if(cmd == "INSERIR"){
		if(point == 0){ //INSERIR
			str += xmlEscreveTagObj(); 
		}
	}
	

	for (var i:Number = 0; i < qtd; i++){
		
		temp = insObjetos(
					dispositivos.obJ[i].@tp, 
					dispositivos.obJ[i].@titulo, 
					dispositivos.obJ[i].@id,
					dispositivos.obJ[i].@md,
					dispositivos.obJ[i].@ip, 
					dispositivos.obJ[i].@o_x, 
					dispositivos.obJ[i].@o_y,
					dispositivos.obJ[i].@num,
					dispositivos.obJ[i].@nivel,
					dispositivos.obJ[i].@nivel_2,
					dispositivos.obJ[i].@nivel_3,
					dispositivos.obJ[i].@alerta,
					dispositivos.obJ[i].@descricao
				);
				
		if(cmd == "INSERIR"){
			if(point == 1){//ATUALIZAR
				if(String(obj_Janela["objetos"].id.text) != dispositivos.obJ[i].@id){
					str += temp;
				}
			}
			if(point == 0){ //INSERIR
				str += temp;
			}
		}
		
		if(cmd == "REMOVER"){
			if(String(obj_Janela["objetos"].id.text) != dispositivos.obJ[i].@id){
				str += temp; 
			}
		}
		
		if(cmd == false){
			str += temp; 
		}
	}
	
	return str;
}
function insObjetos(
			tp, titulo, id, md, ip, 
			o_x, o_y, num, nivel, nivel_2, 
			nivel_3,alerta,descricao){
	
	var str:String = '';
	
	if(tp != "" && 
	   titulo != "" &&
	   id	!= "" &&
	   md	!= "" &&
	   ip	!= "" &&
	   o_x	!= "" &&
	   o_y	!= ""
	  ){
		str += '<obJ ';
			str += 'md="'+md+'" ';
			str += 'tp="'+tp+'" ';
			str += 'id="'+id+'" ';
			str += 'titulo="'+titulo+'" ';
			str += 'ip="'+ip+'" ';
			str += 'o_x="'+o_x+'" ';
			str += 'o_y="'+o_y+'" ';
			str += 'num="'+num+'" ';
			str += 'nivel="'+nivel+'" ';
			str += 'nivel_2="'+nivel_2+'" ';
			str += 'nivel_3="'+nivel_3+'" ';
			str += 'alerta="'+alerta+'" ';
			str += 'descricao="'+descricao+'" ';
		str += '>';
		
		str += '</obJ>';
	} else {
		 alertaMsgBox("Sem modificações Objetos! Preencha os campos obrigatórios.");
	}
	
		return str;
		
}
function insConnSSH(id, titulo, descricao, vetor, key, conn){
	
	var str:String = '';
	
	if(id != "" && 
	   titulo		!= "" &&
	   descricao	!= "" &&
	   vetor	!= "" &&
	   conn		!= ""
	   
	  ){
			
				str += '<ssh ';
					str += 'id="'+id+'" ';
					str += 'titulo="'+titulo+'" ';
					str += 'descricao="'+descricao+'" ';
					str += 'vetor="'+vetor+'" ';
					str += 'key="'+key+'" ';
				str += '>';
				
				str += conn;
				
				str += '</ssh>';
		
	   } else {
		 alertaMsgBox("Sem modificações SSH! Preencha os campos obrigatórios.");
	}
	
	return str;
		
}
function xmlEscreveTagConnSSH(){
	
	var str:String = '';
						
	var v_titulo 	= String(obj_Janela["ssh_conexoes"].titulo.text);
	var v_id 		= String(obj_Janela["ssh_conexoes"].id.text);
	var v_key 		= String(obj_Janela["ssh_conexoes"].key.text);
	var v_vetor 	= String(obj_Janela["ssh_conexoes"].vetor.text);
	var v_descricao	= String(obj_Janela["ssh_conexoes"].descricao.text);
	var v_conn		= String(obj_Janela["ssh_conexoes"].conn.text);
	
	if(v_titulo != "" && 
	   v_id		!= "" &&
	   v_vetor		!= "" &&
	   v_descricao	!= "" &&
	   v_conn	!= ""
	  ){
	
		str += 
			insConnSSH(
				v_id, 
				v_titulo, 
				v_descricao, 
				v_vetor, 
				v_key,
				v_conn
			);
			
	 } else {
		 alertaMsgBox("Sem modificações na Conexão SSH! Preencha todos os campos obrigatórios.");
	 }
	
	return str;
		
}
function xmlEscreveTagObj(){
	
	var str:String = '';
	
	var v_titulo = String(obj_Janela["objetos"].titulo.text);
	var v_id 	= String(obj_Janela["objetos"].id.text);
	var v_ip 	= String(obj_Janela["objetos"].ip.text);
	var v_o_x 	= String(obj_Janela["objetos"].o_x.text);
	var v_o_y	= String(obj_Janela["objetos"].o_y.text);
	var v_descricao = String(obj_Janela["objetos"].descricao.text);
	
	if(v_titulo != "" && 
	   v_id		!= "" &&
	   v_ip		!= "" &&
	   v_o_x	!= "" &&
	   v_o_y	!= ""
	  ){
	
		var v_num 		= "false";
		var v_nivel 	= "false";
		var v_nivel_2 	= "false";
		var v_nivel_3 	= "false";
		var v_alerta	= "false";
		
		if(obj_Janela["objetos"].num.selected == true){ v_num = "true"; }
		if(obj_Janela["objetos"].nivel.selected == true){ v_nivel = "true"; }
		if(obj_Janela["objetos"].nivel_2.selected == true){ v_nivel_2 = "true"; }
		if(obj_Janela["objetos"].nivel_3.selected == true){ v_nivel_3 = "true"; }
		if(obj_Janela["objetos"].alerta.selected == true){ v_alerta = "true"; }
		
			str += insObjetos(
				String(obj_Janela["objetos"].tp.selectedItem.data), 
				v_titulo, 
				v_id, 
				String(obj_Janela["objetos"].md.selectedItem.data), 
				v_ip, 
				v_o_x, 
				v_o_y, 
				v_num, 
				v_nivel, 
				v_nivel_2,
				v_nivel_3,
				v_alerta,
				v_descricao
				
			);
			
	 } else {
		 alertaMsgBox("Sem modificações nos Objetos! Preencha todos os campos obrigatórios.");
	 }
	
	return str;
		
}
function alertaMsgBox(txt){
	obj_Janela["aviso_janela"].visible = true;
	profundidade("MSGBOX_AVISO");
	obj_Janela["aviso"].texto.text = txt;
}

function xmlEscreveTagCab(cmd, cmdSSH){
	
	var dispositivos:XML = new XML(xmlProjeto["arquivo"]);
	
	var v_audio_alertar 		= "false";
	var v_log 					= "false";
	var v_iniciar_visivel 		= "false";
	var v_executar_objetos		= "false";
	var v_systemTrayIcon 		= "false";
	var v_executar_background 	= "false";
	var v_ssh 					= "false";
	var v_ssh_iniciar_auto 		= "false";
	var v_ssh_status			= "false";
	
	if(obj_Janela["projetos"].audio_alertar.selected == true){ v_audio_alertar = "true"; }
	if(obj_Janela["projetos"].log.selected == true){ v_log = "true"; }
	if(obj_Janela["projetos"].iniciar_visivel.selected == true){ v_iniciar_visivel = "true"; }
	if(obj_Janela["projetos"].executar_objetos.selected == true){ v_executar_objetos = "true"; }
	if(obj_Janela["projetos"].systemTrayIcon.selected == true){ v_systemTrayIcon = "true"; }
	if(obj_Janela["projetos"].executar_background.selected == true){ v_executar_background = "true"; }
	if(obj_Janela["projetos"].ssh.selected == true){ v_ssh = "true"; }
	if(obj_Janela["projetos"].ssh_iniciar_auto.selected == true){ v_ssh_iniciar_auto = "true"; }
	if(obj_Janela["projetos"].ssh_status.selected == true){ v_ssh_status = "true"; }
	
	var str:String = '';
		str += '<dispositivos ';
			str += 'titulo="'+String(obj_Janela["projetos"].titulo.text)+'" ';
			str += 'servidor="'+String(obj_Janela["projetos"].servidor.text)+'" ';
			str += 'tempo_atualizacao="'+String(obj_Janela["projetos"].tempo_atualizacao.text)+'" ';
			str += 'audio_alertar="'+v_audio_alertar+'" ';
			str += 'log="'+v_log+'" ';
			str += 'iniciar_visivel="'+v_iniciar_visivel+'" ';
			str += 'executar_objetos="'+v_executar_objetos+'" ';
			str += 'systemTrayIcon="'+v_systemTrayIcon+'" ';
			str += 'executar_background="'+v_executar_background+'" ';
			str += 'key="'+String(obj_Janela["projetos"].key.text)+'" ';
			str += 'key_seguranca="'+String(obj_Janela["projetos"].key_seguranca.text)+'" ';
			str += 'senha_protecao="'+String(trim(obj_Janela["projetos"].senha_protecao.text))+'" ';
			str += 'senha_protecao_exec="'+String(trim(obj_Janela["projetos"].senha_protecao_exec.text))+'" ';
			str += 'data_limite="'+String(trim(obj_Janela["projetos"].data_limite.text))+'" ';
			str += 'cor_offline="'+dispositivos.@cor_offline+'" ';
			str += 'cor_online="'+dispositivos.@cor_online+'" ';
			str += 'cor_obj_titulo="'+dispositivos.@cor_obj_titulo+'" ';
			str += 'escalaXY="'+String(obj_Janela["projetos"].escalaXY.text)+'" ';
			str += 'ssh="'+v_ssh+'" ';
			str += 'ssh_iniciar_auto="'+v_ssh_iniciar_auto+'" ';
			str += 'ssh_id_conn_auto="'+String(obj_Janela["projetos"].ssh_id_conn_auto.text)+'" ';
			str += 'ssh_status="'+v_ssh_status+'" ';
		str += '>';
		
		str += xmlEscreveObj(cmd);
		str += xmlEscreveConnSSH(cmdSSH);
			
		str += '</dispositivos>';
		
		return str;
		
		
}

function controleFuncoes(fn){
	
	statusCarregando(true);
	
	if(fn == "MOV_OBJETOS"){
		pendenciaSalvar = 1;
		xmlProjeto["arquivo"] = xmlEscreveTagCab("INSERIR", false);
	}
	if(fn == "FRM_CONFIGURACOES"){
		altConfinguracoes();
	}
	if(fn == "FRM_PROJETOS"){
		pendenciaSalvar = 1;
		xmlProjeto["arquivo"] = xmlEscreveTagCab(false, false);
	}
	if(fn == "FRM_OBJETOS"){
		pendenciaSalvar = 1;
		xmlProjeto["arquivo"] = xmlEscreveTagCab("INSERIR", false);
	}
	if(fn == "FRM_SSH_CONEXOES"){
		pendenciaSalvar = 1;
		xmlProjeto["arquivo"] = xmlEscreveTagCab(false, "INSERIR");
	}
	
	LoadProjeto("refresh");
}

BT_SALVAR.addEventListener(
	MouseEvent.CLICK,
		function (e:MouseEvent){
			controleFuncoes(janela_ativa);
		}
	);
BT_ATUALIZAR.addEventListener(
	MouseEvent.CLICK,
		function (e:MouseEvent){
			LoadProjeto("refresh");
		}
	);
BT_ADICIONAR.addEventListener(
	MouseEvent.CLICK,
		function (e:MouseEvent){
			
			if(statusBtn["adicionar"] == "true"){
				if(janela_ativa == "FRM_OBJETOS"){
					limpaFrm("objetos");
				}
				if(janela_ativa == "FRM_SSH_CONEXOES"){
					limpaFrm("conexoes");
				}
			}
		}
	);
	
function avtBtn(cmd, exb){
	if(cmd == "edicao"){
		statusBtn["excluir"] = exb;
		statusBtn["adicionar"] = exb;
		statusBtn["editar"] = exb;
		
		if(exb == "false"){
			BT_EXCLUIR.alpha = 0.3;
			BT_EDITAR.alpha = 0.3;
			BT_ADICIONAR.alpha = 0.3;
		} else {
			BT_EXCLUIR.alpha = 1;
			BT_EDITAR.alpha = 1;
			BT_ADICIONAR.alpha = 1;
		}
	}
}
function btnExcluir(){
	
		if(janela_ativa == "FRM_OBJETOS"){
			xmlProjeto["arquivo"] = xmlEscreveTagCab("REMOVER", false);
			limpaFrm("objetos");
			obj_Janela["objetos_janela"].visible = false;
			LoadProjeto("refresh");
		} 
		if(janela_ativa == "FRM_SSH_CONEXOES"){
			xmlProjeto["arquivo"] = xmlEscreveTagCab(false, "REMOVER");
			limpaFrm("conexoes");
			obj_Janela["ssh_conexoes_janela"].visible = false;
			LoadProjeto("refresh");
		}
		if(janela_ativa != "FRM_OBJETOS" &&
			janela_ativa != "FRM_SSH_CONEXOES"
		){
			alertaMsgBox("Selecione o que deseja excluir.");
		}
		
		avtBtn("edicao","false");
}
BT_EXCLUIR.addEventListener(
	MouseEvent.CLICK,
		function (e:MouseEvent){
			if(statusBtn["excluir"] == "true"){
				btnExcluir();
				
			} else {
				alertaMsgBox("Selecione o que deseja excluir.");
			}
		}
	);

function limpaFrm(cmd){
	
	if(cmd == "tuneis"){
		obj_Janela["ssh_tuneis"].id.text = "";
		obj_Janela["ssh_tuneis"].titulo.text = "";
		obj_Janela["ssh_tuneis"].ip_remoto.text = "192.168.0.1";
		obj_Janela["ssh_tuneis"].ip_local.text = "localhost";
		obj_Janela["ssh_tuneis"].porta_remoto.text = "80";
		obj_Janela["ssh_tuneis"].porta_local.text = "80";
		
	}
	if(cmd == "conexoes"){
		obj_Janela["ssh_conexoes"].titulo.text = "";
		obj_Janela["ssh_conexoes"].id.text = "";
		obj_Janela["ssh_conexoes"].vetor.text = "";
		obj_Janela["ssh_conexoes"].key.text = "";
		obj_Janela["ssh_conexoes"].conn.text = "";
		obj_Janela["ssh_conexoes"].descricao.text  = "";
		
	}
	if(cmd == "objetos"){
		obj_Janela["objetos"].titulo.text = "";
		obj_Janela["objetos"].id.text = "";
		obj_Janela["objetos"].ip.text = "";
		obj_Janela["objetos"].o_x.text = "150";
		obj_Janela["objetos"].o_y.text = "150";
		obj_Janela["objetos"].num.selected  = false;
		obj_Janela["objetos"].nivel.selected = false;
		obj_Janela["objetos"].nivel_2.selected = false;
		obj_Janela["objetos"].nivel_3.selected = false;
		obj_Janela["objetos"].alerta.selected = false;
		obj_Janela["objetos"].descricao.text = "";
	}
}

function drag(obj, cmd){
	
	var objeto:Object = getChildByName(obj);
	if(cmd == "m"){
		objeto.startDrag();
	}
	if(cmd == "p"){
		objeto.stopDrag();
	}
}
	
function menuListaPrincipal(btn, menu_lista){
	
	getChildByName(btn).addEventListener(
		MouseEvent.CLICK,
			function (e:MouseEvent){
				if(getChildByName(menu_lista).visible == false){
					getChildByName(menu_lista).visible = true;
				} else {
					getChildByName(menu_lista).visible = false;
				}
			}
		);
	
	getChildByName(btn).addEventListener(
		MouseEvent.ROLL_OVER,
			function (e:MouseEvent){
				e.target.alpha = 0.5;
			}
		);
	getChildByName(btn).addEventListener(
		MouseEvent.ROLL_OUT,
			function (e:MouseEvent){
				e.target.alpha = 1;
			}
		);
}



function objLv(id_obj, seq, sw){
	obj_Janela["desktop"].getChildByName(id_obj).LEVEL_SERVER.getChildByName("LV_"+seq).visible = sw;
}

function biblioteca(id:String):MovieClip{
	var OBJ:Object = null;
	OBJ = getDefinitionByName(id.toString());
	return (new OBJ()) as MovieClip;
}
function inserirObjetos(
			obj, titulo, id, md, ip, o_x, o_y, 
			num, nivel, nivel_2, nivel_3, alerta, descricao){
	
	//INSERIR DA LIBRARY
	var A:MovieClip = biblioteca(obj);
		A.name = id;
		
		obj_Janela["desktop"].addChild(A);
		var OBJ_INSD = obj_Janela["desktop"].getChildByName(A.name);
		
		OBJ_INSD.tp_obj = obj;
		OBJ_INSD.alerta = alerta;
		OBJ_INSD.nivel = nivel;
		OBJ_INSD.nivel_2 = nivel_2;
		OBJ_INSD.nivel_3 = nivel_3;
		OBJ_INSD.ip = ip;
		OBJ_INSD.num = num;
		OBJ_INSD.md = md;
		OBJ_INSD._titulo = titulo;
		OBJ_INSD.descricao = descricao;
		
		OBJ_INSD.x = o_x;
		OBJ_INSD.y = o_y;
		OBJ_INSD.INFORMACAO.visible = false;
		OBJ_INSD.NUMERICO.visible = false;
		
			objLv(A.name, 1, false); 	
			objLv(A.name, 2, false);	
			objLv(A.name, 3, false);
			objLv(A.name, 4, false);	
			objLv(A.name, 5, false);
		
		OBJ_INSD.TITULO.text = titulo;
		OBJ_INSD.IP = ip;
		OBJ_INSD.id_interno = String(obj);
		
		OBJ_INSD.INFORMACAO.OBJ_ID.text = id;
		OBJ_INSD.INFORMACAO.OBJ_TITULO.text = titulo;
		OBJ_INSD.INFORMACAO.OBJ_CMD.text = md+" - "+ip;
		OBJ_INSD.INFORMACAO.OBJ_POS.text =  o_x+"x , "+o_y+"y"

		OBJ_INSD.addEventListener(
			MouseEvent.RIGHT_CLICK, 
					function (e:MouseEvent):void{  
					
						
						janela_ativa = "FRM_OBJETOS";
						carregaObjPropriedades(
							true, id, titulo, 
							ip, o_x, o_y, md, obj, 
							num, nivel, nivel_2, 
							nivel_3, alerta, descricao);
							
					}
				);
				
		OBJ_INSD.addEventListener(
			MouseEvent.MOUSE_DOWN, 
					function (e:MouseEvent):void{  
						
						janela_ativa = "MOV_OBJETOS";
						OBJ_INSD.startDrag();
					}
				);
		
		OBJ_INSD.addEventListener(
			MouseEvent.MOUSE_UP, 
					function (e:MouseEvent){
						OBJ_INSD.stopDrag();
						
						janela_ativa = "MOV_OBJETOS";
						carregaObjPropriedades(
							false, id, titulo, ip, o_x, o_y, md, 
							obj, num, nivel, nivel_2, nivel_3, 
							alerta, descricao);
						
						var x_atual = o_x;
						var y_atual = o_y;

						if(OBJ_INSD.x != x_atual){
							x_atual = OBJ_INSD.x;
						}
						if(OBJ_INSD.y != y_atual){
							y_atual = OBJ_INSD.y;
						}
						
						atualizaInfoXYPosObj(
							x_atual,
							y_atual
						);
					}
				);
				
		var my_color:ColorTransform = new ColorTransform();
			

		OBJ_INSD.addEventListener(
			MouseEvent.MOUSE_OVER, 
					function (e:MouseEvent){
						
						my_color.color = uint("0xFF3333");
						OBJ_INSD.ICON.transform.colorTransform = my_color;
					}
				);
		
		OBJ_INSD.addEventListener(
			MouseEvent.MOUSE_OUT, 
					function (e:MouseEvent){
						
						my_color.color = uint("0x666666");
						OBJ_INSD.ICON.transform.colorTransform = my_color;
					}
				);
}

function atualizaInfoXYPosObj(pos_x, pos_y){
	obj_Janela["objetos"].o_x.text = pos_x;
	obj_Janela["objetos"].o_y.text = pos_y;
}

BT_IMPRIMIR.addEventListener(
	MouseEvent.CLICK, 
		function (e:MouseEvent){
			imprimirDesktop();
		}
	);
	

function imprimirDesktop() {
	
	var IMPRIMA:PrintJob = new PrintJob();
	if (IMPRIMA.start()) {
		
		IMPRIMA.selectPaperSize(PaperSize.A4);
		var options:PrintJobOptions = new PrintJobOptions();
		options.printAsBitmap = true;

		IMPRIMA.orientation = PrintJobOrientation.LANDSCAPE;
		
		IMPRIMA.addPage(obj_Janela["desktop"], null, options);
		IMPRIMA.send();
	}
}

function carregaConnPropriedades(
			id, titulo, vetor, key, conn, descricao){
	
	obj_Janela["ssh_conexoes_janela"].visible = true;
	
	obj_Janela["ssh_conexoes"].titulo.text = titulo;
	obj_Janela["ssh_conexoes"].id.text = id;
	obj_Janela["ssh_conexoes"].vetor.text = vetor;
	obj_Janela["ssh_conexoes"].key.text = key;
	obj_Janela["ssh_conexoes"].conn.text = conn;
	obj_Janela["ssh_conexoes"].descricao.text  = descricao;
}

function carregaObjPropriedades(
			jan, id, titulo, ip, o_x, o_y, md, 
			tp, num, nivel, nivel_2, nivel_3, 
			alerta, descricao){
	
	obj_Janela["objetos_janela"].visible = jan;
	obj_Janela["objetos"].id.text = id;
	obj_Janela["objetos"].titulo.text = titulo;
	obj_Janela["objetos"].ip.text = ip;
	obj_Janela["objetos"].o_x.text = o_x;
	obj_Janela["objetos"].o_y.text = o_y;
	obj_Janela["objetos"].descricao.text = descricao;
	
	obj_Janela["objetos"].tp.selectedIndex = 
			this.encontrarItemIndex(obj_Janela["objetos"].tp, tp);
	
	obj_Janela["objetos"].md.selectedIndex = 
			this.encontrarItemIndex(obj_Janela["objetos"].md, md);
		
	
	verificaCheckBox(num, obj_Janela["objetos"].num);
	verificaCheckBox(nivel, obj_Janela["objetos"].nivel);
	verificaCheckBox(nivel_2, obj_Janela["objetos"].nivel_2);
	verificaCheckBox(nivel_3, obj_Janela["objetos"].nivel_3);
	verificaCheckBox(alerta, obj_Janela["objetos"].alerta);
	
	atualizaPrev(tp);
	
}

function encontrarItemIndex (obj, dataString:String):int {
    var index:int = 0;
    for (var i = 0; i < obj.length; i++) {
        if (obj.getItemAt(i).data.toString() == dataString) {
            index = i;
            break;
        }
        else {
        }
    }
    return index;
}



function limpaQuadro(obj:Object){
	for (var i:int = obj.numChildren - 1; i >= 0; i--) {
    	obj.removeChild(obj.getChildAt(i));
	}
}

function atualizaPrev(obj){
	
	limpaQuadro(obj_Janela["previsualizacao"]);
	var A:MovieClip = biblioteca(obj);
		A.INFORMACAO.visible = false;
		obj_Janela["previsualizacao"].addChild(A);
}
obj_Janela["objetos"].tp.addEventListener(
			Event.CHANGE,
				function(e:Event){
					atualizaPrev(e.target.selectedItem.data);
				}
			);

function verificaCheckBox(e, obj:Object){

	if(e == "true"){ obj.selected = true; }
	if(e == "false"){ obj.selected = false; }
	
}

var senhaDigitada = 0;
FRM_SENHA_PROJETO.FORM.OK.addEventListener(
	MouseEvent.CLICK,
		function():void{
			if(FRM_SENHA_PROJETO.FORM.id.text != ""){
				senhaDigitada = 1;
				LoadProjeto("load");
			} else {
				alertaMsgBox("Por favor, digite a senha.");
			}
		}
	);


function LoadProjeto(cmd){

	try{
		
	 data_hora();
		 
		 limpaQuadro(obj_Janela["desktop"]);
		 obj_Janela["objetos_lista"].lista.removeAll();
		 obj_Janela["ssh_conexoes_lista"].lista.removeAll();
		 obj_Janela["codigo"].conn.text = "";
		
		obj_Janela["codigo"].conn.text = xmlProjeto["arquivo"];
		var dispositivos:XML = new XML(xmlProjeto["arquivo"]);
			
			var libera_carregamento = 0;
			
			if(cmd == "load"){
				if(dispositivos.@senha_protecao != ""){
					
					if(senhaLembrada != dispositivos.@senha_protecao){
						if(FRM_SENHA_PROJETO.FORM.id.text != dispositivos.@senha_protecao){
							FRM_SENHA_PROJETO.visible = true;
							
							if(senhaDigitada == 1){
								alertaMsgBox("Senha Invalida.");
							}
							
						} else {
							libera_carregamento = 1;
							FRM_SENHA_PROJETO.visible = false;
						}
					} else {
						libera_carregamento = 1;
					}
				} else {
					libera_carregamento = 1;
				}
			} else {
				libera_carregamento = 1;
			}
			
			if(libera_carregamento == 1){
				
				senha_lembrar									= senhaLembrada;
				obj_Janela["projetos"].titulo.text 				= dispositivos.@titulo;
				obj_Janela["projetos"].servidor.text 			= dispositivos.@servidor;
				obj_Janela["projetos"].tempo_atualizacao.text 	= dispositivos.@tempo_atualizacao;
				obj_Janela["projetos"].key.text 				= dispositivos.@key;
				obj_Janela["projetos"].key_seguranca.text 		= dispositivos.@key_seguranca;
				obj_Janela["projetos"].senha_protecao.text		= dispositivos.@senha_protecao;
				obj_Janela["projetos"].senha_protecao_exec.text	= dispositivos.@senha_protecao_exec;
				obj_Janela["projetos"].escalaXY.text			= dispositivos.@escalaXY;
				obj_Janela["projetos"].data_limite.text			= dispositivos.@data_limite;
				
				
				
				verificaCheckBox(dispositivos.@audio_alertar, obj_Janela["projetos"].audio_alertar);
				verificaCheckBox(dispositivos.@iniciar_visivel, obj_Janela["projetos"].iniciar_visivel);
				verificaCheckBox(dispositivos.@log, obj_Janela["projetos"].log);
				verificaCheckBox(dispositivos.@systemTrayIcon, obj_Janela["projetos"].systemTrayIcon);
				verificaCheckBox(dispositivos.@executar_background, obj_Janela["projetos"].executar_background);
				verificaCheckBox(dispositivos.@executar_objetos, obj_Janela["projetos"].executar_objetos);
	
				//USO DE SSH?
				verificaCheckBox(dispositivos.@ssh, obj_Janela["projetos"].ssh);
				verificaCheckBox(dispositivos.@ssh_iniciar_auto, obj_Janela["projetos"].ssh_iniciar_auto);
				verificaCheckBox(dispositivos.@ssh_status, obj_Janela["projetos"].ssh_status);
				obj_Janela["projetos"].ssh_id_conn_auto.text	= dispositivos.@ssh_id_conn_auto;
	
				var qtd = dispositivos.obJ.length();
				
					for (var i:Number = 0; i < qtd; i++){
			
						inserirObjetos(
							dispositivos.obJ[i].@tp, 
							dispositivos.obJ[i].@titulo, 
							dispositivos.obJ[i].@id,
							dispositivos.obJ[i].@md,
							dispositivos.obJ[i].@ip, 
							dispositivos.obJ[i].@o_x, 
							dispositivos.obJ[i].@o_y,
							dispositivos.obJ[i].@num,
							dispositivos.obJ[i].@nivel,
							dispositivos.obJ[i].@nivel_2,
							dispositivos.obJ[i].@nivel_3,
							dispositivos.obJ[i].@alerta,
							dispositivos.obJ[i].@descricao
						);
		
						obj_Janela["objetos_lista"].lista.addItem({
							id:		dispositivos.obJ[i].@id,
							titulo:		dispositivos.obJ[i].@titulo,
							ip:		dispositivos.obJ[i].@ip
							
							}
						);
					}
					
					
					//CONEXÕES CRIPTOGRAFADAS
					var qtdSSHConn = 0;
					qtdSSHConn = dispositivos.ssh.length();
	
					for (var a:Number = 0; a < qtdSSHConn; a++){
	
						obj_Janela["ssh_conexoes_lista"].lista.addItem({
							id:		dispositivos.ssh[a].@id,
							titulo:	dispositivos.ssh[a].@titulo,
							key:	dispositivos.ssh[a].@key,
							vetor:	dispositivos.ssh[a].@vetor,
							descricao:	dispositivos.ssh[a].@descricao,
							conn:	dispositivos.ssh[a]
							}
						);
						
					}
			}
			
			statusCarregando(false);
			
	}catch(e:Error){
		trace(e);
	}
}

obj_Janela["ssh_conexoes_lista"].lista.addEventListener(
	Event.CHANGE,
		function(e:Event){

			janela_ativa = "FRM_SSH_CONEXOES";
			
			carregaConnPropriedades(
				e.target.selectedItem.id, 
				e.target.selectedItem.titulo, 
				e.target.selectedItem.vetor, 
				e.target.selectedItem.key, 
				e.target.selectedItem.conn, 
				e.target.selectedItem.descricao);
		}
	);
		
obj_Janela["objetos_lista"].lista.addEventListener(
	Event.CHANGE,
		function(e:Event){
			
			var sel = obj_Janela["objetos_lista"].lista.selectedItem.id;
			var obj = obj_Janela["desktop"].getChildByName(sel);
			
			janela_ativa = "FRM_OBJETOS";
			
			carregaObjPropriedades(
				true,
				obj.name, 
				obj._titulo, 
				obj.ip, 
				obj.x, 
				obj.y, 
				obj.md, 
				obj.tp_obj, 
				obj.num, 
				obj.nivel,
				obj.nivel_2,
				obj.nivel_3,
				obj.alerta,
				obj.descricao
			);
				
				
				
		}
		
		
			
	);



function data_hora(){
	var valores:Date = new Date();
var ano:String=String(valores.getFullYear());
var mes:String=String(valores.getMonth()+1);
var dia:String=String(valores.getDate());


var hora:String=String(valores.getHours());
var minuto:String=String(valores.getMinutes());
var segundo:String=String(valores.getSeconds());

//Condições para acrescentar '0' (zero)
if(hora.length==1){
hora = "0" + hora;
}

if(minuto.length==1){
minuto = "0" + minuto;
}

if(segundo.length==1){
segundo = "0" + segundo;
}

if(mes.length==1){
mes = "0" + mes;
}

var data_formatada:String=dia + "/" + mes + "/" + ano;

var horario:String= data_formatada+" "+hora + ":" + minuto + ":" + segundo;
//HR.text=horario;
}


BT_IMPORTAR.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			importarArqExt();
		}
	);

BT_EXPORTAR.addEventListener(
	MouseEvent.CLICK, 
		function(e:MouseEvent){
			exportarArqExt();
		}
	);

function exportarArqExt(){
	try{
		
		pendenciaSalvar = 0;
		
		try{
			encrypt(xmlProjeto["arquivo"], criptoKey, false);
		}catch (e:Error){
			trace(e);
		}	
		var projCripto = projetoCripto;

		var Proj:FileReference = new FileReference();
			Proj.save('<?xml version="1.0" encoding="utf-8"?>'+
					  '<szarca><proj app="'+idSistema+'" versao="'+versao+'" '+
					  'id="'+vetorCriptoKey+'" senha_lembrar="'+senha_lembrar+'">'+projCripto+'</proj></szarca>', 
					  	"projeto.szd");
			
	} catch (e:Error){
		trace(e);
	}
}

function importarArqExt(){ 

	
	fileRef = new FileReference(); 
	fileRef.addEventListener(Event.SELECT, onFileSelected); 
	
	fileRef.addEventListener(
		IOErrorEvent.IO_ERROR, 
			function ():void{
			alertaMsgBox("Erro de entrada.");
		}
	); 
	fileRef.addEventListener(
		SecurityErrorEvent.SECURITY_ERROR,
		function ():void{
			alertaMsgBox("Arquivo Inacessivel.");
		}
	);
	
	var textTypeFilter:FileFilter = new FileFilter("Projeto Dock (*.szd)", "*.szd;"); 
		fileRef.browse([textTypeFilter]); 
		
		fileRef.cancel();
} 
function onFileSelected(evt:Event):void{ 

	fileRef.addEventListener(
		Event.COMPLETE, 
			function (e:Event):void{
				
				var arqProj:XML = 
					new XML(fileRef.data);

					if(arqProj.proj[0] != "" && arqProj.proj[0].@id != ""){
						
						senhaLembrada = arqProj.proj[0].@senha_lembrar;
						xmlProjeto["arquivo"] = decrypt(arqProj.proj[0].@id, criptoKey,arqProj.proj[0]);
						LoadProjeto("load");
						
					} else {
						alertaMsgBox(
							"O arquivo selecionado esta "+
							"corrompido ou requer outra versão do software."
						);
					}
				
			}
		); 
	fileRef.load(); 
} 


function iniciaConfInicial(){
	
	bloqueioUso("inicial");
	
	var CONF_str:String = 
			'<?xml version="1.0" encoding="ISO-8859-1" ?>';
		CONF_str += '<configuracoes ';
		CONF_str += 'cliente="szarca-dock-builder" ';
		CONF_str += 'id_sistema="'+Math.random()+'" ';
		CONF_str += 'chave="P@dR4O" ';
		CONF_str += '>';
		CONF_str += '<autenticacao id="77acdaa1c8a4971bcbc18bc48cf46872">';
		CONF_str += 'I9YNJMsyhv7GceRuB5h+893y49ZOZ0ppWTJHB685RklaILz9UCER/oZdWJPbHyEWkx8/F4+5QLPi2GniFiGUu8WmxTcp5QXCCVAVnK3OFsJlkf38Akwwk8Rv7IHCqZ+ys44d8fT9QqFQ72uo5ry6oABbTVopr426msmND04czpdoJZIhtWnas8DgbUlEr/tJGgludy/m6y+N0ZYg23yv9wEfYWsRlhdiPkdgWth5nbkFk53vG2jOM0kcHkSX6uOc';
		CONF_str += '</autenticacao>';
		CONF_str += '</configuracoes>';
		
		var CONF_file:File = 
				File.applicationStorageDirectory.resolvePath("config.xml");
		
		if(!CONF_file.exists){
			var CONF_fileStream:FileStream = new FileStream();
			CONF_fileStream.open(CONF_file, FileMode.WRITE);
			CONF_fileStream.writeUTFBytes(CONF_str);
			CONF_fileStream.close();
			
			sobreOnline();
		}

		var CONF_arquivo:File = File.applicationStorageDirectory.resolvePath("config.xml");
		var CONF_stream_arquivo:FileStream = new FileStream();
		CONF_stream_arquivo.open(CONF_arquivo, FileMode.READ);

		var configuracoes:XML = new XML(CONF_stream_arquivo.readUTFBytes(CONF_stream_arquivo.bytesAvailable));
		
		//descriptografa o licenciamento
		decrypt(
			configuracoes.autenticacao[0].@id, 
			criptoKey,
			configuracoes.autenticacao[0]
		);
		
		var arqProj:XML = 
					new XML(currentInput_decrypt);
		
		if(arqProj.@auth == "internet"){
			permissaoUso(configuracoes.@id_sistema, configuracoes.@chave);
		} else {
			if(arqProj.@auth == "local"){
				if(pegaDataAtual() > arqProj.@data_limite){
					bloqueioUso("full");
				} else{
					liberacaoUso();
				}
			}
		}
		
		LICENCA_LIMITE.text = arqProj.@data_limite;
		LICENCA_USUARIO.text = arqProj.@cli_email;
		LICENCA_AUTH.text = arqProj.@auth;
					
		obj_Janela["configuracoes"].id.text = configuracoes.@id_sistema;
		obj_Janela["configuracoes"].chave.text = configuracoes.@chave;
		obj_Janela["configuracoes"].autho.text = configuracoes.autenticacao[0];
		obj_Janela["configuracoes"].autho_vetor.text = configuracoes.autenticacao[0].@id;
		
		
}
iniciaConfInicial();

function altConfinguracoes(){
	var str:String = 
			'<?xml version="1.0" encoding="ISO-8859-1" ?>';
		str += '<configuracoes ';
		str += 'cliente="szarca-dock-builder" ';
		str += 'id_sistema="'+obj_Janela["configuracoes"].id.text+'" ';
		str += 'chave="'+obj_Janela["configuracoes"].chave.text+'" ';
		str += '>';
		str += '<autenticacao id="'+obj_Janela["configuracoes"].autho_vetor.text+'">';
		str += obj_Janela["configuracoes"].autho.text+'</autenticacao>';
		str += '</configuracoes>';
	
	var arq:File = 
				File.applicationStorageDirectory.resolvePath("config.xml");
	var arqEsc:FileStream = new FileStream();
			arqEsc.open(arq, FileMode.WRITE);
			arqEsc.writeUTFBytes(str);
			arqEsc.close();
}

function permissaoUso(id_sistema, chave){
	liberacaoUso();
}

function liberacaoUso(){
		BT_IMPORTAR.visible = true;
		MENU_B.visible = true;
		BT_EXPORTAR.visible = true;
}
function bloqueioUso(modo){
	
	if(modo == "inicial" || modo == "full"){
		BT_IMPORTAR.visible = false;
		MENU_B.visible = false;
		BT_EXPORTAR.visible = false;
	}
	
	if(modo == "full"){
		obj_Janela["configuracoes_janela"].visible = true;
		obj_Janela["configuracoes_janela"].FECHAR.visible = false;
		obj_Janela["aviso_janela"].FECHAR.visible = false;
		obj_Janela["aviso"].CONFIRMAR.visible = false;
		alertaMsgBox("Aplicativo não licenciado ou sem conexão com a internet. Todo licenciamento é feito online. Por favor, entre em contato com o suporte.");
	}
	/*var tempo:Timer = new Timer(25000);
	tempo.start();
	tempo.addEventListener(TimerEvent.TIMER,
		function(){
			NativeApplication.nativeApplication.exit();
		});*/

}



//CRIPTOGRAFA
       function encrypt(arqXml, cKey, cmdModo):void {
               var k:String = "";
				k = cKey;
				
                var kdata:ByteArray;
               var kformat:String = "text";
                switch (kformat) {
                    case "hex": kdata = Hex.toArray(k); break;
                    case "b64": kdata = Base64.decodeToByteArray(k); break;
                    default:
                        kdata = Hex.toArray(Hex.fromString(k));
                }
                // 3: get an input
                var txt:String = arqXml;
                var data:ByteArray;
                 var format:String = "text";
                switch (format) {
                    case "hex": data = Hex.toArray(txt); break;
                    case "b64": data = Base64.decodeToByteArray(txt); break;
                    default:
                        data = Hex.toArray(Hex.fromString(txt));
                }
                var name:String = "aes-cbc";
                
                var pad:IPad = new PKCS5;
                var mode:ICipher = Crypto.getCipher(name, kdata, pad);
                pad.setBlockSize(mode.getBlockSize());
                mode.encrypt(data);
                currentResult = data;
               
				 displayOutput(cmdModo);
			   
			    // populate IV.
                if (mode is IVMode) {
                    var ivmode:IVMode = mode as IVMode;
					
					if(cmdModo == false){
                    	vetorCriptoKey = Hex.fromArray(ivmode.IV);
					}
					
					if(cmdModo == "ssh_credenciais"){
						vetorSSHKey = Hex.fromArray(ivmode.IV);
					}
                }
            }
      
	  		function genIV(cmdModo):void {
                var name:String = "aes-cbc";
                var mode:ICipher = Crypto.getCipher(name, null);
                var bs:uint = mode.getBlockSize();
                var r:Random = new Random;
                var b:ByteArray = new ByteArray;
                r.nextBytes(b, bs);
				
				if(cmdModo == false){
               		 vetorCriptoKey = Hex.fromArray(b);
				}
				
				if(cmdModo == "ssh_credenciais"){
					vetorSSHKey = Hex.fromArray(b);
				}
                
            }
			
            function displayOutput(cmdModo) {
                if (currentResult==null) return;
                var txt:String;
                var format:String = "b64";
                switch (format) {
                    case "hex": txt = Hex.fromArray(currentResult); break;
                    case "b64": txt = Base64.encodeByteArray(currentResult); break;
                    default:
                        txt = Hex.toString(Hex.fromArray(currentResult)); break;
                }
				
				if(cmdModo == false){
					projetoCripto = txt;
				}
				
				if(cmdModo == "ssh_credenciais"){
					tunelSSHCripto = txt;
				}
            }

	function decrypt(vetorEtd, keyEtd, txtEtd) {
         
				if(keyEtd == ""){
					keyEtd = criptoKey;
				}
				
                var k:String = keyEtd;
                var kdata:ByteArray;
                var kformat:String = "text";
                switch (kformat) {
                    case "hex": kdata = Hex.toArray(k); break;
                    case "b64": kdata = Base64.decodeToByteArray(k); break;
                    default:
                        kdata = Hex.toArray(Hex.fromString(k));
                }
                // 3: get an output
                var txt:String = trim(txtEtd);
                var data:ByteArray;
                var format:String = "b64";
                switch (format) {
                    case "hex": data = Hex.toArray(txt); break;
                    case "b64": data = Base64.decodeToByteArray(txt); break;
                    default:
                        data = Hex.toArray(Hex.fromString(txt));
                }
                // 1: get an algorithm..
                var name:String = "aes-cbc";
                
                
                var pad:IPad = new PKCS5;
                var mode:ICipher = Crypto.getCipher(name, kdata, pad);
                pad.setBlockSize(mode.getBlockSize());
                // if an IV is there, set it.
                if (mode is IVMode) {
                    var ivmode:IVMode = mode as IVMode;
                    ivmode.IV = Hex.toArray(vetorEtd);
                }
                mode.decrypt(data);
                currentInput_decrypt = data;
              
			  	return currentInput_decrypt;
                
            }
			
/*bt.addEventListener(MouseEvent.CLICK,
		function(e:MouseEvent){
			encrypt(xmlProjeto["arquivo"]);
		}
	);*/

obj_Janela["ssh_credenciais"].EXPORTAR_CONEXOES.addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				trace(criar_credenciais_ssh());
			}
		);

obj_Janela["ssh_conexoes_btn_cred"].addEventListener(
		MouseEvent.CLICK, 
			function(e:MouseEvent){
				obj_Janela["ssh_credenciais_janela"].visible = true;
			}
		);
		
function criar_credenciais_ssh(){
	
	var titulo = obj_Janela["ssh_credenciais"].titulo.text;
	var servidor = obj_Janela["ssh_credenciais"].servidor.text;
	var porta = obj_Janela["ssh_credenciais"].porta.text;
	var usuario = obj_Janela["ssh_credenciais"].usuario.text;
	var senha = obj_Janela["ssh_credenciais"].senha.text;
	
	var tn_ip_local = obj_Janela["ssh_credenciais"].tn_ip_local.text;
	var tn_pt_local = obj_Janela["ssh_credenciais"].tn_pt_local.text;
	var tn_ip_remoto = obj_Janela["ssh_credenciais"].tn_ip_remoto.text;
	var tn_pt_remoto = obj_Janela["ssh_credenciais"].tn_pt_remoto.text;
	
	if(titulo != "" && 
	   servidor != "" && 
	   porta != "" && 
	   usuario != "" && 
	   senha != "" &&
	   
	   tn_ip_local != "" && 
	   tn_pt_local != "" && 
	   tn_ip_remoto != "" && 
	   tn_pt_remoto != ""
	   
	  ){
			var conn;
			
				conn = '<conn ';
				conn += 'titulo="'+titulo+'" ';
				conn += 'ssh_servidor="'+servidor+'" ';
				conn += 'ssh_porta="'+porta+'" ';
				conn += 'ssh_usuario="'+usuario+'" ';
				conn += 'ssh_senha="'+senha+'"> ';
				conn += '<ssh_tn id="1" ';
						conn += 'pLocal="'+tn_ip_local+':'+tn_pt_local+'" ';
						conn += 'pRemoto="'+tn_ip_remoto+':'+tn_pt_remoto+'">';
				conn += '</ssh_tn>';
				conn += '</conn>';
				
				encrypt(
					conn, 
					criptoKeyDock, 
					"ssh_credenciais"
				);
				
				//Exporta a chave e txt para as conexoes ssh
				obj_Janela["ssh_conexoes"].conn.text = tunelSSHCripto;
				obj_Janela["ssh_conexoes"].vetor.text = vetorSSHKey;
				
				obj_Janela["ssh_conexoes_janela"].visible = true;
				
				return "";
				
	  } else {
		  alertaMsgBox("Preencha todos os campos.");
		  return "";
	  }
}

/*
<conn
		ssh_servidor="177.19.19.0"
		ssh_porta="22"
		ssh_usuario="user"
		ssh_senha="pass">
	
		<ssh_tn id="01" pLocal="127.0.0.1:4000" pRemoto="192.168.0.1:4000"></ssh_tn>
		<ssh_tn id="02" pLocal="127.0.0.1:5000" pRemoto="192.168.0.2:5000"></ssh_tn>
		<ssh_tn id="03" pLocal="127.0.0.1:6000" pRemoto="192.168.0.3:6000"></ssh_tn>
	
	</conn>
	
	*/
function trim(s:String):String {
	return s ? s.replace(/^\s+|\s+$/gs, '') : "";
}