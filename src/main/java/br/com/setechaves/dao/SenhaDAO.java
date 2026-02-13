package br.com.setechaves.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import br.com.setechaves.model.Senha;
import br.com.setechaves.util.ConnectionFactory;
import br.com.setechaves.util.CryptoUtil;

public class SenhaDAO {

    public void cadastrar(Senha s) {
        String sql = "INSERT INTO senhas (usuario_id, nome_servico, login_servico, senha_servico, descricao) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, s.getUsuarioId());
            stmt.setString(2, s.getNomeServico());
            stmt.setString(3, s.getLoginServico());
            
            
            String senhaCriptografada = CryptoUtil.encryptAES(s.getSenhaServico());
            stmt.setString(4, senhaCriptografada);
            
            stmt.setString(5, s.getDescricao());
            
            stmt.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Senha> listarPorUsuario(int idUsuario) {
        List<Senha> lista = new ArrayList<>();
        String sql = "SELECT * FROM senhas WHERE usuario_id = ? ORDER BY data_criacao DESC";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Senha s = new Senha();
                s.setId(rs.getInt("id"));
                s.setUsuarioId(rs.getInt("usuario_id"));
                s.setNomeServico(rs.getString("nome_servico"));
                s.setLoginServico(rs.getString("login_servico"));
                
                String senhaDoBanco = rs.getString("senha_servico");
                String senhaLimpa = CryptoUtil.decryptAES(senhaDoBanco);
                s.setSenhaServico(senhaLimpa);
                
                s.setDescricao(rs.getString("descricao"));
                s.setDataCriacao(rs.getTimestamp("data_criacao"));
                
                lista.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public boolean excluir(int idSenha, int idUsuario) {
        String sql = "DELETE FROM senhas WHERE id = ? AND usuario_id = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idSenha);
            stmt.setInt(2, idUsuario);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}