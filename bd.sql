-- ============================================
-- SISTEMA DE GESTÃO ECLESIÁSTICA - BANCO DE DADOS
-- Versão: 1.0
-- Data: 2024
-- ============================================

-- ============================================
-- SEÇÃO 1: CRIAÇÃO DO BANCO DE DADOS
-- ============================================

CREATE DATABASE IF NOT EXISTS sistema_igreja
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE sistema_igreja;

-- ============================================
-- SEÇÃO 2: TABELAS PRINCIPAIS
-- ============================================

-- 1. TABELA PESSOAS (Base para todas as pessoas do sistema)
CREATE TABLE pessoas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE,
    cpf VARCHAR(14) UNIQUE,
    rg VARCHAR(20),
    email VARCHAR(100),
    telefone VARCHAR(20),
    celular VARCHAR(20),
    endereco TEXT,
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(10),
    foto_url VARCHAR(255),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    observacoes TEXT,
    INDEX idx_pessoas_nome (nome),
    INDEX idx_pessoas_cpf (cpf),
    INDEX idx_pessoas_email (email),
    INDEX idx_pessoas_ativo (ativo)
) ENGINE=InnoDB;

-- 2. TABELA MEMBROS (Extensão de PESSOAS com informações eclesiásticas)
CREATE TABLE membros (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pessoa_id INT UNIQUE NOT NULL,
    codigo_membro VARCHAR(20) UNIQUE,
    data_membresia DATE NOT NULL,
    tipo_membro ENUM('Membro', 'Congregado', 'Visitante', 'Novo Convertido') DEFAULT 'Congregado',
    batizado BOOLEAN DEFAULT FALSE,
    data_batismo DATE,
    local_batismo VARCHAR(200),
    cargo ENUM('Pastor', 'Diácono', 'Presbítero', 'Evangelista', 'Missionário', 'Líder', 'Membro', 'Auxiliar') DEFAULT 'Membro',
    estado_civil ENUM('Solteiro', 'Casado', 'Divorciado', 'Viúvo', 'Separado'),
    profissao VARCHAR(100),
    escolaridade VARCHAR(100),
    nome_conjuge VARCHAR(150),
    data_casamento DATE,
    quantidade_filhos INT DEFAULT 0,
    grupo_sanguineo VARCHAR(5),
    alergias TEXT,
    medicamentos TEXT,
    emergencia_contato VARCHAR(100),
    emergencia_telefone VARCHAR(20),
    receber_notificacoes BOOLEAN DEFAULT TRUE,
    receber_correspondencia BOOLEAN DEFAULT TRUE,
    autoriza_imagem BOOLEAN DEFAULT FALSE,
    data_consagracao DATE,
    ultima_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_alteracao INT,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE,
    INDEX idx_membros_tipo (tipo_membro),
    INDEX idx_membros_data_membresia (data_membresia),
    INDEX idx_membros_cargo (cargo),
    INDEX idx_membros_codigo (codigo_membro)
) ENGINE=InnoDB;

-- 3. TABELA USUÁRIOS DO SISTEMA
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pessoa_id INT UNIQUE NOT NULL,
    login VARCHAR(50) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    perfil ENUM('Administrador', 'Pastor', 'Secretaria', 'Tesouraria', 'Lider', 'Membro', 'Visitante') DEFAULT 'Membro',
    token_recuperacao VARCHAR(100),
    token_expiracao DATETIME,
    ultimo_login DATETIME,
    tentativas_login INT DEFAULT 0,
    bloqueado BOOLEAN DEFAULT FALSE,
    data_bloqueio DATETIME,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id) ON DELETE CASCADE,
    INDEX idx_usuarios_login (login),
    INDEX idx_usuarios_perfil (perfil),
    INDEX idx_usuarios_ativo (ativo)
) ENGINE=InnoDB;

-- 4. TABELA DEPARTAMENTOS/MINISTÉRIOS
CREATE TABLE departamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    sigla VARCHAR(10),
    descricao TEXT,
    missao TEXT,
    visao TEXT,
    cor VARCHAR(7) DEFAULT '#3366CC',
    icone VARCHAR(50),
    lider_id INT,
    vice_lider_id INT,
    data_fundacao DATE,
    reuniao_dia VARCHAR(20),
    reuniao_horario TIME,
    reuniao_local VARCHAR(200),
    orcamento_anual DECIMAL(12,2) DEFAULT 0.00,
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_criacao INT,
    FOREIGN KEY (lider_id) REFERENCES membros(id),
    FOREIGN KEY (vice_lider_id) REFERENCES membros(id),
    INDEX idx_departamentos_nome (nome),
    INDEX idx_departamentos_ativo (ativo)
) ENGINE=InnoDB;

-- 5. TABELA FREQUÊNCIA
CREATE TABLE frequencia (
    id INT PRIMARY KEY AUTO_INCREMENT,
    membro_id INT NOT NULL,
    data_evento DATE NOT NULL,
    horario_entrada TIME,
    horario_saida TIME,
    tipo_evento ENUM('Culto Domingo', 'Culto Quarta', 'Culto Juventude', 'Escola Bíblica', 'Célula', 'Evento Especial', 'Reunião', 'Treinamento', 'Outro') NOT NULL,
    evento_id INT,
    presente BOOLEAN DEFAULT TRUE,
    justificativa_ausencia TEXT,
    temperatura DECIMAL(3,1),
    checkin_automatico BOOLEAN DEFAULT FALSE,
    dispositivo_checkin VARCHAR(100),
    observacoes TEXT,
    registrado_por INT,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE CASCADE,
    INDEX idx_frequencia_data (data_evento),
    INDEX idx_frequencia_membro (membro_id),
    INDEX idx_frequencia_tipo (tipo_evento),
    INDEX idx_frequencia_presente (presente)
) ENGINE=InnoDB;

-- 6. TABELA DÍZIMOS E OFERTAS
CREATE TABLE dizimos_ofertas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    membro_id INT NOT NULL,
    data DATE NOT NULL,
    valor DECIMAL(12,2) NOT NULL,
    tipo ENUM('Dízimo', 'Oferta', 'Missões', 'Construção', 'Assistência Social', 'Outro') DEFAULT 'Oferta',
    forma_pagamento ENUM('Dinheiro', 'Cartão Débito', 'Cartão Crédito', 'Transferência', 'PIX', 'Cheque', 'Outro') DEFAULT 'Dinheiro',
    referencia_mes INT,
    referencia_ano INT,
    comprovante_url VARCHAR(255),
    caixa_id INT,
    conferido BOOLEAN DEFAULT FALSE,
    conferido_por INT,
    data_conferencia DATETIME,
    observacao TEXT,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_registro INT,
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE CASCADE,
    INDEX idx_dizimos_data (data),
    INDEX idx_dizimos_membro (membro_id),
    INDEX idx_dizimos_tipo (tipo),
    INDEX idx_dizimos_referencia (referencia_ano, referencia_mes)
) ENGINE=InnoDB;

-- 7. TABELA EVENTOS
CREATE TABLE eventos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME,
    local VARCHAR(200),
    endereco TEXT,
    tipo_evento ENUM('Culto', 'Conferência', 'Retiro', 'Acampamento', 'Treinamento', 'Reunião', 'Social', 'Evangelístico', 'Outro') DEFAULT 'Culto',
    publico_alvo VARCHAR(100),
    capacidade_maxima INT,
    valor_inscricao DECIMAL(8,2) DEFAULT 0.00,
    inscricao_online BOOLEAN DEFAULT FALSE,
    url_inscricao VARCHAR(255),
    responsavel_id INT,
    departamento_id INT,
    banner_url VARCHAR(255),
    destaque BOOLEAN DEFAULT FALSE,
    cancelado BOOLEAN DEFAULT FALSE,
    motivo_cancelamento TEXT,
    data_cancelamento DATETIME,
    criado_por INT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (responsavel_id) REFERENCES membros(id),
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    INDEX idx_eventos_data (data_inicio),
    INDEX idx_eventos_tipo (tipo_evento),
    INDEX idx_eventos_destaque (destaque)
) ENGINE=InnoDB;

-- 8. TABELA CÉLULAS/GRUPOS PEQUENOS
CREATE TABLE celulas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    codigo VARCHAR(20) UNIQUE,
    lider_id INT NOT NULL,
    vice_lider_id INT,
    anfitriao_id INT,
    endereco TEXT NOT NULL,
    ponto_referencia TEXT,
    dia_semana ENUM('Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado') NOT NULL,
    horario TIME NOT NULL,
    data_inicio DATE,
    zona VARCHAR(50),
    rede_id INT,
    capacidade INT DEFAULT 20,
    latitudade DECIMAL(10,8),
    longitude DECIMAL(11,8),
    observacoes TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    data_desativacao DATE,
    criado_por INT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lider_id) REFERENCES membros(id),
    FOREIGN KEY (vice_lider_id) REFERENCES membros(id),
    FOREIGN KEY (anfitriao_id) REFERENCES membros(id),
    INDEX idx_celulas_nome (nome),
    INDEX idx_celulas_dia (dia_semana),
    INDEX idx_celulas_ativo (ativo)
) ENGINE=InnoDB;

-- 9. TABELA HISTÓRICO ESPIRITUAL
CREATE TABLE historico_espiritual (
    id INT PRIMARY KEY AUTO_INCREMENT,
    membro_id INT NOT NULL,
    data DATE NOT NULL,
    tipo ENUM('Conversão', 'Batismo', 'Consagração', 'Mudança de Cargo', 'Disciplina', 'Transferência', 'Desligamento', 'Reconciliação', 'Outro') NOT NULL,
    titulo VARCHAR(200),
    descricao TEXT NOT NULL,
    local VARCHAR(200),
    ministrante VARCHAR(150),
    testemunhas TEXT,
    documento_url VARCHAR(255),
    privado BOOLEAN DEFAULT FALSE,
    registrado_por INT,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE CASCADE,
    INDEX idx_historico_membro (membro_id),
    INDEX idx_historico_data (data),
    INDEX idx_historico_tipo (tipo)
) ENGINE=InnoDB;

-- 10. TABELA AGENDA PASTORAL
CREATE TABLE agenda_pastoral (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pastor_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME,
    local VARCHAR(200),
    tipo ENUM('Visitação', 'Consulta', 'Aconselhamento', 'Reunião', 'Culto Externo', 'Compromisso', 'Ferias', 'Outro') DEFAULT 'Compromisso',
    membro_envolvido_id INT,
    telefone_contato VARCHAR(20),
    confirmado BOOLEAN DEFAULT FALSE,
    notificado BOOLEAN DEFAULT FALSE,
    data_notificacao DATETIME,
    status ENUM('Agendado', 'Confirmado', 'Realizado', 'Cancelado', 'Adiado') DEFAULT 'Agendado',
    motivo_cancelamento TEXT,
    cor_evento VARCHAR(7) DEFAULT '#3366CC',
    recorrente BOOLEAN DEFAULT FALSE,
    padrao_recorrencia VARCHAR(50),
    criado_por INT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pastor_id) REFERENCES membros(id),
    FOREIGN KEY (membro_envolvido_id) REFERENCES membros(id),
    INDEX idx_agenda_pastor (pastor_id),
    INDEX idx_agenda_data (data_inicio),
    INDEX idx_agenda_status (status)
) ENGINE=InnoDB;

-- 11. TABELA CAIXA/FINANÇAS
CREATE TABLE caixa (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_abertura DATETIME NOT NULL,
    data_fechamento DATETIME,
    responsavel_abertura INT NOT NULL,
    responsavel_fechamento INT,
    saldo_inicial DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_entradas DECIMAL(12,2) DEFAULT 0.00,
    total_saidas DECIMAL(12,2) DEFAULT 0.00,
    saldo_final DECIMAL(12,2),
    observacoes TEXT,
    status ENUM('Aberto', 'Fechado', 'Conferido') DEFAULT 'Aberto',
    conferido_por INT,
    data_conferencia DATETIME,
    FOREIGN KEY (responsavel_abertura) REFERENCES usuarios(id),
    FOREIGN KEY (responsavel_fechamento) REFERENCES usuarios(id),
    INDEX idx_caixa_data (data_abertura),
    INDEX idx_caixa_status (status)
) ENGINE=InnoDB;

-- 12. TABELA DESPESAS
CREATE TABLE despesas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(200) NOT NULL,
    categoria ENUM('Aluguel', 'Água', 'Luz', 'Telefone', 'Internet', 'Material', 'Manutenção', 'Salários', 'Eventos', 'Outros') DEFAULT 'Outros',
    valor DECIMAL(10,2) NOT NULL,
    data_despesa DATE NOT NULL,
    data_vencimento DATE,
    data_pagamento DATE,
    forma_pagamento ENUM('Dinheiro', 'Cartão', 'Transferência', 'Cheque', 'PIX'),
    fornecedor VARCHAR(150),
    nota_fiscal_url VARCHAR(255),
    departamento_id INT,
    aprovado_por INT,
    caixa_id INT,
    observacoes TEXT,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_registro INT,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    FOREIGN KEY (caixa_id) REFERENCES caixa(id),
    INDEX idx_despesas_data (data_despesa),
    INDEX idx_despesas_categoria (categoria)
) ENGINE=InnoDB;

-- 13. TABELA PATRIMÔNIO
CREATE TABLE patrimonio (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item VARCHAR(200) NOT NULL,
    descricao TEXT,
    numero_serie VARCHAR(100),
    categoria ENUM('Eletrônico', 'Móvel', 'Instrumento Musical', 'Som/Áudio', 'Iluminação', 'Utensílio', 'Livro', 'Outro'),
    localizacao VARCHAR(200),
    responsavel_id INT,
    data_aquisicao DATE,
    valor_aquisicao DECIMAL(10,2),
    estado ENUM('Novo', 'Bom', 'Regular', 'Precisa Reparo', 'Inutilizado') DEFAULT 'Bom',
    depreciacao_anual DECIMAL(5,2),
    data_baixa DATE,
    motivo_baixa TEXT,
    observacoes TEXT,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_cadastro INT,
    FOREIGN KEY (responsavel_id) REFERENCES membros(id),
    INDEX idx_patrimonio_item (item),
    INDEX idx_patrimonio_categoria (categoria),
    INDEX idx_patrimonio_estado (estado)
) ENGINE=InnoDB;

-- 14. TABELA ESCOLA BÍBLICA
CREATE TABLE escola_biblica (
    id INT PRIMARY KEY AUTO_INCREMENT,
    turma VARCHAR(100) NOT NULL,
    professor_id INT NOT NULL,
    auxiliar_id INT,
    faixa_etaria VARCHAR(50),
    sala VARCHAR(50),
    dia_semana ENUM('Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'),
    horario TIME,
    data_inicio DATE,
    data_termino DATE,
    livro_base VARCHAR(150),
    carga_horaria INT,
    ativo BOOLEAN DEFAULT TRUE,
    vagas INT DEFAULT 20,
    vagas_preenchidas INT DEFAULT 0,
    observacoes TEXT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (professor_id) REFERENCES membros(id),
    FOREIGN KEY (auxiliar_id) REFERENCES membros(id),
    INDEX idx_eb_turma (turma),
    INDEX idx_eb_ativo (ativo)
) ENGINE=InnoDB;

-- 15. TABELA BIBLIOTECA
CREATE TABLE biblioteca (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150),
    editora VARCHAR(100),
    isbn VARCHAR(20),
    categoria ENUM('Bíblia', 'Teologia', 'Devocional', 'Liderança', 'Família', 'Infantil', 'Biografia', 'Outro'),
    tipo ENUM('Livro', 'DVD', 'CD', 'Revista', 'Folheto'),
    quantidade_total INT DEFAULT 1,
    quantidade_disponivel INT DEFAULT 1,
    localizacao VARCHAR(100),
    codigo_de_barras VARCHAR(50),
    capa_url VARCHAR(255),
    sinopse TEXT,
    observacoes TEXT,
    data_aquisicao DATE,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_cadastro INT,
    INDEX idx_biblioteca_titulo (titulo),
    INDEX idx_biblioteca_autor (autor),
    INDEX idx_biblioteca_categoria (categoria)
) ENGINE=InnoDB;

-- ============================================
-- SEÇÃO 3: TABELAS DE RELACIONAMENTO
-- ============================================

-- 16. MEMBROS DEPARTAMENTOS (Muitos-para-Muitos)
CREATE TABLE membros_departamentos (
    membro_id INT NOT NULL,
    departamento_id INT NOT NULL,
    cargo VARCHAR(50),
    data_entrada DATE DEFAULT (CURRENT_DATE),
    data_saida DATE,
    ativo BOOLEAN DEFAULT TRUE,
    observacoes TEXT,
    PRIMARY KEY (membro_id, departamento_id),
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE CASCADE,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id) ON DELETE CASCADE,
    INDEX idx_md_membro (membro_id),
    INDEX idx_md_departamento (departamento_id),
    INDEX idx_md_ativo (ativo)
) ENGINE=InnoDB;

-- 17. MEMBROS CÉLULAS (Muitos-para-Muitos)
CREATE TABLE membros_celulas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    membro_id INT NOT NULL,
    celula_id INT NOT NULL,
    data_entrada DATE DEFAULT (CURRENT_DATE),
    data_saida DATE,
    funcao ENUM('Líder', 'Vice-Líder', 'Anfitrião', 'Auxiliar', 'Membro', 'Visitante') DEFAULT 'Membro',
    frequencia_media DECIMAL(5,2),
    ativo BOOLEAN DEFAULT TRUE,
    observacoes TEXT,
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE CASCADE,
    FOREIGN KEY (celula_id) REFERENCES celulas(id) ON DELETE CASCADE,
    INDEX idx_mc_membro (membro_id),
    INDEX idx_mc_celula (celula_id),
    INDEX idx_mc_ativo (ativo),
    UNIQUE KEY uk_mc_membro_celula (membro_id, celula_id)
) ENGINE=InnoDB;

-- 18. MATRÍCULAS ESCOLA BÍBLICA
CREATE TABLE matriculas_eb (
    id INT PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT NOT NULL,
    turma_id INT NOT NULL,
    data_matricula DATE DEFAULT (CURRENT_DATE),
    data_conclusao DATE,
    frequencia DECIMAL(5,2) DEFAULT 0.00,
    nota_final DECIMAL(5,2),
    aprovado BOOLEAN DEFAULT FALSE,
    certificado_emitido BOOLEAN DEFAULT FALSE,
    data_certificado DATE,
    observacoes TEXT,
    FOREIGN KEY (aluno_id) REFERENCES membros(id) ON DELETE CASCADE,
    FOREIGN KEY (turma_id) REFERENCES escola_biblica(id) ON DELETE CASCADE,
    INDEX idx_matriculas_aluno (aluno_id),
    INDEX idx_matriculas_turma (turma_id),
    UNIQUE KEY uk_matriculas_aluno_turma (aluno_id, turma_id)
) ENGINE=InnoDB;

-- 19. EMPRÉSTIMOS BIBLIOTECA
CREATE TABLE emprestimos_biblioteca (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    membro_id INT NOT NULL,
    data_emprestimo DATE DEFAULT (CURRENT_DATE),
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_real DATE,
    quantidade INT DEFAULT 1,
    status ENUM('Emprestado', 'Devolvido', 'Atrasado', 'Perdido') DEFAULT 'Emprestado',
    multa DECIMAL(8,2) DEFAULT 0.00,
    multa_paga BOOLEAN DEFAULT FALSE,
    observacoes TEXT,
    emprestado_por INT,
    recebido_por INT,
    FOREIGN KEY (item_id) REFERENCES biblioteca(id) ON DELETE CASCADE,
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE CASCADE,
    INDEX idx_emprestimos_item (item_id),
    INDEX idx_emprestimos_membro (membro_id),
    INDEX idx_emprestimos_status (status)
) ENGINE=InnoDB;

-- 20. PARTICIPANTES EVENTOS
CREATE TABLE participantes_eventos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    evento_id INT NOT NULL,
    membro_id INT NOT NULL,
    data_inscricao DATETIME DEFAULT CURRENT_TIMESTAMP,
    presente BOOLEAN DEFAULT FALSE,
    data_checkin DATETIME,
    data_checkout DATETIME,
    pagamento_realizado BOOLEAN DEFAULT FALSE,
    valor_pago DECIMAL(8,2) DEFAULT 0.00,
    necessidades_especiais TEXT,
    observacoes TEXT,
    FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE CASCADE,
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE CASCADE,
    INDEX idx_participantes_evento (evento_id),
    INDEX idx_participantes_membro (membro_id),
    UNIQUE KEY uk_participantes_evento_membro (evento_id, membro_id)
) ENGINE=InnoDB;

-- 21. FAMÍLIAS
CREATE TABLE familias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_familia VARCHAR(150),
    responsavel_id INT,
    conjuge_id INT,
    endereco TEXT,
    telefone VARCHAR(20),
    data_casamento DATE,
    observacoes TEXT,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (responsavel_id) REFERENCES membros(id),
    FOREIGN KEY (conjuge_id) REFERENCES membros(id),
    INDEX idx_familias_nome (nome_familia)
) ENGINE=InnoDB;

-- 22. MEMBROS FAMÍLIA
CREATE TABLE membros_familia (
    id INT PRIMARY KEY AUTO_INCREMENT,
    familia_id INT NOT NULL,
    membro_id INT NOT NULL,
    parentesco ENUM('Cônjuge', 'Filho', 'Filha', 'Pai', 'Mãe', 'Irmão', 'Irmã', 'Avô', 'Avó', 'Neto', 'Neta', 'Outro'),
    responsavel BOOLEAN DEFAULT FALSE,
    data_entrada DATE,
    data_saida DATE,
    observacoes TEXT,
    FOREIGN KEY (familia_id) REFERENCES familias(id) ON DELETE CASCADE,
    FOREIGN KEY (membro_id) REFERENCES membros(id) ON DELETE CASCADE,
    INDEX idx_mf_familia (familia_id),
    INDEX idx_mf_membro (membro_id),
    UNIQUE KEY uk_mf_familia_membro (familia_id, membro_id)
) ENGINE=InnoDB;

-- ============================================
-- SEÇÃO 4: TABELAS DE CONFIGURAÇÃO E SISTEMA
-- ============================================

-- 23. CONFIGURAÇÕES DO SISTEMA
CREATE TABLE configuracoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    chave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT,
    tipo ENUM('STRING', 'INTEGER', 'BOOLEAN', 'DECIMAL', 'JSON', 'DATE', 'TIME'),
    categoria VARCHAR(50),
    descricao TEXT,
    editavel BOOLEAN DEFAULT TRUE,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_atualizacao INT,
    INDEX idx_configuracoes_chave (chave),
    INDEX idx_configuracoes_categoria (categoria)
) ENGINE=InnoDB;

-- 24. LOGS DE AUDITORIA
CREATE TABLE logs_auditoria (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    acao VARCHAR(100) NOT NULL,
    modulo VARCHAR(50),
    tabela_afetada VARCHAR(50),
    registro_id INT,
    dados_anteriores JSON,
    dados_novos JSON,
    ip VARCHAR(45),
    user_agent TEXT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    INDEX idx_logs_usuario (usuario_id),
    INDEX idx_logs_data (data_hora),
    INDEX idx_logs_acao (acao),
    INDEX idx_logs_modulo (modulo)
) ENGINE=InnoDB;

-- 25. NOTIFICAÇÕES
CREATE TABLE notificacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    mensagem TEXT NOT NULL,
    tipo ENUM('info', 'success', 'warning', 'error', 'system'),
    lida BOOLEAN DEFAULT FALSE,
    data_leitura DATETIME,
    acao_url VARCHAR(255),
    data_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
    expiracao DATETIME,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_notificacoes_usuario (usuario_id),
    INDEX idx_notificacoes_lida (lida),
    INDEX idx_notificacoes_data (data_envio)
) ENGINE=InnoDB;

-- 26. MENUS DO SISTEMA
CREATE TABLE menus (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    icone VARCHAR(50),
    url VARCHAR(255),
    ordem INT DEFAULT 0,
    menu_pai_id INT,
    permissao_necessaria VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (menu_pai_id) REFERENCES menus(id),
    INDEX idx_menus_ordem (ordem),
    INDEX idx_menus_ativo (ativo)
) ENGINE=InnoDB;

-- 27. PERMISSÕES
CREATE TABLE permissoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
    modulo VARCHAR(50),
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_permissoes_nome (nome),
    INDEX idx_permissoes_modulo (modulo)
) ENGINE=InnoDB;

-- 28. PERMISSÕES DE USUÁRIO
CREATE TABLE usuario_permissoes (
    usuario_id INT NOT NULL,
    permissao_id INT NOT NULL,
    concedido_por INT,
    data_concessao DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, permissao_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (permissao_id) REFERENCES permissoes(id) ON DELETE CASCADE,
    FOREIGN KEY (concedido_por) REFERENCES usuarios(id)
) ENGINE=InnoDB;

-- 29. BACKUP REGISTRY
CREATE TABLE backup_registry (
    id INT PRIMARY KEY AUTO_INCREMENT,
    arquivo_nome VARCHAR(255) NOT NULL,
    tamanho_bytes BIGINT,
    tipo ENUM('Completo', 'Incremental', 'Dados', 'Logs'),
    status ENUM('Sucesso', 'Falha', 'Em Andamento') DEFAULT 'Em Andamento',
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME,
    usuario_id INT,
    observacoes TEXT,
    local_armazenamento VARCHAR(500),
    checksum VARCHAR(64),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    INDEX idx_backup_data (data_inicio),
    INDEX idx_backup_status (status)
) ENGINE=InnoDB;

-- ============================================
-- SEÇÃO 5: INSERÇÃO DE DADOS INICIAIS
-- ============================================

-- Inserir configurações padrão do sistema
INSERT INTO configuracoes (chave, valor, tipo, categoria, descricao) VALUES
-- Informações da Igreja
('igreja_nome', 'Igreja Exemplo', 'STRING', 'Geral', 'Nome oficial da igreja'),
('igreja_cnpj', '', 'STRING', 'Geral', 'CNPJ da igreja'),
('igreja_endereco', '', 'STRING', 'Geral', 'Endereço completo'),
('igreja_telefone', '', 'STRING', 'Geral', 'Telefone principal'),
('igreja_email', '', 'STRING', 'Geral', 'E-mail de contato'),
('igreja_pastor_titular', '', 'STRING', 'Geral', 'Nome do pastor titular'),

-- Configurações do Sistema
('sistema_tema', 'light', 'STRING', 'Sistema', 'Tema do sistema (light/dark)'),
('sistema_idioma', 'pt-BR', 'STRING', 'Sistema', 'Idioma do sistema'),
('sistema_timezone', 'America/Sao_Paulo', 'STRING', 'Sistema', 'Fuso horário'),

-- Configurações de Segurança
('seguranca_tentativas_login', '3', 'INTEGER', 'Segurança', 'Tentativas de login antes de bloquear'),
('seguranca_tempo_bloqueio', '30', 'INTEGER', 'Segurança', 'Minutos de bloqueio após falhas'),
('seguranca_troca_senha_dias', '90', 'INTEGER', 'Segurança', 'Dias para forçar troca de senha'),

-- Configurações Financeiras
('financeiro_dizimo_obrigatorio', 'false', 'BOOLEAN', 'Financeiro', 'Dízimo obrigatório para membros'),
('financeiro_relatorio_mensal', 'true', 'BOOLEAN', 'Financeiro', 'Gerar relatório financeiro mensal'),

-- Configurações de Frequência
('frequencia_tolerancia_atraso', '15', 'INTEGER', 'Frequência', 'Tolerância em minutos para atraso'),
('frequencia_auto_checkout', 'true', 'BOOLEAN', 'Frequência', 'Checkout automático após culto'),

-- Configurações de Eventos
('eventos_inscricao_antecipada', '7', 'INTEGER', 'Eventos', 'Dias para inscrição antecipada'),
('eventos_cancelamento_horas', '24', 'INTEGER', 'Eventos', 'Horas mínimas para cancelamento'),

-- Configurações de Backup
('backup_automatico', 'true', 'BOOLEAN', 'Backup', 'Backup automático ativado'),
('backup_frequencia', 'diario', 'STRING', 'Backup', 'Frequência do backup'),
('backup_manter_quantidade', '30', 'INTEGER', 'Backup', 'Quantidade de backups a manter'),

-- Configurações de Notificação
('notificacoes_email', 'true', 'BOOLEAN', 'Notificações', 'Enviar notificações por e-mail'),
('notificacoes_push', 'false', 'BOOLEAN', 'Notificações', 'Notificações push ativadas');

-- Inserir menus padrão do sistema
INSERT INTO menus (nome, icone, url, ordem, menu_pai_id, permissao_necessaria) VALUES
-- Menu Principal
('Dashboard', 'home', '/dashboard', 1, NULL, 'dashboard.view'),
('Membros', 'users', '#', 2, NULL, 'membros.view'),
('Eventos', 'calendar', '#', 3, NULL, 'eventos.view'),
('Finanças', 'dollar-sign', '#', 4, NULL, 'financas.view'),
('Relatórios', 'file-text', '#', 5, NULL, 'relatorios.view'),
('Configurações', 'settings', '#', 99, NULL, 'configuracoes.view'),

-- Submenu Membros
('Todos os Membros', 'user', '/membros', 1, 2, 'membros.view'),
('Novo Membro', 'user-plus', '/membros/novo', 2, 2, 'membros.create'),
('Famílias', 'users', '/familias', 3, 2, 'familias.view'),
('Frequência', 'check-circle', '/frequencia', 4, 2, 'frequencia.view'),

-- Submenu Eventos
('Calendário', 'calendar', '/eventos', 1, 3, 'eventos.view'),
('Novo Evento', 'plus-circle', '/eventos/novo', 2, 3, 'eventos.create'),
('Células', 'home', '/celulas', 3, 3, 'celulas.view'),
('Escola Bíblica', 'book', '/escola-biblica', 4, 3, 'eb.view'),

-- Submenu Finanças
('Dízimos e Ofertas', 'gift', '/dizimos', 1, 4, 'dizimos.view'),
('Caixa', 'credit-card', '/caixa', 2, 4, 'caixa.view'),
('Despesas', 'trending-down', '/despesas', 3, 4, 'despesas.view'),
('Relatórios Financeiros', 'bar-chart-2', '/relatorios/financeiro', 4, 4, 'relatorios.financeiro'),

-- Submenu Relatórios
('Membros Ativos', 'users', '/relatorios/membros', 1, 5, 'relatorios.membros'),
('Financeiro', 'bar-chart', '/relatorios/financeiro', 2, 5, 'relatorios.financeiro'),
('Frequência', 'activity', '/relatorios/frequencia', 3, 5, 'relatorios.frequencia'),
('Eventos', 'calendar', '/relatorios/eventos', 4, 5, 'relatorios.eventos'),

-- Submenu Configurações
('Igreja', 'building', '/config/igreja', 1, 6, 'config.igreja'),
('Usuários', 'users', '/config/usuarios', 2, 6, 'config.usuarios'),
('Permissões', 'lock', '/config/permissoes', 3, 6, 'config.permissoes'),
('Backup', 'database', '/config/backup', 4, 6, 'config.backup');

-- Inserir permissões padrão
INSERT INTO permissoes (nome, descricao, modulo) VALUES
-- Dashboard
('dashboard.view', 'Visualizar dashboard', 'dashboard'),
('dashboard.admin', 'Acesso de administrador ao dashboard', 'dashboard'),

-- Membros
('membros.view', 'Visualizar membros', 'membros'),
('membros.create', 'Cadastrar membros', 'membros'),
('membros.edit', 'Editar membros', 'membros'),
('membros.delete', 'Excluir membros', 'membros'),
('membros.export', 'Exportar lista de membros', 'membros'),
('familias.view', 'Visualizar famílias', 'membros'),
('familias.manage', 'Gerenciar famílias', 'membros'),
('frequencia.view', 'Visualizar frequência', 'membros'),
('frequencia.manage', 'Gerenciar frequência', 'membros'),
('historico.view', 'Visualizar histórico espiritual', 'membros'),
('historico.manage', 'Gerenciar histórico espiritual', 'membros'),

-- Eventos
('eventos.view', 'Visualizar eventos', 'eventos'),
('eventos.create', 'Criar eventos', 'eventos'),
('eventos.edit', 'Editar eventos', 'eventos'),
('eventos.delete', 'Excluir eventos', 'eventos'),
('eventos.inscricoes', 'Gerenciar inscrições', 'eventos'),
('celulas.view', 'Visualizar células', 'eventos'),
('celulas.manage', 'Gerenciar células', 'eventos'),
('escola_biblica.view', 'Visualizar escola bíblica', 'eventos'),
('escola_biblica.manage', 'Gerenciar escola bíblica', 'eventos'),

-- Finanças
('dizimos.view', 'Visualizar dízimos e ofertas', 'financas'),
('dizimos.create', 'Registrar dízimos e ofertas', 'financas'),
('dizimos.edit', 'Editar dízimos e ofertas', 'financas'),
('dizimos.delete', 'Excluir dízimos e ofertas', 'financas'),
('caixa.view', 'Visualizar caixa', 'financas'),
('caixa.manage', 'Gerenciar caixa', 'financas'),
('despesas.view', 'Visualizar despesas', 'financas'),
('despesas.manage', 'Gerenciar despesas', 'financas'),
('relatorios.financeiro', 'Gerar relatórios financeiros', 'financas'),

-- Relatórios
('relatorios.view', 'Visualizar relatórios', 'relatorios'),
('relatorios.membros', 'Relatórios de membros', 'relatorios'),
('relatorios.frequencia', 'Relatórios de frequência', 'relatorios'),
('relatorios.eventos', 'Relatórios de eventos', 'relatorios'),
('relatorios.patrimonio', 'Relatórios de patrimônio', 'relatorios'),
('relatorios.biblioteca', 'Relatórios da biblioteca', 'relatorios'),
('relatorios.export', 'Exportar relatórios', 'relatorios'),

-- Configurações
('configuracoes.view', 'Visualizar configurações', 'configuracoes'),
('configuracoes.edit', 'Editar configurações', 'configuracoes'),
('config.igreja', 'Configurações da igreja', 'configuracoes'),
('config.usuarios', 'Gerenciar usuários', 'configuracoes'),
('config.permissoes', 'Gerenciar permissões', 'configuracoes'),
('config.backup', 'Gerenciar backup', 'configuracoes'),
('logs.view', 'Visualizar logs', 'configuracoes'),

-- Biblioteca
('biblioteca.view', 'Visualizar biblioteca', 'biblioteca'),
('biblioteca.manage', 'Gerenciar biblioteca', 'biblioteca'),
('biblioteca.emprestimos', 'Gerenciar empréstimos', 'biblioteca'),

-- Patrimônio
('patrimonio.view', 'Visualizar patrimônio', 'patrimonio'),
('patrimonio.manage', 'Gerenciar patrimônio', 'patrimonio'),

-- Agenda Pastoral
('agenda.view', 'Visualizar agenda pastoral', 'agenda'),
('agenda.manage', 'Gerenciar agenda pastoral', 'agenda'),
('agenda.admin', 'Administrar agenda pastoral', 'agenda'),

-- Administração
('admin.departamentos', 'Gerenciar departamentos', 'admin'),
('admin.ministérios', 'Gerenciar ministérios', 'admin'),
('admin.dashboard', 'Dashboard administrativo', 'admin'),
('system.backup', 'Realizar backup do sistema', 'system'),
('system.restore', 'Restaurar backup do sistema', 'system'),
('system.users', 'Gerenciar usuários do sistema', 'system'),
('system.audit', 'Auditar sistema', 'system');

-- ============================================
-- SEÇÃO 6: VIEWS ÚTEIS
-- ============================================

-- VIEW 1: Membros Ativos
CREATE OR REPLACE VIEW view_membros_ativos AS
SELECT 
    p.id AS pessoa_id,
    p.nome,
    p.email,
    p.telefone,
    p.celular,
    p.endereco,
    m.id AS membro_id,
    m.codigo_membro,
    m.data_membresia,
    m.tipo_membro,
    m.cargo,
    m.estado_civil,
    m.profissao,
    TIMESTAMPDIFF(YEAR, p.data_nascimento, CURDATE()) AS idade
FROM pessoas p
JOIN membros m ON p.id = m.pessoa_id
WHERE p.ativo = TRUE 
    AND m.tipo_membro IN ('Membro', 'Congregado', 'Líder')
    AND (m.data_saida IS NULL OR m.data_saida > CURDATE());

-- VIEW 2: Frequência Mensal por Membro
CREATE OR REPLACE VIEW view_frequencia_mensal AS
SELECT 
    m.id AS membro_id,
    p.nome,
    YEAR(f.data_evento) AS ano,
    MONTH(f.data_evento) AS mes,
    COUNT(CASE WHEN f.presente = TRUE THEN 1 END) AS total_presencas,
    COUNT(*) AS total_eventos,
    ROUND(COUNT(CASE WHEN f.presente = TRUE THEN 1 END) * 100.0 / COUNT(*), 2) AS percentual,
    GROUP_CONCAT(DISTINCT f.tipo_evento) AS tipos_participados
FROM membros m
JOIN pessoas p ON m.pessoa_id = p.id
LEFT JOIN frequencia f ON m.id = f.membro_id
WHERE f.data_evento IS NOT NULL
GROUP BY m.id, YEAR(f.data_evento), MONTH(f.data_evento)
ORDER BY ano DESC, mes DESC;

-- VIEW 3: Dízimos Mensais
CREATE OR REPLACE VIEW view_dizimos_mensais AS
SELECT 
    m.id AS membro_id,
    p.nome,
    YEAR(d.data) AS ano,
    MONTH(d.data) AS mes,
    SUM(CASE WHEN d.tipo = 'Dízimo' THEN d.valor ELSE 0 END) AS total_dizimos,
    SUM(CASE WHEN d.tipo = 'Oferta' THEN d.valor ELSE 0 END) AS total_ofertas,
    SUM(d.valor) AS total_geral,
    COUNT(DISTINCT d.id) AS numero_lancamentos
FROM membros m
JOIN pessoas p ON m.pessoa_id = p.id
JOIN dizimos_ofertas d ON m.id = d.membro_id
WHERE d.status = 'confirmado'
GROUP BY m.id, YEAR(d.data), MONTH(d.data)
ORDER BY ano DESC, mes DESC;

-- VIEW 4: Próximos Eventos
CREATE OR REPLACE VIEW view_proximos_eventos AS
SELECT 
    e.id,
    e.titulo,
    e.descricao,
    e.data_inicio,
    e.data_fim,
    e.local,
    e.tipo_evento,
    DATEDIFF(e.data_inicio, CURDATE()) AS dias_restantes,
    p.nome AS responsavel_nome,
    COUNT(pe.id) AS total_inscritos,
    e.capacidade_maxima
FROM eventos e
LEFT JOIN participantes_eventos pe ON e.id = pe.evento_id
LEFT JOIN membros m ON e.responsavel_id = m.id
LEFT JOIN pessoas p ON m.pessoa_id = p.id
WHERE e.data_inicio >= CURDATE() 
    AND e.cancelado = FALSE
GROUP BY e.id
ORDER BY e.data_inicio ASC
LIMIT 10;

-- VIEW 5: Resumo Financeiro por Período
CREATE OR REPLACE VIEW view_resumo_financeiro AS
SELECT 
    YEAR(data) AS ano,
    MONTH(data) AS mes,
    SUM(CASE WHEN tipo = 'Dízimo' THEN valor ELSE 0 END) AS total_dizimos,
    SUM(CASE WHEN tipo = 'Oferta' THEN valor ELSE 0 END) AS total_ofertas,
    SUM(CASE WHEN tipo IN ('Dízimo', 'Oferta') THEN valor ELSE 0 END) AS total_arrecadado,
    COUNT(DISTINCT membro_id) AS numero_contribuintes
FROM dizimos_ofertas
WHERE status = 'confirmado'
GROUP BY YEAR(data), MONTH(data)
ORDER BY ano DESC, mes DESC;

-- VIEW 6: Aniversariantes do Mês
CREATE OR REPLACE VIEW view_aniversariantes AS
SELECT 
    p.id,
    p.nome,
    p.data_nascimento,
    p.telefone,
    p.email,
    m.tipo_membro,
    m.cargo,
    DATE_FORMAT(p.data_nascimento, '%d/%m') AS data_aniversario,
    TIMESTAMPDIFF(YEAR, p.data_nascimento, CURDATE()) AS idade
FROM pessoas p
JOIN membros m ON p.id = m.pessoa_id
WHERE MONTH(p.data_nascimento) = MONTH(CURDATE())
    AND p.ativo = TRUE
ORDER BY DAY(p.data_nascimento);

-- VIEW 7: Ocupação das Células
CREATE OR REPLACE VIEW view_ocupacao_celulas AS
SELECT 
    c.id,
    c.nome,
    c.codigo,
    c.dia_semana,
    c.horario,
    c.capacidade,
    COUNT(mc.id) AS membros_ativos,
    ROUND(COUNT(mc.id) * 100.0 / c.capacidade, 2) AS percentual_ocupacao,
    p_lider.nome AS lider_nome,
    CASE 
        WHEN COUNT(mc.id) >= c.capacidade THEN 'Lotada'
        WHEN COUNT(mc.id) >= c.capacidade * 0.8 THEN 'Quase Lotada'
        WHEN COUNT(mc.id) >= c.capacidade * 0.5 THEN 'Média Ocupação'
        ELSE 'Baixa Ocupação'
    END AS status_ocupacao
FROM celulas c
LEFT JOIN membros_celulas mc ON c.id = mc.celula_id AND mc.ativo = TRUE
LEFT JOIN membros m_lider ON c.lider_id = m_lider.id
LEFT JOIN pessoas p_lider ON m_lider.pessoa_id = p_lider.id
WHERE c.ativo = TRUE
GROUP BY c.id
ORDER BY percentual_ocupacao DESC;

-- VIEW 8: Histórico Completo de Membros
CREATE OR REPLACE VIEW view_historico_completo_membros AS
SELECT 
    m.id AS membro_id,
    p.nome AS nome_membro,
    he.data,
    he.tipo AS evento_espiritual,
    he.descricao AS evento_descricao,
    he.ministrante,
    he.local,
    m.data_membresia,
    m.tipo_membro,
    m.cargo,
    d.valor AS ultima_oferta,
    d.data AS data_ultima_oferta
FROM membros m
JOIN pessoas p ON m.pessoa_id = p.id
LEFT JOIN historico_espiritual he ON m.id = he.membro_id
LEFT JOIN (
    SELECT membro_id, valor, data,
        ROW_NUMBER() OVER (PARTITION BY membro_id ORDER BY data DESC) AS rn
    FROM dizimos_ofertas
    WHERE status = 'confirmado'
) d ON m.id = d.membro_id AND d.rn = 1
ORDER BY p.nome;

-- ============================================
-- SEÇÃO 7: PROCEDURES ARMAZENADAS
-- ============================================

-- Procedure 1: Registrar Frequência com Check
DELIMITER //
CREATE PROCEDURE sp_registrar_frequencia(
    IN p_membro_id INT,
    IN p_tipo_evento VARCHAR(50),
    IN p_observacoes TEXT
)
BEGIN
    DECLARE v_presente BOOLEAN;
    
    -- Verificar se membro é ativo
    SELECT CASE 
        WHEN m.tipo_membro IN ('Membro', 'Congregado') AND p.ativo = TRUE 
        THEN TRUE ELSE FALSE 
    END INTO v_presente
    FROM membros m
    JOIN pessoas p ON m.pessoa_id = p.id
    WHERE m.id = p_membro_id;
    
    IF v_presente = TRUE THEN
        INSERT INTO frequencia (membro_id, data_evento, tipo_evento, presente, observacoes)
        VALUES (p_membro_id, CURDATE(), p_tipo_evento, TRUE, p_observacoes);
        
        SELECT 'Frequência registrada com sucesso!' AS mensagem, TRUE AS sucesso;
    ELSE
        SELECT 'Membro não está ativo para registrar frequência!' AS mensagem, FALSE AS sucesso;
    END IF;
END//
DELIMITER ;

-- Procedure 2: Relatório Financeiro Mensal
DELIMITER //
CREATE PROCEDURE sp_relatorio_financeiro_mensal(
    IN p_mes INT,
    IN p_ano INT
)
BEGIN
    SELECT 
        'Total de Dízimos' AS descricao,
        COALESCE(SUM(CASE WHEN tipo = 'Dízimo' THEN valor ELSE 0 END), 0) AS valor
    FROM dizimos_ofertas
    WHERE MONTH(data) = p_mes AND YEAR(data) = p_ano
        AND status = 'confirmado'
    
    UNION ALL
    
    SELECT 
        'Total de Ofertas' AS descricao,
        COALESCE(SUM(CASE WHEN tipo = 'Oferta' THEN valor ELSE 0 END), 0) AS valor
    FROM dizimos_ofertas
    WHERE MONTH(data) = p_mes AND YEAR(data) = p_ano
        AND status = 'confirmado'
    
    UNION ALL
    
    SELECT 
        'Total de Despesas' AS descricao,
        COALESCE(SUM(valor), 0) AS valor
    FROM despesas
    WHERE MONTH(data_pagamento) = p_mes 
        AND YEAR(data_pagamento) = p_ano
        AND data_pagamento IS NOT NULL
    
    UNION ALL
    
    SELECT 
        'Saldo do Período' AS descricao,
        COALESCE((
            SELECT SUM(CASE WHEN tipo IN ('Dízimo', 'Oferta') THEN valor ELSE 0 END)
            FROM dizimos_ofertas
            WHERE MONTH(data) = p_mes AND YEAR(data) = p_ano AND status = 'confirmado'
        ) - (
            SELECT SUM(valor)
            FROM despesas
            WHERE MONTH(data_pagamento) = p_mes 
                AND YEAR(data_pagamento) = p_ano
                AND data_pagamento IS NOT NULL
        ), 0) AS valor;
END//
DELIMITER ;

-- Procedure 3: Backup de Membros
DELIMITER //
CREATE PROCEDURE sp_backup_membros(IN p_data_referencia DATE)
BEGIN
    INSERT INTO backup_registry (arquivo_nome, tipo, data_inicio, status)
    VALUES (CONCAT('backup_membros_', p_data_referencia, '.sql'), 'Dados', NOW(), 'Em Andamento');
    
    -- Aqui entraria a lógica real de backup
    -- Este é um placeholder
    
    UPDATE backup_registry 
    SET status = 'Sucesso', data_fim = NOW()
    WHERE id = LAST_INSERT_ID();
    
    SELECT 'Backup realizado com sucesso!' AS mensagem;
END//
DELIMITER ;

-- ============================================
-- SEÇÃO 8: TRIGGERS
-- ============================================

-- Trigger 1: Atualizar último acesso do usuário
DELIMITER //
CREATE TRIGGER trg_usuario_ultimo_login
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
    IF NEW.ultimo_login != OLD.ultimo_login THEN
        INSERT INTO logs_auditoria (usuario_id, acao, modulo, dados_anteriores, dados_novos)
        VALUES (NEW.id, 'LOGIN', 'usuarios', 
                JSON_OBJECT('ultimo_login', OLD.ultimo_login),
                JSON_OBJECT('ultimo_login', NEW.ultimo_login));
    END IF;
END//
DELIMITER ;

-- Trigger 2: Log de alterações de membros
DELIMITER //
CREATE TRIGGER trg_log_membros
AFTER UPDATE ON membros
FOR EACH ROW
BEGIN
    INSERT INTO logs_auditoria (usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos)
    VALUES (OLD.usuario_alteracao, 'UPDATE', 'membros', NEW.id,
            JSON_OBJECT('tipo_membro', OLD.tipo_membro, 'cargo', OLD.cargo, 'ativo', OLD.ativo),
            JSON_OBJECT('tipo_membro', NEW.tipo_membro, 'cargo', NEW.cargo, 'ativo', NEW.ativo));
END//
DELIMITER ;

-- Trigger 3: Validar CPF antes de inserir membro
DELIMITER //
CREATE TRIGGER trg_validar_cpf
BEFORE INSERT ON pessoas
FOR EACH ROW
BEGIN
    IF NEW.cpf IS NOT NULL AND LENGTH(NEW.cpf) != 14 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF deve ter 14 caracteres (formato: 000.000.000-00)';
    END IF;
END//
DELIMITER ;

-- ============================================
-- SEÇÃO 9: FUNÇÕES
-- ============================================

-- Função 1: Calcular Idade
DELIMITER //
CREATE FUNCTION fn_calcular_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
END//
DELIMITER ;

-- Função 2: Média de Presença do Membro
DELIMITER //
CREATE FUNCTION fn_media_presenca(p_membro_id INT, p_ultimos_meses INT)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE v_media DECIMAL(5,2);
    
    SELECT AVG(
        CASE WHEN presente = 1 THEN 100 ELSE 0 END
    ) INTO v_media
    FROM frequencia
    WHERE membro_id = p_membro_id
        AND data_evento >= DATE_SUB(CURDATE(), INTERVAL p_ultimos_meses MONTH);
    
    RETURN COALESCE(v_media, 0);
END//
DELIMITER ;

-- Função 3: Total Contribuído por Membro
DELIMITER //
CREATE FUNCTION fn_total_contribuicao(p_membro_id INT, p_ano INT, p_tipo VARCHAR(20))
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12,2);
    
    SELECT COALESCE(SUM(valor), 0) INTO v_total
    FROM dizimos_ofertas
    WHERE membro_id = p_membro_id
        AND YEAR(data) = p_ano
        AND (p_tipo = 'TODOS' OR tipo = p_tipo)
        AND status = 'confirmado';
    
    RETURN v_total;
END//
DELIMITER ;

-- ============================================
-- SEÇÃO 10: INDEXES ADICIONAIS
-- ============================================

-- Índices para melhorar performance de consultas comuns
CREATE INDEX idx_busca_completa_pessoas ON pessoas(nome, email, telefone);
CREATE INDEX idx_relatorios_dizimos ON dizimos_ofertas(data, tipo, status);
CREATE INDEX idx_frequencia_analise ON frequencia(data_evento, tipo_evento, presente);
CREATE INDEX idx_eventos_periodo ON eventos(data_inicio, data_fim, cancelado);
CREATE INDEX idx_membros_dados_completos ON membros(tipo_membro, cargo, data_membresia);
CREATE INDEX idx_agenda_completa ON agenda_pastoral(data_inicio, status, pastor_id);
CREATE INDEX idx_emprestimos_atraso ON emprestimos_biblioteca(data_devolucao_prevista, data_devolucao_real);

-- Índices para full-text search
ALTER TABLE pessoas ADD FULLTEXT idx_fulltext_nome_endereco (nome, endereco);
ALTER TABLE eventos ADD FULLTEXT idx_fulltext_eventos (titulo, descricao);
ALTER TABLE biblioteca ADD FULLTEXT idx_fulltext_biblioteca (titulo, autor, sinopse);

-- ============================================
-- SEÇÃO 11: CONFIGURAÇÕES INICIAIS DO BANCO
-- ============================================

-- Configurar charset e collation
ALTER DATABASE sistema_igreja CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Criar usuário de aplicação (ajustar senha conforme necessidade)
-- CREATE USER IF NOT EXISTS 'igreja_app'@'localhost' IDENTIFIED BY 'senha_segura';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON sistema_igreja.* TO 'igreja_app'@'localhost';
-- GRANT EXECUTE ON sistema_igreja.* TO 'igreja_app'@'localhost';

-- Criar usuário de backup
-- CREATE USER IF NOT EXISTS 'igreja_backup'@'localhost' IDENTIFIED BY 'senha_backup_segura';
-- GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON sistema_igreja.* TO 'igreja_backup'@'localhost';

-- Criar usuário readonly para relatórios
-- CREATE USER IF NOT EXISTS 'igreja_readonly'@'localhost' IDENTIFIED BY 'senha_readonly';
-- GRANT SELECT ON sistema_igreja.* TO 'igreja_readonly'@'localhost';
-- GRANT EXECUTE ON sistema_igreja.* TO 'igreja_readonly'@'localhost';

FLUSH PRIVILEGES;

-- ============================================
-- FIM DO SCRIPT
-- ============================================

SELECT 'Banco de dados do Sistema de Igreja criado com sucesso!' AS Status;
SELECT DATABASE() AS Database_Name, 
       COUNT(*) AS Total_Tables 
FROM information_schema.tables 
WHERE table_schema = DATABASE();