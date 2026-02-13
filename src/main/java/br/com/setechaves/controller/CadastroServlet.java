package br.com.setechaves.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import br.com.setechaves.dao.UsuarioDAO;
import br.com.setechaves.model.Usuario;
import br.com.setechaves.util.CryptoUtil;

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        if (nome == null || email == null || senha == null || senha.isEmpty()) {
            response.getWriter().write("{\"status\": \"erro\", \"msg\": \"Preencha todos os campos!\"}");
            return;
        }

        Usuario u = new Usuario();
        u.setNome(nome);
        u.setEmail(email);
        
        u.setSenha(CryptoUtil.hashSHA256(senha));

        UsuarioDAO dao = new UsuarioDAO();
        boolean sucesso = dao.cadastrar(u);

        if (sucesso) {
            response.getWriter().write("{\"status\": \"ok\"}");
        } else {
            response.getWriter().write("{\"status\": \"erro\", \"msg\": \"Erro ao cadastrar. E-mail já existe\"}");
        }
    }
}