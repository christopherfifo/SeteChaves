package br.com.setechaves.service;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import br.com.setechaves.util.ConfigLoader;

public class EmailService {

    private final String USERNAME = ConfigLoader.getProperty("mailtrap.username");
    private final String PASSWORD = ConfigLoader.getProperty("mailtrap.password");

    public void enviarCodigo(String destinatario, String codigo) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "sandbox.smtp.mailtrap.io");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("seguranca@setechaves.com"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            message.setSubject("Código de Verificação - SeteChaves");
            
            String htmlContent = "<h1>Seu código de acesso é:</h1>"
                    + "<h2>" + codigo + "</h2>"
                    + "<p>Se você não solicitou este código, ignore este e-mail.</p>";
            
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("E-mail enviado com sucesso para: " + destinatario);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao enviar e-mail: " + e.getMessage());
        }
    }
}