module segmentio-kafka-go

go 1.23.0

replace github.com/alibaba/opentelemetry-go-auto-instrumentation => ../../../../opentelemetry-go-auto-instrumentation

replace github.com/alibaba/opentelemetry-go-auto-instrumentation/test/verifier => ../../../../opentelemetry-go-auto-instrumentation/test/verifier

require (
	github.com/alibaba/opentelemetry-go-auto-instrumentation/test/verifier v0.0.0-20250423111209-a5689b116b5b
	github.com/segmentio/kafka-go v0.4.48
	go.opentelemetry.io/otel/sdk v1.35.0
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/go-logr/logr v1.4.2 // indirect
	github.com/go-logr/stdr v1.2.2 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/klauspost/compress v1.18.0 // indirect
	github.com/mohae/deepcopy v0.0.0-20170929034955-c48cc78d4826 // indirect
	github.com/pierrec/lz4/v4 v4.1.22 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/stretchr/testify v1.10.0 // indirect
	go.opentelemetry.io/auto/sdk v1.1.0 // indirect
	go.opentelemetry.io/otel v1.35.0 // indirect
	go.opentelemetry.io/otel/metric v1.35.0 // indirect
	go.opentelemetry.io/otel/sdk/metric v1.35.0 // indirect
	go.opentelemetry.io/otel/trace v1.35.0 // indirect
	golang.org/x/net v0.38.0 // indirect
	golang.org/x/sys v0.32.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)
