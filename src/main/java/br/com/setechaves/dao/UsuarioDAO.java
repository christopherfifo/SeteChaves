package br.com.setechaves.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import br.com.setechaves.model.Usuario;
import br.com.setechaves.util.ConnectionFactory;
import br.com.setechaves.util.CryptoUtil;
import java.sql.Timestamp;

public class UsuarioDAO {

    public Usuario validarLogin(String email, String senha) {
    	String sql = "SELECT * FROM usuarios WHERE email = ? AND senha = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            String senhaHash = CryptoUtil.hashSHA256(senha);
            stmt.setString(2, senhaHash);
                        
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return new Usuario(
                    rs.getInt("id"),
                    rs.getString("nome"),
                    rs.getString("email")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean cadastrar(Usuario u) {
        String sql = "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, u.getNome());
            stmt.setString(2, u.getEmail());
            stmt.setString(3, u.getSenha());
            
            stmt.execute();
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean salvarCodigoRecuperacao(String email, String codigo) {
        String sql = "UPDATE usuarios SET codigo_recuperacao = ?, validade_codigo = ? WHERE email = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, codigo);
            
            Timestamp validade = new Timestamp(System.currentTimeMillis() + (15 * 60 * 1000));
            stmt.setTimestamp(2, validade);
            
            stmt.setString(3, email);
            
            return stmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean redefinirSenha(String email, String codigo, String novaSenhaHash) {
        String sql = "UPDATE usuarios SET senha = ?, codigo_recuperacao = NULL WHERE email = ? AND codigo_recuperacao = ? AND validade_codigo > NOW()";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, novaSenhaHash);
            stmt.setString(2, email);
            stmt.setString(3, codigo);
            
            return stmt.executeUpdate() > 0; // correto
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}