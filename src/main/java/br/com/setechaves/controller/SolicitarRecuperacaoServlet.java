package br.com.setechaves.controller;

import java.io.IOException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import br.com.setechaves.dao.UsuarioDAO;
import br.com.setechaves.service.EmailService;

@WebServlet("/solicitarRecuperacao")
public class SolicitarRecuperacaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        UsuarioDAO dao = new UsuarioDAO();
        String codigo = String.format("%06d", new Random().nextInt(999999));
        
        boolean emailExiste = dao.salvarCodigoRecuperacao(email, codigo);

        if (emailExiste) {
            try {
                new EmailService().enviarCodigo(email, codigo);
                response.getWriter().write("{\"status\": \"ok\"}");
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"status\": \"erro\", \"msg\": \"Erro ao enviar e-mail.\"}");
            }
        } else {
            response.getWriter().write("{\"status\": \"ok\"}"); // por segurança, para não expor se email existe
        }
    }
}