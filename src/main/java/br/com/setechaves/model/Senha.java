package br.com.setechaves.model;

import java.util.Date;

public class Senha {
    private int id;
    private int usuarioId;
    private String nomeServico;
    private String loginServico;
    private String senhaServico;
    private String descricao;
    private Date dataCriacao;

    public Senha() {}

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    public Date getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(Date dataCriacao) { this.dataCriacao = dataCriacao; }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
    public String getNomeServico() { return nomeServico; }
    public void setNomeServico(String nomeServico) { this.nomeServico = nomeServico; }
    public String getLoginServico() { return loginServico; }
    public void setLoginServico(String loginServico) { this.loginServico = loginServico; }
    public String getSenhaServico() { return senhaServico; }
    public void setSenhaServico(String senhaServico) { this.senhaServico = senhaServico; }
}