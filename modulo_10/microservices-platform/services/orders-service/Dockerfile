#* Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.md do.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLE=0 GOOS=linux go build -a -installsuffix cgo -o main .

#* Runtime stage
FROM alpine:latest

RUN apk --no-chache add ca-certificates curl

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/.env .

RUN addgroup -S appgroup && adduser -S appuser -G appuser

USER appuser

EXPOSE 8003

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://localhost:8003/health || exit 1


CMD ["./main"]

