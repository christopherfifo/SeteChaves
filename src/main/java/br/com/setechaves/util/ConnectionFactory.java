package br.com.setechaves.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
    
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/setechaves?useTimezone=true&serverTimezone=UTC", 
                "root", ""); // colocar a senha se tiver
    }
    
    public static void main(String[] args) {
        try {
            getConnection();
            System.out.println("Conexão realizada com sucesso!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}