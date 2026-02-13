<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SeteChaves - Acesso Seguro</title>
    <link rel="icon" href="assets/img/cadeado.png" type="image/png">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #2c3e50;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: #333;
        }
        .card {
            background: white;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 350px;
            text-align: center;
        }
        
        .icon-img {
            width: 80px;
            height: auto;
            margin-bottom: 15px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        h2 { 
            color: #2c3e50; 
            margin-top: 0;
            margin-bottom: 10px; 
            font-size: 24px;
        }
        
        input {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
            background-color: #f9f9f9;
        }
        input:focus { border-color: #27ae60; outline: none; background-color: #fff; }
        
        button {
            width: 100%;
            padding: 12px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin-top: 15px;
            transition: background 0.3s;
        }
        button:hover { background-color: #219150; }
        
        .toggle-link {
            display: block;
            margin-top: 15px;
            color: #3498db;
            text-decoration: none;
            font-size: 0.9em;
            cursor: pointer;
        }
        .toggle-link:hover { text-decoration: underline; }

        .hidden { display: none; }
        .error { color: #e74c3c; font-size: 0.9em; margin-top: 15px; font-weight: 500; }
        .success { color: #27ae60; font-size: 0.9em; margin-top: 15px; font-weight: 500; }
        .info { color: #7f8c8d; font-size: 0.95em; margin-bottom: 20px; }
    </style>
</head>
<body>

    <div class="card">
        
        <div id="step-login">
            <img src="assets/img/cadeado.png" alt="Login Icon" class="icon-img">
            <h2>SeteChaves</h2>
            <p class="info">Entre para acessar seu cofre.</p>
            
            <input type="email" id="email" placeholder="Seu e-mail" required>
            <input type="password" id="senha" placeholder="Sua senha" required>
            
            <button onclick="realizarLogin()">Entrar</button>
            <a class="toggle-link" onclick="mostrarCadastro()">Não tem conta? Cadastre-se</a>
            <a class="toggle-link" onclick="mostrarRecuperacao()" style="color: #e67e22;">Esqueci minha senha</a>
        </div>

        <div id="step-cadastro" class="hidden">
            <img src="assets/img/cadeado.png" alt="Cadastro Icon" class="icon-img">
            <h2>Criar Conta</h2>
            <p class="info">Preencha os dados abaixo.</p>
            
            <input type="text" id="cad-nome" placeholder="Nome Completo" required>
            <input type="email" id="cad-email" placeholder="Seu E-mail" required>
            <input type="password" id="cad-senha" placeholder="Crie uma Senha Forte" required>
            
            <button onclick="realizarCadastro()">Cadastrar</button>
            <a class="toggle-link" onclick="mostrarLogin()">Voltar para Login</a>
        </div>
        
        <div id="step-recuperar-1" class="hidden">
            <img src="assets/img/escudo.png" class="icon-img">
            <h2>Recuperar Senha</h2>
            <p class="info">Digite seu e-mail para receber o código.</p>
            <input type="email" id="rec-email" placeholder="Seu e-mail cadastrado">
            <button onclick="solicitarCodigoRecuperacao()">Enviar Código</button>
            <a class="toggle-link" onclick="mostrarLogin()">Cancelar</a>
        </div>

        <div id="step-recuperar-2" class="hidden">
            <img src="assets/img/escudo.png" class="icon-img">
            <h2>Redefinir</h2>
            <p class="info">Verifique seu e-mail.</p>
            <input type="text" id="rec-codigo" placeholder="Código recebido (6 dígitos)" style="text-align: center;">
            <input type="password" id="rec-novaSenha" placeholder="Nova Senha">
            <button onclick="redefinirSenhaFinal()">Alterar Senha</button>
        </div>

        <div id="step-2fa" class="hidden">
            <img src="assets/img/escudo.png" alt="Security Icon" class="icon-img">
            <h2>Verificação</h2>
            <p class="info">Enviamos um código para seu e-mail.</p>
            
            <input type="text" id="codigo" placeholder="Digite o código (ex: 123456)" maxlength="6" style="text-align: center;">
            
            <button onclick="validar2FA()">Verificar Código</button>
            <a class="toggle-link" onclick="location.reload()">Cancelar</a>
        </div>

        <p id="msg-erro" class="error"></p>
        <p id="msg-sucesso" class="success"></p>
    </div>

    <script>
	    function esconderTelas() {
	        $("#step-login").hide();
	        $("#step-cadastro").hide();
	        $("#step-recuperar-1").hide();
	        $("#step-recuperar-2").hide();
	        $("#step-2fa").hide();
	        
	        $("#msg-erro").text("");
	        $("#msg-sucesso").text("");
	    }
	
	    function mostrarLogin() {
	        esconderTelas();
	        $("#step-login").show();
	    }
	
	    function mostrarCadastro() {
	        esconderTelas();
	        $("#step-cadastro").show();
	    }
	
	    function mostrarRecuperacao() {
	        esconderTelas();
	        $("#step-recuperar-1").show();
	    }
        
	    function realizarLogin() {
            var email = $("#email").val();
            var senha = $("#senha").val();

            if(email === "" || senha === "") { $("#msg-erro").text("Preencha todos os campos!"); return; }

            $("#msg-erro").text("Verificando...");
            
            $.ajax({
                type: "POST", 
                url: "login", 
                data: { email: email, senha: senha }, 
                dataType: "json",
                success: function(response) {
                    if (response.status === "2fa_required") {
                        esconderTelas();
                        $("#step-2fa").show();
                        $("#codigo").focus();
                    } else { 
                        $("#msg-erro").text(response.msg); 
                    }
                }, 
                error: function() { $("#msg-erro").text("Erro de conexão."); }
            });
       }
       
       function validar2FA() {
            var codigo = $("#codigo").val();
            
            $.ajax({
                type: "POST", 
                url: "validar2fa", 
                data: { codigo: codigo }, 
                dataType: "json",
                success: function(response) {
                    if (response.status === "ok") {
                        window.location.href = "dashboard.jsp";
                    } else { 
                        $("#msg-erro").text(response.msg); 
                    }
                }, 
                error: function() { $("#msg-erro").text("Erro ao validar."); }
            });
       }

       function realizarCadastro() {
            var nome = $("#cad-nome").val();
            var email = $("#cad-email").val();
            var senha = $("#cad-senha").val();

            if(nome === "" || email === "" || senha === "") { $("#msg-erro").text("Preencha todos os campos!"); return; }

            $("#msg-erro").text("Cadastrando...");

            $.ajax({
                type: "POST", 
                url: "cadastro", 
                data: { nome: nome, email: email, senha: senha }, 
                dataType: "json",
                success: function(response) {
                    if (response.status === "ok") { 
                        mostrarLogin(); 
                        $("#msg-sucesso").text("Conta criada! Faça login agora."); 
                        // Limpa campos
                        $("#cad-nome").val(""); $("#cad-email").val(""); $("#cad-senha").val("");
                    } else { 
                        $("#msg-erro").text(response.msg); 
                    }
                }, 
                error: function() { $("#msg-erro").text("Erro ao tentar cadastrar."); }
            });
       }

       function solicitarCodigoRecuperacao() {
           var email = $("#rec-email").val();
           if(email === "") { $("#msg-erro").text("Digite o e-mail."); return; }
           
           $("#msg-erro").text("Enviando...");
           
           $.ajax({
               type: "POST",
               url: "solicitarRecuperacao",
               data: { email: email },
               dataType: "json",
               success: function(response) {
                   esconderTelas();
                   $("#step-recuperar-2").show(); // Vai para a tela de digitar código
                   $("#msg-sucesso").text("Se o e-mail existir, o código foi enviado.");
               },
               error: function() { $("#msg-erro").text("Erro no servidor."); }
           });
       }

       function redefinirSenhaFinal() {
           var email = $("#rec-email").val();
           var codigo = $("#rec-codigo").val();
           var novaSenha = $("#rec-novaSenha").val();

           if(codigo === "" || novaSenha === "") { $("#msg-erro").text("Preencha tudo."); return; }

           $("#msg-erro").text("Redefinindo...");

           $.ajax({
               type: "POST",
               url: "redefinirSenha",
               data: { email: email, codigo: codigo, novaSenha: novaSenha },
               dataType: "json",
               success: function(response) {
                   if (response.status === "ok") {
                       mostrarLogin(); // AGORA VAI FUNCIONAR CORRETAMENTE
                       $("#msg-sucesso").text("Senha alterada com sucesso! Faça login.");
                       // Limpa campos de recuperação
                       $("#rec-email").val(""); $("#rec-codigo").val(""); $("#rec-novaSenha").val("");
                   } else {
                       $("#msg-erro").text(response.msg);
                   }
               },
               error: function() { $("#msg-erro").text("Erro ao redefinir."); }
           });
       }
    </script>

</body>
</html>