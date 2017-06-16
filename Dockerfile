FROM swift:3.1

WORKDIR /package

RUN apt-get update && apt-get install -y uuid-dev libmysqlclient-dev && rm -rf /var/lib/apt

COPY . ./

RUN swift package --enable-prefetching fetch
RUN swift package clean
# CMD swift test --parallel
RUN swift build --configuration release

EXPOSE 8080
ENTRYPOINT [".build/release/SwiftBot"]
