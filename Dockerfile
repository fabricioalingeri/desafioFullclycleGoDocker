# Iniciando uma imagem base golang:alpine
FROM golang:alpine AS builder
# criando diretório de trabalho
WORKDIR /usr/src/app/
# Copiando o app
COPY . .
##podemos incluir mais dois parâmetros para o linker que vão ajudar a diminuir o tamanho do executável final -ldflags “-s -w”
##O parâmetro -s remove informações de debug do executável e o -w impede a geração do DWARF (Debugging With Attributed Record Formats).
RUN CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static" -s -w' main.go

##Esta imagem é mais útil no contexto da construção de imagens de base
##ou imagens super mínimas (que contêm apenas um único binário e o que for necessário
FROM scratch
# diretório de trabalho
WORKDIR /
# copiando o binário
COPY --from=builder /usr/src/app/ /
# executando
CMD ["./main"]