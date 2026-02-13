package br.com.setechaves.controller;

import java.io.IOException;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import br.com.setechaves.dao.UsuarioDAO;
import br.com.setechaves.model.Usuario;
import br.com.setechaves.service.EmailService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.validarLogin(email, senha);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (usuario != null) { //existe
            String codigo2FA = String.format("%06d", new Random().nextInt(999999));
            
            HttpSession session = request.getSession();
            session.setAttribute("auth_temp_user", usuario); // guarda o usuario na sessao
            session.setAttribute("auth_code", codigo2FA);    // guarda o codigo
            
            try {
                EmailService service = new EmailService();
                service.enviarCodigo(usuario.getEmail(), codigo2FA);
                
                response.getWriter().write("{\"status\": \"2fa_required\"}");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"status\": \"erro\", \"msg\": \"Erro ao enviar e-mail.\"}");
            }
            
        } else {
            // login invalido
            response.getWriter().write("{\"status\": \"erro\", \"msg\": \"E-mail ou senha incorretos.\"}");
        }
    }
}