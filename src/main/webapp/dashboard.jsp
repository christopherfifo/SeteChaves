<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="br.com.setechaves.model.Usuario" %>
<%@ page import="br.com.setechaves.model.Senha" %>
<%@ page import="br.com.setechaves.dao.SenhaDAO" %>
<%@ page import="br.com.setechaves.util.CryptoUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogado");
    if (usuario == null) { response.sendRedirect("login.jsp"); return; }

    SenhaDAO dao = new SenhaDAO();
    List<Senha> listaSenhas = dao.listarPorUsuario(usuario.getId());
    
    SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfFull = new SimpleDateFormat("dd/MM/yyyy 'às' HH:mm:ss");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cofre - SeteChaves</title>
    <link rel="icon" href="assets/img/cadeado.png" type="image/png">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #ecf0f1; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 20px; }
        .btn-logout { background-color: #c0392b; color: white; text-decoration: none; padding: 8px 15px; border-radius: 4px; font-size: 14px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 10px; table-layout: fixed; }
        th, td { text-align: left; padding: 12px; border-bottom: 1px solid #ddd; vertical-align: middle; }
        th { background-color: #f2f2f2; color: #333; }
        tr:hover { background-color: #f9f9f9; }
        
        .col-data { width: 100px; color: #777; font-size: 0.9em; cursor: help; }
        .col-servico { width: 140px; }
        .col-login { width: 200px; word-wrap: break-word; }
        .col-desc { color: #888; font-style: italic; font-size: 0.9em; }
        .col-senha { width: 170px; }
        .col-acao { width: 50px; text-align: center; }

        .input-senha-box { display: flex; align-items: center; background: #fff; border: 1px solid #ddd; border-radius: 4px; padding: 5px; transition: border-color 0.3s; }
        .input-senha-box:hover { border-color: #2980b9; }
        .input-senha-display { border: none; background: transparent; font-family: 'Courier New', monospace; font-size: 14px; color: #2c3e50; width: 100%; cursor: pointer; outline: none; }
        
        .btn-eye { cursor: pointer; width: 20px; opacity: 0.5; transition: opacity 0.2s; margin-left: 5px; }
        .btn-eye:hover { opacity: 1; }
        
        .btn-trash { cursor: pointer; width: 20px; opacity: 0.6; transition: transform 0.2s, opacity 0.2s; }
        .btn-trash:hover { opacity: 1; transform: scale(1.1); }

        #toast { visibility: hidden; min-width: 250px; margin-left: -125px; background-color: #333; color: #fff; text-align: center; border-radius: 50px; padding: 16px; position: fixed; z-index: 1; left: 50%; bottom: 30px; font-size: 17px; }
        #toast.show { visibility: visible; -webkit-animation: fadein 0.5s, fadeout 0.5s 2.5s; animation: fadein 0.5s, fadeout 0.5s 2.5s; }
        @-webkit-keyframes fadein { from {bottom: 0; opacity: 0;} to {bottom: 30px; opacity: 1;} }
        @keyframes fadein { from {bottom: 0; opacity: 0;} to {bottom: 30px; opacity: 1;} }
        @-webkit-keyframes fadeout { from {bottom: 30px; opacity: 1;} to {bottom: 0; opacity: 0;} }
        @keyframes fadeout { from {bottom: 30px; opacity: 1;} to {bottom: 0; opacity: 0;} }

        .box-add { background: #f8f9fa; padding: 15px; border-radius: 5px; border: 1px solid #ddd; display: flex; gap: 10px; flex-wrap: wrap; align-items: flex-end; }
        .input-group { display: flex; flex-direction: column; }
        .input-group label { font-size: 12px; margin-bottom: 5px; font-weight: bold; color: #555; }
        .input-group input { padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .flex-grow { flex-grow: 1; }
        .btn-add { background-color: #27ae60; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; height: 36px; }
        .input-with-icon { display: flex; align-items: center; gap: 5px; }
        .input-with-icon input { flex-grow: 1; }
        .btn-dice { width: 24px; height: 24px; cursor: pointer; opacity: 1; transition: transform 0.2s; }
        .btn-dice:hover { opacity: 0.7; }
        #inputBusca:focus { border-color: #3498db; outline: none; box-shadow: 0 0 5px rgba(52, 152, 219, 0.3); }

        .modal-overlay {
            display: none; /* Começa invisível */
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* Fundo escuro transparente */
            z-index: 1000;
            justify-content: center; align-items: center;
        }
        .modal-box {
            background: white; padding: 25px; border-radius: 8px; text-align: center;
            width: 300px; box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            animation: popin 0.3s;
        }
        @keyframes popin { from {transform: scale(0.8); opacity: 0;} to {transform: scale(1); opacity: 1;} }
        
        .modal-btn { padding: 10px 20px; margin: 5px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-confirm { background-color: #e74c3c; color: white; }
        .btn-cancel { background-color: #bdc3c7; color: #333; }
        .btn-confirm:hover { background-color: #c0392b; }
        .btn-cancel:hover { background-color: #95a5a6; }
    </style>
</head>
<body>

    <div class="container">
        <div class="header">
            <h1>Olá, <%= usuario.getNome() %>!</h1>
            <div>
                <span style="margin-right: 15px; font-size: 0.9em; color: #777;"><%= usuario.getEmail() %></span>
                <a href="logout" class="btn-logout">Sair</a>
            </div>
        </div>

        <h3>Adicionar Nova Senha</h3>
        <div class="box-add">
            <div class="input-group">
                <label>Serviço</label>
                <input type="text" id="novoServico" placeholder="Ex: Netflix">
            </div>
            <div class="input-group">
                <label>Login/Email</label>
                <input type="text" id="novoLogin" placeholder="usuario@email.com">
            </div>
            <div class="input-group">
                <label>Senha</label>
                <div class="input-with-icon">
                    <input type="text" id="novaSenha" placeholder="******">
                    <img src="assets/img/dados.png" class="btn-dice" title="Gerar senha" onclick="gerarSenhaAleatoria()">
                </div>
            </div>
            <div class="input-group flex-grow">
                <label>Descrição (Opcional)</label>
                <input type="text" id="novaDescricao" placeholder="Nota..." style="width: 95%;">
            </div>
            <button class="btn-add" onclick="salvarSenha()">Salvar</button>
        </div>

        <hr style="margin: 30px 0; border: 0; border-top: 1px solid #eee;">

        <div style="margin-bottom: 15px; position: relative;">
            <input type="text" id="inputBusca" placeholder="Pesquisar..." 
                   style="width: 100%; padding: 12px 12px 12px 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 16px;">
        </div>

        <h3>Suas senhas guardadas:</h3>
        
        <table id="tabela-senhas">
            <thead>
                <tr>
                    <th class="col-data">Data</th>
                    <th class="col-servico">Serviço</th>
                    <th class="col-login">Login</th>
                    <th class="col-senha">Senha</th>
                    <th class="col-desc">Descrição</th>
                    <th class="col-acao"></th> </tr>
            </thead>
            <tbody>
                <% for(Senha s : listaSenhas) { 
                    String dataCurta = s.getDataCriacao() != null ? sdfDisplay.format(s.getDataCriacao()) : "-";
                    String dataCompleta = s.getDataCriacao() != null ? sdfFull.format(s.getDataCriacao()) : "";
                %>
                    <tr>
                        <td class="col-data" title="<%= dataCompleta %>"><%= dataCurta %></td>
                        <td class="col-servico"><strong><%= s.getNomeServico() %></strong></td>
                        <td class="col-login">
                            <div class="input-senha-box" title="Clique para copiar">
                                <input type="text" value="<%= s.getLoginServico() %>" class="input-senha-display" readonly onclick="copiarEmail(this)">
                            </div>
                        </td>
                        <td class="col-senha">
                            <div class="input-senha-box">
                                <input type="text" value="••••••••••••" class="input-senha-display" readonly 
                                       id="input-<%= s.getId() %>" data-real="<%= s.getSenhaServico() %>" data-visible="false"
                                       onclick="copiarSenha(this)" title="Clique para copiar">
                                <img src="assets/img/olho.png" class="btn-eye" onclick="toggleSenha('<%= s.getId() %>')">
                            </div>
                        </td>
                        <td class="col-desc"><%= s.getDescricao() != null ? s.getDescricao() : "" %></td>
                        
                        <td class="col-acao">
                            <img src="assets/img/lixeira.png" class="btn-trash" 
                                 title="Excluir Senha" onclick="abrirModalExclusao('<%= s.getId() %>')">
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div id="modalConfirmacao" class="modal-overlay">
        <div class="modal-box">
            <h3 style="color: #c0392b; margin-top: 0;">Excluir Senha?</h3>
            <p>Tem certeza que deseja remover este item?<br>Essa ação não pode ser desfeita.</p>
            <br>
            <input type="hidden" id="idParaExcluir"> <button class="modal-btn btn-cancel" onclick="fecharModal()">Cancelar</button>
            <button class="modal-btn btn-confirm" onclick="confirmarExclusao()">Sim, Excluir</button>
        </div>
    </div>

    <div id="toast">Copiado!</div>

    <script>
        function abrirModalExclusao(id) {
            $("#idParaExcluir").val(id);
            $("#modalConfirmacao").css("display", "flex");
        }

        function fecharModal() {
            $("#modalConfirmacao").hide();
        }

        function confirmarExclusao() {
            var id = $("#idParaExcluir").val();
            
            $.ajax({
                type: "POST",
                url: "gerenciarSenhas",
                data: { acao: "deletar", id: id },
                dataType: "json",
                success: function(response) {
                    if (response.status === "ok") {
                        location.reload(); 
                    } else {
                        alert(response.msg);
                    }
                },
                error: function() { alert("Erro ao excluir."); }
            });
        }

        $("#inputBusca").on("keyup", function() {
            var termo = $(this).val().toLowerCase();
            $("#tabela-senhas tbody tr").filter(function() {
                var texto = $(this).text().toLowerCase();
                var login = $(this).find(".col-login input").val() || "";
                $(this).toggle((texto + " " + login.toLowerCase()).indexOf(termo) > -1)
            });
        });

        function toggleSenha(id) {
            var input = document.getElementById("input-" + id);
            if (input.getAttribute("data-visible") === "true") {
                input.value = "••••••••••••"; input.setAttribute("data-visible", "false");
            } else {
                input.value = input.getAttribute("data-real"); input.setAttribute("data-visible", "true");
            }
        }
        function copiarSenha(el) { copiarParaClipboard(el.getAttribute("data-real"), "Senha copiada!"); }
        function copiarEmail(el) { copiarParaClipboard(el.value, "E-mail copiado!"); }
        
        function copiarParaClipboard(txt, msg) {
            navigator.clipboard.writeText(txt).then(function() {
                var x = document.getElementById("toast"); x.innerText = msg; x.className = "show";
                setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
            });
        }

        function gerarSenhaAleatoria() {
            var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+";
            var pass = "";
            for (var i=0; i<16; i++) pass += chars.charAt(Math.floor(Math.random() * chars.length));
            $("#novaSenha").val(pass);
        }

        function salvarSenha() {
            var servico = $("#novoServico").val();
            var login = $("#novoLogin").val();
            var senha = $("#novaSenha").val();
            var desc = $("#novaDescricao").val();

            if(servico === "" || senha === "") { alert("Preencha serviço e senha!"); return; }

            $.ajax({
                type: "POST",
                url: "gerenciarSenhas",
                data: { servico: servico, login: login, pass: senha, descricao: desc },
                dataType: "json",
                success: function(r) { if(r.status==="ok") location.reload(); else alert("Erro."); },
                error: function() { alert("Erro servidor."); }
            });
        }
    </script>
</body>
</html>