package br.com.setechaves.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import br.com.setechaves.dao.UsuarioDAO;
import br.com.setechaves.util.CryptoUtil;

@WebServlet("/redefinirSenha")
public class RedefinirSenhaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String codigo = request.getParameter("codigo");
        String novaSenha = request.getParameter("novaSenha");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String senhaHash = CryptoUtil.hashSHA256(novaSenha);
        
        UsuarioDAO dao = new UsuarioDAO();
        boolean sucesso = dao.redefinirSenha(email, codigo, senhaHash);

        if (sucesso) {
            response.getWriter().write("{\"status\": \"ok\"}");
        } else {
            response.getWriter().write("{\"status\": \"erro\", \"msg\": \"Código inválido ou expirado.\"}");
        }
    }
}