# Projeto prático: Otimização de uma imagem golang

## 🌱 Descrição do projeto 

Esse desafio é muito empolgante principalmente se você nunca trabalhou com a linguagem Go!
Você terá que publicar uma imagem no docker hub. Quando executarmos:

    -  docker run <seu-user>/codeeducation

Temos que ter o seguinte resultado: `Code.education Rocks!`

Se você perceber, essa imagem apenas realiza um print da mensagem como resultado final, logo, vale a pena dar uma conferida no próprio site da Go Lang para aprender como fazer um "olá mundo".

Lembrando que a Go Lang possui imagens oficiais prontas, vale a pena consultar o Docker Hub.

A imagem de nosso projeto Go precisa ter menos de 2MB =)

Dica: No vídeo de introdução sobre o Docker quando falamos sobre o sistema de arquivos em camadas, apresento uma imagem "raiz", talvez seja uma boa utilizá-la.

Divirta-se

## Utilizando o multi-stage build para compilar a aplicação e otimizar a imagem

- Stage 1

```

# Iniciando uma imagem base golang:alpine
FROM golang:alpine AS builder

# criando diretório de trabalho
WORKDIR /usr/src/app/

# Copiando o app
COPY . .

# Compilando o binário removendo informações de debug
RUN CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static" -s -w' main.go
```
- Stage 2
# Iniciando com scratch
FROM scratch

# diretório de trabalho
WORKDIR /

# copiando o binário
COPY --from=builder /usr/src/app/ / 

# executando 
CMD ["./main"]
```

## Inserindo alguns parâmetros para o linker via -ldflags

- Parâmetros para o linker que vão ajudar a diminuir o tamanho do executável final  ( -ldflags '-s -w' )

```
O parâmetro -s remove informações de debug do executável e o -w impede a geração do DWARF (Debugging With Attributed Record Formats).
```

## Build 

```
docker build -t fabricioalingeri/codeeducation .
```
## Run

```
docker run fabricioalingeri/codeeducation
```
## Docker login

```
docker login
```
## Push

```
docker push fabricioalingeri/codeeducation
```
## Pull

```
docker pull fabricioalingeri/codeeducation
```


