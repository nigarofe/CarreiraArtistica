-- Tabelas Principais (Entidades)

-- Tabela de plataformas: Onde as participações ocorrem.
CREATE TABLE Plataformas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    tipo VARCHAR(100),
    abrangencia VARCHAR(100),
    criterio_selecao TEXT,
    observacoes TEXT
);

-- Tabela de artistas: Pessoas individuais.
-- A relação com a plataforma foi movida para a tabela 'Participacoes'.
CREATE TABLE Artistas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL, -- Adicionado NOT NULL
    idade INT,
    genero VARCHAR(50),
    naturalidade VARCHAR(100),
    formacao VARCHAR(100),
    formacao_area VARCHAR(100),
    observacoes TEXT
);

-- Tabela de grupos: Coletivos de artistas.
CREATE TABLE Grupos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT
);


-- Tabelas de Relacionamento

-- Tabela intermediária (muitos-para-muitos): Define QUAIS artistas pertencem a QUAIS grupos.
-- Esta tabela representa uma relação de 'membresia'.
CREATE TABLE Artista_Grupo (
    artista_id INT NOT NULL REFERENCES Artistas(id) ON DELETE CASCADE,
    grupo_id INT NOT NULL REFERENCES Grupos(id) ON DELETE CASCADE,
    PRIMARY KEY (artista_id, grupo_id)
);

-- Tabela de Participações: Onde artistas OU grupos se relacionam com plataformas.
-- Esta é a nova tabela central que registra o evento da participação.
CREATE TABLE Participacoes (
    id SERIAL PRIMARY KEY,
    plataforma_id INT NOT NULL REFERENCES Plataformas(id) ON DELETE CASCADE,
    
    -- Chaves estrangeiras separadas que apontam para Artista ou Grupo
    artista_id INT REFERENCES Artistas(id) ON DELETE CASCADE,
    grupo_id INT REFERENCES Grupos(id) ON DELETE CASCADE,
    
    -- Detalhes do evento de participação
    ano_participacao INT NOT NULL,
    titulo_trabalho VARCHAR(255), -- Sugestão de melhoria: campo para o nome da obra/projeto
    descricao_participacao TEXT,
    observacoes TEXT,
    
    -- Constraint para garantir que ou o artista_id ou o grupo_id seja preenchido, mas não ambos.
    -- Isso garante que cada registro de participação é para UM artista ou UM grupo.
    CONSTRAINT chk_participante CHECK (
        (artista_id IS NOT NULL AND grupo_id IS NULL) OR
        (artista_id IS NULL AND grupo_id IS NOT NULL)
    )
);