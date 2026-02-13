package br.com.setechaves.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import br.com.setechaves.dao.SenhaDAO;
import br.com.setechaves.model.Senha;
import br.com.setechaves.model.Usuario;

@WebServlet("/gerenciarSenhas")
public class SenhaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado == null) {
            response.setStatus(403);
            return;
        }

        String acao = request.getParameter("acao");
        SenhaDAO dao = new SenhaDAO();

        if ("deletar".equals(acao)) {
            String idStr = request.getParameter("id");
            int idSenha = Integer.parseInt(idStr);
            
            boolean sucesso = dao.excluir(idSenha, usuarioLogado.getId());
            
            if (sucesso) {
                response.getWriter().write("{\"status\": \"ok\"}");
            } else {
                response.getWriter().write("{\"status\": \"erro\", \"msg\": \"Erro ao excluir.\"}");
            }
            return;
        }

        String servico = request.getParameter("servico");
        String login = request.getParameter("login");
        String pass = request.getParameter("pass");
        String descricao = request.getParameter("descricao");

        Senha novaSenha = new Senha();
        novaSenha.setUsuarioId(usuarioLogado.getId());
        novaSenha.setNomeServico(servico);
        novaSenha.setLoginServico(login);
        novaSenha.setSenhaServico(pass);
        novaSenha.setDescricao(descricao);

        dao.cadastrar(novaSenha);

        response.getWriter().write("{\"status\": \"ok\"}");
    }
}