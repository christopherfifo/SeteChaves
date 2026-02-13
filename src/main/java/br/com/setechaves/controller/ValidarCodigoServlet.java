package br.com.setechaves.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import br.com.setechaves.model.Usuario;

@WebServlet("/validar2fa")
public class ValidarCodigoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String codigoDigitado = request.getParameter("codigo");
        
        HttpSession session = request.getSession();
        String codigoCorreto = (String) session.getAttribute("auth_code");
        Usuario usuarioTemp = (Usuario) session.getAttribute("auth_temp_user");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (codigoCorreto != null && codigoCorreto.equals(codigoDigitado)) { //ok
           
            session.setAttribute("usuarioLogado", usuarioTemp);
            
            // limpar dados temporario
            session.removeAttribute("auth_code");
            session.removeAttribute("auth_temp_user");
            
            response.getWriter().write("{\"status\": \"ok\"}");
            
        } else {
            response.getWriter().write("{\"status\": \"erro\", \"msg\": \"Código inválido!\"}");
        }
    }
}