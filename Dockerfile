FROM alpine:latest

# 필요하면 수정!!!!!!!!!!
ARG APP_USER=skills
ARG APP_UID=1001
ARG LOG_DIRECTORY=/app/log

# 프록시 관련
ENV AWS_REGION_NAME=us-east-1
ENV SLO=1000

WORKDIR /app

RUN apk add --no-cache curl gcompat
RUN curl -fsSL https://storage.juwon.codes/skills/binaries/subtrace-$(uname -m) -o subtrace && \
    chmod +x subtrace
RUN mkdir -p ${LOG_DIRECTORY}
# 심볼릭 링크 로그 경로 수정!!!!!!!!!
# RUN ln -sf /dev/stdout ${LOG_DIRECTORY}/app.log

RUN adduser -D -u ${APP_UID} ${APP_USER}
COPY --chown=${APP_UID}:${APP_UID} token .
RUN chown -R ${APP_UID}:${APP_UID} /app && \
    chmod +x token

USER ${APP_UID}:${APP_UID}


ENTRYPOINT ["/app/token"]

# === 사용 가이드 ===
# 기본 실행: 
# docker run -d -p 8080:8080 --cap-add=SYS_PTRACE token
#
# 토큰 엔드포인트 설정:
# docker run -d -p 8080:8080 token -tokenEndpoint http://token -region us-east-1
#
# 프록시 빼고 실행:
# docker run -d -p 8080:8080 --entrypoint /app/token token
#
# 멀티 플랫폼 빌드:
# docker buildx build --platform linux/arm64 -t token:latest --load .
# docker buildx build --platform linux/amd64 -t token:latest --load .
