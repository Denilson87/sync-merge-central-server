#!/usr/bin/env Rscript

suppressMessages(library(openxlsx))

# =============================
#   CONFIGURAÇÃO DOS CAMINHOS
# =============================
origem_dir <- "/srv/assiduidade/"
saida_file <- "/srv/assiduidade/efectividade-us/efectividade-maputo-cidade.xlsx"
log_file   <- "/srv/assiduidade/efectividade-us/rscript.log"

cat("===== PROCESSAMENTO INICIADO =====\n", file = log_file)

# =============================
#   FUNÇÃO PARA LER PLANILHA
# =============================
ler_planilha <- function(file_path) {

  cat("\nArquivo: ", file_path, "\n", file = log_file, append = TRUE)

  sheets <- tryCatch(getSheetNames(file_path),
                     error = function(e) return(NULL))

  if (is.null(sheets) || length(sheets) == 0) {
    cat(" -> ERRO: Nenhuma sheet encontrada. Ignorado.\n",
        file = log_file, append = TRUE)
    return(NULL)
  }

  # Ler a sheet "Registos" se existir, senão usa a 1ª
  sheet <- if ("Registos" %in% sheets) "Registos" else sheets[1]

  df <- tryCatch({
    read.xlsx(file_path,
              sheet = sheet,
              startRow = 5,
              colNames = FALSE)
  }, error = function(e) {
    cat(" -> ERRO ao ler a sheet. Detalhe: ", e$message, "\n",
        file = log_file, append = TRUE)
    return(NULL)
  })

  # Arquivo possui a sheet mas está vazia
  if (is.null(df) || nrow(df) == 0) {
    cat(" -> AVISO: Nenhum dado encontrado após a linha 5. Ignorando.\n",
        file = log_file, append = TRUE)
    return(NULL)
  }

  # Garantir que somente 8 colunas sejam usadas (A–H)
  df <- df[, 1:8, drop = FALSE]

  cat(" -> Linhas importadas: ", nrow(df), "\n",
      file = log_file, append = TRUE)

  return(df)
}

# =============================
#   LISTAR ARQUIVOS DE ORIGEM
# =============================
arquivos <- list.files(origem_dir,
                       pattern = "\\.xlsx$",
                       recursive = TRUE,
                       full.names = TRUE)

cat("\nTotal de ficheiros encontrados: ", length(arquivos), "\n",
    file = log_file, append = TRUE)

# =============================
#   LER TODOS OS EXCELS
# =============================
dados_lista <- lapply(arquivos, ler_planilha)
dados_lista <- Filter(Negate(is.null), dados_lista)

if (length(dados_lista) == 0) {
  cat("\nNenhum dado válido encontrado. Encerrado.\n",
      file = log_file, append = TRUE)
  quit(save = "no")
}

df_novo <- do.call(rbind, dados_lista)

# =============================
#   CARREGAR ARQUIVO FINAL
# =============================
if (file.exists(saida_file)) {
  cat("\nCarregando ficheiro final existente...\n",
      file = log_file, append = TRUE)

  df_exist <- read.xlsx(saida_file, colNames = FALSE)
  df_exist <- df_exist[, 1:8]

  df_final <- unique(rbind(df_exist, df_novo))
} else {
  df_final <- unique(df_novo)
}

cat("\nTotal de linhas após remover duplicados: ", nrow(df_final), "\n",
    file = log_file, append = TRUE)

# =============================
#   GRAVAR ARQUIVO FINAL
# =============================
wb <- createWorkbook()
addWorksheet(wb, "Efectividade")
writeData(wb, "Efectividade", df_final)
saveWorkbook(wb, saida_file, overwrite = TRUE)

cat("\n✔ PROCESSO CONCLUÍDO COM SUCESSO!\n",
    file = log_file, append = TRUE)
cat("Ficheiro final: ", saida_file, "\n",
    file = log_file, append = TRUE)
