FROM golang:1.9.2

RUN mkdir /src
COPY *.go /src/
RUN go get -u "github.com/prometheus/client_golang/prometheus"
RUN go get -u "github.com/prometheus/client_golang/prometheus/promhttp"
RUN go get -u "github.com/prometheus/common/log"
RUN go get -u "github.com/prometheus/common/version"
RUN go get -u "github.com/heketi/heketi/client/api/go-client"
RUN go get -u "github.com/heketi/heketi/pkg/glusterfs/api"

WORKDIR /src
ENV CGO_ENABLED=0
RUN go build -o heketi-metrics-exporter

FROM scratch
LABEL authors="Robert Tindell <Robert@Tindell.info>, CSC Rahti Team <rahti-team@postit.csc.fi>"
EXPOSE 9189
# Copy heketi_exporter
COPY --from=0 /src/heketi-metrics-exporter /heketi-metrics-exporter

CMD ["/heketi-metrics-exporter"]
ENTRYPOINT ["/heketi-metrics-exporter"]
