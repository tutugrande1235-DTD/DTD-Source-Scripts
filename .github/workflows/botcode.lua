-- .github/workflows/botcode.lua

-- Pega variáveis de ambiente
local comment_body = os.getenv("COMMENT_BODY")
local github_token = os.getenv("GITHUB_TOKEN")
local issue_number = os.getenv("ISSUE_NUMBER")

-- Imprime tudo
print("=== Variáveis de Ambiente Recebidas ===")
print("COMMENT_BODY: ", comment_body or "nil")
print("GITHUB_TOKEN: ", github_token and ("***"..github_token:sub(-4)) or "nil") -- esconde quase todo token
print("ISSUE_NUMBER: ", issue_number or "nil")
print("======================================")